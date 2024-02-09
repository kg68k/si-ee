.title Si - Sram

.include si.mac


SRAM_ED0000_START:     .equ $ed0000
SRAM_ED002D_SRAM_USE:  .equ $ed002d
SRAM_ED0010_SRAM_BOOT: .equ $ed0010
SRAM_ED0100_PROGRAM:   .equ $ed0100
SRAM_ED4000_END:       .equ $ed4000
SRAM_EE0000_END_MAX:   .equ $ee0000

SRAM_U_NO_USE::  .equ 0
SRAM_U_RAMDISK:: .equ 1
SRAM_U_PROGRAM:: .equ 2

SRAM_P_UNKNOWN::    .equ 0
SRAM_P_CH30_OMAKE:: .equ 1
.fail SRAM_P_UNKNOWN.ne.0


;ch30_omake.sys
CH30_HEADER_ID:   .equ 'CH30'
CH30_HEADER2_ID:  .equ 'XT30'
CH30_SAVE_MAGIC:  .equ 'A'
CH30_VER_LEN_MAX: .equ 32

.offset 0
~CH30_STARTUP:      .ds    1  ;bra.s
~CH30_HEADER:       .ds.l  1  ;'CH30'
~CH30_SECOND_BOOT:  .ds.l  1
~CH30_XT30IO:       .ds.l  1  ;$00ec?000
~CH30_HEADER2:      .ds.l  1  ;'XT30'
~CH30_68030_ENTRY:  .ds    1
~CH30_BOOT_COUNTER: .ds.l  1
                    .ds.b  1
~CH30_SAVE_MAGIC:   .ds.b  1  ;'A'
~CH30_SAVEAREA:     .ds.b 10
~CH30_VERSION:      .ds.b  1  ;不定サイズ
.text


.cpu 68000
.text

;SRAMのサイズを調べる(KiB単位)。
;out d0.l ... キビバイト数
Sram_GetSizeInKiB::
  bsr Sram_GetSize
  lsr.l #2,d0
  lsr #8,d0
  rts


;SRAMのサイズを調べる。
;out d0.l ... バイト数
Sram_GetSize::
  PUSH d1/a0
  lea (SRAM_ED4000_END),a0
  @@:
    bsr DosBusErrLong
    bne @f
      lea (1024,a0),a0
    cmpa.l #SRAM_EE0000_END_MAX,a0
    bcs @b
  @@:
  suba.l #SRAM_ED0000_START,a0
  move.l a0,d0
  POP d1/a0
  rts


;SRAMの使用モードを調べる。
;  $ed002d(1バイト)を取得するだけ。
;out d0.l ... SRAM_U_* 0:未使用 1:SRAMDISK 2:プログラム
Sram_GetUseMode::
  moveq #0,d0
  move.b (SRAM_ED002D_SRAM_USE),d0
  rts


;SRAMに組み込まれているプログラムの種類を調べる。
;  予めSRAMの使用モードが2(プログラム)であることを確認しておくこと。
;out d0.l ... SRAM_P_*
SramProgram_GetType::
  PUSH a0-a1
  lea (SRAM_ED0000_START),a0
  lea (SRAM_ED0100_PROGRAM-SRAM_ED0000_START,a0),a1

  bsr getType_ch30omake

  POP a0-a1
  rts


getType_ch30omake:
  cmp.l (SRAM_ED0010_SRAM_BOOT-SRAM_ED0000_START,a0),a1
  bne @f
  cmpi.l #CH30_HEADER_ID,(~CH30_HEADER,a1)
  bne @f
  cmpi.l #CH30_HEADER2_ID,(~CH30_HEADER2,a1)
  bne @f
  cmpi.b #CH30_SAVE_MAGIC,(~CH30_SAVE_MAGIC,a1)
  bne @f

    moveq #SRAM_P_CH30_OMAKE,d0
    rts
@@:
  moveq #SRAM_P_UNKNOWN,d0
  rts


;プログラムの名称とバージョンを文字列化する。
;in
;  d0.l ... 種類(SramProgram_GetTypeの返り値)
;  a0.l ... 文字列バッファ(今のところ64バイトあれば足りる)
;out
;  d0.l ... 0:失敗(名称なし) 1:成功
;  a0.l ... 文字列末尾のアドレス(NULを指す)
SramProgram_ToString::
  move.l a1,-(sp)
  subq.l #SRAM_P_CH30_OMAKE,d0
  bne 8f
    bsr toStr_ch30omake
    moveq #1,d0
    bra 9f
8:
  moveq #0,d0
9:
  movea.l (sp)+,a1
  rts


toStr_ch30omake:
  lea (ch30_omake_sys,pc),a1
  STRCPY a1,a0,-1

  lea (SRAM_ED0100_PROGRAM+~CH30_VERSION),a1
  moveq #CH30_VER_LEN_MAX-1,d0
  @@:
    move.b (a1)+,(a0)+
  dbeq d0,@b
  beq @f
    clr.b (a0)+
  @@:
  subq.l #1,a0
  rts


ch30_omake_sys: .dc.b 'ch30*_omake.sys version ',0
.even


.end
