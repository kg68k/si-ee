		.title	X680x0 System Information Extended Edition


* Include File -------------------------------- *

		.include	fefunc.mac
		.include	doscall.mac
		.include	iocscall.mac
		.include	scsicall.mac

		.include	si.mac
		.include	si_ver.mac


* Global Symbol ------------------------------- *

* si_util.s
		.xref	check_bus_error_byte
		.xref	check_bus_error_word
		.xref	check_bus_error_long

		.xref	hex_table
		.xref	hexstr_byte
		.xref	hexstr_word
		.xref	hexstr_long
		.xref	hexstr_z
		.xref	decstr
		.xref	device_search

		.xref	fe_idiv
		.xref	fe_iusing

		.xref	GetArgChar
		.xref	GetArgCharInit

* si_emu.s
		.xref	Emulator_GetType
		.xref	Emulator_ToString
* si_model.s
		.xref	Model_GetType
		.xref	Model_ToString
* si_acc.s
		.xref	Accelerator_GetTypes
		.xref	Accelerator_AwesomexExists
		.xref	Accelerator_ToString
* si_scsiex.s
		.xref	Scsiex_GetType
		.xref	Scsiex_ToString
		.xref	Scsiex_hasRomName
		.xref	Scsiex_GetRomName
		.xref	SCSIEX_UNKNOWN,SCSIEX_TS6BS1MK3
		.xref	SCSIEX_MACH2,SCSIEX_MACH2P
* si_sram.s
		.xref	Sram_GetSizeInKiB
		.xref	Sram_GetUseMode
		.xref	SramProgram_GetType
		.xref	SramProgram_ToString
		.xref	SRAM_U_PROGRAM


* Fixed Number -------------------------------- *

RTE_CODE:	.equ	$4e73
JMP_ABSL:	.equ	$4ef9
FLOAT_ID:	.equ	'FEfn'

STDOUT:		.equ	1
STDERR:		.equ	2

WAIT_COLOR:	.equ	1			;水色(変更可能)
MEMSIZE_LEN:	.equ	.sizeof.('262144')	;256MB
LONG_OPT_MAX:	.equ	7+1			;"-f-","--"は含まない(+1 は末尾の NUL)
		.fail	LONG_OPT_MAX.and.1	;必ず偶数であること

PRINT_BUF_SIZE:	.equ	 4*1024
STACK_SIZE:	.equ	12*1024
		.fail	STACK_SIZE<8192

DATE_DELIM:	.equ	'-'			;日付の区切り記号


* IOCS Call ----------------------------------- *

ROMVER_V1_00:	.equ	$10_870318
ROMVER_V1_00P:	.equ	$10_870507
ROMVER_XVI:	.equ	$11_910111
ROMVER_COMPACT:	.equ	$12_911024
ROMVER_030:	.equ	$13_921127
ROMVER_060T:	.equ	$15_970529		;日付違いあり

ALMTINIT:	.equ	$9ca
ALMTIMER:	.equ	$9cc


	.ifndef	_HIMEM
_HIMEM:		.equ	$f8
	.endif
_HIMEM_GETSIZE:	.equ	3
_HIMEM_VERSION:	.equ	5


TWOSCSI:	.macro	callno
	.if	callno<=$7f
		moveq	#callno,d1
	.else
		move	#callno,d1
	.endif
		IOCS	_SCSIDRV
		.endm

_S_TW_CHK:	.equ	$001e
_S_TW_LEVEL:	.equ	$020a
_S_TW_INTVCS:	.equ	$0215


* I/O Address --------------------------------- *

FC_CPU:		.equ	7
FPCP_REG:	.equ	$22000
PMMU_REG:	.equ	$24000

MFP:		.equ	$e88000
~MFP_IERA:	.equ	$07
~MFP_IERB:	.equ	$09
~MFP_IMRA:	.equ	$13
~MFP_IMRB:	.equ	$15
~MFP_TCDCR:	.equ	$1d
~MFP_TCDR:	.equ	$23
~MFP_TDDR:	.equ	$25

RTC:		.equ	$e8a000
~RTC_1SEC:	.equ	$01
~RTC_MODE:	.equ	$1b
~RTC_RESET:	.equ	$1f

SYS_P6:		.equ	$e8e00b			;CPU Type/CPU Clock
SYS_P7:		.equ	$e8e00d			;SRAM Write En/Dis

JOYSTICK1:	.equ	$e9a001

IOC_STATUS:	.equ	$e9c001

IOFPU0:		.equ	$e9e000
IOFPU1:		.equ	$e9e080

TS6BGA_PCMCTRL:	.equ	$e9e210
TS6BGA_GA_HDR:	.equ	$e9e3c7
TS6BGA_EE0000:	.equ	$ee0000
TS6BGA_EF0000:	.equ	$ef0000

E040EXCEL_IO:	.equ	$e9f000
WINPORT:	.equ	$e9f000

TS6BSI_P_ID:	.equ	$ea1ff0+5

FAX_IO:		.equ	$eaf900+1
MIDI0_IO:	.equ	$eafa00+1
MIDI1_IO:	.equ	$eafa10+1
PARA0_IO:	.equ	$eafb00+1
PARA1_IO:	.equ	$eafb10+1
RS232C0_IO:	.equ	$eafc00+4
RS232C1_IO:	.equ	$eafc10+4
RS232C2_IO:	.equ	$eafc20+4
RS232C3_IO:	.equ	$eafc30+4
U_IO0_IO:	.equ	$eafd00+3
U_IO1_IO:	.equ	$eafd04+3
U_IO2_IO:	.equ	$eafd08+3
U_IO3_IO:	.equ	$eafd0c+3
GPIB_IO:	.equ	$eafe00+3

AWESOME_IO1:	.equ	$ec0000+$100
AWESOME_IO2:	.equ	$ec8000
PPI_IO:		.equ	$ec0000+6
F_SCAN_IO:	.equ	$ec0ff0+7

XT30_IO0:	.equ	$ec0000
XT30_IO1:	.equ	$ec4000
XT30_IO2:	.equ	$ec8000
XT30_IO3:	.equ	$ecc000

MU_TOP:		.equ	$ecc000
MU_COMMAND:	.equ	$ecc091
MU_STATUS:	.equ	$ecc0a1
MU_OPNREG:	.equ	$ecc0c1
MU_OPNST2:	.equ	$ecc0c3

NEPTUNE0_IO:	.equ	$ece3ff
NEPTUNE1_IO:	.equ	$ece7ff
NEREID0_REG:	.equ	$ece3f1
NEREID1_REG:	.equ	$ecebf1

E8390_CMD:	.equ	$00
E8390_PAGE0:	.equ	$00
E8390_STOP:	.equ	$01
E8390_START:	.equ	$02
E8390_RREAD:	.equ	$08
E8390_NODMA:	.equ	$20
EN0_RSARLO:	.equ	$10
EN0_RSARHI:	.equ	$12
EN0_RCNTLO:	.equ	$14
EN0_RCNTHI:	.equ	$16
EN0_DCFG:	.equ	$1c
NE_DATAPORT:	.equ	$20

VX_CTRL:	.equ	$ecf000
VX_ID1:		.equ	$ecf004
VX_ID2:		.equ	$ecf008
VX_REV:		.equ	$ecf00c

BANK_REG:	.equ	$ecffff

POLY0_IO:	.equ	$eff800+$3c
POLY1_IO:	.equ	$eff880+$3c

PSX16550_MAX:	.equ	2
PSX16570_MAX:	.equ	8
PSX0_IO:	.equ	$efff00+$e		;ch.0～3  ch.0～1
PSX1_IO:	.equ	$efff20+$e		;ch.2～5  ch.2～3
PSX2_IO:	.equ	$efff40+$e		;ch.4～7
PSX3_IO:	.equ	$efff60+$e		;ch.6～9
PSX4_IO:	.equ	$efff80+$e		;ch.8～b
PSX5_IO:	.equ	$efffa0+$e		;ch.a～d
PSX6_IO:	.equ	$efffc0+$e		;ch.c～f
PSX7_IO:	.equ	$efffe0+$e		;ch.e～f(+0～1?)

JUPITER_SYSREG:	.equ	$01800003


* SRAM/ROM Address ---------------------------- *

SRAM:		.equ	$ed0000
SRAM_ONTIME:	.equ	$ed0040
SRAM_POWOFF:	.equ	$ed0044
SRAM_SCSI_ID:	.equ	$ed0070
SRAM_ASKA_ID:	.equ	$ed00f4
SRAM_ASKA_ADR:	.equ	$ed00f8
SRAM_ASKA_BUS:	.equ	$ed00fc
SRAM_MAX:	.equ	$edffff

SCSIEX_ROM:	.equ	$ea0020

SCSIROM:	.equ	$fc0000
SCSIIN_ID:	.equ	$fc0024			;'SCSIIN'


* Macro --------------------------------------- *

SRAM_WRITE_ENABLE:	.macro
		move.b	#$31,(SYS_P7)
		.endm
SRAM_WRITE_DISABLE:	.macro
		clr.b	(SYS_P7)
		.endm


* Offset Table -------------------------------- *

		.offset	0

reg_save:	.ds.l	2
trap14_save:	.ds.l	1

restore_prog:	.ds.l	1
iera_save:	.ds.b	1
ierb_save:	.ds.b	1
imra_save:	.ds.b	1
imrb_save:	.ds.b	1

		.quad
rom_version:	.ds.l	1

emu_ver_type:
emu_ver:	.ds	1
emu_type:	.ds	1

has_scsiex_type:.ds.b	1
scsiex_type:	.ds.b	1

mpu_type:	.ds.b	1
fpu_exist:	.ds.b	1
xt30_id3:	.ds.b	1
atty_flag:	.ds.b	1

opt_all_flag:	.ds.b	1
opt_cut_flag:	.ds.b	1
opt_pow_flag:	.ds.b	1
opt_iob_flag:	.ds.b	1
opt_m35_flag:	.ds.b	1
opt_exp_flag:	.ds.b	1

		.quad
sizeof_work_c:

* 以下は初期化されないワーク
* (それぞれのルーチンで初期化が必要)
print_ptr:	.ds.l	1
print_cnt:	.ds.l	1
print_buf:	.ds.b	PRINT_BUF_SIZE
		.even
sram_save:	.ds.b	32			;これだけあれば足りる筈
		.quad
sizeof_work:


* Text Section -------------------------------- *

		.cpu	68000

		.text
		.even

si_start:
		bra.s	@f
		.dc.b	'#HUPAIR',0
		.even
@@:
		lea	(work_top,pc),a6
		lea	(sizeof_work+STACK_SIZE,a6),a1

		lea	(16,a0),a0
		suba.l	a0,a1
		move.l	a1,-(sp)
		move.l	a0,-(sp)
		DOS	_SETBLOCK
		addq.l	#8,sp
		tst.l	d0
		bmi	setblock_error

		lea	(sizeof_work+STACK_SIZE,a6),sp
		clr.l	-(sp)
		DOS	_SUPER
		addq.l	#4,sp

		bsr	emulator_check
		bsr	init_misc
		bsr	init_print_buf

		bra	si_start2


* プロセッサ速度計測ルーチン ------------------ *

* バージョンによってキャッシュ効率の違いから計測値が変わらないように
* プログラム先頭からのオフセットを si 3.67 と同じになるよう配置する。

* vec_save	     -> $00xx58
* int_flag	     -> $00xx5C
* count_proc_sp_loop -> $00xx78

* 速度計測
* out	d0.l	ループ回数
*	d1.l	10MHz無負荷時のループ回数

LOOP_CNT:	.equ	32

count_processor_speed:
		PUSH	d2-d6/a0-a5

		move.l	(TIMERC_VEC*4),(vec_save-work_top,a6)
		lea	(count_proc_sp_restore,pc),a2
		move.l	a2,(restore_prog,a6)	;復帰ルーチンを登録

		bra.s	@f
		.ds	3
vec_save::	.ds.l	1
int_flag::	.ds.b	1
		.ds.b	3
		.align	16			;調整OKならパディングなしになる
		.ds	1
@@:
		lea	(count_processor_speed_int,pc),a0
		move.l	a0,(TIMERC_VEC*4)	;Timer-C をフック

		lea	(int_flag-work_top,a6),a0
		moveq	#LOOP_CNT+1,d1

		moveq	#0,d0			;+0
		move.b	d1,(a0)			;+2
@@:		cmp.b	(a0),d1			;+4
		beq	@b			;+6	割り込み発生まで待機
count_proc_sp_loop::
		addq.l	#1,d0			;+8	 8clk
		tst.b	(a0)			;+a	 8clk
		bne	count_proc_sp_loop	;+c	10clk
* 合計 26clk
* (10MHz/100Hz*32)/26clk = 3200000clk/26clk = 123076

		bsr	count_proc_sp_restore	;後始末

*		move.l	#123076,d1		;理論値
		move.l	#119422,d1		;実測値(-2.97%)
		POP	d2-d6/a0-a5
		rts


* Timer-C を元に戻す
* in	a6.l	work_top

count_proc_sp_restore:
		move.l	(vec_save-work_top,a6),(TIMERC_VEC*4)
		clr.l	(restore_prog,a6)	;復帰ルーチンを削除
		rts


count_processor_speed_int:
		move.l	a0,-(sp)
		lea	(int_flag,pc),a0
		subq.b	#1,(a0)
		movea.l	(sp)+,a0
	.ifdef	STD_PROC_SPEED
		rte
	.else
		move.l	(vec_save,pc),-(sp)
		rts				;標準の割り込み処理を呼び出す
	.endif


* ここより上のコードの長さを変更したら調整が必要。


* 初期化 続き --------------------------------- *

si_start2:
		pea	(1,a2)
		bsr	GetArgCharInit
		addq.l	#4,sp
arg_loop:
		bsr	GetArgChar
		tst.l	d0
		beq	arg_loop
		bmi	arg_end
		cmpi.b	#'-',d0
		bne	print_short_help

		bsr	GetArgChar
option_loop:
		cmpi.b	#'-',d0
		beq	long_option		;--***
		cmpi.b	#'?',d0
		beq	print_long_help		;-?

		ori.b	#$20,d0
		cmpi.b	#'f',d0
		beq	option_f		;-f-***

		cmpi.b	#'a',d0
		beq	option_a
		cmpi.b	#'b',d0
		beq	option_b
		cmpi.b	#'c',d0
		beq	option_c
		cmpi.b	#'e',d0
		beq	option_e
		cmpi.b	#'h',d0
		beq	print_long_help
		cmpi.b	#'i',d0
		beq	print_interrupt
		cmpi.b	#'m',d0
		beq	option_m
		cmpi.b	#'p',d0
		beq	option_p
		cmpi.b	#'s',d0
		beq	print_scsi_info
		cmpi.b	#'v',d0
		beq	print_version
		cmpi.b	#'l',d0
		beq	print_license

		bra	print_short_help

option_all:	moveq	#0,d0
option_a:	not.b	(opt_all_flag,a6)
		bra	@f

option_board:	moveq	#0,d0
option_b:	not.b	(opt_iob_flag,a6)
		sf	(opt_pow_flag,a6)
		bra	@f

option_cut:	moveq	#0,d0
option_c:	not.b	(opt_cut_flag,a6)
		bra	@f

option_expose:	moveq	#0,d0
option_e:	not.b	(opt_exp_flag,a6)
		bra	@f

option_m35:	moveq	#0,d0
option_m:	not.b	(opt_m35_flag,a6)
		bra	@f

option_power:	moveq	#0,d0
option_p:	not.b	(opt_pow_flag,a6)
		sf	(opt_iob_flag,a6)
@@:		tst	d0
		beq	arg_loop		;--all,--cut,--power

		bsr	GetArgChar		;-a,-c,-pなら続けて指定できる
		tst.b	d0
		bne	option_loop
		bra	arg_loop

option_f:
		bsr	GetArgChar
		cmpi.b	#'-',d0
		bne	print_short_help

		lea	(option_f_table1,pc),a1
		lea	(option_f_table2,pc),a2
		bra	@f
long_option:
		lea	(long_opt_table1,pc),a1
		lea	(long_opt_table2,pc),a2
@@:
		subq.l	#LONG_OPT_MAX,sp
		lea	(sp),a0
		moveq	#LONG_OPT_MAX-1,d1
get_long_option_loop:
		bsr	GetArgChar
		move.b	d0,(a0)
		beq	@f
		ori.b	#$20,(a0)+
		dbra	d1,get_long_option_loop
		addq.l	#LONG_OPT_MAX,sp	;オプションが長すぎる
		bra	print_short_help
@@:
search_long_option_loop:
		lea	(sp),a0			;"-f-","--"の次から比較
@@:
		move.b	(a1)+,d0
		beq	search_long_option_nul
		cmp.b	(a0)+,d0
		beq	@b

@@:		tst.b	(a1)+			;残りを飛ばす
		bne	@b
search_long_option_next:
		addq.l	#2,a2
		tst.b	(a1)
		beq	print_short_help	;見つからなかった
		bra	search_long_option_loop
search_long_option_nul:
		tst.b	(a0)+
		bne	search_long_option_next

		addq.l	#LONG_OPT_MAX,sp	;オプションが見つかった
		adda	(a2),a2
		jmp	(a2)

arg_end:
		pea	(abort_job,pc)		;アボート時の処理を設定
		move	#_CTRLVC,-(sp)
		DOS	_INTVCS
		addq.l	#6,sp

		tst.b	(opt_iob_flag,a6)
		bne	board_only
		tst.b	(opt_pow_flag,a6)	;--all,--cutよりも優先
		bne	benchmark_only

		bsr	print_si_version
		bsr	print_emulator
		bsr	print_host
		bsr	print_romver
		bsr	print_clockswitch
		bsr	print_mpu
		bsr	print_mpu_rev
		bsr	print_cache
		bsr	print_2nd_cache
		bsr	print_mmu
		bsr	print_fpu
		bsr	print_vernum
		bsr	print_syspatch
		bsr	print_float
		bsr	print_memory_size
		bsr	print_himem_size
		bsr	print_sram
		bsr	print_boot_count
		bsr	print_bootinf
		bsr	print_scsi
		bsr	print_ontime
		bsr	print_runtime
		bsr	print_error_count
		bsr	print_printer
board_only:
		bsr	print_io_board

		move.b	(opt_iob_flag,a6),d0
		or.b	(opt_cut_flag,a6),d0
		bne	skip_benchmark
benchmark_only:
		bsr	print_processor_pfm
		bsr	print_sys_mac_pfm
skip_benchmark:
flush_and_exit0:
		clr	-(sp)
		bra	@f
flush_and_exit1:
		move	#1,-(sp)
@@:		bsr	flush_print_buf
		DOS	_EXIT2


* アボート処理 -------------------------------- *

abort_job:
		lea	(work_top,pc),a6

		move.l	(restore_prog,a6),d0
		beq	@f
		movea.l	d0,a0
		jsr	(a0)			;割り込みを元に戻す
@@:
		move	#-1,-(sp)
		DOS	_EXIT2


* 初期化いろいろ ------------------------------ *

init_misc:
		PUSH	d1/a0
		lea	(a6),a0
		moveq	#0,d1
		moveq	#sizeof_work_c/4-1,d0
		.fail	(sizeof_work_c.mod.4)!=0
@@:		move.l	d1,(a0)+		;ワーククリア
		dbra	d0,@b

		bsr	get_mpu_type
		move.b	d0,(mpu_type,a6)
		bsr	is_exist_fpu
		move.b	d0,(fpu_exist,a6)

		IOCS	_ROMVER
		move.l	d0,(rom_version,a6)

		lea	(XT30_IO3+$100),a0	;$ecc100.w
		bsr	check_bus_error_word
		seq	(xt30_id3,a6)

		bsr	Emulator_GetType
		move.l	d0,(emu_ver_type,a6)

		POP	d1/a0
		rts


* エミュレータチェック ------------------------ *

* エミュレータのバージョンによっては一部の命令が正しく動作せず、
* Si 自体の実行に支障があるので、ここではじく。
*
* エミュレータの種類とバージョンを調べるのではなく、該当の命令
* を実行してみて正しく動作するかを見ている。

emulator_check:

.ifndef NO_CHECK_WINX68K_BTST
* WinX68k Version 0.59 では BTST Dn,#Imm 命令が正しく動作しない
		btst	d0,#$00			;WinX68k v0.59 では btst d0,ccr (#Imm なしの1ワード命令)として解釈される
		bra.s	@f			;↑で取り残された #$00 と bra.s が ori.b #xx,d0 として実行される
		bra	emu_check_exit		;その結果ここに到達する
@@:
.endif

.ifndef NO_CHECK_WINX68030_BFINS
* WinX68030 v0.02 では BFINS 命令が正しく動作しない
		moveq	#2,d0
		.cpu	68020
		jmp	($,pc,d0.l*2)		;簡易 MPU 判別
		bra.s	@f			;68000/010 ではここに飛び込む
		bfins	d0,d0{0:2}		;68020 以上
		rol.l	#1,d0
		subq.l	#%101,d0
		bne.s	emu_check_exit
		.cpu	68000
@@:
.endif

		rts

emu_check_exit:
		DOS	_EXIT


*┌────────────────────────────────────────┐
*│			   System Information のバージョン			   │
*└────────────────────────────────────────┘

print_si_version:
		pea	(si_ver_mes,pc)
		bsr	print
		addq.l	#4,sp
		rts


si_ver_mes:	.dc.b	'System Information	: Extended Edition version ',SIEE_VERSION
		.dc.b	' (',SIEE_DATE,')'
		.dc.b	LF,0
		.even


*┌────────────────────────────────────────┐
*│				    エミュレータ名				   │
*└────────────────────────────────────────┘

