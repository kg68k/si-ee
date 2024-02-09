.title Si - Scsiex

.include si.mac


SCSIEX_LIST: .macro op
  item: .macro type,symbol,rom,name
    op
  .endm

  item  0,SCSIEX_NONE,      0,''
  item  1,SCSIEX_UNKNOWN,   0,'unknown device'
  item  2,SCSIEX_SPC,       0,'SPC board'
  item  3,SCSIEX_CZ6BS1,    0,'CZ-6BS1'
  item  4,SCSIEX_SX68SC,    1,'SX-68SC'
  item  5,SCSIEX_TS6BS1,    0,''  ;未対応
  item  6,SCSIEX_TS6BS1MK2, 0,''  ;未対応
  item  7,SCSIEX_TS6BS1MK2D,0,''  ;未対応
  item  8,SCSIEX_TS6BS1MK3, 0,'TS-6BS1mkIII'
  item  9,SCSIEX_MACH2,     1,'Mach-2'
  item 10,SCSIEX_MACH2P,    1,'mach2p'
  item 11,SCSIEX_XM6,       1,''
  item 12,SCSIEX_XEIJ15,    1,''
  item 13,SCSIEX_XEIJ16,    1,''
.endm

SCSIEX_LIST <symbol:: .equ type>

SCSIEX_BASE:  .equ $ea0000
~SCSIEX_PSNS: .equ $000b  ;MB89352 Phase Sense
~SCSIEX_ID:   .equ $0044  ;'SCSIEX'

ROM_NAME_MAX: .equ 63


.ifdef TEST
  .include si_scsiex_test.mac
.else
  TEST_ONLY: .macro
  .endm
.endif


.cpu 68000
.text


;SCSIボードの種類を調べる。
;out d0.l ... 種類
Scsiex_GetType::
  PUSH d1-d2/a0-a1/a5
  lea (SCSIEX_BASE),a5

  moveq #SCSIEX_UNKNOWN,d2
  bsr verifyScsiexId
  bgt @f  ;'SCSIEX'識別子あり
  beq 8f  ;何らかのメモリはあるが識別子が一致しない

    ;SCSIEX ROMなし
    moveq #SCSIEX_NONE,d2
    lea (~SCSIEX_PSNS,a5),a0
    bsr DosBusErrByte
    bne 8f  ;SPC(MB89352)なし

    moveq #SCSIEX_SPC,d0  ;SPCボードあり
    bra 9f

  @@:
  ;ROMの内容によって判別する
  lea (idDataTbl,pc),a0
  bsr getTypeByRomData
  bne 9f

    ;未知のROMならCZ-6BS1とみなす
    moveq #SCSIEX_CZ6BS1,d2
8:
  move.l d2,d0
9:
  POP d1-d2/a0-a1/a5
  rts


;SCSIEX ROMに'SCSIEX'識別子があるか調べる。
;in a5.l ... SCSIEX_BASE
;out d0.l ... -1:ROMなし 0:識別子なし 1:識別子あり
;break a0
verifyScsiexId:
  lea (~SCSIEX_ID,a5),a0
  bsr DosBusErrLong
  bne 2f
  cmpi.l #'SCSI',d0
  bne 1f

  addq.l #4,a0
  bsr DosBusErrWord
  bne 2f
  cmpi #'EX',d0
  bne 1f

    moveq #1,d0
    rts
1:
  moveq #0,d0
  rts
2:
  moveq #-1,d0
  rts


;ROM内の値を比較してROMの種類を判別する。
;in a0/a5, out d0, break d1/a0-a1
getTypeByRomData:
  PUSH d2/a2/a4
  link a6,#-RomReader_BUFFER_SIZE
  lea (sp),a4
  bsr RomReader_Init

  lea (a0),a2
  moveq #0,d2
  1:
    move.b (a2)+,d2  ;type
    beq 9f

    moveq #0,d1
    move.b (a2)+,d1  ;length
    lea (a5),a0
    adda (a2)+,a0    ;address
    lea (a2),a1
    adda d1,a2  ;次の行のデータ
    @@:
      bsr RomReader_ReadLong
      addq.l #4,a0
      cmp.l (a1)+,d0
      bne 1b
    subq #4,d1
    bhi @b
9:
  move.l d2,d0
  unlk a6
  POP d2/a2/a4
  rts


ID_DATA: .macro type,addr,len,str
  .sizem sz,argc
  .dc.b type,len
  .dc   (addr-SCSIEX_BASE)
  .fail (addr-SCSIEX_BASE)>=$8000
  .if argc>=4
    .dc.l str
  .endif
.endm

idDataTbl:
  ID_DATA SCSIEX_MACH2,    $ea00d8,8,' Mach-2 '
  ID_DATA SCSIEX_MACH2P,   $ea00d8,8,' mach2p '
  ID_DATA SCSIEX_SX68SC,   $ea0070,8,'M SACOM '

  ID_DATA SCSIEX_TS6BS1MK3,$ea1640,32
    .dc.l $4e7a0002,$807c0808,$4e7b0002,$c07cf7f7
    .dc.l $4e7b0002,$4cdf0301,$4e750000,$ffff0000

  ID_DATA SCSIEX_XEIJ16,   $ea004c,8,'SCSIEXRO'
  ID_DATA SCSIEX_XEIJ15,   $ea004c,8,"XEiJDon'"
  ID_DATA SCSIEX_XM6,      $ea1ff8,4,'XM6 '

  .dc.b 0
.even


.offset 0
RomReader_ADDRESS: .ds.l 2
RomReader_VALUE:   .ds.l 2
RomReader_BUFFER_SIZE:
.text

