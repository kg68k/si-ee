.title Si - MPU clock

.include si.mac

.xref fe_idiv,decstr
U32DivMod: .reg fe_idiv
U32ToDecimalString: .reg decstr


MFP: .equ $e88000
~MFP_IERA: .equ $07
~MFP_IERB: .equ $09
~MFP_IMRA: .equ $13
~MFP_IMRB: .equ $15
~MFP_TCDCR:.equ $1d
~MFP_TCDR: .equ $23
~MFP_TDDR: .equ $25

SYS_P7: .equ $e8e00d

SRAM_WRITE_ENABLE: .macro
  move.b #$31,(SYS_P7)
.endm

SRAM_WRITE_DISABLE: .macro
  clr.b (SYS_P7)
.endm


.cpu 68000
.text

;MPUクロック数(kHz)の値を返す。
;  スーパーバイザモードで呼び出すこと。
;in
;  d0.l ... bit31=1: 常に自己測定  bit7-0: MPU種類(0:68000 ... 6:68060)
;out
;  d0.l ... MPUクロック数(kHz)
MpuClock_GetClock::
  PUSH d1-d2
  move.l d0,d2
  bmi 1f
    move.l (ROMCNT_U32),d0
    bne @f
      move (ROMCNT),d0
      bne @f
        1:
        move.l d2,d0
        bsr MpuClock_CountLoopOnSram
  @@:
  move.l d0,d1
  add.l d0,d0
  add.l d1,d0
  add.l d0,d0  ;6倍
  subq #2,d2
  bcc @f
    add.l d0,d0  ;68000,68010ならさらに2倍
  @@:
  POP d1-d2
  rts


;MPUクロック数を文字列化して返す。
;  指定したバッファに文字列(単位 kHz/MHz つき)を書き込む。
;  その他制限は MpuClock_GetClock と同じ。
;in
;  d0.l ... bit31=1: 常に自己測定  bit7-0: MPU種類(0:68000 ... 6:68060)
;  a0.l ... 文字列バッファ
;out
;  d0.l ... MPUクロック数(kHz)
;  a0.l ... 文字列末尾(NUL)のアドレス
MpuClock_GetString::
  bsr MpuClock_GetClock
  PUSH d0-d1  ;d0も返り値なので保存

  moveq #100,d1
  cmp.l d1,d0
  bcc 1f
    bsr U32ToDecimalString  ;0.1MHz未満はkHz単位で出力
    moveq #'k',d0
    bra 2f
  1:
    moveq #50,d1
    add.l d1,d0
    move.l #1000,d1
    bsr U32DivMod  ;MHz単位の値に換算
    bsr U32ToDecimalString
    move.b #'.',(a0)+
    move.l d1,d0
    moveq #100,d1
    bsr U32DivMod  ;余りを0.1MHz単位の値に換算
    addi.b #'0',d0
    move.b d0,(a0)+  ;少数第1位まで出力
    moveq #'M',d0
  2:
  move.b d0,(a0)+  ;k or M
  move.b #'H',(a0)+
  move.b #'z',(a0)+
  clr.b (a0)

  POP d0-d1
  rts


TCDCR_C_MASK:      .equ %1111_0000
TCDCR_D_MASK:      .equ %0000_1111
TCDCR_D_DELAY_16:  .equ %0011_0000  ;ディレイモード(÷16 プリスケーラ)
TCDCR_D_DELAY_200: .equ %0111_0000  ;ディレイモード(÷200 プリスケーラ)

CODE_ADDRESS: .equ $ed00c0
CODE_SIZE:    .equ countOnSramEnd-countOnSram
MAX_CODE_SIZE: .equ 16

.offset -24
  ~workTop:
  ~timerCVector: .ds.l 1
  ~sramData: .ds.b MAX_CODE_SIZE
  ~mfpIera: .ds.b 1
  ~mfpIerb: .ds.b 1
  ~mfpImra: .ds.b 1
  ~mfpImrb: .ds.b 1
  ~workBottom:
  .fail $.ne.0
.text

;MPUクロック数(kHz)の値を返す。
;  スーパーバイザモードで呼び出すこと。
;  68000,68010以外には対応していない。
;in
;  d0.l ... bit7-0: MPU種類(0:68000 ... 6:68060)
;out
;  d0.l ... MPUクロック数(kHz)。68020以上の場合は0
;
;・備考
;  SRAM上で1ms内にdbraの空ループが何回実行できるかを測定する。
;  回数×12でkHz数が求まる(12はdbra+メモリアクセスウェイトの動作クロック数)。
;  RAM上で測定して×10では、ときどきアクセスウェイトが入るため少し遅い値になるので
;  ROMと同じウェイトのSRAMで測定している。
;・注意
;  SRAMに一時的に測定ルーチンを書き込んでいる。
;  MFP Timer-Cを設定を変更して使用している。このため、システム時間が多少遅延する。
;
MpuClock_CountLoopOnSram::
  subq.b #2,d0
  bcs Count68000

  moveq #0,d0
  rts