print_emulator:
		tst.b	(opt_all_flag,a6)
		bne	@f
		tst	(emu_type,a6)
		beq	print_emu_end
@@:
		lea	(-256,sp),sp
		lea	(emu_title,pc),a1
		lea	(sp),a0
		STRCPY	a1,a0,-1

		move.l	(emu_ver_type,a6),d0
		bsr	Emulator_ToString

		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
print_emu_end:
		rts


emu_title:	.dc.b	'emulator		: ',0
		.even


*┌────────────────────────────────────────┐
*│				      本体機種名				   │
*└────────────────────────────────────────┘

* 仕様:
*	初代(後期)/ACE/EXPERT(同II)/PRO(同II) を判別できない.
*	X68030 と同 Compact を判別できない.
*	68030 モードで 040turbo を認識しない.
*	68000 モードで JUPITER-X や 040Excel を認識しない.
*	PRO(II)に Xellent30PRO を載せても Xellent30s と表示される.
*	JUPITER-X と 040Excel の判別が未確認.

print_host:
		lea	(-512,sp),sp
		lea	(sp),a0
		lea	(host_title,pc),a1
		STRCPY	a1,a0,-1

		bsr	Model_GetType
		move.l	d0,d7

		bsr	Accelerator_GetTypes
		tst	d0
		beq	print_host_no_acc

		swap	d0
		move	d7,d0
		swap	d0			;上位wordに本体種類
print_host_acc_loop:
		bsr	Accelerator_ToString
		lea	(_on_,pc),a1
		STRCPY	a1,a0,-1
		tst	d0
		bne	print_host_acc_loop

print_host_no_acc:
		bsr	get_rom_embedded_model_name
		bne	@f

		move.l	d7,d0
		bsr	Model_ToString
@@:
		bsr	get_hostname

		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(512,sp),sp
		rts


* 環境変数 HOSTNAME を取得し、' (変数値)' の形式でバッファに書き込む。
get_hostname:
		lea	(a0),a1
		move.b	#' ',(a1)+
		move.b	#'(',(a1)+

		pea	(a1)
		clr.l	-(sp)
		pea	(env_hostname,pc)
		DOS	_GETENV
		addq.l	#12-4,sp
		move.l	d0,(sp)+
		bmi	get_hostname_noenv

		STREND	a1
		move.b	#')',(a1)+
		lea	(a1),a0
get_hostname_noenv:
		clr.b	(a0)
		rts


ROM_EMBED_NAME_MAX:	.equ	32-4-4	;ヘッダ'NAME'と予約4バイトを除く

* ROM埋め込み機種名を取得する
get_rom_embedded_model_name:
		lea	($ffffe0),a1
		cmpi.l	#'NAME',(a1)+
		bne	8f

		moveq	#ROM_EMBED_NAME_MAX-1,d0
@@:		move.b	(a1)+,(a0)+
		dbeq	d0,@b
		beq	@f
		clr.b	(a0)+
@@:		subq.l	#1,a0

		moveq	#1,d0
		bra	9f
8:
		moveq	#0,d0
9:
		rts


* JUPITER-X が載っているかを調べる.
* out	d0.l	0:なし 1:あり
*	ccr	<tst.l d0> の結果
* 注意:
*	ハードウェアによる判別は不可能と思われるので、
*	「JUPITER-X 専用のドライバ」が組み込まれているか
*	どうかで判別する.
*	ただし、ファンクションコール等では判別できないので、
*	ROM パッチ内に JUPITER-X のシステムレジスタをアクセス
*	するコードがあるかどうかで調べている.

is_exist_jupiter_s:
		PUSH	d1/a0
		lea	($ff0fdc),a0
		cmpi.b	#ROMVER_XVI>>24,(rom_version,a6)
		bne	@f
		lea	($ff121c-$ff0fdc,a0),a0
@@:		bsr	check_bus_error_word
		cmpi	#JMP_ABSL,d0
		bne	is_exist_js_false	;ドライバ組み込みなし

		addq.l	#2,a0
		bsr	check_bus_error_long	;分岐先アドレス
		movea.l	d0,a0
		addq.l	#8,a0
		moveq	#20-1,d1
@@:
		bsr	check_bus_error_long
		bne	is_exist_js_false
		cmpi.l	#JUPITER_SYSREG,d0
		beq	is_exist_js_true
		addq.l	#2,a0
		dbra	d1,@b
is_exist_js_false:
		moveq	#0,d0
		bra	@f
is_exist_js_true:
		moveq	#1,d0
@@:		POP	d1/a0
		rts


host_title:	.dc.b	'host computer		: ',0
_on_:		.dc.b	' on ',0
env_hostname:	.dc.b	'HOSTNAME',0
		.even


*┌────────────────────────────────────────┐
*│				     ROM version				   │
*└────────────────────────────────────────┘

print_romver:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(romver_title,pc),a1
		STRCPY	a1,a0,-1

		move.l	(rom_version,a6),d0
		bsr	print_romver_sub
		move.b	#'.',(a0)+
		bsr	print_romver_sub
		move.b	#' ',(a0)+

		move.b	#"(",(a0)+
		moveq	#$19,d1
		cmpi.l	#$80<<24,d0
		bcc	@f			;80-90
		moveq	#$20,d1			;00-79
@@:		move.b	d1,d0
		ror.l	#8,d0
		bsr	print_romver_sub2	;西暦(4 桁)
		bsr	print_romver_sub2
		moveq	#DATE_DELIM,d2
		move.b	d2,(a0)+
		bsr	print_romver_sub2	;月
		move.b	d2,(a0)+
		bsr	print_romver_sub2	;日

		cmpi.l	#ROMVER_XVI,(rom_version,a6)
		bne	@f
		cmpi.l	#$4eb9_00ff,($ff0ace)
		bne	@f
		lea	(rom_movep_pat,pc),a1	;JUPITER-X on XVI 用のパッチ済み ROM
		STRCPY	a1,a0,-1
@@:
		move.b	#')',(a0)+
		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts

print_romver_sub2:
		pea	(print_romver_sub,pc)
print_romver_sub:
		rol.l	#4,d0
		moveq	#$f,d1
		and.b	d0,d1
		addi.b	#'0',d1
		move.b	d1,(a0)+
		rts


romver_title:	.dc.b	'BIOS ROM		: version ',0
rom_movep_pat:	.dc.b	', movep patched',0
		.even


*┌────────────────────────────────────────┐
*│			   XVI(Compact XVI)の Clock Switch			   │
*└────────────────────────────────────────┘

print_clockswitch:
		tst.b	(opt_all_flag,a6)
		bne	@f

		move.b	(rom_version,a6),d0
		cmpi.b	#ROMVER_XVI>>24,d0
		beq	@f
		cmpi.b	#ROMVER_COMPACT>>24,d0
		bne	print_clockswitch_end
@@:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(clocksw_title,pc),a1
		STRCPY	a1,a0,-1

		moveq	#%1111_0000,d0
		or.b	(SYS_P6),d0
		not	d0			;%0000=10MHz ... %0110=50MHz
		lea	(clocksw_mes,pc),a1
		cmpi	#%0110,d0
		bcc	@f			;一応エラー処理
		add	d0,d0
		move	(clocksw_table,pc,d0.w),(a1)
@@:
		STRCPY	a1,a0,-1

		bsr	print_stack_buffer
		lea	(256,sp),sp
print_clockswitch_end:
		rts


clocksw_table:	.dc	'10','16','20','25','33','40','50'
clocksw_mes:	.dc	'??'
		.dc.b	'MHz mode',LF,0
clocksw_title:	.dc.b	'clock switch		: ',0
		.even


*┌────────────────────────────────────────┐
*│				Micro Processor Unit				   │
*└────────────────────────────────────────┘

print_mpu:
		lea	(-512,sp),sp
		lea	(sp),a0
		lea	(mpu_title,pc),a1
		STRCPY	a1,a0,-1

		pea	(a0)
		clr.l	-(sp)
		pea	(env_mpupack,pc)
		DOS	_GETENV
		addq.l	#12-4,sp
		move.l	d0,(sp)+
		bmi	print_mpu_no_env

		STREND	a0			;$MPUPACK 有り
		bra	print_mpu_clock
print_mpu_no_env:
* 対応 MPU
* 68000
* 68010
* 68020 (68EC020 は判別不可)
* 68030 68EC030
* 68040 68EC040 68LC040
* 68040 68EC040 68LC040
		move.b	(mpu_type,a6),d7
		cmpi.b	#2,d7
		bls	print_mpu_680x0		;68000/010/020

		lea	(mpu_68ec000,pc),a1
		tst.b	(MMUEXIST)
		beq	print_mpu_set		;68EC030/040/060

		cmpi.b	#3,d7			;68LC030 は存在しないので
		beq	print_mpu_680x0		;030 はこの時点で 68030 に確定

		addq.l	#mpu_68lc000-mpu_68ec000,a1
		tst.b	(fpu_exist,a6)
		beq	print_mpu_set		;68LC040/060
print_mpu_680x0:
		lea	(mpu_68000,pc),a1	;680x0
print_mpu_set:
		STRCPY	a1,a0,-1
		add.b	d7,(-2,a0)
print_mpu_clock:
		move.b	#' ',(a0)+
		move.b	#'(',(a0)+

		moveq	#0,d6
		cmpi.b	#1,d7
		bls	print_mpu_clock_68000
*print_mpu_clock_68020:
		move	(ROMCNT),d0
		seq	d6			;値が設定されていなかった
		moveq	#6,d1
		bra	print_mpu_clock_print
print_mpu_clock_68000:
		move	(ROMCNT),d0
		cmpi.b	#ROMVER_XVI>>24,(rom_version,a6)
		bcc	@f			;(Compact)XVI なら計測済み
		bsr	count_sram_1ms_loop	;それ以外は自前で計測
@@:
		moveq	#10+2,d1		;dbra+wait
print_mpu_clock_print:
		mulu	d1,d0
		moveq	#100/2,d1
		add.l	d1,d0
		divu	#100,d0			;clock(MHz)*10
		andi.l	#$ffff,d0		;余りをクリア

		divu	#10,d0
		lea	(mpu_mhz,pc),a1
		swap	d0
		add.b	d0,(1,a1)		;小数第一位(0.1MHz 単位)
		clr	d0
		swap	d0			;整数部(1MHz 単位)
		bsr	decstr
		STRCPY	a1,a0,-1		;.?MHz)

		cmp.b	(MPUTYPE),d7		;IOCS ワークの値を確かめる
		beq	@f
		lea	(mputype_bug,pc),a1	;IOCS ワークに設定されている MPU 種類
		STRCPY	a1,a0,-1		;が間違っていたら警告を表示する
		move.l	(MPUTYPE),d0
**		ror.l	#8,d0
		bsr	hexstr_byte
		move.b	#')',(a0)+
@@:
		tst.b	d6
		beq	@f
		lea	(romcnt_bug,pc),a1	;IOCS ワークに MPU 速度が設定されて
		STRCPY	a1,a0,-1		;いなかったら警告を表示する
@@:
		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(512,sp),sp
		rts


* クロック計測 -------------------------------- *
* out	d0.w	ループ回数
*
* SRAM 上で 1ms 内に dbra の空ループが何回実行できるかを測定する.
* 回数*12*1000 で MHz が求まる(12 は dbra+wait の動作クロック数).
* RAM 上で計測して *10*1000 では、時々ウェイトが入る為か微妙に遅い
* 値になるので、ROM と同じウェイトの SRAM で計測している.
*
* 注意:
* S-RAM に一時的に計測ルーチンを書き込んでいる.
* Timer-C を設定を変更して使用している. このため、システム時間が
* 多少遅延する.

COUNT_ADR:	.equ	$ed00c0
COUNT_SIZE:	.equ	count_sram_1ms_job_end-count_sram_1ms_job

count_sram_1ms_loop:
		PUSH	d1-d7/a0-a6
		move	sr,-(sp)
		lea	(COUNT_ADR),a5

		lea	(a5),a0			;復帰情報を用意する
		lea	(sram_save,a6),a1
		moveq	#COUNT_SIZE/2-1,d0
		DI
@@:		move	(a0)+,(a1)+		;SRAM の内容を保存
		dbra	d0,@b

		move.l	(TIMERC_VEC*4),(vec_save-work_top,a6)

		lea	(MFP),a0
		move.b	(~MFP_IERA,a0),(iera_save,a6)
		move.b	(~MFP_IERB,a0),(ierb_save,a6)
		move.b	(~MFP_IMRA,a0),(imra_save,a6)
		move.b	(~MFP_IMRB,a0),(imrb_save,a6)

		lea	(count_sram_1ms_restore,pc),a2
		move.l	a2,(restore_prog,a6)	;復帰ルーチンを登録

		SRAM_WRITE_ENABLE
		lea	(count_sram_1ms_job,pc),a2
		lea	(a5),a1
		moveq	#COUNT_SIZE/2-1,d0
@@:		move	(a2)+,(a1)+		;SRAM に計測ルーチンを書き込む
		dbra	d0,@b
		SRAM_WRITE_DISABLE

		moveq	#$00,d0
		move.b	d0,(~MFP_IERA,a0)
		move.b	d0,(~MFP_IMRA,a0)
		moveq	#$20,d0
		move.b	d0,(~MFP_IERB,a0)	;Timer-C のみ許可
		move.b	d0,(~MFP_IMRB,a0)

		andi.b	#$0f,(~MFP_TCDCR,a0)	;Timer-C 停止

		lea	(count_sram_1ms_int,pc),a2
		move.l	a2,(TIMERC_VEC*4)	;割り込み処理アドレスを設定

		moveq	#-1,d1
		jsr	(a5)			;SRAM 上で計測

		bsr	count_sram_1ms_restore	;後始末
		POP_SR

		neg	d1
		subq	#1,d1
		moveq	#0,d0
		move	d1,d0
		bne	@f
		move	#979,d0
@@:
		POP	d1-d7/a0-a6
		rts


* Timer-C を元に戻す
* in	a6.l	work_top

count_sram_1ms_restore:
		PUSH_SR_DI
		PUSH	d0/a0-a1
		lea	(MFP),a0

		move.l	(vec_save-work_top,a6),(TIMERC_VEC*4)

		andi.b	#$0f,(~MFP_TCDCR,a0)	;Timer-C の設定を元に戻す
		move.b	#200,(~MFP_TCDR,a0)
		ori.b	#$70,(~MFP_TCDCR,a0)

		move.b	(imra_save,a6),(~MFP_IMRA,a0)
		move.b	(imrb_save,a6),(~MFP_IMRB,a0)
		move.b	(iera_save,a6),(~MFP_IERA,a0)
		move.b	(ierb_save,a6),(~MFP_IERB,a0)

		SRAM_WRITE_ENABLE
		lea	(sram_save,a6),a0
		lea	(COUNT_ADR),a1
		moveq	#COUNT_SIZE/2-1,d0
@@:
		move	(a0)+,(a1)+		;元のデータに戻す
		dbra	d0,@b
		SRAM_WRITE_DISABLE

		clr.l	(restore_prog,a6)	;復帰ルーチンを削除

		POP	d0/a0-a1
		POP_SR
		rts


* in	a0.l	MFP
*	a5.l	戻りアドレス
* out	d1.w	dbraの残り回数

count_sram_1ms_job:
		move.b	#250,(~MFP_TCDR,a0)		;ここから
		move	#$2500,sr
		ori.b	#$30,(~MFP_TCDCR,a0)		;Timer-C 動作開始
count_sram_1ms_job_loop:
		dbra	d1,count_sram_1ms_job_loop
count_sram_1ms_job_rts:
		rts					;ここまで SRAM に転送
count_sram_1ms_job_end:

count_sram_1ms_int:
		pea	(count_sram_1ms_job_rts,pc)	;dbra のループから抜ける
		move.l	(sp)+,(2,sp)
		rte


mpu_title:	.dc.b	'micro processing unit	: ',0
mpu_68000:	.dc.b	'68000',0
mpu_68ec000:	.dc.b	'68EC000',0
mpu_68lc000:	.dc.b	'68LC000',0
mpu_mhz:	.dc.b	'.0MHz)',0
mputype_bug:	.dc.b	' (Warning: $cbc.b = $',0
romcnt_bug:	.dc.b	' (Warning: $cb8.w = 0)',0
env_mpupack:	.dc.b	'MPUPACK',0
		.even


*┌────────────────────────────────────────┐
*│		MPU Identification / Revision Number (68060 only)		   │
*└────────────────────────────────────────┘

print_mpu_rev:
		lea	(-256,sp),sp
		lea	(sp),a0

		cmpi.b	#6,(mpu_type,a6)
		bne	print_mpu_rev_skip

		lea	(mpu_rev_title,pc),a1
		STRCPY	a1,a0,-1

*		move.b	#'$',(a0)+
		.cpu	68060
		movec	pcr,d0
		.cpu	68000
		bsr	hexstr_word		;bit 31-16:Identification
		bsr	strcpy_slash
		move.b	#'$',(a0)+
		swap	d0
		bsr	hexstr_byte		;bit 15-8:Revision Number

		STRCPY_EOL a0
		bsr	print_stack_buffer
print_mpu_rev_skip:
		lea	(256,sp),sp
		rts


mpu_rev_title:	.dc.b	'MPU ID / Revision	: $',0
		.even


*┌────────────────────────────────────────┐
*│				On-Chip Cache の状態				   │
*└────────────────────────────────────────┘

print_cache:
		lea	(-256,sp),sp
		lea	(sp),a0

		bsr	get_cache_stat
		moveq	#0,d1
		move.b	(mpu_type,a6),d1
		move.b	(@f,pc,d1.w),d1
		jmp	(@f,pc,d1.w)
@@:
		.dc.b	print_cache_000-@b
		.dc.b	print_cache_010-@b
		.dc.b	print_cache_020-@b
		.dc.b	print_cache_030-@b
		.dc.b	print_cache_040-@b
		.dc.b	print_cache_xxx-@b
		.dc.b	print_cache_060-@b
		.even
print_cache_000:
print_cache_010:
print_cache_xxx:
		lea	(cache_title,pc),a1	;キャッシュ無し
		STRCPY	a1,a0,-1
		bra	print_cache_nothing

;(instruction / no data cache)
print_cache_020:
;(instruction / data)
print_cache_030:
print_cache_040:
		lea	(cache_title,pc),a1
		STRCPY	a1,a0,-1

		moveq	#1,d1			;命令
		bsr	print_cache_on_off
		bsr	strcpy_slash

		lea	(no_data_cache,pc),a1
		cmpi.b	#2,(mpu_type,a6)
		beq	print_cache_over	;68020 はデータキャッシュ無し

		moveq	#0,d1			;データ
		bsr	print_cache_on_off
		bra	print_cache_over2

;(SuperScalar / Branch Cache / Store Buffer / Instruction / Data)
print_cache_060:
		lea	(cache_title060,pc),a1
		STRCPY	a1,a0,-1
		moveq	#4,d1
		bra	@f
print_cache_68060_loop:
		bsr	strcpy_slash
@@:		bsr	print_cache_on_off
		dbra	d1,print_cache_68060_loop
		bra	print_cache_over2

print_cache_nothing:
		tst.b	(opt_all_flag,a6)
		beq	print_cache_skip

		lea	(without_cache,pc),a1
print_cache_over:
		STRCPY	a1,a0,-1
print_cache_over2:
		STRCPY_EOL a0
		bsr	print_stack_buffer
print_cache_skip:
		lea	(256,sp),sp
		rts

strcpy_slash:
	.irpc	char," / "
		move.b	#'&char',(a0)+
	.endm
		rts

print_cache_on_off:
		move.b	#'o',(a0)+
		btst	d1,d0
		beq	@f
		move.b	#'n',(a0)+		;on
		rts
@@:		move.b	#'f',(a0)
		move.b	(a0)+,(a0)+		;off
		rts


* MPU キャッシュの状態を返す.
* out	d0.l	bit 4	スーパースケーラ
*		bit 3	分岐キャッシュ
*		bit 2	ストアバッファ
*		bit 1	命令キャッシュ
*		bit 0	データキャッシュ

get_cache_stat:
		move.l	d1,-(sp)
		moveq	#0,d0
		moveq	#0,d1
		move.b	(mpu_type,a6),d1
		move.b	(@f,pc,d1.w),d1
		jmp	(@f,pc,d1.w)
@@:
		.dc.b	get_cache_stat_000-@b
		.dc.b	get_cache_stat_010-@b
		.dc.b	get_cache_stat_020-@b
		.dc.b	get_cache_stat_030-@b
		.dc.b	get_cache_stat_040-@b
		.dc.b	get_cache_stat_xxx-@b
		.dc.b	get_cache_stat_060-@b
		.even
get_cache_stat_020:
get_cache_stat_030:
		.cpu	68020
		movec	cacr,d0
		bfins	d0,d0{31-9:1}
		bfextu	d0{31-9:2},d0
		bra	get_cache_stat_end
get_cache_stat_040:
		.cpu	68040
		movec	cacr,d0
		rol	#1,d0
		rol.l	#1,d0
**		bfclr	d0{31-31:30}		;他のビットは全部 0 になっている
		bra	get_cache_stat_end
get_cache_stat_060:
		.cpu	68060
		movec	cacr,d1
		rol	#1,d1
		rol.l	#1,d1
		bfins	d1,d1{2:2}
		rol.l	#4,d1
		bfins	d1,d1{4:3}
		bfextu	d1{3:4},d0
		movec	pcr,d1			;bit0: Enable Superscalar Dispatch
		bfins	d1,d0{31-4:1}
		bra	get_cache_stat_end
		.cpu	68000
get_cache_stat_000:
get_cache_stat_010:
get_cache_stat_xxx:
get_cache_stat_end:
		move.l	(sp)+,d1
		rts


