		.title	Si - utilities


* Include File -------------------------------- *

		.include	si.mac
		.include	doscall.mac


* Text Section -------------------------------- *

		.cpu	68000

		.text
		.even


* 指定アドレスを読みこんでバスエラーが発生するか調べる
* in	a0.l	アドレス
* out	d0.bwl	読み込んだデータ
*	ccr	Z=1:正常終了 Z=0:バスエラーが発生した

check_bus_error_byte::
		move	#1,-(sp)
		move.l	sp,-(sp)
		move.l	a0,-(sp)
		DOS	_BUS_ERR
		move.l	d0,(sp)
		moveq	#0,d0
		move.b	(8,sp),d0
		tst.l	(sp)+
		addq.l	#10-4,sp
		rts

check_bus_error_word::
		move	#2,-(sp)
		move.l	sp,-(sp)
		move.l	a0,-(sp)
		DOS	_BUS_ERR
		move.l	d0,(sp)
		moveq	#0,d0
		move	(8,sp),d0
		tst.l	(sp)+
		addq.l	#10-4,sp
		rts

check_bus_error_long::
		move	#4,-(sp)
		subq.l	#4,sp
		move.l	sp,(sp)
		move.l	a0,-(sp)
		DOS	_BUS_ERR
		move.l	d0,(sp)
		move.l	(4,sp),d0
		tst.l	(sp)+
		addq.l	#10-4,sp
		rts

* 指定アドレスから読み書きしてバスエラーが発生するか調べる
* in	a0.l	アドレス
* out	d0.l	0:OK 1:Write Error 2:Read Error -1:Arg Error
*	ccr	Z=1:正常終了 Z=0:バスエラーが発生した

	.if	0
check_bus_error_byte_rw::
		move	#1,-(sp)
		move.l	a0,-(sp)
		move.l	a0,-(sp)
		DOS	_BUS_ERR
		addq.l	#10-4,sp
		move.l	d0,(sp)+
		rts
	.endif


* 数値を 16 進数文字列に変換する -------------- *
* 桁数固定、0 詰め、接頭記号($、0x の類)なし、NUL 終端
* 引数は d0.l の上位桁から渡す(左詰め)
* in	d0.l	数値
*	a0.l	文字列バッファ
* out	a0.l	+= strlen(a0)

* バイト値 -> 二桁
* in	d0.hwhb	数値
* out	a0.l	+= 2

hexstr_byte::
		PUSH	d0-d2
		moveq	#2-1,d1
		bra	hexstr_loop

* ワード値 -> 四桁
* in	d0.hw	数値
* out	a0.l	+= 4

hexstr_word::
		PUSH	d0-d2
		moveq	#4-1,d1
		bra	hexstr_loop

* ロングワード値 -> 八桁
* in	d0.l	数値
* out	a0.l	+= 8

hexstr_long::
		PUSH	d0-d2
		moveq	#8-1,d1
		bra	hexstr_loop

hexstr_loop:
		rol.l	#4,d0
		moveq	#$f,d2
		and	d0,d2
		move.b	(hex_table,pc,d2.w),(a0)+
		dbra	d1,hexstr_loop
		clr.b	(a0)
		POP	d0-d2
		rts

hex_table::
*		.dc.b	'0123456789ABCDEF'
		.dc.b	'0123456789abcdef'

* ロングワード値 -> 1～8 桁
* in	d0.l	数値
* out	a0.l	+= 桁数
* 備考:
*	上位桁の 0 は省略する.

hexstr_z::
		PUSH	d0-d2
		moveq	#8-1,d1
hexstr_z_loop:
		cmpi.l	#$1000_0000,d0
		bcc	hexstr_loop
		lsl.l	#4,d0
		dbra	d1,hexstr_z_loop
		moveq	#1-1,d1			;0 の場合
		bra	hexstr_loop


* ロングワード値(符号なし) -> 10 進数文字列
* in	d0.l	数値(符号なし)
*	a0.l	バッファ
* out	a0.l	+= 桁数

decstr::
		PUSH	d0-d2/a1
		lea	(dec_table,pc),a1
decstr_loop1:
		move.l	(a1)+,d1
		bmi	decstr_1
		cmp.l	d1,d0
		bcs	decstr_loop1
decstr_loop2:
		moveq	#'0'-1,d2
@@:		addq.l	#1,d2
		sub.l	d1,d0
		bcc	@b
		add.l	d1,d0
		move.b	d2,(a0)+
		move.l	(a1)+,d1
		bpl	decstr_loop2
decstr_1:
		addi.b	#'0',d0
		move.b	d0,(a0)+
decstr_end:
		clr.b	(a0)
		POP	d0-d2/a1
		rts

dec_table:
		.dc.l	1000000000
		.dc.l	100000000
		.dc.l	10000000
		.dc.l	1000000
		.dc.l	100000
		.dc.l	10000
		.dc.l	1000
		.dc.l	100
		.dc.l	10
		.dc	-1


* デバイスドライバを検索する ------------------ *
* in	d0.hw	デバイス属性マスク
*	d0.w	デバイス属性
*	a0.l	デバイス名(8 バイトの文字)
* out	d0.l	デバイスヘッダのアドレス(0 なら見つからなかった)
*	a0.l	〃
* 機能:
*	a0.l で指定したデバイス名が一致したデバイスヘッダのデバイス属性
*	と d0.hw の論理積をとり、その値を d0.w と比較し一致すればデバイ
*	スヘッダのアドレスを d0.l と a0.l に返す. d0.l に 0 を指定すれば
*	デバイス属性は完全に無視される.
*	同じデバイス名が複数ある場合、最初のデバイスを返す.
* 制限:
*	検索が行われるのは Human68k 内蔵の CLOCK デバイス以降であり、そ
*	れより前にある NUL、CON、AUX、PRN、LPT デバイスを検索することは
*	出来ない.

