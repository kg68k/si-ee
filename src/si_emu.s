.title Si - Emulator

.include si.mac
.include doscall.mac

.xref check_bus_error_byte
.xref check_bus_error_long


SYSPORT_E8E00B_P6: .equ $e8e00b
SYSPORT_E8E00D_P7: .equ $e8e00d

WINPORT_E9F000:        .equ $e9f000
XEIJ_E9F03C_HFS_MAGIC: .equ $e9f03c

MU_ECC091_COMMAND: .equ $ecc091

EMULATOR_REAL::      .equ 0
EMULATOR_EX68::      .equ 1
EMULATOR_WINX68K::   .equ 2
EMULATOR_WINX68030:: .equ 3
EMULATOR_WINX68KSE:: .equ 4
EMULATOR_WINX68KCE:: .equ 5
EMULATOR_XM6::       .equ 6
EMULATOR_XM6I::      .equ 7
EMULATOR_XM6G::      .equ 8
EMULATOR_XEIJ::      .equ 9
.fail EMULATOR_REAL.ne.0


.cpu 68000
.text

;エミュレータの種類を調べる。
;  スーパーバイザモードで呼び出すこと。
;out d0.hw ... バージョン
;    d0.w .... 種類(0-9)
Emulator_GetType::
  PUSH d1/a0

  ;XM6 v0.90 以降 / XM6i / XM6g
  lea (SYSPORT_E8E00D_P7),a0
  bsr getXm6Version
  bne 9f

  ;WinX68k SE/CE v0.71 以降
  bsr getWinSCVersion
  bne 9f

  ;XEiJ HFS と EX68 WINPORT は、040Excel(試作版)が$e9f000-$00e9f7ffで競合するが割愛

  ;XEiJ (X68000 Emulator in Java)
  lea (XEIJ_E9F03C_HFS_MAGIC),a0
  bsr check_bus_error_long
  bne @f
    moveq #EMULATOR_XEIJ,d1
    cmpi.l #'JHFS',d0
    beq 8f
  @@:

  ;WINPORTが読めなければ実機
  lea (WINPORT_E9F000),a0
  moveq #EMULATOR_REAL,d1
  bsr check_bus_error_byte
  bne 8f

  ;EX68
  moveq #EMULATOR_EX68,d1
  tst.b (SYSPORT_E8E00B_P6)
  beq 8f

  ;Mercury-Unit がなければ XM6 v0.90 未満
  ;  この時点で XM6 or WinX68k or WinX68030 なので、実機としての Xellent30(#3) の存在確認は不要
  moveq #EMULATOR_XM6,d1
  lea (MU_ECC091_COMMAND),a0
  bsr check_bus_error_byte
  bne 8f

  ;Mercury-Unit があれば WinX68k / WinX68030
  bsr getWin68kType
8:
  move.l d1,d0  ;バージョン番号なし
9:
  POP d1/a0
  rts


READ_VER: .macro ea,dn
  move.b ea,-(sp)
  move (sp)+,dn  ;バージョン上位
  move.b ea,dn   ;バージョン下位
.endm

;XM6、XM6g、XM6iの判別を行う。
;in a0, out d0/ccr
getXm6Version:
  moveq #EMULATOR_REAL,d0

  PUSH_SR_DI
  move.b #'X',(a0)
  cmpi.b #'6',(a0)
  bne 9f

  READ_VER (a0),d0
  swap d0

  move.b (a0),d0
  cmpi.b #'g',d0
  beq 2f
  cmpi.b #'i',d0
  beq 1f
    move #EMULATOR_XM6,d0
    bra 9f
  1:
    READ_VER (a0),d0  ;最初に読んだ値はダミーなので、XM6iのバージョンを読み直す
    swap d0
    move #EMULATOR_XM6I,d0
    bra 9f
  2:
    move #EMULATOR_XM6G,d0
9:
  POP_SR
  tst.l d0
  rts


;WinX68k S.E.、C.E.の判別を行う。
;in a0, out d0/ccr
getWinSCVersion:
  PUSH_SR_DI
  move.b #'W',(a0)
  move.b (a0),d0
  cmpi.b #'S',d0
  beq 1f
  cmpi.b #'C',d0
  beq 2f
    moveq #EMULATOR_REAL,d0
    bra 9f
  1:
    moveq #EMULATOR_WINX68KSE,d0
    bra @f
  2:
    moveq #EMULATOR_WINX68KCE,d0
  @@:
  swap d0
  READ_VER (a0),d0
  swap d0
9:
  POP_SR
  tst.l d0
  rts


;WinX68kとWinX68030の判別を行う。
;out d1
getWin68kType:
  moveq #1,d1
  .cpu 68030
  move.b (@f-1,pc,d1.w*2),d1  ;スケールファクタを利用して68000/68030判別
  .cpu 68000
  rts
@@:
  .dc.b EMULATOR_WINX68K,EMULATOR_WINX68030
  .even


;エミュレータの種類・バージョンを文字列化する。
;in
;  d0.l ... バージョン・種類(Emulator_GetType の返り値)
;  a0.l ... 文字列バッファ(今のところ64バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
Emulator_ToString::
  PUSH d1-d3/a1

  lea (emuNameOffs,pc,d0.w),a1
  move.b (a1),d0
  adda d0,a1
  STRCPY a1,a0,-1

  clr d0
  swap d0
  beq 9f  ;バージョン番号なし
    lea (version,pc),a1
    STRCPY a1,a0,-1

    subq.l #8,sp
    lea (sp),a1
    bsr versionToString
    lea (sp),a1
    cmpi.b #'0',(a1)
    bne @f
      addq.l #1,a1  ;十の位が0なら省略する
    @@:
    STRCPY a1,a0,-1
    addq.l #8,sp
9:
  POP d1-d3/a1
  rts

emuNameOffs: .dc.b @f-$,1f-$,2f-$,3f-$,4f-$,5f-$,6f-$,7f-$,8f-$,9f-$
@@: .dc.b 'real machine',0
1:  .dc.b 'EX68',0
2:  .dc.b 'WinX68k',0
3:  .dc.b 'WinX68030',0
4:  .dc.b 'WinX68k S.E.',0
5:  .dc.b 'WinX68k C.E.',0
6:  .dc.b 'XM6',0
7:  .dc.b 'XM6i',0
8:  .dc.b 'XM6 TypeG',0
9:  .dc.b 'XEiJ',0
version: .dc.b ' version ',0
.even


;バージョン番号を文字列化する
;in d0/a1, break d0/d2-d3/a1
versionToString:
  moveq #'0',d2
  bsr @f  ;十の位
  bsr @f  ;一の位
  move.b #'.',(a1)+
  bsr @f  ;小数第一位
  bsr @f  ;小数第二位
  clr.b (a1)
  rts
@@:
  rol #4,d0
  moveq #$f,d3
  and.b d0,d3
  add.b d2,d3
  move.b d3,(a1)+
  rts


.end