cache_title:	.dc.b	'cache (instruct / data)	: ',0
cache_title060:	.dc.b	'cache (ss/bc/sb/i/d)	: ',0
without_cache:	.dc.b	'no cache',0
no_data_cache:	.dc.b	'no data cache',0
		.even


*┌────────────────────────────────────────┐
*│			       二次キャッシュ(VENUS-X)				   │
*└────────────────────────────────────────┘

print_2nd_cache:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(cache2_title,pc),a1
		STRCPY	a1,a0,-1

		bsr	is_exist_venus_x
		beq	print_2nd_cache_nothing

		move.b	d1,d0			;VENUS-X 有り
		moveq	#7,d1
		bsr	print_cache_on_off

		lea	(cache2_vx,pc),a1
		moveq	#$f,d0
		and.b	d2,d0			;リビジョン
		add.b	d0,(vx_rev-cache2_vx,a1)
		lsr.b	#4,d2			;対象 MPU
		add.b	d2,(vx_mpu-cache2_vx,a1)
print_cache_last:
		STRCPY	a1,a0,-1
		STRCPY_EOL a0
		bsr	print_stack_buffer
print_2nd_cache_skip:
		lea	(256,sp),sp
		rts

print_2nd_cache_nothing:
		tst.b	(opt_all_flag,a6)
		beq	print_2nd_cache_skip

		lea	(without_cache,pc),a1
		bra	print_cache_last


* VENUS-X が存在するか調べる.
* out	d0.l	0:なし 1:あり
*	d1.l	キャッシュ制御レジスタの内容(最下位バイトのみ有効)
*	d2.l	ファームウェアリビジョン(〃)
*	ccr	<tst.l d0> の結果

is_exist_venus_x:
		move.l	a0,-(sp)
		tst.b	(xt30_id3,a6)
		bne	is_exist_vx_false	;Xellent30 が存在すれば VENUS-X は無し

		lea	(VX_CTRL),a0
		bsr	check_bus_error_long	;制御レジスタ
		bne	is_exist_vx_false
		move.l	d0,d1
	.irp	id,'V','X'
		addq.l	#4,a0
		bsr	check_bus_error_long	;ID レジスタ
		bne	is_exist_vx_false
		cmpi.b	#id,d0
		bne	is_exist_vx_false
	.endm
		addq.l	#4,a0
		bsr	check_bus_error_long
		bne	is_exist_vx_false
		move.l	d0,d2			;ファームウェアリビジョン
		moveq	#1,d0
is_exist_vx_end:
		movea.l	(sp)+,a0
		rts
is_exist_vx_false:
		moveq	#0,d0
		bra	is_exist_vx_end


cache2_title:	.dc.b	'secondary cache		: ',0
cache2_vx:	.dc.b	' (VENUS-X for MC680'
vx_mpu:		.dc.b			   '00, Revision.'
vx_rev:		.dc.b					'0)',0
		.even


*┌────────────────────────────────────────┐
*│			  Memory Management Unit のチェック			   │
*└────────────────────────────────────────┘

print_mmu:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(mmu_title,pc),a1
		STRCPY	a1,a0,-1

		move.b	(mpu_type,a6),d1
		cmpi.b	#1,d1
		bls	print_mmu_nothing

		tst.b	(MMUEXIST)
		beq	print_mmu_nothing

		lea	(mmu_internal,pc),a1
		subq.b	#3,d1
		bcc	@f
		lea	(mmu_68851,pc),a1	;68020+68851
		bra	@f
print_mmu_nothing:
		tst.b	(opt_all_flag,a6)
		beq	print_mmu_skip

		lea	(not_installed,pc),a1
@@:
		STRCPY	a1,a0
		bsr	print_stack_buffer
print_mmu_skip:
		lea	(256,sp),sp
		rts


mmu_title:	.dc.b	'memory management unit	: ',0
mmu_internal:	.dc.b	'on chip MMU',LF,0
mmu_68851:	.dc.b	'68851',LF,0
not_installed:	.dc.b	'not installed',LF,0
		.even


*┌────────────────────────────────────────┐
*│			      コプロセッサー装着チェック			   │
*└────────────────────────────────────────┘

FPU_IO1:	.equ	0
FPU_IO2:	.equ	1
FPU_COPRO:	.equ	2
FPU_ONCHIP:	.equ	3

print_fpu:
		lea	(-512,sp),sp
		lea	(sp),a0
		lea	(fpu_title,pc),a1
		STRCPY	a1,a0,-1

		bsr	print_fpu_env
		beq	print_fpu_end

		bsr	get_fpu_type
		move.l	d1,d7			;種類
		move.l	d0,d6			;有無
		lea	(not_installed,pc),a1
		beq	print_fpu_end2

		btst	#FPU_ONCHIP,d6
		sne	d5			;0=まだ一度も表示していない
		beq	print_fpu_copro

		lea	(fpu_onchip,pc),a1	;68040/68060内蔵
		STRCPY	a1,a0,-1
		cmpi.b	#6,(mpu_type,a6)
		bne	print_fpu_copro

		lea	(fpu_enable,pc),a1	;68060ならen/disも表示
		btst	#FPU_ONCHIP,d7
		beq	@f
		lea	(fpu_disable,pc),a1
@@:		STRCPY	a1,a0,-1

print_fpu_copro:
		btst	#FPU_COPRO,d6
		beq	print_fpu_io1

		bsr	print_fpu_slash		;6888x(PLCC)
		btst	#FPU_COPRO,d7
		bsr	print_fpu_6888x
		lea	(fpu_plcc,pc),a1
		STRCPY	a1,a0,-1

print_fpu_io1:
		btst	#FPU_IO1,d6
		beq	print_fpu_io2

		bsr	print_fpu_slash		;ID=0, 6888x(PGA)
		moveq	#'0',d0
		bsr	print_fpu_id
		btst	#FPU_IO1,d7
		bsr	print_fpu_6888x_pga

print_fpu_io2:
		btst	#FPU_IO2,d6
		beq	print_fpu_io_done

		bsr	print_fpu_slash		;ID=1, 6888x(PGA)
		moveq	#'1',d0
		bsr	print_fpu_id
		btst	#FPU_IO2,d7
		bsr	print_fpu_6888x_pga

print_fpu_io_done:
print_fpu_end:
		lea	(lf,pc),a1
print_fpu_end2:
		STRCPY	a1,a0
		bsr	print_stack_buffer
		lea	(512,sp),sp
		rts

print_fpu_slash:
		tas	d5
		bne	strcpy_slash
		rts

print_fpu_id:
		lea	(fpu_id,pc),a1		;"ID=N, "
		move.b	d0,(3,a1)
		bra	@f

print_fpu_6888x_pga:
		bsr	print_fpu_6888x
		lea	(fpu_pga,pc),a1
		bra	@f

print_fpu_6888x:
		lea	(fpu_68881,pc),a1
		beq	@f
		addq.l	#fpu_68882-fpu_68881,a1
@@:
		STRCPY	a1,a0,-1
		rts


* 浮動小数点演算プロセッサが存在するか調べる.
* out	d0.l	bit 0=1:I/O接続 ID1			... PGA
*		bit 1=1:I/O接続 ID2			... PGA
*		bit 2=1:コプロセッサ接続(68020/68030)	... PLCC
*		bit 3=1:68040/68060内蔵
*	d1.l	bit 0=0:68881 =1:68882
*		bit 1=0:68881 =1:68882
*		bit 2=0:68881 =1:68882
*		bit 3=0:enable 1:disable(68060の場合のみ)
*
* 68040/68060 に外付けの 6888x をコプロ接続することは出来ない.

get_fpu_type:
		PUSH	d6-d7/a0
		moveq	#0,d6			;d0(有無)
		moveq	#0,d7			;d1(種類)

		move.b	(mpu_type,a6),d0
		cmpi.b	#2,d0
		bcs	get_fpu_type_io		;68000/68010
		subq.b	#4,d0
		bcs	get_fpu_type_030	;68020/68030
		beq	get_fpu_type_040
*get_fpu_type_060:
		.cpu	68060
		movec	pcr,d0
		.cpu	68000
		lsr	#2,d0			;bit 1=Disable Floating-Point Unit
		bcc	get_fpu_type_040
		addq	#1<<FPU_ONCHIP,d7	;FPU無効
get_fpu_type_040:
		tst.b	(fpu_exist,a6)
		beq	@f
		addq	#1<<FPU_ONCHIP,d6	;内蔵FPUあり
@@:
		bsr	get_fpcp_type
		ble	@f
		addq	#1<<FPU_COPRO,d6	;FPCPあり
		subq.l	#1,d0
		beq	@f
		addq	#1<<FPU_COPRO,d7	;68882
@@:		bra	get_fpu_type_io

get_fpu_type_030:
		tst.b	(fpu_exist,a6)
		beq	@f

		addq	#1<<FPU_COPRO,d6	;FPCPあり
		.cpu	68030
		fmove.x	fp0,-(sp)		;save fp0
		fmovecr.x #$01,fp0
		fmove.d	fp0,-(sp)
		move.l	(sp)+,d0
		or.l	(sp)+,d0
		fmove.x	(sp)+,fp0		;restore fp0
		.cpu	68000
		tst.l	d0
		beq	@f			;FPCP は 68881

		addq	#1<<FPU_COPRO,d7	;FPCP は 68882
@@:		bra	get_fpu_type_io

get_fpu_type_io:
		lea	(IOFPU0),a0
		bsr	check_bus_error_word
		bne	@f

		addq	#1<<FPU_IO1,d6
		bsr	get_fpu_type_6888x
		beq	@f
		addq	#1<<FPU_IO1,d7
@@:
		lea	(IOFPU1-IOFPU0,a0),a0
		bsr	check_bus_error_word
		bne	@f

		addq	#1<<FPU_IO2,d6
		bsr	get_fpu_type_6888x
		beq	@f
		addq	#1<<FPU_IO2,d7
@@:
get_fpu_type_end:
		move.l	d7,d1
		move.l	d6,d0
		POP	d6-d7/a0
		rts


* I/O 接続している FPCP の 68881/68882 の判別をする.
* 参考:LIBC src/math/_fpu_is68881.s
* in	a0.l	FPCP の I/O アドレス($e9e000 or $e9e080)
* out	d0.l	0:68881 0 以外:68882
*	ccr	<tst.l d0> の結果

get_fpu_type_6888x:
		PUSH_SR_DI

		move	#$5c01,($a,a0)
@@:		tst	(a0)
		bmi	@b
		move	#$7400,($a,a0)
@@:		cmpi	#$8900,(a0)		;btst #4,(a0)
		beq	@b			;↑これじゃマズいような…
		move.l	($10,a0),d0
		or.l	($10,a0),d0
@@:		tst	(a0)
		bmi	@b

		POP_SR
		tst.l	d0
		rts


* FPCP が存在するか調べる.
* out	d0.l	0:なし 1:68881 2:68882 -1:なし(040Excel)
*	ccr	<tst.l d0> の結果
* 備考:
*	68040/68060 専用.
*	040Excel の判別が可能.

		.cpu	68040
get_fpcp_type:
		PUSH	d1/d6-d7/a0-a3
		PUSH_SR_DI

		movec	sfc,d6
		movec	dfc,d7
		movea.l	(BUSERR_VEC*4),a1
		lea	(sp),a2

		moveq	#FC_CPU,d0
		movec	d0,sfc
		movec	d0,dfc
		lea	(FPCP_REG),a0

* 040Excel(限定配布版)では、何故か CPU 空間にスーパーバイザ
* データが割り当てられているので、コプロセッサにアクセスする
* ことは出来ない. そこで、コプロセッサ領域としては不正なアド
* レスをアクセスしてアクセスフォールトが発生しないかどうかで
* 040Excel の判別を行う.
		lea	(@f,pc),a3
		move.l	a3,(BUSERR_VEC*4)

		moves	(PMMU_REG-FPCP_REG,a0),d0
		moveq	#-1,d0			;アクセスフォールトが起きなければ
		bra	get_fpcp_type_end	;040Excel(＝FPCP なし)
@@:
		lea	(a2),sp
		lea	(get_fpcp_type_af,pc),a3
		move.l	a3,(BUSERR_VEC*4)

		move	#$5c01,d0
		moves	d0,($a,a0)

@@:		moves	(a0),d0
		tst	d0
		bmi	@b

		move	#$7400,d0
		moves	d0,($a,a0)

@@:		moves	(a0),d0
		cmpi	#$8900,d0		;btst #4,(a0)
		beq	@b

		moves.l	($10,a0),d0
		moves.l	($10,a0),d1
		or.l	d0,d1

@@:		moves	(a0),d0
		tst	d0
		bmi	@b

		moveq	#1,d0
		tst.l	d1
		beq	get_fpcp_type_end
		moveq	#2,d0
get_fpcp_type_end:
		move.l	a1,(BUSERR_VEC*4)

		movec	d6,sfc
		movec	d7,dfc
		POP_SR

		POP	d1/d6-d7/a0-a3
		tst.l	d0
		rts
get_fpcp_type_af:
		lea	(a2),sp
		moveq	#0,d0
		bra	get_fpcp_type_end
		.cpu	68000


* FPUがある場合の環境変数表示下請け
print_fpu_env:
		pea	(a0)
		clr.l	-(sp)
		pea	(env_fpupack,pc)
		DOS	_GETENV
		addq.l	#12-4,sp
		move.l	d0,(sp)+
		bmi	print_fpu_no_env

		STREND	a0
		moveq	#0,d0
print_fpu_no_env:
		rts


fpu_title:	.dc.b	'floating point unit	: ',0
fpu_onchip:	.dc.b	'on chip FPU',0
fpu_enable:	.dc.b	' (enable)',0
fpu_disable:	.dc.b	' (disable)',0
fpu_id:		.dc.b	'ID=0, ',0
fpu_68881:	.dc.b	'68881',0
fpu_68882:	.dc.b	'68882',0
fpu_pga:	.dc.b	' (PGA)',0
fpu_plcc:	.dc.b	' (PLCC)',0
env_fpupack:	.dc.b	'FPUPACK',0
		.even


*┌────────────────────────────────────────┐
*│				   ＯＳのバージョン				   │
*└────────────────────────────────────────┘

print_vernum:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(vernum_title,pc),a1
		STRCPY	a1,a0,-1

		DOS	_VERNUM
		move.b	d0,-(sp)
		move	d0,-(sp)
		moveq	#0,d0
		move.b	(sp)+,d0		;バージョン整数部
		bsr	decstr
		move.b	#'.',(a0)+

		moveq	#0,d0
		move.b	(sp)+,d0		;バージョン小数部
		cmpi.b	#10,d0
		bcc	@f
		move.b	#'0',(a0)+		;$0302 -> "3.02"
@@:		bsr	decstr

		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts


vernum_title:	.dc.b	'operating system	: Human68k version ',0
		.even


*┌────────────────────────────────────────┐
*│				system patch driver				   │
*└────────────────────────────────────────┘

ROM_PATCH:	.equ	$00fff000
MAGIC_040T:	.equ	'040T'			;$00ff0000 (+ $00fff000)
MAGIC_SIPL:	.equ	'KG00'			;$00fff008
MAGIC_030S:	.equ	'X030'			;$00ff0000

print_syspatch:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(sysp_title,pc),a1
		STRCPY	a1,a0,-1
		suba.l	a3,a3			;警告メッセージ

		cmpi.b	#2,(MPUTYPE)		;IOCS _SYS_STAT を使うので $cbc.b 参照
		bcc	print_sysp_ac_ok

* Xellent30 搭載機に XT30DRV.X を組み込めば、mpusw により
* 68000 モードに変更することが出来る. ただし、68030 モード
* で _30SYSpatch.x を組み込んでいる可能性があるので、
* XT30DRV.X により常に IOCS _SYS_STAT が使えるようになって
* いるのを利用して、68020 以降と同じように調べる.

		movea.l	a0,a1
		moveq	#0,d0			;デバイス属性は無視
		lea	(sysp_xt30drv,pc),a0	;デバイス名
		bsr	device_search
		movea.l	a1,a0
		beq	print_sysp_skip		;XT30DRV.X は組み込まれていない
print_sysp_ac_ok:

* パッチ ROM アドレスが '060T' なら 060turbo.sys
		lea	(sysp_060t,pc),a1
		bsr	is_060turbo
		beq	print_sysp_setver	;060turbo.sys

		move.l	d0,d2
		lea	(ROM_PATCH),a2
		addq.l	#1,d0
		bne	print_sysp_no_040sipl	;バージョンが返った

* バージョンが返らなくて、$00fff000 に識別子があれば 040sipl.x
		cmpi.l	#MAGIC_040T,(a2)+
		bne	print_sysp_skip
		move.l	(a2)+,d2		;バージョン
		cmpi.l	#MAGIC_SIPL,(a2)+
		bne	print_sysp_skip

		lea	(sysp_040sipl,pc),a1
		bra	print_sysp_setver2	;040sipl.x
print_sysp_no_040sipl:

* 互換/拡張モードの収得が出来れば jupiter.x
		move	#$c002,d1		;jupiter.x & 060turbo.sys で有効
		IOCS	_SYS_STAT
		addq.l	#1,d0
		beq	@f

		lea	(sysp_jupiter,pc),a1	;jupiter.x
		bsr	is_exist_jupiter_s
		beq	print_sysp_setver2	;040Excel 用の jupiter.x
		bsr	get_fpcp_type
		bpl	print_sysp_setver2	;JUPITER-X

		lea	(jx_jx_bug,pc),a3	;040Excel なのに JUPITER-X 用の jupiter.x
		bra	print_sysp_setver2
@@:

* 040 系と 030 系の判別
		lea	(sysp_040sysp,pc),a1
		move.l	(IOCS_ROM),d3
		cmpi.l	#MAGIC_040T,d3
		bne	print_sysp_no_040sp

* $00fff000 に識別子がなければ 040SYSpatch.x
		cmpi.l	#MAGIC_040T,(a2)
		bne	print_sysp_setver2	;040SYSpatch.x

		lea	(sysp_040sram,pc),a1	;040SRAMpatch.r
		STRCPY	a1,a0,-1
		bsr	print_float_sub		;version x.xx
		move.b	#'.',(a0)+
		move.l	(8,a2),d0		;リリース番号
		bra	print_sysp_setrel

print_sysp_no_040sp:
		subq.b	#'4'-'3',(1,a1)

* $00ff0000 に識別子があれば 030SYSpatch.x
		cmpi.l	#MAGIC_030S,d3
		beq	print_sysp_setver2	;030SYSpatch.x

		move.b	#'_',(a1)		;_30SYSpatch.x
print_sysp_setver2:
		move.l	d2,d0
print_sysp_setver:
		STRCPY	a1,a0,-1		;ドライバ名をコピー
		lea	(sysp_version,pc),a1
		STRCPY	a1,a0,-1
print_sysp_setrel:
		bsr	print_float_sub		;バージョン番号(or リリース番号)
		move.l	a3,d0
		beq	@f
		STRCPY	a3,a0,-1
@@:
		STRCPY_EOL a0
print_sysp_print:
		bsr	print_stack_buffer
print_sysp_end:
		lea	(256,sp),sp
		rts

print_sysp_skip:
		tst.b	(opt_all_flag,a6)
		beq	print_sysp_end

		lea	(not_installed,pc),a1
		STRCPY	a1,a0,-1
		bra	print_sysp_print


* 060turbo.sys が組み込まれているか調べ、そのバージョンを返す.
* 040/030SYSpatch.x の場合も ccr は Z=0 だが、バージョンを返す.
* (いずれのドライバかは MPU 種別に依存する)
* MPU が 68020 以上であることを確認してから呼び出すこと.
*
* out	d0.l	060turbo.sys または 040/030SYSpatch.x のバージョン.
*		-1 なら syspatch の類は組み込まれていない.
*	ccr	Z=1:060turbo.sys Z=0:それ以外か syspatch なし

is_060turbo:
		PUSH	d1/a1
		suba.l	a1,a1			;エラー時の a1.ne.'060T' を保証
		move	#$8000,d1
		IOCS	_SYS_STAT
		cmpa.l	#'060T',a1
		POP	d1/a1
		rts


sysp_title:	.dc.b	'system patch driver	: ',0
sysp_xt30drv:	.dc.b	'@XT30DRV'
sysp_jupiter:	.dc.b	'jupiter.x',0
sysp_060t:	.dc.b	'060turbo.sys',0
sysp_040sipl:	.dc.b	'040sipl.x',0
sysp_040sysp:	.dc.b	'040SYSpatch.x',0
sysp_040sram:	.dc.b	'040SRAMpatch.r'	;NUL は不要
sysp_version:	.dc.b	' version ',0
jx_jx_bug:	.dc.b	' (Warning: It breaks memory when RESET)',0
		.even


*┌────────────────────────────────────────┐
*│				FLOATn.X の種類					   │
*└────────────────────────────────────────┘

print_float:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(float_title,pc),a1
		STRCPY	a1,a0,-1

		move.l	#FLOAT_ID,d0		;FLOATn.X の常駐検査
		movea.l	(FLINE_VEC*4),a1
		cmp.l	-(a1),d0
		beq	print_float_exist
		movea.l	(PRIV_VEC*4),a1
		cmp.l	-(a1),d0
		beq	print_float_exist

		cmpi.b	#6,(MPUTYPE)		;IOCS _SYS_STAT を使うので $cbc.b 参照
		bne	print_float_nothing
		bsr	is_060turbo		;060turbo.sys は内蔵している
		beq	print_float_exist
print_float_nothing:
		tst.b	(opt_all_flag,a6)
		beq	print_float_skip

		lea	(not_installed,pc),a1
		STRCPY	a1,a0,-1
		bra	print_float_last

