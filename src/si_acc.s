.title Si - Accelerator

.include macro.mac

.xref check_bus_error_byte
.xref check_bus_error_word


FC_CPU: .equ 7
PMMU_REG: .equ $24000

MOVEL_IMM_D0: .equ $203C  ;move.l #imm,d0 のオペコード

BUSERR_VEC_NO:   .equ $02
BUSERR_VEC_ADDR: .equ BUSERR_VEC_NO*4

IOCS_0CBC_MPU_TYPE: .equ $cbc

SYSTEM_PORT6_E8E00B: .equ $e8e00b
SPC_E9602D_SSTS:     .equ $e9602d

XEIJ_E9F03C_HFS_MAGIC: .equ $e9f03c

AWESOMEX_EC0000_DSPADDR: .equ $ec0000
AWESOMEX_EC8000_DSPCTRL: .equ $ec8000

XELLENT30_S0_EC0000: .equ $ec0000
XELLENT30_S1_EC4000: .equ $ec4000
XELLENT30_S2_EC8000: .equ $ec8000
XELLENT30_S3_ECC000: .equ $ecc000

;ビット位置
ACC_XELLENT30_S0: .equ 0
ACC_XELLENT30_S1: .equ 1
ACC_XELLENT30_S2: .equ 2
ACC_XELLENT30_S3: .equ 3
ACC_JUPITER_X:    .equ 4
ACC_JUPITER_X060: .equ 5
ACC_040EXCEL:     .equ 6
ACC_060EXCEL:     .equ 7
ACC_040TURBO:     .equ 8
ACC_060TURBO:     .equ 9
;ACC_PHANTOMX:    .equ 10

;si_model.s
MODEL_UNIDENTIFIED:      .equ  0
MODEL_UNIDENTIFIED_SASI: .equ  1  ;初代/ACE/EXPERT/PRO
MODEL_UNIDENTIFIED_SCSI: .equ  2  ;SUPER/XVI/Compact
MODEL_UNIDENTIFIED_XVI:  .equ  3  ;XVI/Compact
MODEL_X68000:            .equ  4  ;初代(初期)
MODEL_X68000_SERIES:     .equ  5  ;初代(後期)/ACE/EXPERT/PRO
MODEL_PRO:               .equ  6  ;GetType が返すことはない
MODEL_SUPER:             .equ  7
MODEL_XVI:               .equ  8
MODEL_COMPACT:           .equ  9
MODEL_X68020:            .equ 10
MODEL_X68030:            .equ 11  ;X68030/X68030 Compact
MODEL_HYBRID:            .equ 12  ;XEiJ X68000 SCSI + ROM1.5-


.cpu 68000
.text

;アクセラレータの種類を返す。
;  スーパーバイザモードで呼び出すこと。
;out
;  d0.hw ... 0
;  d0.w .... アクセラレータの種類(ビットマップ)
;  ccr
Accelerator_GetTypes::
  PUSH d1-d2/d7/a0
  cmpi.b #$fe,(SYSTEM_PORT6_E8E00B)
  bcc @f
    bsr getTypes030
    bra 9f
  @@:
  bsr getTypes000
9:
  POP d1-d2/d7/a0
  tst.l d0
  rts


;X68030用アクセラレータの判別。
;out d0, break d1/a0
getTypes030:
  moveq #ACC_040TURBO,d1
  cmpi.b #4,(IOCS_0CBC_MPU_TYPE)
  beq @f

  moveq #ACC_060TURBO,d1
  cmpi.b #6,(IOCS_0CBC_MPU_TYPE)
  beq @f
  bsr is060turboRom  ;68030でも060turboのIOCS ROMなら060turboと見なす
  beq @f
    moveq #0,d0
    bra 9f
@@:
  moveq #0,d0
  bset d1,d0
9:
  rts


;060turbo用のIOCS ROMか調べる。
;out ccr, break d0/a0
is060turboRom:
  bsr getRomVer
  cmpi.l #$15_970213,d0
  beq @f
  cmpi.l #$15_970529,d0
  beq @f
  cmpi.l #$15_980315,d0
@@:
  rts


;IOCS ROMのバージョンを得る(IOCS _ROMVERを使わない)。
;out d0, break a0
getRomVer:
  lea ($ff0000),a0

  move.l ($8+2,a0),d0  ;ROM 1.0-1.2
  cmpi #MOVEL_IMM_D0,($8,a0)
  beq 9f

  move.l ($30+2,a0),d0  ;ROM 1.3
  cmpi #MOVEL_IMM_D0,($30,a0)
  beq 9f

  moveq #0,d0
9:
  rts


;X68000用アクセラレータの判別。
;out d0, break d1/d7/a1
getTypes000:
  bsr Accelerator_GetXellent30
  move.l d0,d7

  moveq #ACC_040EXCEL,d1
  cmpi.b #4,(IOCS_0CBC_MPU_TYPE)
  bcs 9f
    beq @f
      moveq #ACC_060EXCEL,d1
    @@:
    bsr is040Excel
    bne @f
      subq #ACC_040EXCEL-ACC_JUPITER_X,d1
    @@:
    bset d1,d7
9:
  move.l d7,d0
  rts


;040Excel(限定配布版)上で実行されているか調べる。
;  MPU 68040/68060専用。
;  040Excel(限定配布版)ではCPU空間にスーパーバイザデータが割り当てられているので、
;  コプロセッサにアクセスすることは出来ない。そこで、コプロセッサ領域としては不正な
;  アドレスをアクセスしてアクセスフォールトが発生しないかどうかで判別を行う。
;out d0/ccr
.cpu 68040
is040Excel:
  PUSH d6-d7/a0-a2
  moveq #FC_CPU,d0
  lea (BUSERR_VEC_ADDR),a0
  lea (8f,pc),a2

  PUSH_SR_DI
  movec sfc,d6
  movec dfc,d7
  movec d0,sfc
  movec d0,dfc

  movea.l (a0),a1  ;バスエラーの処理アドレスを保存して差し替え
  move.l a2,(a0)

  movea.l sp,a2

  moves (PMMU_REG),d0  ;040Excelならアクセスフォールトが発生する

  moveq #0,d0  ;上の命令が正常終了すれば、040Excelなし
  bra	9f
