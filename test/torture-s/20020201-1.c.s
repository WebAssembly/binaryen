	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020201-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load8_u	$0=, cx($2)
	i32.const	$3=, 255
	i32.const	$4=, 6
	block   	BB0_2
	i32.const	$push0=, -6
	i32.add 	$push1=, $0, $pop0
	i32.and 	$push2=, $pop1, $3
	i32.lt_u	$push3=, $pop2, $4
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB0_2:                                  # %if.end
	block   	BB0_20
	i32.and 	$push4=, $0, $3
	i32.rem_u	$push5=, $pop4, $4
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, BB0_20
# BB#3:                                 # %if.end10
	i32.load16_u	$0=, sx($2)
	i32.const	$3=, 65535
	block   	BB0_5
	i32.const	$push8=, -12
	i32.add 	$push9=, $0, $pop8
	i32.and 	$push10=, $pop9, $3
	i32.lt_u	$push11=, $pop10, $4
	br_if   	$pop11, BB0_5
# BB#4:                                 # %if.then17
	call    	abort
	unreachable
BB0_5:                                  # %if.end18
	block   	BB0_19
	i32.and 	$push12=, $0, $3
	i32.rem_u	$push13=, $pop12, $4
	i32.const	$push14=, 2
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, BB0_19
# BB#6:                                 # %if.end26
	i32.load	$0=, ix($2)
	block   	BB0_8
	i32.const	$push16=, -18
	i32.add 	$push17=, $0, $pop16
	i32.lt_u	$push18=, $pop17, $4
	br_if   	$pop18, BB0_8
# BB#7:                                 # %if.then30
	call    	abort
	unreachable
BB0_8:                                  # %if.end31
	block   	BB0_18
	i32.rem_u	$push19=, $0, $4
	i32.const	$push20=, 3
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	$pop21, BB0_18
# BB#9:                                 # %if.end36
	i32.load	$0=, lx($2)
	block   	BB0_11
	i32.const	$push22=, -24
	i32.add 	$push23=, $0, $pop22
	i32.lt_u	$push24=, $pop23, $4
	br_if   	$pop24, BB0_11
# BB#10:                                # %if.then40
	call    	abort
	unreachable
BB0_11:                                 # %if.end41
	block   	BB0_17
	i32.rem_u	$push25=, $0, $4
	i32.const	$push26=, 4
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, BB0_17
# BB#12:                                # %if.end46
	i64.load	$1=, Lx($2)
	i64.const	$5=, 6
	block   	BB0_14
	i64.const	$push28=, -30
	i64.add 	$push29=, $1, $pop28
	i64.lt_u	$push30=, $pop29, $5
	br_if   	$pop30, BB0_14
# BB#13:                                # %if.then50
	call    	abort
	unreachable
BB0_14:                                 # %if.end51
	block   	BB0_16
	i64.rem_u	$push31=, $1, $5
	i64.const	$push32=, 5
	i64.ne  	$push33=, $pop31, $pop32
	br_if   	$pop33, BB0_16
# BB#15:                                # %if.end56
	call    	exit, $2
	unreachable
BB0_16:                                 # %if.then55
	call    	abort
	unreachable
BB0_17:                                 # %if.then45
	call    	abort
	unreachable
BB0_18:                                 # %if.then35
	call    	abort
	unreachable
BB0_19:                                 # %if.then25
	call    	abort
	unreachable
BB0_20:                                 # %if.then9
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	cx,@object              # @cx
	.data
	.globl	cx
cx:
	.int8	7                       # 0x7
	.size	cx, 1

	.type	sx,@object              # @sx
	.globl	sx
	.align	1
sx:
	.int16	14                      # 0xe
	.size	sx, 2

	.type	ix,@object              # @ix
	.globl	ix
	.align	2
ix:
	.int32	21                      # 0x15
	.size	ix, 4

	.type	lx,@object              # @lx
	.globl	lx
	.align	2
lx:
	.int32	28                      # 0x1c
	.size	lx, 4

	.type	Lx,@object              # @Lx
	.globl	Lx
	.align	3
Lx:
	.int64	35                      # 0x23
	.size	Lx, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