print_float_exist:
		FPACK	__FEVARG
		bsr	print_float_sub
		bsr	strcpy_slash
		move.l	d1,d0
		bsr	print_float_sub

		moveq	#2,d0
		moveq	#1,d1
		FPACK	__IDIV
		subq.l	#2,d0
		or.l	d1,d0
		beq	@f			;d0=2、d1=0 なら問題なし
		lea	(idiv_bug,pc),a1
		STRCPY	a1,a0,-1
@@:
		STRCPY_EOL a0
print_float_last:
		bsr	print_stack_buffer
print_float_skip:
		lea	(256,sp),sp
		rts


* d0.l を 4 バイトの文字列と見なしてバッファに転送する.
* in	d0.l	文字(4bytes)
*	a0.l	バッファ
* out	a0.l	+= 4

print_float_sub:
		pea	(@f,pc)			;bsr @f
@@:		swap	d0
		move	d0,-(sp)
		move.b	(sp)+,(a0)+
		move.b	d0,(a0)+
		rts


float_title:	.dc.b	'fefunc driver		: ',0
idiv_bug:	.dc.b	' (Warning: FPACK __IDIV returns wrong value)',0
		.even


*┌────────────────────────────────────────┐
*│			       メインメモリ装着チェック				   │
*└────────────────────────────────────────┘

print_memory_size:
		bsr	get_memory_free_size
		move.l	d0,d1
		bsr	get_memory_size
		lea	(memsize_title,pc),a1
		bra	print_memsize_sub
*		rts


* メインメモリ実装容量を調べる.
* out	d0.l	メモリ実装容量(バイト単位)

get_memory_size:
		move.l	a0,-(sp)
		suba.l	a0,a0
@@:
		bsr	check_bus_error_long
		bne	@f
		adda.l	#$10_0000,a0
		cmpa.l	#$c0_0000,a0
		bcs	@b
@@:
		move.l	a0,d0
		movea.l	(sp)+,a0
		rts

* メインメモリ空き容量を調べる.
* out	d0.l	空きメモリ容量(バイト単位)
* 備考:
*	DOS _SETBLOCK/_MALLOC を使用する方法では、060turbo(060turbo.sys)
*	や TS-6BE16(xt30drv.x)のハイメモリの影響を受けてしまうので、直接
*	Human68k のメモリ管理を参照して計算する.

get_memory_free_size:
		PUSH	d1-d2/a0-a2
		lea	($0100_0000),a3
		movea.l	($1c00),a1		;メモリ末尾

		lea	(si_start-$100+$10,pc),a0
		move.l	(-$10+12,a0),d2		;自分自身のメモリブロックの
		bne	@f			;最大サイズを計算する
		move.l	a1,d2
@@:		sub.l	a0,d2
		cmpa.l	a3,a0
		bcs	@f
		moveq	#0,d2			;ハイメモリでの実行時は無視する
@@:
		movea.l	($1c04),a0		;先頭のメモリブロック
		bra	get_mem_free_next
get_mem_free_loop:
		move.l	(12,a0),d1
		bne	@f
		move.l	a1,d1
@@:
		moveq	#$1f,d0
		add.l	(8,a0),d0		;16 バイト単位に切り上げ
		andi	#$fff0,d0		;＆ メモリ管理ポインタ分を引く
		sub.l	d0,d1
		bls	@f
		cmp.l	d1,d2
		bcc	@f
		move.l	d1,d2			;最大空きブロック容量を更新
@@:
		move.l	(12,a0),d1
		beq	get_mem_free_end
		movea.l	d1,a0
get_mem_free_next:
		cmpa.l	a3,a0			;ハイメモリに着いたらやめる
		bcs	get_mem_free_loop
get_mem_free_end:
		move.l	d2,d0
		POP	d1-d2/a0-a2
		rts

.if 0
get_memory_free_size:
		pea	($ffffff)
		pea	(si_start-$f0,pc)
		DOS	_SETBLOCK
		addq.l	#4,sp
		and.l	d0,(sp)

		pea	($ffffff)
		DOS	_MALLOC
		and.l	(sp)+,d0

		cmp.l	(sp),d0
		bcc	@f
		move.l	(sp),d0
@@:		addq.l	#4,sp
		rts
.endif


*┌────────────────────────────────────────┐
*│				ハイメモリ装着チェック				   │
*└────────────────────────────────────────┘

print_himem_size:
		movea.l	(_HIMEM*4+IOCS_VECTBL),a0
		cmpi	#'M'<<8,-(a0)
		bne	print_himem_size_err
		cmpi.l	#'HIME',-(a0)
		beq	print_himem_size_exist
print_himem_size_err:
		moveq	#-1,d0
		tst.b	(opt_all_flag,a6)
		bne	@f
		rts
print_himem_size_exist:
		bsr	get_himem_size
		move.l	d0,d1
		ble	print_himem_size_err
		bsr	get_himem_free_size
		exg	d0,d1
@@:
		lea	(himem_title,pc),a1
		bra	print_memsize_sub
*print_himem_size_end:
*		rts


* ハイメモリ実装容量を調べる.
* 060turbo.sysでIOCS _SYS_STATが拡張されていなければ、TS-6BE16の16MBと見なす.
* out	d0.l	メモリ実装容量(バイト単位)
*		0ならハイメモリ無し、負数ならエラー

get_himem_size:
		PUSH	d1/a1
	.if	0
		moveq	#_HIMEM_VERSION,d1
		IOCS	_HIMEM
		cmpi.l	#'060T',d0
		bne	get_himem_size_ts6be16
	.endif
		cmpi.b	#6,(MPUTYPE)		;IOCS _SYS_STAT を使うので $cbc.b 参照
		bcs	get_himem_size_ts6be16
		bsr	is_060turbo
		bne	get_himem_size_ts6be16

		move	#$4000,d1		;d0=size,a1=start adr.
		IOCS	_SYS_STAT
		bra	@f
get_himem_size_ts6be16:
		move.l	#16*1024*1024,d0
@@:		POP	d1/a1
		rts

* ハイメモリ空き容量を調べる.
* IOCS _HIMEMが使用可能なことを確認してから呼び出すこと.
* out	d0.l	空きメモリ容量(バイト単位)

get_himem_free_size:
		move.l	d1,-(sp)
		moveq	#_HIMEM_GETSIZE,d1
		IOCS	_HIMEM
		move.l	d1,d0
		move.l	(sp)+,d1
		rts


* メモリ容量表示下請け ------------------------ *
* in	d0.l	実装容量(0か負数なら未実装)
*	d1.l	空き容量
*		d0/d1いずれもバイト数.
*	a1.l	タイトル文字列のアドレス
* break d0-d1/a0-a1

print_memsize_sub:
		lea	(-256,sp),sp
		lea	(sp),a0
		STRCPY	a1,a0,-1		;title
		lea	(not_installed,pc),a1
		tst.l	d0
		ble	print_memsize_sub_end
;実装容量
		move.l	d1,-(sp)
		lsr.l	#8,d0
		lsr.l	#2,d0			;÷1024
		moveq	#MEMSIZE_LEN,d1
		bsr	fe_iusing
		lea	(memsize_kb,pc),a1
		STRCPY	a1,a0,-1
;空き容量
		move.l	(sp)+,d0
		lsr.l	#8,d0
		lsr.l	#2,d0			;÷1024
		moveq	#MEMSIZE_LEN,d1
		bsr	fe_iusing
		lea	(memsize_kb_free,pc),a1
print_memsize_sub_end:
		STRCPY	a1,a0

		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts


memsize_title:	.dc.b	'memory size		: ',0
himem_title:	.dc.b	'extention memory	: ',0
memsize_kb:	.dc.b	'K Bytes (',0
memsize_kb_free:.dc.b	'K Bytes Free)',LF,0
		.even


*┌────────────────────────────────────────┐
*│				SRAM 容量/使用モード表示			   │
*└────────────────────────────────────────┘

print_sram:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(sram_title,pc),a1
		STRCPY	a1,a0,-1

		bsr	Sram_GetSizeInKiB
		moveq	#MEMSIZE_LEN,d1
		bsr	fe_iusing

		lea	(sramsize_kb,pc),a1
		STRCPY	a1,a0,-1

		bsr	Sram_GetUseMode
		cmpi	#SRAM_U_PROGRAM,d0
		seq	d1
		bls	@f
		moveq	#SRAM_U_PROGRAM+1,d0
@@:
		lea	(sram_use_offs,pc,d0.w),a1
		move.b	(a1),d0
		adda	d0,a1
		STRCPY	a1,a0,-1

		tst.b	d1
		beq	@f			;SRAM_U_PROGRAM ではなかった
		bsr	SramProgram_GetType
		beq	@f

		bsr	strcpy_slash
		bsr	SramProgram_ToString
@@:
		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts


sram_title:	.dc.b	'SRAM			: ',0
sramsize_kb:	.dc.b	'K Bytes / ',0

sram_use_offs:	.dc.b	sram_free-$,sram_ramdisk-$,sram_prog-$,sram_unknown-$
sram_free:	.dc.b	'Free',0
sram_ramdisk:	.dc.b	'SRAMDISK',0
sram_prog:	.dc.b	'Program',0
sram_unknown:	.dc.b	'???',0
		.even


*┌────────────────────────────────────────┐
*│				パワーオフ回数表示				   │
*└────────────────────────────────────────┘

print_boot_count:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(pow_on_title,pc),a1
		STRCPY	a1,a0,-1

		move.l	(SRAM_POWOFF),d0
		addq.l	#1,d0			;起動回数は終了回数より1多い
**		bcc	@f
**		subq.l	#1,d0
**@@:
		bsr	decstr

		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts


pow_on_title:
		.dc.b	'boot count		: ',0
		.even


*┌────────────────────────────────────────┐
*│				起動デバイス／電源種別				   │
*└────────────────────────────────────────┘

print_bootinf:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(boot_title,pc),a1
		STRCPY	a1,a0,-1

		IOCS	_BOOTINF
		move.l	d0,-(sp)
		andi.l	#$00ff_ffff,d0

		cmpi.l	#SCSIROM,d0
		bcs	@f
		cmpi.l	#SCSIROM+4*8,d0
		bcs	print_bootinf_scsiin	;$fc00?? : SCSI-ROM(built-in)
@@:
		cmpi.l	#SCSIEX_ROM,d0
		bcs	@f
		cmpi.l	#SCSIEX_ROM+4*8,d0
		bcs	print_bootinf_scsiex	;$ea00?? : SCSI-ROM(I/O board)
@@:
		cmpi.l	#SRAM,d0
		bcs	@f
		cmpi.l	#SRAM_MAX+1,d0
		bcs	print_bootinf_sram	;$ed???? : SRAM
@@:
		tst	(sp)
		bne	print_bootinf_rom

		cmpi	#$80,d0
		bcs	@f
		cmpi	#$8f,d0
		bls	print_bootinf_sasi	;$80～$8f : SASI
@@:
		cmpi	#$90,d0
		bcs	@f
		cmpi	#$93,d0
		bls	print_bootinf_fdd	;$90～$93 : FDD
@@:
* 起動デバイス不明(とりあえずアドレスを表示する)

print_bootinf_rom:
		lea	(boot_rom,pc),a1
		bra	@f
print_bootinf_sram:
		move.l	d0,d1
		moveq	#0,d0
		bsr	is_exist_sxsi
		subq.l	#2,d0
		beq	print_bootinf_sxsi	;SxSI から起動

		moveq	#8,d0
		bsr	is_exist_sxsi
		subq.l	#2,d0
		beq	print_bootinf_sxsi	;〃

		move.l	d1,d0			;起動アドレス
		lea	(boot_sram,pc),a1
@@:		STRCPY	a1,a0,-1
		bsr	hexstr_z
		bra	print_bootinf_switch

print_bootinf_sxsi:
		move.l	d1,d0			;起動アドレス
		lea	(boot_sxsi,pc),a1
		STRCPY	a1,a0,-1
		bsr	hexstr_z
		move.b	#')',(a0)+
		bra	print_bootinf_switch

print_bootinf_scsiin:
		lea	(boot_scsiin,pc),a1
		bra	@f
print_bootinf_scsiex:
		bsr	get_scsiex_type
		bsr	Scsiex_ToString
		bra	print_bootinf_switch
print_bootinf_sasi:
		lea	(boot_sasi,pc),a1
		bra	@f
print_bootinf_fdd:
		lea	(boot_fdd,pc),a1
@@:
		STRCPY	a1,a0,-1

print_bootinf_switch:
		bsr	strcpy_slash

		move.b	(sp),d0			;最上位バイト=起動方法
		addq.l	#4,sp
		lea	(boot_power,pc),a1
		beq	@f
		subq.b	#2,d0
		lea	(boot_remote,pc),a1
		bcs	@f
		lea	(boot_timer,pc),a1
		beq	@f
		lea	(boot_unknown,pc),a1
@@:		STRCPY	a1,a0

		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts


boot_title:	.dc.b	'boot device / switch	: ',0
boot_rom:	.dc.b	'ROM $',0
boot_scsiin:	.dc.b	'SCSIIN',0
boot_sasi:	.dc.b	'SASI',0
boot_sxsi:	.dc.b	'SxSI ('		;'SxSI (SRAM $xxxxxxxx)'
boot_sram:	.dc.b	'SRAM $',0
boot_fdd:	.dc.b	'FDD',0
boot_power:	.dc.b	'power switch',LF,0
boot_remote:	.dc.b	'remote switch',LF,0
boot_timer:	.dc.b	'timer',LF,0
boot_unknown:	.dc.b	'???',LF,0
		.even


*┌────────────────────────────────────────┐
*│				   ＳＣＳＩチェック				   │
*└────────────────────────────────────────┘

print_scsi:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(scsi_title,pc),a1
		STRCPY	a1,a0,-1

		moveq	#0,d7

		moveq	#0,d0
		bsr	is_exist_sxsi
		lea	(scsi_sxsi,pc),a1
		bsr	print_scsi_sub

		moveq	#8,d0
		bsr	is_exist_sxsi
**		lea	(scsi_sxsi,pc),a1
		bsr	print_scsi_sub

		bsr	is_exist_builtin_scsi
		lea	(boot_scsiin,pc),a1
		bsr	print_scsi_sub

		bsr	get_scsiex_type
		move.l	d0,d1
		beq	print_scsi_no_ex	;SCSI ボードなし

		bsr	tas_d7_strcpy_slash
		bsr	Scsiex_ToString

		move.l	d1,d0
		bsr	is_mach2_series
		bne	@f

		moveq	#.not.(1<<3),d0
		or.b	(SRAM_SCSI_ID),d0	;SCSIIN 起動: 2nd-port が SCSIEX
		not.l	d0			;SCSIEX  〃 : 1st-port	〃
		bsr	get_scsi_iocs_level
		bmi	@f

		move.b	#' ',(a0)+
		move.b	#'(',(a0)+
		bsr	scsi_level_to_str2	;Mach-2 ならレベルを表示
		move.b	#')',(a0)+
@@:
print_scsi_no_ex:
		lea	(lf,pc),a1
		tst.b	d7
		bne	@f
		tst.b	(opt_all_flag,a6)
		beq	print_scsi_end
		lea	(not_installed,pc),a1
@@:
		STRCPY	a1,a0
		bsr	print_stack_buffer
print_scsi_end:
		lea	(256,sp),sp
		rts


is_mach2_series:
		cmpi	#SCSIEX_MACH2,d0
		beq	@f
		cmpi	#SCSIEX_MACH2P,d0
@@:		rts

tas_d7_strcpy_slash:
		tas	d7
		bne	strcpy_slash
		rts

print_scsi_sub:
		tst.l	d0
		beq	print_scsi_sub_end
print_scsi_sub2:
		bsr	tas_d7_strcpy_slash
@@:
		STRCPY	a1,a0,-1
print_scsi_sub_end:
		rts


* SCSI IOCS のレベル値を文字列化する.
* in	d0.l	SCSI LEVEL
*	a0.l	バッファアドレス
* out
*	a0.l	文字列末尾
*
* d0.l が 256 以上なら 16 進数表示(0 詰め 4 桁)、それ未満なら
* 10 進数表示(1～3 桁)に変換する.

scsi_level_to_str2:
		cmpi.l	#256,d0
		bcs	decstr			;10 進数(1～3 桁)

		swap	d0
		bra	hexstr_word		;16 進数(0 詰め 4 桁)


* 内蔵 SCSI が存在するか調べる.
* out	d0.l	0:なし 1:あり

is_exist_builtin_scsi:
		move.l	a0,-(sp)
		lea	(SCSIIN_ID),a0
		bsr	check_bus_error_long
		bne	is_exist_scsiin_false
		cmpi.l	#'SCSI',d0
		bne	is_exist_scsiin_false

		addq.l	#4,a0
		bsr	check_bus_error_word
		bne	is_exist_scsiin_false
		cmp	#'IN',d0
		bne	is_exist_scsiin_false
*is_exist_scsi_true:
		moveq	#1,d0
		bra	@f
is_exist_scsiin_false:
		moveq	#0,d0
@@:		movea.l	(sp)+,a0
		rts


* SCSI ボードの種類を調べる.
* out	d0.l	si_scsiex.s 参照のこと

get_scsiex_type:
		tas	(has_scsiex_type,a6)
		bne	@f

		bsr	Scsiex_GetType
		move.b	d0,(scsiex_type,a6)
		rts
@@:
		moveq	#0,d0
		move.b	(scsiex_type,a6),d0
		rts


* SxSI が存在するか調べる.
* in	d0.l	0～7:通常 8～15:TWOSCSI 常駐時に 2nd-port を調べる
* out	d0.l	0:なし 1:あり 2:あり(BOOTSET.X による SRAM からの起動)

is_exist_sxsi:
		PUSH	d1/d4/a0-a1
		move.l	d0,d4
		bsr	is_exist_builtin_scsi
		bne	is_exist_sxsi_false	;SCSIIN があれば SASI は無い
		bsr	get_scsi_iocs_level0
		bmi	is_exist_sxsi_false

		TWOSCSI	_S_TW_CHK
		addq.l	#2,d0
		bne	@f

		lea	(-1),a1
		TWOSCSI	_S_TW_INTVCS
		movea.l	d0,a1			;_SCSIDRV の処理アドレスを収得
		TWOSCSI	_S_TW_LEVEL
		andi.l	#$ffff,d0
		bra	is_exist_sxsi_check
@@:
		moveq	#8,d1
		cmp.l	d1,d4
		bcc	is_exist_sxsi_false	;2nd-port は無い

		movea.l	(_SCSIDRV*4+IOCS_VECTBL),a1
		SCSI	_S_LEVEL
is_exist_sxsi_check:
		subq.l	#1,d0
		bne	is_exist_sxsi_false	;SxSI は必ずレベル 1

		lea	(-$78,a1),a0
		bsr	check_bus_error_long
		bne	is_exist_sxsi_false
		cmpi.l	#'*SAS',d0
		bne	is_exist_sxsi_false
		addq.l	#4,a0
		bsr	check_bus_error_long
		bne	is_exist_sxsi_false
		cmpi.l	#'ITRP',d0
		bne	is_exist_sxsi_false

		moveq	#1,d0			;SxSI あり
		cmpa.l	#SRAM,a1
		bcs	@f
		cmpa.l	#SRAM_MAX+1,a1
		bcc	@f
		moveq	#2,d0			;SRAM 起動
		bra	@f
is_exist_sxsi_false:
		moveq	#0,d0
@@:
		POP	d1/d4/a0-a1
		rts


scsi_title:	.dc.b	'SCSI			: ',0
scsi_sxsi:	.dc.b	'SxSI',0
		.even


*┌────────────────────────────────────────┐
*│				  起動開始からの時間				   │
*└────────────────────────────────────────┘

print_ontime:
		IOCS	_ONTIME
		move.l	d1,-(sp)
		moveq	#100,d1
		bsr	fe_idiv			;0.01秒→1秒単位
		moveq	#60,d1
		bsr	fe_idiv
		move.l	d1,d4			;秒数
		moveq	#60,d1
		bsr	fe_idiv
		move.l	d1,d3			;分数
		move.l	d0,d2			;時間数
		move.l	(sp)+,d1		;日数

		lea	(ontime_title,pc),a1
		bra	print_time_sub


*┌────────────────────────────────────────┐
*│				   累積稼動時間表示				   │
*└────────────────────────────────────────┘

print_runtime:
		moveq	#0,d4			;秒数=0
		move.l	(SRAM_ONTIME),d0
		moveq	#60,d1
		bsr	fe_idiv
		move.l	d1,d3			;分数
		moveq	#24,d1
		bsr	fe_idiv
		move.l	d1,d2			;時間数
		move.l	d0,d1			;日数

		lea	(runtime_title,pc),a1
		bra	print_time_sub


* 日数/時分秒を文字列に変換し、タイトルと改行記号をつけて表示する.
* 日数が 0 の時は空白で埋める.
* in	d1.l	日数
*	d2.l	時間数(0～23)
*	d3.l	分数(0～59)
*	d4.l	秒数(0～59)
*	a1.l	タイトル文字列
* break	d0-d1/a0-a1

print_time_sub:
		lea	(-256,sp),sp
		lea	(sp),a0
		STRCPY	a1,a0,-1

		move.l	d1,d0
		bne	print_time_sub_day

		moveq	#' ',d0
		moveq	#.sizeof.('65535',' / ')-1,d1
@@:		move.b	d0,(a0)+
		dbra	d1,@b
		bra	@f
print_time_sub_day:
		moveq	#.sizeof.('65535'),d1
		bsr	fe_iusing		;日数
		bsr	strcpy_slash