device_search::
		PUSH	d1/a1-a3
		move.l	d0,d1
**		clr.l	-(sp)
**		DOS	_SUPER
**		move.l	d0,(sp)

		movea.l	($1cb6),a1		;CLOCK デバイスのアドレス
devsch_loop:
		tst.l	d1
		beq	devsch_cmp_name		;デバイス属性は比較不要

		move.l	d1,d0
		and.l	(4,a1),d0		;属性をマスクする
		swap	d0
		cmp	d1,d0
		bne	devsch_next
devsch_cmp_name:
		lea	(a0),a2
		lea	(14,a1),a3		;デバイス名
		moveq	#8-1,d0
devsch_cmp_loop:
		cmpm.b	(a2)+,(a3)+
		dbne	d0,devsch_cmp_loop
		beq	devsch_end		;見つかった
devsch_next:
		movea.l	(a1),a1			;次のデバイスヘッダ
		cmpa	#-1,a1
		bne	devsch_loop
		suba.l	a1,a1			;見つからなかった
devsch_end:
**		tst	(sp)
**		bmi	devsch_skip
**		DOS	_SUPER
**devsch_skip:	addq.l	#4,sp
		move.l	a1,d0
		POP	d1/a1-a3
		rts


* 擬似 FLOAT ファンクション ------------------- *

* FPACK __IDIV
* in	d0.l	被除数
*	d1.l	除数
* out	d0.l	演算結果(商)
*	d1.l	〃	(剰余)
*	ccr	C=1:エラー(ゼロ除算)
* 機能:
*	ロングワード符号なし整数同士の除算を行う.

fe_idiv::
		tst.l	d1
		beq	fe_idiv_by_zero		;ゼロ除算エラー

		PUSH	d2-d3
		moveq	#0,d2
		moveq	#32-1,d3
fe_idiv_loop:
		add.l	d0,d0
		addx.l	d2,d2			;d0 の上位から 1 ビット取り出し
		cmp.l	d1,d2
		bcs	fe_idiv_next
		sub.l	d1,d2
		addq	#1,d0
fe_idiv_next:
		dbra	d3,fe_idiv_loop
		move.l	d2,d1			;Carry Clear
		POP	d2-d3
		rts
fe_idiv_by_zero:
		move	#%00001,ccr		;Carry Set
		rts


* FPACK __IUSING
* in	d0.l	ロングワード符号付き整数
*	d1.l	桁数
*	a0.l	バッファアドレス
* out	a0.l	文字列末尾のアドレス(NUL を指す)
* 機能:
*	ロングワード符号付き整数を任意の桁数の 10 進数文字列に変換する.

fe_iusing::
		PUSH	d0/a1-a2
		lea	(a0),a1
		tst.l	d0
		bpl	@f
		move.b	#'-',(a0)+		;Si では不要だが一応負数に対応
		neg.l	d0
@@:
		bsr	decstr			;とりあえず文字列化
		STRLEN	a1,d0
		sub.l	d0,d1
		bls	fe_iusing_end		;右寄せ不要

		lea	(a0),a1			;転送元
		adda.l	d1,a0
		lea	(a0),a2			;転送先
		clr.b	(a0)
fe_iusing_loop1:
		move.b	-(a1),-(a2)		;本体を右寄せする
		subq.l	#1,d0
		bne	fe_iusing_loop1
		moveq	#' ',d0
fe_iusing_loop2:
		move.b	d0,-(a2)		;先頭に空白を入れる
		subq.l	#1,d1
		bne	fe_iusing_loop2
fe_iusing_end:
		POP	d0/a1-a2
		rts


* HUPAIR Decoder ------------------------------ *

GetArgChar_p:	.equ	GetArgCharInit
GetArgChar_c:	.equ	GetArgCharInit+4

GetArgChar::
		PUSH	d1/a0-a1
		moveq	#0,d0
		lea	(GetArgChar_p,pc),a0
		movea.l	(a0)+,a1
		move.b	(a0),d0
		bmi	GetArgChar_noarg
GetArgChar_quate:
		move.b	d0,d1
GetArgChar_next:
		move.b	(a1)+,d0
		beq	GetArgChar_endarg
		tst.b	d1
		bne	GetArgChar_inquate
		cmpi.b	#' ',d0
		beq	GetArgChar_separate
		cmpi.b	#"'",d0
		beq	GetArgChar_quate
		cmpi.b	#'"',d0
		beq	GetArgChar_quate
GetArgChar_end:
		move.b	d1,(a0)
		move.l	a1,-(a0)
GetArgChar_abort:
		POP	d1/a0-a1
		rts
GetArgChar_endarg:
		st	(a0)
		bra	GetArgChar_abort
GetArgChar_noarg:
		moveq	#1,d0
		ror.l	#1,d0
		bra	GetArgChar_abort

GetArgChar_inquate:
		cmp.b	d0,d1
		bne	GetArgChar_end
		clr.b	d1
		bra	GetArgChar_next

GetArgChar_separate:
		cmp.b	(a1)+,d0
		beq	GetArgChar_separate
		moveq	#0,d0
		tst.b	-(a1)
		beq	GetArgChar_endarg
		bra	GetArgChar_end

GetArgCharInit::
		PUSH	a0-a1
		movea.l	(12,sp),a1
GetArgCharInit_skip:
		cmpi.b	#' ',(a1)+
		beq	GetArgCharInit_skip
		tst.b	-(a1)
		lea	(GetArgChar_c,pc),a0
		seq	(a0)
		move.l	a1,-(a0)
		POP	a0-a1
		rts


		.end

* End of File --------------------------------- *