;初期化
;in a4.l バッファ(16バイト)
;break d0
RomReader_Init:
  moveq #0,d0
  move.l d0,(RomReader_ADDRESS,a4)
  move.l d0,(RomReader_ADDRESS+4,a4)
  rts

;ROMのデータを読む(ロングワード)
;in
;  a0.l アドレス
;  a4.l バッファ
;out
;  d0.l 読み込んだデータ(バスエラー発生時は 0)
RomReader_ReadLong:
  move.l d1,-(sp)
  move a0,d1
  andi #%100,d1

  cmpa.l (RomReader_ADDRESS,a4,d1.w),a0
  bne @f
    move.l (RomReader_VALUE,a4,d1.w),d0  ;キャッシュ済みアドレスだった
    bra 9f
  @@:
  bsr DosBusErrLong
  beq @f
    moveq #0,d0
  @@:
  move.l a0,(RomReader_ADDRESS,a4,d1.w)
  move.l d0,(RomReader_VALUE,a4,d1.w)
9:
  move.l (sp)+,d1
  rts


;SCSIボードの種類を文字列化する。
;in
;  d0.l ... 種類(Scsiex_GetType の返り値)
;  a0.l ... 文字列バッファ(今のところ64バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
Scsiex_ToString::
  move.l a1,-(sp)
  lea (nameOffs,pc,d0.w),a1
  move.b (a1),d0
  adda d0,a1
  STRCPY a1,a0,-1
  movea.l (sp)+,a1
  rts


nameItem: .macro type,symbol,rom,name
  .if (.sizeof.(name)==0).and.(type!=SCSIEX_NONE)
    str&symbol: .equ strSCSIEX_CZ6BS1
  .else
    str&symbol: .dc.b name,0
  .endif
.endm

nameOffs:
  SCSIEX_LIST <.dc.b str&symbol-$>
  SCSIEX_LIST <nameItem type,symbol,rom,name>
.even


;SCSIボードのROM名称が存在するか返す。
;out d0/ccr
Scsiex_hasRomName::
  move.b (hasNameTbl,pc,d0.w),d0
  rts

hasNameTbl:
  SCSIEX_LIST <.dc.b rom>
.even


;SCSIボードのROM名称をコピーする。
;in
;  d0.l ... 種類(Scsiex_GetType の返り値)
;  a0.l ... 文字列バッファ(64バイト)
;out
;  d0.l ... 0:失敗(名称なし) 1:成功
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
Scsiex_GetRomName::
  PUSH d1-d2/a1
  lea (SCSIEX_BASE),a1

  moveq #$20,d1
  moveq #ROM_NAME_MAX-1,d2
  move.b (romNameOffs,pc,d0.w),d0
  jsr (romNameOffs,pc,d0.w)

  POP d1-d2/a1
  rts


romNameOffs:
  SCSIEX_LIST <.dc.b romName&symbol-romNameOffs>
.even


romNameSCSIEX_NONE:
romNameSCSIEX_UNKNOWN:
romNameSCSIEX_SPC:
romNameSCSIEX_CZ6BS1:
romNameSCSIEX_TS6BS1:
romNameSCSIEX_TS6BS1MK2
romNameSCSIEX_TS6BS1MK2D:
romNameSCSIEX_TS6BS1MK3:
  moveq #0,d0
  move.b d0,(a0)
  rts


;'SCSI board for X68k Version 1.01  1992',CR,LF,0
romNameSCSIEX_SX68SC:
  lea ($007a,a1),a1
  bra copyRomName


;'X680x0 SCSI Host Adapter Mach-2 BIOS',CR,LF,0
;'X680x0 SCSI Host Adapter mach2p BIOS',CR,LF,0
romNameSCSIEX_MACH2:
romNameSCSIEX_MACH2P:
  lea ($00c0,a1),a1
  bra copyRomName


;'XM6 2.06'
;  8バイトの文字列がROM終端にあるため、NULで終わっていないので注意。
romNameSCSIEX_XM6:
  lea ($1ff8,a1),a1
  moveq #8-1,d2
  bra copyRomName


;'derived from IPLROM30.DAT.',$48e7,$fffe
;  文字列が $00 で終わっていないので $48e7(movem.l) を見る。
romNameSCSIEX_XEIJ15:
  lea ($0072,a1),a1
  TEST_ONLY <TRANSLATE_ROM_ADDRESS a1>

  moveq #0,d0
  @@:
    lsl #8,d0
    move.b (a1)+,d0
    cmpi #$48e7,d0
    beq 1f  ;直前にコピーした$48は取り消す
    move.b d0,(a0)+
  cmp.b d1,d0  ;$20未満の文字(CR,LF,NUL)で終了
  dblt d2,@b   ;$80-$ffなら文字ではなく命令とみなして終了
  bge @f
    1:
    subq.l #1,a0
  @@:
  bra copyRomName_finish


;'SCSIEXROM 16 (2022-02-15)',0
romNameSCSIEX_XEIJ16:
  lea ($004c,a1),a1
  bra copyRomName


;in a0/a1, out d0, break d1-d2
copyRomName:
  TEST_ONLY <TRANSLATE_ROM_ADDRESS a1>
  @@:
    move.b (a1)+,d0
    move.b d0,(a0)+
  cmp.b d1,d0  ;$20未満の文字(CR,LF,NUL)で終了
  dbcs d2,@b
  bcc @f
    subq.l #1,a0
  @@:
copyRomName_finish:
  clr.b (a0)
  moveq #1,d0
  rts



.end