@@:
		move.l	d2,d0
		moveq	#2,d1
		bsr	fe_iusing		;時間数

		move.l	d3,d0
		bsr	dec2_to_str		;分数

		move.l	d4,d0
		bsr	dec2_to_str		;秒数

		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
		rts

dec2_to_str:
		move.b	#':',(a0)+
		divu	#10,d0
		addi.l	#'0'<<16+'0',d0
		move.b	d0,(a0)+
		swap	d0
		move.b	d0,(a0)+
		rts


ontime_title:	.dc.b	'elapsed time (H:M:S)	: ',0
runtime_title:	.dc.b	'run time (day/H:M:S)	: ',0
		.even


*┌────────────────────────────────────────┐
*│			      バスエラーカウントルーチン			   │
*└────────────────────────────────────────┘

print_error_count:
		lea	(SRAM_ASKA_ID),a2
		cmpi.l	#'BEL.',(a2)+		;組み込まれていなければ
		bne	print_error_count_skip	;-allでも表示しない

		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(error_title,pc),a1
		STRCPY	a1,a0,-1

		move.l	(a2)+,d0		;SRAM_ASKA_ADR
		bsr	decstr
		bsr	strcpy_slash
		move.l	(a2)+,d0		;SRAM_ASKA_BUS
		bsr	decstr

		STRCPY_EOL a0
		bsr	print_stack_buffer
		lea	(256,sp),sp
print_error_count_skip:
		rts


error_title:	.dc.b	'error count ADDRESS/BUS	: ',0
		.even


*┌────────────────────────────────────────┐
*│				   Printer チェック				   │
*└────────────────────────────────────────┘

print_printer:
		lea	(-256,sp),sp
		lea	(sp),a0
		lea	(printer_title,pc),a1
		STRCPY	a1,a0,-1

		lea	(online_mes,pc),a1
		IOCS	_SNSPRN
		tst.l	d0
		bne	@f			;出力可能
		lea	(offline_mes,pc),a1
		tst.b	(opt_all_flag,a6)
		beq	print_printer_skip
@@:
		STRCPY	a1,a0
		bsr	print_stack_buffer
print_printer_skip:
		lea	(256,sp),sp
		rts


printer_title:	.dc.b	'printer			: ',0
online_mes:	.dc.b	'online',LF,0
offline_mes:	.dc.b	'offline',LF,0
		.even


*┌────────────────────────────────────────┐
*│				拡張 I/O ボード表示				   │
*└────────────────────────────────────────┘

* $eafa00 ～ $eafa0f
*    |||+- 6	|||+- 17
*    ||+- 5	||+- 16
*    |+- 4	|+- 15
*    +- 3	+- 14
B_ADR0_3:	.equ	3
B_ADR0_2:	.equ	4
B_ADR0_1:	.equ	5
B_ADR0_0:	.equ	6
B_ADR1_3:	.equ	14
B_ADR1_2:	.equ	15
B_ADR1_1:	.equ	16
B_ADR1_0:	.equ	17

print_io_board:
		lea	(-256,sp),sp
		lea	(sp),a3
		lea	(board_title,pc),a1
		STRCPY	a1,a3,-1		;a3=書き込みアドレス

		moveq	#0,d6			;1=一枚でもボードが存在する


