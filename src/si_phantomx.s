.title Si -  PhantomX

.include si.mac


PHANTOMX_EA8000_REG:  .equ $ea8000
PHANTOMX_EA8002_DATA: .equ $ea8002

PHANTOMX_VERSION:     .equ $0000
PHANTOMX_MPU:         .equ $0001
PHANTOMX_WAIT:        .equ $0002
PHANTOMX_FDD_SWAP:    .equ $0003
PHANTOMX_VRAMDISK_ID: .equ $0010
PHANTOMX_TEMPERATURE: .equ $00f0


.cpu 68000
.text


;PhantomXが装着されているか調べる。
;out d0/ccr
PhantomX_Exists::
  move.l a0,-(sp)
  lea (PHANTOMX_EA8000_REG),a0
  bsr DosBusErrWord
  bne @f
    moveq #1,d0
    bra 9f
  @@:
  moveq #0,d0
9:
  movea.l (sp)+,a0
  rts


;PhantomXのバージョンを取得する。
;  PhantomXの装着を確認しておくこと。
;  スーパーバイザモードで呼び出すこと。
;out d0.l ... バージョン(BCD 4桁、上位ワードは $0000)
PhantomX_GetVersion::
  moveq #PHANTOMX_VERSION,d0
  bra getData


;PhantomXのエミュレーションMPUを取得する。
;  PhantomXの装着を確認しておくこと。
;  スーパーバイザモードで呼び出すこと。
;out d0.l ... MPUの種類 0:68000 3:68030 4:68040 6:68060
PhantomX_GetMpu::
  moveq #PHANTOMX_MPU,d0
  bra getData


;PhantomXのウェイトレベルを取得する。
;  PhantomXの装着を確認しておくこと。
;  スーパーバイザモードで呼び出すこと。
;out d0.l ... ウェイトレベル(0,1...7)
PhantomX_GetWait::
  moveq #PHANTOMX_WAIT,d0
  bra getData


;PhantomXのFDDスワップ設定を取得する。
;  PhantomXの装着を確認しておくこと。
;  スーパーバイザモードで呼び出すこと。
;out d0.l ... 0:off 1:on
PhantomX_GetFddSwap::
  moveq #PHANTOMX_FDD_SWAP,d0
  bsr getData
  andi #1,d0
  rts


;Raspberry Pi SOCの温度を取得する。
;  PhantomXの装着を確認しておくこと。
;  スーパーバイザモードで呼び出すこと。
;out d0.l ... 温度(BCD 4桁、上位ワードは $0000)
PhantomX_GetTemperature::
  moveq #.notb.PHANTOMX_TEMPERATURE,d0
  not.b d0
  bra getData


getData:
  PUSH_SR_DI
  move d0,(PHANTOMX_EA8000_REG)
  move (PHANTOMX_EA8002_DATA),d0
  POP_SR
  rts


;PhantomXのバージョンを文字列化する。
;in
;  d0.l ... バージョン(PhantomX_GetVersion の返り値)
;  a0.l ... 文字列バッファ(今のところ8バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
PhantomX_VersionToString::
  PUSH d1-d2
  bsr toHexString1  ;10の位
  moveq #$f,d1
  and.b d0,d1
  bne @f
    subq.l #1,a0  ;10の位が0だったら省略する
  @@:
  bsr toHexString1  ;1の位
  move.b #'.',(a0)+
  bsr toHexString2  ;小数部
  POP d1-d2
  rts


;PhantomXのエミュレーションMPUを文字列化する。
;in
;  d0.l ... MPU(PhantomX_GetMpu の返り値)
;  a0.l ... 文字列バッファ(今のところ8バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
PhantomX_MpuToString::
  move.b #'6',(a0)+
  move.b #'8',(a0)+
  move.b #'0',(a0)+
  addi.b #'0',d0
  move.b d0,(a0)+
  move.b #'0',(a0)+
  clr.b (a0)
  rts


;PhantomXのウェイトレベルを文字列化する。
;in
;  d0.l ... ウェイトレベル(PhantomX_GetWait の返り値)
;  a0.l ... 文字列バッファ(今のところ8バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
PhantomX_WaitToString::
  addi.b #'0',d0
  move.b d0,(a0)+
  clr.b (a0)
  rts


;PhantomXのFDDスワップ設定を文字列化する。
;in
;  d0.l ... FDDスワップ設定(PhantomX_GetFddSwap の返り値)
;  a0.l ... 文字列バッファ(今のところ8バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
PhantomX_FddSwapToString::
  move.l a1,-(sp)
  lea (strOff,pc),a1
  lsr #1,d0
  bcc @f
    addq.l #strOn-strOff,a1
  @@:
  STRCPY a1,a0,-1
  movea.l (sp)+,a1
  rts

strOff: .dc.b 'off',0
strOn:  .dc.b 'on',0
.even


;Raspberry Pi SOCの温度を文字列化する。
;in
;  d0.l ... 温度(PhantomX_GetTemperature の返り値)
;  a0.l ... 文字列バッファ(今のところ8バイトあれば足りる)
;out
;  a0.l ... 文字列末尾のアドレス(NUL を指す)
;break d0
PhantomX_TemperatureToString::
  PUSH d1-d2
  bsr toHexString2
  move.b #'.',(a0)+
  bsr toHexString2
  POP d1-d2
  rts


toHexString1:
  moveq #1-1,d2
  bra @f
toHexString2:
  moveq #2-1,d2
  @@:
    rol #4,d0
    moveq #$f,d1
    and.b d0,d1
    move.b (hexTable,pc,d1.w),(a0)+
  dbra d2,@b
  clr.b (a0)
  rts

hexTable: .dc.b '0123456789abcdef'
.even


.end