Count68000:
  link a6,#~workTop
  PUSH d1-d7/a0-a5
  lea (MFP),a5
  lea (CODE_ADDRESS),a4
  move sr,d7

  DI
  bsr saveSram
  bsr writeCodeToSram
  bsr saveMfpRegs
  bsr setMfpRegs
  move.l (TIMERC_VEC*4),(~timerCVector,a6)
  lea (timerCInt,pc),a0
  move.l a0,(TIMERC_VEC*4)

  moveq #-1,d1
  moveq #-1,d2
  move d7,d0
  ori #SR_I_MASK,d0  ;測定終了時にmove to srする値
  lea (@f,pc),a0  ;測定終了時にjmpするアドレス

  move #$2500,sr
  move.b #250,(~MFP_TCDR,a5)
  ori.b #TCDCR_D_DELAY_16,(~MFP_TCDCR,a5)  ;Timer-C 動作開始
  jmp (a4)  ;SRAM上で測定
  @@:

  move.l (~timerCVector,a6),(TIMERC_VEC*4)
  bsr restoreMfpRegs
  bsr restoreSram
  move d7,sr

  move d1,d0  ;ループカウンタ上位
  swap d0
  move d2,d0  ;ループカウンタ下位
  not.l d0  ;neg.l + subq.l #1
  POP d1-d7/a0-a5
  unlk a6
  rts


;SRAM上で実行するコード
;in
;  d0.w = 終了時にsrに設定する値(割り込み禁止)
;  d2.w = $ffff, d1.w = $ffff
;  a0.l ... 終了時にジャンプするアドレス
;  a5.l ... MFP
;out
;  d2.w, d1.w ... 残り回数
countOnSram:
  1:
    2:
      ;空ループ
    dbra d2,2b  ;4bytes
  dbra d1,1b  ;4bytes
countOnSramExit:
  move d0,sr  ;2bytes
  jmp (a0)  ;2bytes
countOnSramEnd:
;ここまでSRAMに転送する
;(countOnSramEnd-countOnSram) <= MAX_CODE_SIZE であること

timerCInt:
  pea (countOnSramExit,pc)  ;dbra の空ループから抜ける
  move.l (sp)+,(2,sp)
  rte


writeCodeToSram:
  lea (countOnSram,pc),a0
  lea (a4),a1
  bra copyCodeToSram

restoreSram:
  lea (~sramData,a6),a0
  lea (a4),a1
  bsr copyCodeToSram

copyCodeToSram:
  SRAM_WRITE_ENABLE
  bsr copyCode
  SRAM_WRITE_DISABLE
  rts

saveSram:
  lea (a4),a0
  lea (~sramData,a6),a1
  bra copyCode

copyCode:
  moveq #CODE_SIZE/2-1,d0
  @@:
    move (a0)+,(a1)+
  dbra d0,@b
  rts

saveMfpRegs:
  move.b (~MFP_IERA,a5),(~mfpIera,a6)
  move.b (~MFP_IERB,a5),(~mfpIerb,a6)
  move.b (~MFP_IMRA,a5),(~mfpImra,a6)
  move.b (~MFP_IMRB,a5),(~mfpImrb,a6)
  rts

setMfpRegs:
  moveq #$00,d0
  move.b d0,(~MFP_IERA,a5)
  move.b d0,(~MFP_IMRA,a5)
  moveq #$20,d0
  move.b d0,(~MFP_IERB,a5)  ;Timer-C のみ許可
  move.b d0,(~MFP_IMRB,a5)
  andi.b #TCDCR_D_MASK,(~MFP_TCDCR,a5) ;Timer-C 停止
  rts

restoreMfpRegs:
  andi.b #TCDCR_D_MASK,(~MFP_TCDCR,a5)  ;Timer-C の設定を元に戻す
  move.b #200,(~MFP_TCDR,a5)
  ori.b #TCDCR_D_DELAY_200,(~MFP_TCDCR,a5)

  move.b (~mfpImra,a6),(~MFP_IMRA,a5)
  move.b (~mfpImrb,a6),(~MFP_IMRB,a5)
  move.b (~mfpIera,a6),(~MFP_IERA,a5)
  move.b (~mfpIerb,a6),(~MFP_IERB,a5)
  rts


.end