* bit[n+3] = 0:バンクメモリ無し 1:有り
* bit[n+2] = 0:バンクメモリ 4MB 1:16MB
* bit[n+1] = 0:バンクメモリ $eexxxx 1:$efxxxx
* bit[n+0] = 0:Nereid 無し 1:有り
* n=0:Nereid(#0) / n=4:Nereid(#1)
* bit[31] = 0:TS-6BGA (G-RAM #1)無し 1:有り
		moveq	#0,d7

* バンクメモリチェック
*
*   $ee0000～$eeffff、$ef0000～$efffff は TS-6BGA
* の  G-RAM バンク及び、Nereid のバンクメモリとし
* て使われる.
*
*   TS-6BGA と ispr16bitPCMBoard の判別は G-RAM
* バンクがあるかどうかでしか出来ないので、先にチ
* ェックすると Nereid のバンクメモリを誤認する可
* 能性がある.
*
*   よって、先に Nereid の実装確認を行う. なお、
* Nereid の DRAM 未実装モデルを「バンク切り替えメ
* モリ・イネーブル」設定で装着し、TS-6BGA も装着
* すると、Nereid(バンク有り)＋ispr16bitPCMBoard
* として判定すると思われるが、Nereid をそのような
* 設定で使用してはいけないので、仕様とする.

* Nereid 実装確認
		tst.b	(xt30_id3,a6)
		bne	print_iob_no_nereid

		lea	(NEPTUNE0_IO),a0
		bsr	check_bus_error_byte
		lea	(NEREID0_REG-NEPTUNE0_IO,a0),a0
		beq	@f			;Neptune だった
		bsr	check_bus_error_byte
		bne	@f			;Nereid #0 無し

		move.b	(a0),d7			;有り
		lsr.b	#4,d7
		bset	#0,d7			;%xxx1
@@:		ror	#4,d7

		lea	(NEREID1_REG-NEREID0_REG,a0),a0
		bsr	check_bus_error_byte
		bne	@f			;Nereid #1 無し

		move.b	(a0),d7			;有り
		lsr.b	#4,d7
		bset	#0,d7			;%xxx1
@@:		rol	#4,d7
print_iob_no_nereid:


* TS-6BGA (制御部固定、バンク #0 / #1)
* ispr16bitPCMBoard (〃)
		bsr	is_exist_ts6bga
		beq	print_iob_no_ts6bga

		lea	(b_isprpcm,pc),a1
		lsr.b	#2,d0
		bcs	print_iob_ga_exist	;ispr16bitPCMBoard (バンク無し)

		lea	(b_ts6bga,pc),a1
		beq	print_iob_ga_exist	;TS-6BGA (G-RAM #0)

		bset	#31,d7			;TS-6BGA (G-RAM #1)
		addq.b	#1,(b_ts6bga_1-b_ts6bga,a1)
		addq.b	#1,(b_ts6bga_2-b_ts6bga,a1)
		bsr	print_iob_inc_id
print_iob_ga_exist:
		bsr	print_iob_sub
print_iob_no_ts6bga:
* a0 は破壊


* SCSI ボード
		bsr	get_scsiex_type
		move.l	d0,d1
		cmpi	#SCSIEX_UNKNOWN,d1
		bhi	@f
		beq	print_iob_scsiex_end	;未知のデバイス

* SCSIボードなし
		lea	(TS6BSI_P_ID),a0
		bsr	check_bus_error_byte
		bne	print_iob_scsiex_end

		lea	(b_ts6bsi_p,pc),a1	;TS-6BS1mkIII のパラレルポート
		bsr	print_iob_sub		;だけが存在する
		bra	print_iob_scsiex_end
@@:
* SCSIボードあり
		cmpi	#SCSIEX_TS6BS1MK3,d1
		beq	print_iob_ts6bs1mk3

		move.l	d1,d0
		bsr	is_mach2_series
		lea	(b_mach2,pc),a1
		beq	@f
		lea	(b_scsiex,pc),a1
@@:
		lea	(a3),a0
		STRCPY	a1,a0,-1
		move.l	d1,d0
		bsr	Scsiex_ToString

		move.l	d1,d0
		bsr	Scsiex_hasRomName
		beq	@f

		bsr	strcpy_slash
		move.l	d1,d0
		bsr	Scsiex_GetRomName
@@:
		lea	(a0),a2
		bsr	print_iob_sub3
		bra	print_iob_scsiex_end

print_iob_ts6bs1mk3:
		lea	(b_ts6bsi,pc),a1
		lea	(TS6BSI_P_ID),a0
		bsr	check_bus_error_byte
		beq	@f
		clr.b	(b_ts6bsi_1-b_ts6bsi,a1)	;パラレルポートなし
@@:
		bsr	print_iob_sub
print_iob_scsiex_end:
* a0 は破壊


* FAX ボード
		lea	(FAX_IO),a0
		bsr	check_bus_error_byte
		bne	print_iob_no_fax

		lea	(b_fax,pc),a1
		bsr	print_iob_sub
print_iob_no_fax:
~a0:		.set	FAX_IO


* MIDI ボード (#0 / #1)
		bsr	is_exist_midi
		move	d0,d1
		lea	(b_midi,pc),a1
		moveq	#2-1,d2
print_iob_midi_loop:
		lsr	#1,d1
		bcc	@f
		bsr	print_iob_sub
@@:
		bsr	print_iob_inc_id2
		dbra	d2,print_iob_midi_loop
*print_iob_no_midi:


* パラレルボード (#0 / #1)
		lea	(PARA0_IO-~a0,a0),a0
		lea	(b_para,pc),a1
		moveq	#2-1,d2
print_iob_para_loop:
		bsr	check_bus_error_byte
		bne	@f
		bsr	print_iob_sub
@@:
		lea	(PARA1_IO-PARA0_IO,a0),a0
		bsr	print_iob_inc_id2
		dbra	d2,print_iob_para_loop
*print_iob_no_para:
~a0:		.set	PARA0_IO+(PARA1_IO-PARA0_IO)*2


* RS-232C ボード (#0 / #1 / #2 / #3)
		lea	(RS232C0_IO-~a0,a0),a0
		lea	(b_rs232c,pc),a1
		moveq	#4-1,d2
print_iob_rs_loop:
		bsr	check_bus_error_word
		bne	@f
		bsr	print_iob_sub
@@:
		lea	(RS232C1_IO-RS232C0_IO,a0),a0
		bsr	print_iob_inc_id2
		dbra	d2,print_iob_rs_loop
*print_iob_no_rs:
~a0:		.set	RS232C0_IO+(RS232C1_IO-RS232C0_IO)*4


* ユニバーサル I/O ボード (#$00 ～ #$3f)
		lea	(U_IO0_IO-~a0,a0),a0
		lea	(b_u_io,pc),a1
		moveq	#$40-1,d2
print_iob_uio_loop:
		bsr	check_bus_error_byte
		bne	print_iob_uio_next

		movea.l	a0,a2			;save a0
		clr.l	-(sp)

		moveq	#$40-1,d0		;ID
		sub.b	d2,d0
		ror.l	#8,d0
		lea	(sp),a0
		bsr	hexstr_byte
		move.b	-(a0),(b_u_io_id+1-b_u_io,a1)
		move.b	-(a0),(b_u_io_id+0-b_u_io,a1)

		lsl.l	#2,d0			;先頭アドレス
*		lea	(sp),a0
		bsr	hexstr_byte
		move.b	-(a0),(B_ADR0_0,a1)
		move.b	-(a0),(B_ADR0_1,a1)

		addi.l	#3<<24,d0		;末尾アドレス
*		lea	(sp),a0
		bsr	hexstr_byte
		move.b	-(a0),(B_ADR1_0,a1)
		move.b	-(a0),(B_ADR1_1,a1)

		addq.l	#4,sp
		movea.l	a2,a0			;restore a0

		bsr	print_iob_sub
print_iob_uio_next:
		addq.l	#U_IO1_IO-U_IO0_IO,a0
		dbra	d2,print_iob_uio_loop
*print_iob_no_uio:
~a0:		.set	U_IO0_IO+(U_IO1_IO-U_IO0_IO)*$40


* GP-IB ボード
.if ~a0.ne.GPIB_IO
		lea	(GPIB_IO-~a0,a0),a0
.endif
		bsr	check_bus_error_byte
		bne	print_iob_no_gpib

		lea	(b_gpib,pc),a1
		bsr	print_iob_sub
print_iob_no_gpib:
~a0:		.set	GPIB_IO


* AWESOME-X
*	AWESOME-X が存在すれば、X68K-PPI 及び FineScanner-X68(#$0～#$7)
*	は有り得ない
		bsr	Accelerator_AwesomexExists
		beq	print_iob_no_awe

		lea	(b_awe,pc),a1
		bsr	print_iob_sub
		bra	print_iob_no_ppi_fs2
print_iob_no_awe:


* X68K-PPI / FineScanner-X68 (#$0 ～ #$3)
*	Xellent30(#0)が存在すれば、X68K-PPI 及び FineScanner-X68(#$0～#$3)
*	は有り得ない
		lea	(XT30_IO0+8),a0		;$ec0008.w
		bsr	check_bus_error_word
		beq	print_iob_no_ppi_fs	;Xellent30(#0)有り
~a0:		.set	XT30_IO0+8


* X68K-PPI
		subq.l	#~a0-PPI_IO,a0
		bsr	check_bus_error_byte	;$ec0006.b
		bne	print_iob_no_ppi

		lea	(b_ppi,pc),a1
		bsr	print_iob_sub
print_iob_no_ppi:
~a0:		.set	PPI_IO


* FineScanner-X68 (#$0 ～ #$3)
		moveq	#$0,d0
		moveq	#4-1,d1
		bsr	print_iob_fs_sub
print_iob_no_ppi_fs:
* a0 は破壊


* FineScanner-X68 (#$4 ～ #$7)
*	Xellent30(#1)が存在すれば、FineScanner-X68(#$4～#$7)
*	は有り得ない
		lea	(XT30_IO1+$100),a0	;$ec4100.w
		bsr	check_bus_error_word
		beq	print_iob_no_ppi_fs2

		moveq	#$4,d0
		moveq	#4-1,d1
		bsr	print_iob_fs_sub
print_iob_no_ppi_fs2:
* a0 は破壊


* FineScanner-X68 (#$8 ～ #$b)
*	Xellent30(#2)が存在すれば、FineScanner-X68(#$8～#$b)
*	は有り得ない
		lea	(XT30_IO2+$100),a0	;$ec8100.w
		bsr	check_bus_error_word
		beq	print_iob_no_fs3

		moveq	#$8,d0
		moveq	#4-1,d1
		bsr	print_iob_fs_sub
print_iob_no_fs3:
~a0:		.set	XT30_IO2+$100


* Mercury-Unit / Neptune-X(Evolution) / VENUS-X / FineScanner-X68(#$c～#$f) / Nereid
*	Xellent30(#3)が存在すれば、Mercury-Unit(全バージョン)、
*	Neptune-X(Evolution)、VENUS-X、FineScanner-X68(#$c～#$f)、
*	Nereid は有り得ない
		tst.b	(xt30_id3,a6)
		bne	print_iob_no_mu_ne


* Mercury-Unit
		bsr	is_exist_mercury_unit2
		beq	print_iob_no_mu

		lea	(a3),a2
		lea	(b_mu,pc),a1
		btst	d0,#1<<MERC_V4+1<<MERC_V4OPNA
		beq	@f
		addq.b	#8,(B_ADR0_1,a1)	;V4 は開始アドレスが違う
@@:		STRCPY	a1,a2,-1

		add	d0,d0
		lea	(b_mu_tbl,pc),a1
		adda	(-2,a1,d0.w),a1		;バージョン / 型番
		bsr	print_iob_sub2
print_iob_no_mu:


* FineScanner-X68 (#$c ～ #$d)
		moveq	#$c,d0
		moveq	#2-1,d1
		bsr	print_iob_fs_sub


* イーサネットボード各種
*	Nereid (#0)と Neptune-X(Evolution) (#0) は共存できない.
* 1.Nereid (#0)
* 2.Neptune-X(Evolution) (#0)
* 3.Neptune-X(Evolution) (#1)
* 4.Nereid (#1)

* Nereid (#0)
		lea	(NEREID0_REG-~a0,a0),a0	;print_iob_ne_mac 用
		moveq	#0,d0
		btst	d0,d7
		beq	print_iob_no_nere0

**		moveq	#0,d0
		bsr	print_iob_nereid_sub	;Nereid #0
		bsr	print_iob_sub2
		bra	print_iob_no_nept0
print_iob_no_nere0:
~a0:		.set	NEREID0_REG
* Neptune-X(Evolution) (#0)
		lea	(NEPTUNE0_IO-~a0,a0),a0	;print_iob_ne_mac 用
		bsr	check_bus_error_byte
		bne	print_iob_no_nept0

		moveq	#0,d0			;Neptune #0
		bsr	print_iob_nept_sub
		bsr	print_iob_sub2
print_iob_no_nept0:
* a0 は破壊

* Neptune-X(Evolution) (#1)
		lea	(NEPTUNE1_IO),a0
		bsr	check_bus_error_byte
		bne	print_iob_no_nept1

		moveq	#1,d0			;Neptune #1
		bsr	print_iob_nept_sub
		bsr	print_iob_sub2
print_iob_no_nept1:
~a0:		.set	NEPTUNE1_IO

* Nereid (#1)
		lea	(NEREID1_REG-~a0,a0),a0	;print_iob_ne_mac 用
		moveq	#4,d0
		btst	d0,d7
		beq	print_iob_no_nere1

**		moveq	#4,d0
		bsr	print_iob_nereid_sub	;Nereid #1
		bsr	print_iob_sub2
print_iob_no_nere1:
~a0:		.set	NEREID1_REG


* FineScanner-X68 (#$e ～ #$f) / バンクメモリ
*	VENUS-X が存在すれば、FineScanner-X68(#$f) 及び
*	バンクメモリは有り得ない


* FineScanner-X68 (#$e ～ #$f)
		bsr	is_exist_venus_x
		moveq	#2-1,d1			;VENUS-X なし -> moveq #2-1,d1
		sub	d0,d1			;	 あり -> moveq #1-1,d1
		moveq	#$e,d0
		bsr	print_iob_fs_sub


* バンクメモリ(レジスタ)
		tst	d1
		beq	print_iob_no_bankram	;VENUS-X あり
		tst	d0
		bmi	print_iob_no_bankram	;FineScanner-X68(#$f) あり

		lea	(BANK_REG-~a0,a0),a0
		bsr	check_bus_error_byte
		bne	print_iob_no_bankram

		lea	(b_bank,pc),a1
		bsr	print_iob_sub
print_iob_no_bankram:
~a0:		.set	BANK_REG


print_iob_no_mu_ne:
* a0 は破壊


* $ee0000 ～ $efffff

* POLYPHON / PSX
*	TS-6BGA が存在し、かつ G-RAM バンクが #1 であれば
*	POLYPHON、PSX16550、PSX16750 は有り得ない
		tst	d7
		bne	print_iob_no_poly_psx


* POLYPHON (#0 / #1)
		lea	(POLY0_IO),a0
		lea	(b_poly,pc),a1
		moveq	#2-1,d2
print_iob_poly_loop:
		bsr	check_bus_error_word
		bne	@f
		bsr	print_iob_sub
@@:
		lea	(POLY1_IO-POLY0_IO,a0),a0
		addq.b	#8,(B_ADR0_1,a1)
		move.b	#'b',(B_ADR1_1,a1)	;3+8=$b
		bsr	print_iob_inc_id
		dbra	d2,print_iob_poly_loop
*print_iob_no_awe:
~a0:		.set	POLY0_IO+(POLY1_IO-POLY0_IO)*2


* PSX16550
		bsr	is_exist_psx16550
		move	d0,d1
		lea	(b_psx550,pc),a1
		moveq	#PSX16550_MAX-1,d2
print_iob_psx5_loop:
		lsr	#1,d1
		bcc	@f
		bsr	print_iob_sub
@@:
		addq.b	#2,(B_ADR0_1,a1)
		addq.b	#2,(B_ADR1_1,a1)
		bsr	print_iob_inc_id
		dbra	d2,print_iob_psx5_loop
*print_iob_no_psx5:


* PSX16750
		bsr	is_exist_psx16750
		move.l	d0,d1
		lea	(b_psx750,pc),a1
		lea	(b_psx_ch,pc),a4
		moveq	#PSX16570_MAX-1,d2
print_iob_psx7_loop:
		lsr	#1,d1
		bcc	@f
		bsr	print_iob_sub
@@:
		move.b	(a4)+,(B_ADR0_1,a1)
		move.b	(a4)+,(B_ADR1_1,a1)
		bsr	print_iob_inc_id
		dbra	d2,print_iob_psx7_loop

		tst.l	d1
		bpl	@f
		pea	(b_psx750_7,pc)		;ID=7 には ch.0～1 もある
		bsr	print
		addq.l	#4,sp
@@:
*print_iob_no_psx7:


print_iob_no_poly_psx:
* a0 は破壊


* ボードが一枚もなかった時の処理
		tst	d6
		bne	print_iob_end		;何かボードがあった
		tst.b	(opt_all_flag,a6)
		beq	print_iob_end

		lea	(not_installed,pc),a1
		STRCPY	a1,a3,-1
		bsr	print_stack_buffer

* おしまい
print_iob_end:
		lea	(256,sp),sp
		rts


* a1 の文字列と改行をコピーして表示
print_iob_sub:
		lea	(a3),a2
print_iob_sub2:
		move.l	a1,-(sp)
		STRCPY	a1,a2,-1
		movea.l	(sp)+,a1
print_iob_sub3:
		STRCPY_EOL a2
		moveq	#1,d6			;ボード有り
		bra	print_stack_buffer

* アドレスもインクリメント
print_iob_inc_id2:
		addq.b	#1,(B_ADR0_1,a1)
		addq.b	#1,(B_ADR1_1,a1)
* a1 の文字列内の (#n) 形式の ID 番号をインクリメント
print_iob_inc_id:
		move.l	a1,-(sp)
print_iob_inc_id_loop:
		tst.b	(a1)
		beq	print_iob_inc_id_end
		cmpi.b	#'(',(a1)+
		bne	print_iob_inc_id_loop

		cmpi.b	#'#',(a1)
		bne	print_iob_inc_id_loop
		addq.l	#1,a1			;'(#' 確定
		cmpi.b	#'0',(a1)
		bcs	print_iob_inc_id_loop
		cmpi.b	#'9',(a1)
		bcc	print_iob_inc_id_loop
		cmpi.b	#')',(1,a1)
		bne	print_iob_inc_id_loop

		addq.b	#1,(a1)			;(#n) をインクリメント
print_iob_inc_id_end:
		movea.l	(sp)+,a1
		rts


* TS-6BGA が存在するか調べる.
* in	d7.l	Nereid 装着フラグ
* out	d0.l	bit0=0:なし	1:あり
*		bit1=0:TS-6BGA	1:ispr16bitPCMBoard
*		bit2=0:bank#0	1:bank#1
*	ccr	<tst.l d0> の結果

is_exist_ts6bga:
		PUSH	d6/a0
		moveq	#0,d6
		lea	(TS6BGA_PCMCTRL),a0
		bsr	check_bus_error_word
		bne	is_exist_ga_end		;TS-6BGA 無し

		moveq	#%1011<<0,d0
		and.b	d7,d0
		cmpi.b	#%1001<<0,d0
		beq	is_exist_ga_no_ee	;$eexxxx は Nereid(#0)のバンクメモリ
		moveq	#%1011<<4,d0
		and.b	d7,d0
		cmpi.b	#%1001<<4,d0
		beq	is_exist_ga_no_ee	;$eexxxx は Nereid(#1)のバンクメモリ

		moveq	#%001,d6
		lea	(TS6BGA_EE0000),a0
		bsr	check_bus_error_word
		beq	is_exist_ga_end		;TS-6BGA (G-RAM #0)有り
is_exist_ga_no_ee:
		moveq	#%1011<<0,d0
		and.b	d7,d0
		cmpi.b	#%1011<<0,d0
		beq	is_exist_ga_no_ef	;$efxxxx は Nereid(#0)のバンクメモリ
		moveq	#%1011<<4,d0
		and.b	d7,d0
		cmpi.b	#%1011<<4,d0
		beq	is_exist_ga_no_ef	;$efxxxx は Nereid(#1)のバンクメモリ

		moveq	#%101,d6
		lea	(TS6BGA_EF0000),a0
		bsr	check_bus_error_word
		beq	is_exist_ga_end		;TS-6BGA (G-RAM #1)有り
is_exist_ga_no_ef:
		moveq	#%011,d6		;ispr16bitPCMBoard 有り
is_exist_ga_end:
		move.l	d6,d0
		POP	d6/a0
		rts

.if 0
is_exist_ts6bga_old:
		PUSH	d1-d5/d7/a0
		moveq	#0,d7

		lea	(TS6BGA_PCMCTRL),a0
		bsr	check_bus_error_word
		bne	is_exist_ga_end

		lea	(TS6BGA_EE0000),a0
		bsr	check_bus_error_word
		beq	@f			;bank #0
		lea	(TS6BGA_EF0000),a0
		bsr	check_bus_error_word
		bne	is_exist_ga_end
		addq	#1<<2,d7		;bank #1
@@:
		addq	#1<<0,d7		;存在する

		lea	(TS6BGA_GA_HDR-TS6BGA_PCMCTRL,a0),a0
		PUSH_SR_DI
		move.b	(a0),d1			;ダミーリード
		nop
		move.b	(a0),d2			;〃
		nop
		move.b	(a0),d3			;〃
		nop
		move.b	(a0),d4			;〃
		nop
		move.b	(a0),d5			;Hidden DAC 読み込み
		POP_SR
	.irp	dn,d1,d2,d3,d4
		and.b	dn,d5
	.endm
		not.b	d5
		bne	is_exist_ga_end

		addq	#1<<1,d7		;ispr16bitPCMBoard
is_exist_ga_end:
		move.l	d7,d0
		POP	d1-d5/d7/a0
		rts
.endif


* Neptune-X(Evolution) 表示下請け
* in	d0.l	ID 番号(0～1)
*	a0.l	チェック用 I/O アドレス($ece3ff / $ece7ff)
* out	a1.l	空文字列
*	a2.l	文字列書き込みバッファアドレス
* break	d0

print_iob_nept_sub:
		lea	(b_nept,pc),a1
		tst	d0
		beq	@f
		addq.b	#4,(B_ADR0_2,a1)	;$ece4ff
		addq.b	#4,(B_ADR1_2,a1)	;$ece7ff
		bsr	print_iob_inc_id
@@:
		lea	(a3),a2
		STRCPY	a1,a2,-1		;一行目をコピー
		bsr	print_iob_ne_mac	;MAC アドレス付け加え

		lea	(b_ne_nul,pc),a1
		rts


* Nereid 表示下請け
* in	d0.l	=0:Nereid #0 =4:Nereid #1
*	d7.l	Nereid 装着フラグ
*	a0.l	チェック用 I/O アドレス($ece3f1 / $ecebf1)
* out	a1.l	二行目(バンクメモリ)の文字列のアドレス
*		バンクメモリが無い場合は空文字列のアドレスを返す
*	a2.l	文字列書き込みバッファアドレス

print_iob_nereid_sub:
		PUSH	d0/d7/a0/a3
		lsr.b	d0,d7			;%xxx1

		lea	(b_nere,pc),a1
		tst	d0
		beq	@f
		moveq	#'b',d1			;$ecebxx
		move.b	d1,(B_ADR0_2,a1)
		move.b	d1,(B_ADR1_2,a1)
		bsr	print_iob_inc_id
@@:
		lea	(a3),a2
		STRCPY	a1,a2,-1		;一行目をコピー
		bsr	print_iob_ne_mac	;MAC アドレス付け加え

		lea	(b_ne_nul,pc),a1
		btst	#3,d7
		beq	print_iob_ne_sub_end	;バンクメモリ無し

		lea	(b_nere_bm_ee,pc),a1
		btst	#1,d7
		beq	@f			;$eexxxx
		lea	(b_nere_bm_ef,pc),a1	;$efxxxx
@@:
		btst	#2,d7
		beq	print_iob_ne_sub_end	;4MB

		lea	(b_nere_16m,pc),a0	;16MB
		lea	(b_nere_bm_ee_1-b_nere_bm_ee,a1),a3
		moveq	#B_NERE_LEN-1,d7
@@:		move.b	(a0)+,(a3)+
		dbra	d7,@b
print_iob_ne_sub_end:
		POP	d0/d7/a0/a3
		rts


* MAC アドレス表示下請け
* in	a0.l	チェック用 I/O アドレス($eceyxx)
*	a2.l	文字列書き込みバッファアドレス
* out	a2.l	〃
print_iob_ne_mac:
		PUSH	d0-d1/a0-a1
		tst.b	(opt_exp_flag,a6)
		beq	@f			;無指定なら表示しない

* -e,--expose 指定時のみ実データを表示する
		moveq	#' ',d0
		move.b	d0,(a2)+
		move.b	#'/',(a2)+
		move.b	d0,(a2)+
		bsr	read_and_str_mac_addr
@@:
		POP	d0-d1/a0-a1
		rts


* Neptune-X(及び互換ボード)からMACアドレスを読み込み、文字列化する
read_and_str_mac_addr:
		subq.l	#6,sp			;MAC アドレス読み込みバッファ

		move.l	a0,d0
		clr.b	d0
		movea.l	d0,a0			;$ecex00

		lea	(sp),a1
		moveq	#0,d0
		moveq	#6-1,d1			;SEEPROM から 6.w 読み込む
		PUSH_SR_DI
		move.b	#E8390_NODMA+E8390_PAGE0+E8390_STOP,(E8390_CMD,a0)
		move.b	#$48,(EN0_DCFG,a0)	;set byte-transfer mode
		move.b	#6*2,(EN0_RCNTLO,a0)
		move.b	d0,(EN0_RCNTHI,a0)	;6.w転送
		move.b	d0,(EN0_RSARLO,a0)
		move.b	d0,(EN0_RSARHI,a0)	;$00 番地から読み込み
		move.b	#E8390_RREAD+E8390_START,(E8390_CMD,a0)
@@:
		move.b	(NE_DATAPORT,a0),(a1)+
		tst.b	(NE_DATAPORT,a0)	;空読み
		dbra	d1,@b
		POP_SR

		lea	(sp),a1
		lea	(a2),a0
		moveq	#6-1,d1
@@:
		move.b	(a1)+,d0
		ror.l	#8,d0
		bsr	hexstr_byte
		move.b	#':',(a0)+
		dbra	d1,@b
		clr.b	-(a0)
		lea	(a0),a2

		addq.l	#6,sp
		rts


* FineScanner-X68 表示下請け
* in	d0.l	ID 番号(0～15)
*	d1.l	連続して調べる ID 数-1
* out	d0.l	制御ボードを検出した ID(ビットマップ)
*	ccr	<tst.l d0> の結果
* 注意:
*	他のボードとアドレスが衝突していないか予め調べておくこと.

print_iob_fs_sub:
		PUSH	d1/d6-d7/a0-a2
		moveq	#0,d6
		move.l	d0,d7
print_iob_fs_loop:
		move.l	d7,d0
		ror	#4,d0			;lsl #12,d0
		lea	(F_SCAN_IO),a0
		adda.l	d0,a0
		bsr	check_bus_error_byte
		bne	print_iob_fs_next

		lea	(-256,sp),sp
		lea	(board_title,pc),a1
		lea	(sp),a2
		STRCPY	a1,a2,-1

		lea	(hex_table,pc),a1
		move.b	(a1,d7.w),d0
		lea	(b_fs,pc),a1
		move.b	d0,(B_ADR0_3,a1)	;先頭アドレス
		move.b	d0,(B_ADR1_3,a1)	;末尾〃
		move.b	d0,(b_fs_id-b_fs,a1)	;ID 番号

		bsr	print_iob_sub2
		lea	(256,sp),sp
		bset	d7,d6
print_iob_fs_next:
		addq	#1,d7
		dbra	d1,print_iob_fs_loop

		move.l	d6,d0
		POP	d1/d6-d7/a0-a2
		rts


b_mu_tbl:	.dc	b_mu_nul-b_mu_tbl	;MERC_V3
		.dc	b_mk_mu1-b_mu_tbl	;MERC_V4
		.dc	b_mk_mu1o-b_mu_tbl	;MERC_V4OPNA
		.dc	b_mu_v35-b_mu_tbl	;MERC_V35

board_title:	.dc.b	'optional board		: ',0
B_TAB:		.reg	'			: '

b_isprpcm:	.dc.b	'$e9e200 ～ $e9e3ff  ispr16bitPCMBoard',0
b_ts6bga:	.dc.b	'$e9e200 ～ $e9e3ff  TS-6BGA',LF,B_TAB
		.dc.b	'$e'			;二行目
b_ts6bga_1:	.dc.b	  'e0000 ～ $e'
b_ts6bga_2:	.dc.b		     'effff  G-RAM bank (#0)',0

b_mach2:	.dc.b	'$ea0020 ～ $ea7fff  ',0
b_scsiex:	.dc.b	'$ea0000 ～ $ea1fff  ',0
b_ts6bsi:	.dc.b	'$ea0000 ～ $ea1fef  TS-6BS1mkIII'
b_ts6bsi_1:	.dc.b	LF,B_TAB		;二行目
		.dc.b	'$ea1ff0 ～ $ea1fff  Parallel',0
b_ts6bsi_p:	.dc.b	'$ea1ff0 ～ $ea1fff  TS-6BS1mkIII (Parallel)',0

b_fax:		.dc.b	'$eaf900 ～ $eaf93f  FAX',0
b_midi:		.dc.b	'$eafa00 ～ $eafa0f  MIDI (#0)',0
b_para:		.dc.b	'$eafb00 ～ $eafb0f  Parallel (#0)',0
b_rs232c:	.dc.b	'$eafc00 ～ $eafc0f  RS-232C (#0)',0
b_u_io:		.dc.b	'$eafd00 ～ $eafd03  Universal I/O (#$'
b_u_io_id:	.dc.b					     '00)',0
b_gpib:		.dc.b	'$eafe00 ～ $eafe1f  GP-IB',0

b_awe:		.dc.b	'$ec0000 ～ $ec8001  AWESOME-X',0
b_ppi:		.dc.b	'$ec0000 ～ $ec0007  X68K-PPI',0
b_mu:		.dc.b	'$ecc000 ～ $ecc0ff  Mercury-Unit',0
b_nept:		.dc.b	'$ece000 ～ $ece3ff  Neptune-X (#0)',0
b_nere:		.dc.b	'$ece300 ～ $ece3ff  Nereid (#0)',0
b_nere_bm_ee:	.dc.b	LF,B_TAB		;二行目
		.dc.b	'$ee0000 ～ $eeffff  bank memory (#0) / '
b_nere_bm_ee_1:	.dc.b	' 4096K Bytes',0
b_nere_bm_ef:	.dc.b	LF,B_TAB		;二行目
		.dc.b	'$ef0000 ～ $efffff  bank memory (#1) / '
b_nere_bm_ef_1:	.dc.b	' 4096K Bytes',0
B_NERE_LEN:	.equ	5			;バンクメモリ容量の桁数
*b_nere_4m:	.dc.b	' 4096'
b_nere_16m:	.dc.b	'16384'

*b_venus:	.dc.b	'$ecf000 ～ $ecffff  VENUS-X',0
b_bank:		.dc.b	'$ecffff ～ $ecffff  BANK RAM BOARD',0
b_poly:		.dc.b	'$eff800 ～ $eff83f  POLYPHON (#0)',0

*b_xt:		.dc.b	'$ec0000 ～ $ec3fff  Xellent30 (#0)',0

b_fs:		.dc.b	'$ec0ff0 ～ $ec0fff  FineScanner-X68 (#$'
b_fs_id:	.dc.b					       '0)',0

b_psx550:	.dc.b	'$efff00 ～ $efff1f  PSX16550 (#0)',0
b_psx750:	.dc.b	'$efff00 ～ $efff3f  PSX16750 (#0)',0
b_psx750_7:	.dc.b	B_TAB
		.dc.b	'$efff00 ～ $efff1f',LF,0

b_psx_ch:	.dc.b	'25','47','69','8b','ad','cf','ef'

b_mk_mu1:	.dc.b	' V4 (MK-MU1)',0
b_mk_mu1o:	.dc.b	' V4 (MK-MU1O)',0
b_mu_v35:	.dc.b	' V3.5'
b_mu_nul:
b_ne_nul:	.dc.b	0
		.even


*┌────────────────────────────────────────┐
*│			ＰＳＸ１６５５０ ／ ＰＳＸ１６７５０			   │
*└────────────────────────────────────────┘

* PSX16550 が存在するか調べる.
* out	d0.l	bit0～bit1 が ID=0～ID=1 に対応し、値が 1 なら存在する
* 注意:
*	TS-6BGA が G-RAM バンク #1 の設定で存在していないことを
*	確認してから呼び出すこと(バンク #0 なら良い).

is_exist_psx16550:
		PUSH	d1-d2/a0
		lea	(PSX1_IO),a0
		moveq	#0,d1
		moveq	#PSX16550_MAX-1,d2
is_exist_psx16550_loop:
		bsr	check_bus_error_byte
		bne	@f			;未実装
		addq.b	#1,d0
		bne	@f			;PSX16750 だった
		bset	d2,d1
@@:		lea	(PSX0_IO-PSX1_IO,a0),a0
		dbra	d2,is_exist_psx16550_loop
		move.l	d1,d0
		POP	d1-d2/a0
		rts


* PSX16750 が存在するか調べる.
* out	d0.l	bit0～bit7 が ID=0～ID=7 に対応し、値が 1 なら存在する
*		ID=0 -> ch.0～ch.3、ID=1 -> ch.2～ch.5 …となるので
*		連続する 2 ビットが同時に 1 になることはない.
*		bit31=1 の時、ID=7 が ch.e～f だけでなく ch.0～1 も
*		有効になっていることを示す.
* 注意:
*	TS-6BGA が G-RAM バンク #1 の設定で存在していないことを
*	確認してから呼び出すこと(バンク #0 なら良い).
* 備考:
*	実際のところ ID=7 で ch.0～1 が使えるかどうかは不明.

is_exist_psx16750:
		PUSH	d1-d4/a0
		moveq	#31,d3			;ID=7 の ch.0～1 フラグのビット位置
		moveq	#0,d4
		lea	(PSX7_IO),a0
		moveq	#0,d1
		moveq	#PSX16570_MAX-1,d2
is_exist_psx16750_loop:
		bsr	check_bus_error_byte
		bne	@f			;未実装
		addq.b	#1,d0
		beq	@f			;PSX16550 だった
		bset	d2,d1
@@:		lea	(PSX0_IO-PSX1_IO,a0),a0
		dbra	d2,is_exist_psx16750_loop

	.if	1
		move	d1,d0			;ID=7 ch.e～f の片割れの
@@:		lsr	#1,d0			;ch.0～1 をマスクする
		bcc	@f
		lsr	#1,d0
		bcs	@b
		bclr	d4,d1			;bclr #0,d1
		beq	@f
		bset	d3,d1			;ch.0～1 が存在する
@@:
	.endif
		moveq	#PSX16570_MAX-1,d2
is_exist_psx16750_loop2:
		ror.b	#1,d1			;ID=n が存在するなら
		bcc	@f			;ID=n+1 を取り消す
		bclr	d4,d1			;bclr #0,d1
@@:		dbra	d2,is_exist_psx16750_loop2

	.if	1
		tst.b	d1
		bmi	@f
		bclr	d3,d1			;ID=7 は存在しないのでフラグもクリア
@@:
	.endif
		move.l	d1,d0
		POP	d1-d4/a0
		rts


*┌────────────────────────────────────────┐
*│				プロセッサ速度					   │
*└────────────────────────────────────────┘

print_processor_pfm:
		bsr	print_wait_message
		bsr	count_processor_speed
		bsr	delete_wait_message

		lea	(proc_title,pc),a0
		lea	(percent_as,pc),a1
		bra	print_performance


*┌────────────────────────────────────────┐
*│				プロセッサ＆I/O速度				   │
*└────────────────────────────────────────┘

* 1秒間のループ回数を計測するが、開始と終了のタイミングを RTC の秒カウンタが
* 変化してから再度変化するまでとしている。しかしこれでは、X680x0 本体の不調で
* RTC が停止している場合に計測を始められず無限ループになってしまう。
*
* この対策として、Timer-C 割り込み処理でカウントダウンされる値で時間経過を監視
* し、2秒間 RTC が変化しなければ計測を取りやめる。
*
* また、この手法で system performance と machine performance を別々に計測する
* と、その間に必ず1秒の待機時間が生じてしまうため、まず machine ～ を計測して
* 終了したらその場で直ちに system ～ の計測を開始することにより待機時間を削減
* している。

print_sys_mac_pfm:
		bsr	print_wait_message
		bsr	count_io_performance
		bsr	delete_wait_message
		tst.l	d0
		bmi	print_sys_mac_pfm_err

		lea	(syspfm_title,pc),a0
		lea	(percent,pc),a1
		exg	d0,d1
		bsr	print_performance

		lea	(machine_title,pc),a0
		move.l	d2,d0
		bra	print_performance
**		rts

print_sys_mac_pfm_err:
		pea	(rtc_stall_mes,pc)
		bsr	print
		addq.l	#4,sp
		rts


* 標準エラー出力に文字列を出力する。
*   LF->CR+LF 変換をしないので、改行する場合は CR+LF を使うこと。
print_stderr:
		move	#STDERR,-(sp)
		move.l	a0,-(sp)
		DOS	_FPUTS
		addq.l	#6,sp
		rts


* "Wait..." を表示する
print_wait_message:
		tst.b	(atty_flag,a6)
		beq	print_wait_mes_end

		PUSH	d0-d2/a0
		moveq	#-1,d1			;表示色保存
		IOCS	_B_COLOR
		move	d0,d2
		moveq	#WAIT_COLOR,d1		;表示色設定
		IOCS	_B_COLOR

		lea	(wait_mes,pc),a0	;"Wait..."表示
		bsr	print_stderr

		move	d2,d1			;表示色復帰
		IOCS	_B_COLOR
		POP	d0-d2/a0
print_wait_mes_end:
		rts

* "Wait..." の表示を取り消す
* (文字自体は消えないが condrv のバックログからは削除される)
delete_wait_message:
		tst.b	(atty_flag,a6)
		beq	@f

		PUSH	d0/a0
		lea	(del_wait_mes,pc),a0
		bsr	print_stderr
		POP	d0/a0
@@:
		rts


* 計測結果を表示する
* in	d0.l	計測値
*	d1.l	基準値
*	a0.l	タイトル
*	a1.l	末尾に表示する文字列
print_performance:
		PUSH	d1-d7/a1
		lea	(-256,sp),sp

		move.l	d0,d7
		move.l	a0,-(sp)
		bsr	print
		addq.l	#4,sp
		move.l	d7,d0

		lea	(sp),a0

	.if	0
		move.l	d0,-(sp)
		move.l	d1,d0			;10MHz無負荷時のループ回数
		FPACK	__LTOD
		move.l	d0,d2
		move.l	d1,d3
		move.l	(sp)+,d0
		moveq	#100,d1
		FPACK	__UMUL
		FPACK	__LTOD
		FPACK	__DDIV			;(n/n0)*100(%)

		moveq	#3,d2			;整数部の桁数
		moveq	#2,d3			;小数部〃
		moveq	#0,d4			;変換オプション
		FPACK	__USING			;"xxx.xx" の形に変換
		STREND	a0
	.else
		moveq	#0,d2
		moveq	#(3+2+1)-1,d3
		bra	@f
print_pfm_loop:
	.irp	dn,d0,d2
		move.l	dn,d4
		lsl.l	#2,dn
		add.l	d4,dn
		add.l	dn,dn			;x10
	.endm
**		addq.l	#5,d0
@@:		addq.l	#1,d2
		sub.l	d1,d0
		bcc	@b
		subq.l	#1,d2
		add.l	d1,d0
		dbra	d3,print_pfm_loop

		move.l	d2,d0
		moveq	#10,d1
		bsr	fe_idiv
		subq.l	#5,d1
		bcs	@f
		addq.l	#1,d0			;小数第三位を四捨五入
@@:
		moveq	#100,d1
		bsr	fe_idiv
		move.l	d1,d2
*		moveq	#3,d1
		moveq	#5,d1
		bsr	fe_iusing		;整数部を最低 5 桁に変換
		move.b	#'.',(a0)+
		divu	#10,d2
		addi.l	#'0'<<16+'0',d2
		move.b	d2,(a0)+		;小数第一位
		swap	d2
		move.b	d2,(a0)+		;    第二位
	.endif
		STRCPY	a1,a0			;"%" or "% as ..."

		bsr	print_stack_buffer
		lea	(256,sp),sp
		POP	d1-d7/a1
		rts


* 速度計測
* out	d0.l	負数:エラー それ以外:10MHz無負荷時のループ回数
*	d1.l	無負荷時(割り込み禁止状態)のループ回数
*	d2.l	有負荷時のループ回数

		.offset	0
~pfm_sr:	.ds	1
~pfm_rtc_mode:	.ds.b	1
		.quad
sizeof_pfm_work:
		.text

PFM_MONITORING_PERIOD:	.equ	2*100	;2秒

count_io_performance:
		PUSH	d4-d7/a0-a2
		link	a5,#-sizeof_pfm_work
		move	sr,d7
		move	d7,(~pfm_sr,a5)
		ori	#SR_I_MASK,d7

		lea	(RTC),a1
		move.b	(~RTC_MODE,a1),(~pfm_rtc_mode,a5)
		bsr	rtc_wait
		move.b	#%1000,(~RTC_MODE,a1)	;bank 0
		bsr	rtc_wait

		moveq	#0,d1
		moveq	#0,d2
		lea	(~RTC_1SEC,a1),a0

* カウンタ最大値($9ca.w) = 60*100
* カウンタ現在地($9cc.w) = 最大値～1
*   (割り込みごとに-1され、0になった瞬間に最大値に戻る)
		lea	(ALMTIMER),a2
		move	#-PFM_MONITORING_PERIOD,d6
		move	(a2),d5
		addq	#1,d5
		cmpi	#PFM_MONITORING_PERIOD,d5
		bcc	@f
		add	(ALMTINIT),d6
@@:
* 秒カウンタと同期をとる
		move.b	(a0),d0
@@:		cmp.b	(a0),d0
		bne	@f

		move	(a2),d4
		sub	d5,d4
		cmp	d6,d4
		bcc	@b		;まだ指定時間経っていない

		moveq	#-1,d0		;RTCの秒カウンタが変化しなかった
		bra	count_io_pfm_end

		.align	16
@@:
* 割り込み許可で計測する
		move.b	(a0),d0		;+0
@@:		addq.l	#1,d2		;+2
		cmp.b	(a0),d0		;+4
		beq	@b		;+6

* 割り込み禁止で計測する
		move	d7,sr		;+8
		bra.s	@f		;+a
		.align	16		;+c +e
@@:
		move.b	(a0),d0		;+0
@@:		addq.l	#1,d1		;+2
		cmp.b	(a0),d0		;+4
		beq	@b		;+6

		move	(~pfm_sr,a5),sr
		move.l	#351472,d0		;実測値
count_io_pfm_end:
		move.b	(~pfm_rtc_mode,a5),(~RTC_MODE,a1)
		unlk	a5
		POP	d4-d7/a0-a2
		rts


rtc_wait:
		nop
		tst.b	(JOYSTICK1)
		nop
		tst.b	(JOYSTICK1)
		nop
		rts


proc_title:	.dc.b	'processor performance	: ',0
syspfm_title:	.dc.b	'system    performance	: ',0
machine_title:	.dc.b	'machine   performance	: ',0
percent_as:	.dc.b	'% as compared with X68000 XVI 10MHz',LF,0
percent:	.dc.b	'%',LF,0

wait_mes:	.dc.b	'Wait...',0

del_wait_mes:	.dcb.b	7,BS
		.dcb.b	7,' '
		.dcb.b	7,BS
		.dc.b	0

rtc_stall_mes:	.dc.b	'RTCが停止しています。',LF,0
		.even


*┌────────────────────────────────────────┐
*│				汎用プリントルーチン				   │
*└────────────────────────────────────────┘

print_lf:
		pea	(lf,pc)
		bra	@f
print:
		move.l	(4,sp),-(sp)
		bra	@f
print_stack_buffer:
		pea	(4,sp)
@@:
		move.l	(sp)+,d0		;文字列のアドレス
		tst.b	(atty_flag,a6)
		bne	print_lf2crlf

* ファイルには LF 改行のまま出力
		PUSH	d1/a0-a1
		movea.l	d0,a0			;文字列のアドレス
print_buf_loop2:
		movea.l	(print_ptr,a6),a1
		move.l	(print_cnt,a6),d1
		subq.l	#1,d1
print_buf_loop:
		move.b	(a0)+,(a1)+
		dbeq	d1,print_buf_loop
		beq	print_buf_nul

		clr.l	(print_cnt,a6)
		bsr	flush_print_buf
		bra	print_buf_loop2
print_buf_nul:
		subq.l	#1,a1			;NUL の分を戻す
		addq.l	#1,d1
		move.l	a1,(print_ptr,a6)
		move.l	d1,(print_cnt,a6)
		POP	d1/a0-a1
		rts


* 端末には CR/LF 改行に変換して出力
print_lf2crlf:
		move.l	a0,-(sp)
		movea.l	d0,a0			;文字列のアドレス
print_lf2crlf_loop:
		pea	(a0)			;次に表示するアドレス
@@:		move.b	(a0)+,d0
		beq	print_lf2crlf_nul
		cmpi.b	#LF,d0
		bne	@b
		clr.b	-(a0)			;LF -> NUL
		cmpa.l	(sp),a0
		beq	@f
		DOS	_PRINT			;LF の手前まで表示
@@:		pea	(cr_and_lf,pc)		;LF を CR/LF に換えて表示
		DOS	_PRINT
		addq.l	#8,sp
		move.b	#LF,(a0)+		;NUL -> LF
		bra	print_lf2crlf_loop
print_lf2crlf_nul:
		subq.l	#1,a0
		cmpa.l	(sp),a0
		beq	@f
		DOS	_PRINT			;末尾を表示
@@:		addq.l	#4,sp
		movea.l	(sp)+,a0
		rts


flush_print_buf:
		move.l	#PRINT_BUF_SIZE,d0
		sub.l	(print_cnt,a6),d0
		beq	@f			;バッファは空

		move.l	d0,-(sp)
		pea	(print_buf,a6)
		move	#STDOUT,-(sp)
		DOS	_WRITE
		lea	(10,sp),sp
@@:
		bra	init_print_buf2


init_print_buf:
		pea	(0<<16+STDOUT)
		DOS	_IOCTRL
		ori	#$7ffd,d0		;キャラクタデバイス && 標準出力デバイス
		not	d0
		move.l	d0,(sp)+
		seq	(atty_flag,a6)
init_print_buf2:
		pea	(print_buf,a6)
		move.l	(sp)+,(print_ptr,a6)
		move.l	#PRINT_BUF_SIZE,(print_cnt,a6)
		rts


*┌────────────────────────────────────────┐
*│				   -f-ms / -f-memf				   │
*└────────────────────────────────────────┘

sw_f_memory_size:
		bsr	get_memory_size
		swap	d0
		lsr	#4,d0			;÷1024K
		bra.s	exit_d0

sw_f_memory_free:
		bsr	get_memory_free_size
		lsr.l	#8,d0
		lsr.l	#2,d0			;÷1024
		bra.s	exit_d0


*┌────────────────────────────────────────┐
*│					-f-cs					   │
*└────────────────────────────────────────┘

sw_f_clock_switch:
		moveq	#%1111_0000,d0
		or.b	(SYS_P6),d0
		not	d0
exit_d0:
		move	d0,-(sp)
		DOS	_EXIT2


*┌────────────────────────────────────────┐
*│					-f-fpu					   │
*└────────────────────────────────────────┘

sw_f_fpu:
		bsr	get_fpu_type
		move.b	(sw_f_fpu_table,pc,d0.w),d0
		bra.s	exit_d0

sw_f_fpu_table:
		.dc.b	0,1,2,1			;ID=0/1 両方あれば ID=0 を返す
		.dc.b	3,3,3,3			;コプロ接続
		.dc.b	4,4,4,4,4,4,4,4		;内蔵
		.even


* FPU/FPCP が存在するか調べる.
* out	d0.l	0:なし 1:あり
*	ccr	<tst.l d0> の結果

is_exist_fpu:
		moveq	#0,d0
		move.b	(mpu_type,a6),d0
		move.b	(@f,pc,d0.w),d0
		jmp	(@f,pc,d0.w)
@@:
		.dc.b	is_exist_fpu_000-@b
		.dc.b	is_exist_fpu_010-@b
		.dc.b	is_exist_fpu_020-@b
		.dc.b	is_exist_fpu_030-@b
		.dc.b	is_exist_fpu_040-@b
		.dc.b	is_exist_fpu_xxx-@b
		.dc.b	is_exist_fpu_060-@b
		.even
is_exist_fpu_000:
is_exist_fpu_010:
is_exist_fpu_xxx:
		moveq	#0,d0
		bra	is_exist_fpu_end
is_exist_fpu_020:
is_exist_fpu_030:
is_exist_fpu_040:
		bsr	is_exist_fpu_sub
		bra	is_exist_fpu_end
is_exist_fpu_060:
		.cpu	68060
		move.l	d1,-(sp)
		movec	pcr,d1
		moveq	#%1111_1101,d0
		and.l	d1,d0			;Disable Floating-Point Unit をオフにする
		movec	d0,pcr
		bsr	is_exist_fpu_sub
		movec	d1,pcr
		move.l	(sp)+,d1
		bra	is_exist_fpu_end
		.cpu	68000
is_exist_fpu_end:
		tst.l	d0
		rts

is_exist_fpu_sub:
		move.l	a0,-(sp)
		PUSH_SR_DI
		move.l	(FLINE_VEC*4),-(sp)
		move.l	(FPU_PROT_VEC*4),-(sp)
		lea	(sp),a0
		pea	(is_exist_fpu_sub_end,pc)
		move.l	(sp),(FPU_PROT_VEC*4)
		move.l	(sp)+,(FLINE_VEC*4)

		moveq	#0,d0
		.cpu	68020
		fnop
		.cpu	68000
		moveq	#1,d0
is_exist_fpu_sub_end:
		lea	(a0),sp
		move.l	(sp)+,(FPU_PROT_VEC*4)
		move.l	(sp)+,(FLINE_VEC*4)
		POP_SR
		movea.l	(sp)+,a0
		rts


*┌────────────────────────────────────────┐
*│					-f-mpu					   │
*└────────────────────────────────────────┘

sw_f_mpu:
		moveq	#0,d0
		move.b	(MPUTYPE),d0		;IOCS ワークの設定値を返す
		bra	exit_d0


* MPU の種類を調べる.
* out	d0.l	0:68000 1:68010 2:68020 3:68030 4:68040 6:68060
*	ccr	<tst.l d0> の結果

get_mpu_type:
		move.l	a0,-(sp)
		PUSH_SR_DI
		move.l	(ILLEGAL_VEC*4),-(sp)
		lea	(sp),a0
		pea	(get_mpu_type_end,pc)
		move.l	(sp),(ILLEGAL_VEC*4)

		moveq	#0,d0
		.cpu	68010
		move	ccr,d0

		moveq	#1,d0
		.cpu	68020
		extb	d0

		moveq	#6,d0
		.cpu	68040
		movec	msp,d0

		moveq	#4,d0
		.cpu	68030
		movec	caar,d0

		moveq	#2,d0
		pmove	tt0,(sp)

		moveq	#3,d0
get_mpu_type_end:
		.cpu	68000
		lea	(a0),sp
		move.l	(sp)+,(ILLEGAL_VEC*4)
		POP_SR
		movea.l	(sp)+,a0
		tst.l	d0
		rts


*┌────────────────────────────────────────┐
*│					-f-mmu					   │
*└────────────────────────────────────────┘

sw_f_mmu:
		cmpi.b	#1,(mpu_type,a6)
		bls	sw_f_mmu_false		;68000/68010

		tst.b	(MMUEXIST)
		bmi	sw_f_mmu_true
sw_f_mmu_false:
		DOS	_EXIT
sw_f_mmu_true:
		move	#1,-(sp)
		DOS	_EXIT2


*┌────────────────────────────────────────┐
*│				       -f-midi					   │
*└────────────────────────────────────────┘

sw_f_midi:
		bsr	is_exist_midi
		bra	exit_d0


* MIDI ボードが存在するか調べる.
* out	d0.l	bit0=1:ID:0 のボードが存在
*		bit1=1:ID:1 〃
*	ccr	<tst.l d0> の結果

is_exist_midi:
		PUSH	d1/a0
		moveq	#0,d1
		lea	(MIDI0_IO),a0
		bsr	check_bus_error_byte
		bne	@f
		addq	#%01,d1
@@:
		lea	(MIDI1_IO-MIDI0_IO,a0),a0
		bsr	check_bus_error_byte
		bne	@f
		addq	#%10,d1
@@:
		move.l	d1,d0
		POP	d1/a0
		rts


*┌────────────────────────────────────────┐
*│				       -f-merc					   │
*└────────────────────────────────────────┘

sw_f_mercury:
		bsr	is_exist_mercury_unit2
		bra	exit_d0


* ～V3.1/V3.5 判別付き Mercury-Unit 存在検査.
* out	d0.l	0:存在しない
*		1:Mercury-Unit ～V3.1
*		2:Mercury-Unit V4(MK-MU1)
*		3:Mercury-Unit V4 with OPN3-L(MK-MU1O)
*		4:Mercury-Unit V3.5
*	ccr	<tst.l d0> の結果
* 仕様:
*	設定が破壊されたり、動作中に実行すると音が乱れる可能性がある.

MERC_NON:	.equ	0
MERC_V3:	.equ	1
MERC_V4:	.equ	2
MERC_V4OPNA:	.equ	3
MERC_V35:	.equ	4

is_exist_mercury_unit2:
		PUSH	d1/a0
		move	sr,-(sp)
		bsr	is_exist_mercury_unit
		tst.b	(opt_m35_flag,a6)
		beq	is_exist_mu2_end
		cmpi	#MERC_V3,d0
		bne	is_exist_mu2_end

		lea	(MU_COMMAND),a0
		tst.b	(MU_STATUS-MU_COMMAND)
		bpl	is_exist_mu2_v35	;既にハーフレートに設定されている

		DI
		and.b	#$7f,(a0)		;ハーフレートにしてみる
		tst.b	(MU_STATUS-MU_COMMAND)
		bmi	is_exist_mu2_end	;変化しなかったら ～V3.1

		tas	(a0)			;元に戻す
is_exist_mu2_v35:
		moveq	#MERC_V35,d0		;ハーフレートに出来れば V3.5
is_exist_mu2_end:
		POP_SR
		POP	d1/a0
		tst.l	d0
		rts


* Mercury-Unit が存在するか調べ、存在するならその種類を返す.
* out	d0.l	0:存在しない
*		1:Mercury-Unit ～V3.5
*		2:Mercury-Unit V4(MK-MU1)
*		3:Mercury-Unit V4 with OPN3-L(MK-MU1O)
*	ccr	<tst.l d0> の結果
* 仕様:
*	V3.5 以下のバージョンは判別しない.

is_exist_mercury_unit:
		PUSH	d1/a0
		moveq	#MERC_NON,d1
		tst.b	(xt30_id3,a6)
		bne	is_exist_mu_end		;Xellent30 が存在すれば MU は無し

		lea	(MU_COMMAND),a0
		bsr	check_bus_error_byte
		bne	is_exist_mu_end

		moveq	#MERC_V3,d1
		lea	(MU_TOP-MU_COMMAND,a0),a0
		bsr	check_bus_error_byte
		beq	is_exist_mu_end		;アクセス出来れば ～V3.5

* V4 の OPNA 無し/有りを判別
		moveq	#MERC_V4,d1
		PUSH_SR_DI
		st	(MU_OPNREG-MU_TOP,a0)
		bsr	rtc_wait
		move.b	(MU_OPNST2-MU_TOP,a0),d0	;ステータスレジスタ 2
		POP_SR
		subq.b	#1,d0
		subq.b	#2,d0			;1～2 なら OPNA 有り
		bcc	is_exist_mu_end

		moveq	#MERC_V4OPNA,d1
is_exist_mu_end:
		move.l	d1,d0
		POP	d1/a0
		rts

*		V3	V4	Xellent30
* $ecc000	○	×	○
* $ecc080	○	○	○
* $ecc100	×	×	○


*┌────────────────────────────────────────┐
*│				       -f-emu					   │
*└────────────────────────────────────────┘

sw_f_emu:
		move	(emu_type,a6),d0
		move.b	(emu_type_conv_table,pc,d0.w),d0
		bra	exit_d0


			;	WINPORT	M-U	SYS_P6	SYS_P7	$ef0000
EMU_REAL:	.equ	0	×	○or×	○	×	○or×
EMU_EX68:	.equ	1	'W'	×	×	×	×
EMU_WINX:	.equ	2	'W'	○	○	×	×
EMU_W030:	.equ	3	'W'	○	○	×	×
EMU_XM6W:	.equ	4	'X'or×	×	○	×	×	(v0.90 未満)
			;	'W'or×	？	○	'6'	？	(v0.90 以降)
EMU_XM6I:	.equ	5	;予約
EMU_WXSE:	.equ	6	'W'	○	○	'S'	×	(v0.71 以降)
EMU_WXCE:	.equ	7	'W'	○	○	'C'	×	(    〃    )

emu_type_conv_table:
		.dc.b	EMU_REAL
		.dc.b	EMU_EX68
		.dc.b	EMU_WINX
		.dc.b	EMU_W030
		.dc.b	EMU_WXSE
		.dc.b	EMU_WXCE
		.dc.b	EMU_XM6W
		.dc.b	EMU_XM6I
		.dc.b	EMU_XM6W	;8 XM6g
		.dc.b	EMU_REAL	;9 XEiJ
		.even


*┌────────────────────────────────────────┐
*│				ＳＣＳＩ接続機器表示				   │
*└────────────────────────────────────────┘

INQBUF_SIZE:	.equ	256

		.offset	0
~scsi_strbuf:	.ds.b	256
~scsi_inqbuf:	.ds.b	INQBUF_SIZE
sizeof_scsi_work:
		.text

print_scsi_info:
		bsr	get_scsi_iocs_level0
		move.l	d0,d7
		bpl	@f

		pea	(no_scsi_mes,pc)
		bsr	print
		addq.l	#4,sp
		bra	flush_and_exit1
@@:
		lea	(-sizeof_scsi_work,sp),sp
		bsr	print_lf

		moveq	#8-1,d5
		TWOSCSI	_S_TW_CHK
		addq.l	#2,d0
		bne	@f
		moveq	#.not.(16-1),d5
		not	d5			;TWOSCSI あり
@@:
		moveq	#0,d4
print_scsi_info_loop:
		lea	(~scsi_strbuf,sp),a0
		lea	(scsi_vendor+2,pc),a1
		move	#'0 ',(a1)
		add.b	d4,(a1)			;ID 番号をセット
		cmpi	#10,d4
		bcs	@f
		move	#'10'-10,(a1)		;二桁で表示
		add	d4,(a1)
@@:
		subq.l	#2,a1
		STRCPY	a1,a0,-1

		move.b	(SRAM_SCSI_ID),d0
		eor.b	d4,d0			;下位 3 ビットが一致すればイニシエータ
		lsl.b	#5,d0			;(TWOSCSI の場合は n と n+8 の二つある)
		beq	print_scsi_info_initiator

		lea	(~scsi_inqbuf,sp),a1
		moveq	#0,d0
		moveq	#INQBUF_SIZE/8-1,d1
@@:		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbra	d1,@b

		lea	(~scsi_inqbuf,sp),a1
		moveq	#5,d3			;とりあえず5バイト読む
		SCSI	_S_INQUIRY
		addq.l	#1,d0
		beq	print_scsi_info_next
		move.b	(4,a1),d3
		beq	no_additional_inquiry
		addq.b	#5,d3			;追加データも読む
		bcc	@f
		st	d3			;一応255バイトまで...
@@:		SCSI	_S_INQUIRY
		addq.l	#1,d0
		beq	print_scsi_info_next
no_additional_inquiry:
		addq.l	#8,a1			;製品名
		clr.b	(28,a1)
		STRCPY	a1,a0,-1

		STRCPY_EOL a0
		bsr	print_stack_buffer

		lea	(~scsi_strbuf,sp),a0
		lea	(scsi_devtype,pc),a1
		STRCPY	a1,a0,-1

		moveq	#0,d0
		move.b	(~scsi_inqbuf+0,sp),d0	;デバイス種別
		cmpi.b	#(pdt_table_end-pdt_table)/2,d0
		bcs	@f
		cmpi.b	#$1f,d0			;$1f	  -> end
		seq	d0			;それ以外 -> end+1
		addi.b	#(pdt_table_end-pdt_table)/2+1,d0
@@:
		add	d0,d0
		lea	(pdt_table,pc),a1
		adda	(a1,d0.w),a1
		STRCPY	a1,a0
		bsr	print_stack_buffer

		lea	(~scsi_strbuf,sp),a0
		lea	(scsi_ansi,pc),a1
		STRCPY	a1,a0,-1

		moveq	#%111,d0
		and.b	(~scsi_inqbuf+2,sp),d0	;ANSI準拠規格
		cmpi.b	#(ansi_table_end-ansi_table)/2,d0
		bcs	@f
		moveq	#-1,d0
@@:		add	d0,d0
		lea	(ansi_table,pc),a1
		adda	(a1,d0.w),a1
		STRCPY	a1,a0
		bsr	print_stack_buffer

		lea	(~scsi_strbuf,sp),a0
		lea	(scsi_media,pc),a1
		STRCPY	a1,a0,-1

		tst.b	(~scsi_inqbuf+1,sp)
		smi	d6
		bpl	scsi_not_rmb

		lea	(media_rmb,pc),a1
		STRCPY	a1,a0,-1
scsi_not_rmb:
		lea	(~scsi_inqbuf,sp),a1
		moveq	#0,d2
		moveq	#8,d3
		SCSI	_S_MODESENSE
		addq.l	#1,d0
		beq	scsi_not_writep
		tst.b	(2,a1)
		bpl	scsi_not_writep

		tst.b	d6
		beq	@f
		bsr	strcpy_slash
@@:
		lea	(media_writep,pc),a1
		STRCPY	a1,a0,-1
		st	d6
scsi_not_writep:
		STRCPY_EOL a0

		tst.b	d6
		beq	@f
		bsr	print_stack_buffer
@@:
		bra	print_scsi_info_next2

print_scsi_info_initiator:
		lea	(vendor_x68000,pc),a1
		moveq	#'3',d0
		move.b	(SYS_P6),d1
		cmpi.b	#$dc,d1
		beq	@f
		cmpi.b	#$ec,d1
		bne	scsi_info_vendor
		moveq	#'2',d0
@@:		move.b	d0,(12,a1)		;X680x0
scsi_info_vendor:
		STRCPY	a1,a0,-1

		move.l	d4,d0
		bsr	is_exist_sxsi
		lea	(_sxsi,pc),a1
		bne	scsi_info_type

		moveq	#1<<3,d0
		and.b	(SRAM_SCSI_ID),d0	;d0.b=0 なら SCSIIN
		tst.l	d5
		bpl	@f

		TWOSCSI	_S_TW_LEVEL
		moveq	#0,d7
		move	d0,d7			;レベル
		swap	d0			;bit0=0 なら SCSIIN
@@:
		lea	(_scsiin,pc),a1
		tst.b	d0
		beq	scsi_info_type		;SCSIIN

		bsr	get_scsiex_product	;SCSIEX はボード名を表示
scsi_info_type:
		STRCPY	a1,a0,-1

		lea	(vendor_end,pc),a1
		STRCPY	a1,a0,-1

		move.l	d7,d0
		bsr	scsi_level_to_str	;レベルを表示する
		STRCPY_EOL a0
		bsr	print_stack_buffer

		lea	(~scsi_strbuf,sp),a0
		lea	(scsi_devtype,pc),a1
		STRCPY	a1,a0,-1
		lea	(pdt_initiator,pc),a1
		STRCPY	a1,a0
		bsr	print_stack_buffer

print_scsi_info_next2:
		bsr	print_lf
print_scsi_info_next:
		addq	#1,d4
		dbra	d5,print_scsi_info_loop

		lea	(sizeof_scsi_work,sp),sp
		bra	flush_and_exit0


* (SCSIボード名) を取得する。
* out	a1.l	ボード名
* 表示幅が7文字しかないので si 3.67 と同じ表示にする。

get_scsiex_product:
		bsr	get_scsiex_type
		lea	(scsiex_product_tbl,pc),a1
		move.b	(a1,d0.w),d0
		adda	d0,a1
		rts



* SCSI IOCS のレベルを収得する.
* in	d0.l	0～7:通常 8～15:TWOSCSI 常駐時に 2nd-port を調べる
* out	d0.l	レベル(-1 なら SCSI なし)

get_scsi_iocs_level0:
		moveq	#0,d0			;存在するか調べるだけの場合
get_scsi_iocs_level:
		PUSH	d1/d4/d7
		move.l	d0,d4

		movem.l	a6/sp,(reg_save,a6)
		pea	(get_scsi_lvl_trap,pc)
		move	#TRAP14_VEC,-(sp)
		DOS	_INTVCS
		addq.l	#6,sp
		move.l	d0,(trap14_save,a6)

		TWOSCSI	_S_TW_CHK
		addq.l	#2,d0
		bne	@f

		TWOSCSI	_S_TW_LEVEL
		andi.l	#$ffff,d0
		bra	get_scsi_lvl_end
@@:
		moveq	#8,d0
		cmp.l	d0,d4
		bcc	get_scsi_lvl_error	;2nd-port は無い

		SCSI	_S_LEVEL
get_scsi_lvl_end:
		move.l	d0,d4

		move.l	(trap14_save,a6),-(sp)
		move	#TRAP14_VEC,-(sp)
		DOS	_INTVCS
		addq.l	#6,sp

		move.l	d4,d0
		POP	d1/d4/d7
		rts
get_scsi_lvl_trap:
		movem.l	(work_top+reg_save,pc),a6/sp
get_scsi_lvl_error:
		moveq	#-1,d0
		bra	get_scsi_lvl_end


* SCSI IOCS のレベル値を文字列化する.
* in	d0.l	SCSI LEVEL
*	a0.l	文字列末尾

scsi_level_to_str:
		move.l	a1,-(sp)
		cmpi.l	#256,d0
		bcc	scsi_level_to_str_long

		move.l	a0,a1
		bsr	decstr
		move.l	a0,d0
		sub.l	a1,d0			;桁数
		sub.l	d0,a0
		sub.l	d0,a1
		exg	a0,a1
		STRCPY	a1,a0,-1		;28 桁にちょうど収まるように...
		bra	scsi_level_to_str_end

scsi_level_to_str_long:
		subq.l	#4,a0			;$100 以上は 16 進で表示する
**		move.b	#'$',(-1,a0)
		swap	d0
		bsr	hexstr_word
scsi_level_to_str_end:
		movea.l	(sp)+,a1
		rts


pdt_table:	.dc	pdt_direct-pdt_table	;$00
		.dc	pdt_sequence-pdt_table	;$01
		.dc	pdt_printer-pdt_table	;$02
		.dc	pdt_processor-pdt_table	;$03
		.dc	pdt_worm-pdt_table	;$04
		.dc	pdt_cdrom-pdt_table	;$05
		.dc	pdt_scanner-pdt_table	;$06
		.dc	pdt_mo-pdt_table	;$07
		.dc	pdt_changer-pdt_table	;$08
		.dc	pdt_com-pdt_table	;$09
		.dc	pdt_it8-pdt_table	;$0a
		.dc	pdt_it8-pdt_table	;$0b
		.dc	pdt_array-pdt_table	;$0c
		.dc	pdt_enc-pdt_table	;$0d
		.dc	pdt_simpl-pdt_table	;$0e
		.dc	pdt_card-pdt_table	;$0f
**		.dc	pdt_mini-pdt_table	;$10
		.dc	pdt_bridge-pdt_table	;$10
pdt_table_end:
		.dc	pdt_nodev-pdt_table	;$1f
		.dc	pdt_unknown-pdt_table	;上記以外

		.dc	ansi_unknown-ansi_table
ansi_table:	.dc	ansi_scsi0-ansi_table	;%000
		.dc	ansi_scsi1-ansi_table	;%001
		.dc	ansi_scsi2-ansi_table	;%010
		.dc	ansi_scsi3-ansi_table	;%011
		.dc	ansi_spc2-ansi_table	;%100
ansi_table_end:

		.even
scsi_vendor:	.dc.b	'ID0 : Vendor Unique Parameter : ',0
scsi_devtype:	.dc.b	'      Peripheral Device Type  : ',0
scsi_ansi:	.dc.b	'      ANSI-Approved Version   : ',0
scsi_media:	.dc.b	'      Medium Type             : ',0

vendor_x68000:	.dc.b	'SHARP   X68000 ',0

* Scsiex_GetType -> '(ボード名)' 変換テーブル
scsiex_product_tbl:
@@:		.dc.b	_scsiex-@b
		.dc.b	_scsiex-@b
		.dc.b	_scsiex-@b
		.dc.b	_cz6bs1-@b
		.dc.b	_sx68sc-@b
		.dc.b	_ts6bsi-@b
		.dc.b	_ts6bsi-@b
		.dc.b	_ts6bsi-@b
		.dc.b	_ts6bsi-@b
		.dc.b	_mach2-@b
		.dc.b	_mach2p-@b
		.dc.b	_cz6bs1-@b
		.dc.b	_cz6bs1-@b
		.dc.b	_cz6bs1-@b

_sxsi:		.dc.b	'(SxSI)   ',0
_scsiin:	.dc.b	'(SCSIIN) ',0
_scsiex:	.dc.b	'(SCSIEX) ',0
_cz6bs1:	.dc.b	'(CZ-6BS1)',0
_sx68sc:	.dc.b	'(SX-68SC)',0
_ts6bsi:	.dc.b	'(TS-6BS1)',0
_mach2:		.dc.b	'(Mach-2) ',0
_mach2p:	.dc.b	'(mach2p) ',0
vendor_end:	.dc.b	'    ',0

pdt_initiator:	.dc.b	'Initiator',LF,0
pdt_unknown:
ansi_unknown:	.dc.b	'unknown',LF,0

pdt_direct:	.dc.b	'Direct-access device',LF,0
pdt_sequence:	.dc.b	'Sequential-access device',LF,0
pdt_printer:	.dc.b	'Printer device',LF,0
pdt_processor:	.dc.b	'Processor device',LF,0
pdt_worm:	.dc.b	'Write-once device',LF,0
pdt_cdrom:	.dc.b	'CD-ROM device',LF,0
pdt_scanner:	.dc.b	'Scanner device',LF,0
pdt_mo:		.dc.b	'Optical memory device',LF,0
pdt_changer:	.dc.b	'Medium changer device',LF,0
pdt_com:	.dc.b	'Communications device',LF,0
pdt_it8:	.dc.b	'Defined by ASC IT8',LF,0
pdt_array:	.dc.b	'Array controller device',LF,0
pdt_enc:	.dc.b	'Enclosure services device',LF,0
pdt_simpl:	.dc.b	'Simplified Direct Access',LF,0
pdt_card:	.dc.b	'Optical Card Device',LF,0
**pdt_mini:	.dc.b	'MiniDisc',LF,0
pdt_bridge:	.dc.b	'Bridge Expander Device',LF,0
pdt_nodev:	.dc.b	'Unknown or no device type',LF,0

*ansi_scsi0:	.dc.b	'Non ANSI',LF,0
*ansi_scsi1:	.dc.b	'ANSI X3.131-1986   (SCSI-1)',LF,0
*ansi_scsi2:	.dc.b	'ANSI X3T9.2/86-109 (SCSI-2)',LF,0
ansi_scsi0:	.dc.b	'Not ANSI',LF,0
ansi_scsi1:	.dc.b	'SCSI-1 ANSI X3.131-1986',LF,0
ansi_scsi2:	.dc.b	'SCSI-2 ANSI X3.131-1994',LF,0
ansi_scsi3:	.dc.b	'SCSI-3 ANSI X3.301-1997 SPC Rev.11',LF,0
ansi_spc2:	.dc.b	'SPC-2 T10/1236-D SPC-2',LF,0

media_rmb:	.dc.b	'Removable Device',0
media_writep:	.dc.b	'Write Protection',0

no_scsi_mes:	.dc.b	'SCSI is not installed.',LF,0
		.even


*┌────────────────────────────────────────┐
*│				   割り込みチェック				   │
*└────────────────────────────────────────┘

print_interrupt:
		lea	(-256,sp),sp
		lea	(MFP),a3

		bsr	print_int_timer_a
		bsr	print_int_timer_b
		bsr	print_int_timer_c
		bsr	print_int_timer_d
		bsr	print_int_vdisp
		bsr	print_int_hsync
		bsr	print_int_raster
		bsr	print_int_opm
		bsr	print_int_alarm
		bsr	print_int_expon
		bsr	print_int_powsw
		bsr	print_int_printer
		bsr	print_int_spurious

		lea	(256,sp),sp
		bra	flush_and_exit0

;MFP IERA/IMRA
print_int_timer_a:
		lea	(int_timer_a,pc),a0
		bra	print_int_mfp_a
print_int_timer_b:
		lea	(int_timer_b,pc),a0
		bra	print_int_mfp_a
print_int_hsync:
		lea	(int_hsync,pc),a0
		bra	print_int_mfp_a
print_int_raster:
		lea	(int_raster,pc),a0
		bra	print_int_mfp_a
print_int_mfp_a:
		move.b	(a0)+,d0
		and.b	(~MFP_IERA,a3),d0
		and.b	(~MFP_IMRA,a3),d0
		bra	print_int_en_dis

;MFP IERB/IMRB
print_int_timer_c:
		lea	(int_timer_c,pc),a0
		bra	print_int_mfp_b
print_int_timer_d:
		lea	(int_timer_d,pc),a0
		bra	print_int_mfp_b
print_int_vdisp:
		lea	(int_vdisp,pc),a0
		bra	print_int_mfp_b
print_int_opm:
		lea	(int_opm,pc),a0
		bra	print_int_mfp_b
print_int_alarm:
		lea	(int_alarm,pc),a0
		bra	print_int_mfp_b
print_int_expon:
		lea	(int_expon,pc),a0
		bra	print_int_mfp_b
print_int_powsw:
		lea	(int_powsw,pc),a0
		bra	print_int_mfp_b
print_int_mfp_b:
		move.b	(a0)+,d0
		and.b	(~MFP_IERB,a3),d0
		and.b	(~MFP_IMRB,a3),d0
		bra	print_int_en_dis

print_int_en_dis:
		lea	(int_enable,pc),a1
		bne	print_int_sub
		lea	(int_disable,pc),a1
print_int_sub:
		moveq	#0,d0
		move.b	(a0)+,d0

		lea	(4,sp),a2
		STRCPY	a0,a2,-1		;割り込み名称
		STRCPY	a1,a2,-1		;許可/禁止

		lea	(lf,pc),a0
		lsl	#2,d0
		beq	@f			;IOCSで割り込み設定できない種類
		movea.l	d0,a0
		tst.b	(a0)			;処理アドレスの上位1バイト
		lea	(int_can_hook,pc),a0
		bne	@f			;!=0なら割り込み設定可能
		lea	(int_cant_hook,pc),a0	;==0なら不可能
@@:		STRCPY	a0,a2

		bra	print_stack_buffer	;(4,sp) = buffer
*		rts				;bsrだと(8,sp)になるので不可

;その他
print_int_printer:
		lea	(int_printer,pc),a0
		btst	#0,(IOC_STATUS)
		bra	print_int_en_dis

print_int_spurious:
		movea.l	(SPURIOUS_VEC*4),a0
		bsr	check_bus_error_word
		lea	(int_spurious,pc),a0
		lea	(spr_notmask,pc),a1
		bne	@f
		cmpi	#RTE_CODE,d0
		bne	@f
		lea	(spr_mask,pc),a1	;rteで無効化されている
@@:		bra	print_int_sub


int_timer_a:	.dc.b	1<<5,TIMERA_VEC	,'Timer-A		 :	',0
int_timer_b:	.dc.b	1<<0,0		,'Timer-B		 :	',0
int_timer_c:	.dc.b	1<<5,0		,'Timer-C		 :	',0
int_timer_d:	.dc.b	1<<4,TIMERD_VEC	,'Timer-D		 :	',0
int_vdisp:	.dc.b	1<<6,0		,'V-DISP		 :	',0
int_hsync:	.dc.b	1<<7,HSYNC_VEC	,'H-SYNC		 :	',0
int_raster:	.dc.b	1<<6,CRTCRAS_VEC,'Raster		 :	',0
int_opm:	.dc.b	1<<3,OPMINT_VEC	,'OPM		 :	',0
int_alarm:	.dc.b	1<<0,0		,'Alarm		 :	',0
int_expon:	.dc.b	1<<1,0		,'EXPON		 :	',0
int_powsw:	.dc.b	1<<2,0		,'Power Switch	 :	',0
int_printer:	.dc.b	    PRNREADY_VEC,'Printer		 :	',0
int_spurious:	.dc.b	     0		,'Spurious	 :	',0
int_enable:	.dc.b	'enable',0
int_disable:	.dc.b	'disable',0
spr_mask:	.dc.b	'masked',0
spr_notmask:	.dc.b	'not masked',0
int_can_hook:	.dc.b	' (can hook)',LF,0
int_cant_hook:	.dc.b	' (cannot hook)',LF,0
		.even


* 使用法表示 ---------------------------------- *

print_version:
		pea	(version_mes,pc)
		bra	@f
print_license:
		pea	(license_mes,pc)
		bra	@f
print_long_help:
		pea	(title_mes,pc)
		bsr	print
		pea	(usage_mes,pc)
		bsr	print
		addq.l	#8,sp
		pea	(switch_mes,pc)
@@:		bsr	print
		addq.l	#4,sp
		bra	flush_and_exit0

print_short_help:
		pea	(usage_mes,pc)
		bsr	print
		addq.l	#4,sp
		bra	flush_and_exit1

setblock_error:
		lea	(memory_err_mes,pc),a0
		bsr	print_stderr
		move	#1,-(sp)
		DOS	_EXIT2


* Data Section -------------------------------- *

		.data
		.even

option_f_table1:
		.dc.b	'cs',0			;長いオプションを追加した時は
		.dc.b	'emu',0			;LONG_OPT_MAXも変更すること
		.dc.b	'fpu',0
*		.dc.b	'himemf',0
*		.dc.b	'hims',0
		.dc.b	'memf',0
		.dc.b	'merc',0
		.dc.b	'midi',0
		.dc.b	'mmu',0
		.dc.b	'mpu',0
		.dc.b	'ms',0
		.dc.b	0
		.even
option_f_table2:
		.dc	sw_f_clock_switch-$
		.dc	sw_f_emu-$
		.dc	sw_f_fpu-$
*		.dc	sw_f_himemf-$
*		.dc	sw_f_hims-$
		.dc	sw_f_memory_free-$
		.dc	sw_f_mercury-$
		.dc	sw_f_midi-$
		.dc	sw_f_mmu-$
		.dc	sw_f_mpu-$
		.dc	sw_f_memory_size-$

long_opt_table1:
		.dc.b	'all',0			;長いオプションを追加した時は
		.dc.b	'board',0		;LONG_OPT_MAX も変更すること
		.dc.b	'cut',0
		.dc.b	'expose',0
		.dc.b	'help',0
		.dc.b	'int',0
		.dc.b	'm35',0
		.dc.b	'power',0
		.dc.b	'scsi',0
		.dc.b	'version',0
		.dc.b	'license',0
		.dc.b	0
		.even
long_opt_table2:
		.dc	option_all-$
		.dc	option_board-$
		.dc	option_cut-$
		.dc	option_expose-$
		.dc	print_long_help-$
		.dc	print_interrupt-$
		.dc	option_m35-$
		.dc	option_power-$
		.dc	print_scsi_info-$
		.dc	print_version-$
		.dc	print_license-$


* 文字列データ -------------------------------- *

license_mes:
		.dc.b	LF
		.dc.b	' System Information (Si)',LF
		.dc.b	' Modified Version ',SIEE_VERSION,LF
		.dc.b	LF
		.dc.b	'Copyright (C)1992-1993  Misao.Satake',LF
		.dc.b	'Copyright (C)1993-1997  Tatsuya.Tsuyuzaki',LF
		.dc.b	'Copyright (C)1997/09/13 Arisugawa Seara',LF
		.dc.b	'Copyright (C)1999-2022  TcbnErik',LF
		.dc.b	LF
		.dc.b	0

title_mes:
		.dc.b	LF
		.dc.b	'X680x0 '
version_mes:
		.dc.b	'System Information Extended Edition version ',SIEE_VERSION
		.dc.b	LF,0

usage_mes:
		.dc.b	'usage : si [-a,-c,-e,-i,-m,-p,-s,'
		.dc.b		'-f-(cs,emu,fpu,memf,merc,midi,mmu,mpu,ms)]',LF
		.dc.b	0

switch_mes:
		.dc.b	'switch:',LF
		.dc.b	'	-a  --all	all device',LF
		.dc.b	'	-b  --board	I/O board only',LF
		.dc.b	'	-c  --cut	cut benchmark',LF
		.dc.b	'	-e  --expose	expose private data (MAC address)',LF
		.dc.b	'	-i  --int	check interrupt',LF
		.dc.b	'	-m  --m35	check Mercury-Unit v3.5',LF
		.dc.b	'	-p  --power	benchmark only',LF
		.dc.b	'	-s  --scsi	SCSI check',LF
		.dc.b	'	-l  --license	print license',LF
		.dc.b	'	-v  --version	print version',LF
		.dc.b	'	-h  --help	print help',LF
		.dc.b	LF
		.dc.b	'	-f-cs		Clock Switch',LF
		.dc.b	'	-f-emu		Emulator',LF
		.dc.b	'	-f-fpu		Floating Point Unit',LF
		.dc.b	'	-f-memf		Free Area (K bytes)',LF
		.dc.b	'	-f-merc		Mercury-Unit',LF
		.dc.b	'	-f-midi		MIDI',LF
		.dc.b	'	-f-mmu		Memory Management Unit',LF
		.dc.b	'	-f-mpu		Micro Processing Unit',LF
		.dc.b	'	-f-ms		Memory Size (M bytes)',LF
		.dc.b	LF,0

memory_err_mes:	.dc.b	'si: setblock failed.'
cr_and_lf:	.dc.b	CR			;必ず CR + LF
lf:		.dc.b	LF,0


* Block Storage Section ----------------------- *

		.bss
		.quad
work_top:


		.end	si_start

* End of File --------------------------------- *