8:
  movea.l a2,sp
  moveq #1,d0  ;040Excelあり
9:
  move.l a1,(a0)  ;バスエラーの処理アドレスを戻す

  movec d6,sfc
  movec d7,dfc
  POP_SR

  POP d6-d7/a0-a2
  tst.l d0
  rts
.cpu 68000


xel0: .equ XELLENT30_S0_EC0000+$100
xel1: .equ XELLENT30_S1_EC4000+$100
xel2: .equ XELLENT30_S2_EC8000+$100
xel3: .equ XELLENT30_S3_ECC000+$100

;Xellent30の判別。
;  $ec0000はX68K-PPIと、$ecc000はMercury-Unitと誤認するので、
;  避けて+$100のアドレスを調べる。
;out d0/ccr
Accelerator_GetXellent30::
  PUSH d1/d7/a0
  moveq #0,d7

  moveq #ACC_XELLENT30_S3,d1
  lea (xel3),a0
  bsr getXt30

  ;AWESOME-Xが存在するなら #0-#2 は存在できない
  bsr Accelerator_AwesomexExists
  bne 9f
    moveq #ACC_XELLENT30_S2,d1
    lea (xel2-xel3,a0),a0
    bsr getXt30

    moveq #ACC_XELLENT30_S1,d1
    lea (xel1-xel2,a0),a0
    bsr getXt30

    moveq #ACC_XELLENT30_S0,d1
    lea (xel0-xel1,a0),a0
    bsr getXt30
9:
  move.l d7,d0
  POP d1/d7/a0
  rts

getXt30:
  bsr check_bus_error_byte
  bne @f
    bset d1,d7
  @@:
  rts


awe1: .equ AWESOMEX_EC0000_DSPADDR+$100
awe2: .equ AWESOMEX_EC8000_DSPCTRL

;AWESOME-Xが装着されているか調べる。
;  $ec0100.wと$ec8000.wが読み込み可能ならAWESOME-Xあり。
;  $ec0000はX68K-PPIと誤認すると思われるので避ける。
;  アドレス的には、Xellent30 #0と#2が2階建てで装着されていると誤認する。
;out d0/ccr
Accelerator_AwesomexExists::
  move.l a0,-(sp)
  lea (awe1),a0
  bsr check_bus_error_word
  bne @f
    lea (awe2-awe1,a0),a0
    bsr check_bus_error_word
  @@:
  seq d0
  neg.b d0
  ext d0
  ext.l d0
  movea.l (sp)+,a0
  rts


;アクセラレータ名を文字列化する。
;  複数のアクセラレータが認識されている場合、最上位のアクセラレータ
;  のみ文字列化する。
;in
;  d0.hw ... 本体機種(Model_GetType の返り値; 不明なら0にする)
;  d0.w .... アクセラレータの種類(Accelerator_GetTypes の返り値)
;  a0.l ... 文字列バッファ(今のところ32バイトあれば足りる)
;out
;  d0.l ... 引数の d0.l と同じ。
;           ただし、最上位のアクセラレータのビットがクリアされる。
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
Accelerator_ToString::
  PUSH d1/d6-d7/a1
  move.l d0,d7
  clr.b (a0)

  moveq #ACC_060TURBO,d6
  @@:
    bclr d6,d7
  dbne d6,@b
  beq 9f  ;アクセラレータなし

    cmpi #ACC_XELLENT30_S3,d6
    bhi @f
      move.l d7,d0
      bsr copyXellent30
    @@:
    lea (accNameOffs,pc,d6.w),a1
    move.b (a1),d6
    adda d6,a1
    STRCPY a1,a0
    subq.l #1,a0
9:
  move.l d7,d0
  POP d1/d6-d7/a1
  rts

accNameOffs: .dc.b @f-$,1f-$,2f-$,3f-$,4f-$,5f-$,6f-$,7f-$,8f-$,9f-$
@@: .dc.b ' (#0)',0  ;Xellent30
1:  .dc.b ' (#1)',0
2:  .dc.b ' (#2)',0
3:  .dc.b ' (#3)',0
4:  .dc.b 'Jupiter-X',0
5:  .dc.b 'Jupiter-X/060',0
6:  .dc.b '040Excel',0
7:  .dc.b '060Excel',0
8:  .dc.b '040turbo',0
9:  .dc.b '060turbo',0
.even

copyXellent30:
  swap d0
  lea (xelNameTable,pc),a1
  moveq #0,d1
  @@:
    move.b (a1)+,d1
    bmi @f
    cmp.b d0,d1
    beq @f
      addq.l #1,a1
      bra @b
  @@:
  move.b (a1),d1
  adda d1,a1
  STRCPY a1,a0
  subq.l #1,a0
  rts

.data
xelNameTable:
  .dc.b MODEL_UNIDENTIFIED_SASI,xellent30s-$
  .dc.b MODEL_X68000_SERIES,xellent30s-$
  .dc.b MODEL_SUPER,xellent30s-$
  .dc.b MODEL_PRO,xellent30pro-$
  .dc.b -1,xellent30-$

xellent30:    .dc.b 'Xellent30',0
xellent30s:   .dc.b 'Xellent30s',0
xellent30pro: .dc.b 'Xellent30PRO',0
.text


.end
