	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/ffs-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load	$1=, ffstesttab($0)
	i32.wrap/i64	$2=, $1
	i32.const	$3=, 1
	i64.const	$4=, 32
	block   	.LBB0_9
	i32.ctz 	$push0=, $2
	i32.add 	$push1=, $pop0, $3
	i32.select	$push2=, $2, $pop1, $0
	i64.shr_u	$push3=, $1, $4
	i32.wrap/i64	$push4=, $pop3
	i32.ne  	$push5=, $pop2, $pop4
	br_if   	$pop5, .LBB0_9
# BB#1:                                 # %for.cond
	i64.load	$1=, ffstesttab+8($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push6=, $2
	i32.add 	$push7=, $pop6, $3
	i32.select	$push8=, $2, $pop7, $0
	i64.shr_u	$push9=, $1, $4
	i32.wrap/i64	$push10=, $pop9
	i32.ne  	$push11=, $pop8, $pop10
	br_if   	$pop11, .LBB0_9
# BB#2:                                 # %for.cond.1
	i64.load	$1=, ffstesttab+16($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push12=, $2
	i32.add 	$push13=, $pop12, $3
	i32.select	$push14=, $2, $pop13, $0
	i64.shr_u	$push15=, $1, $4
	i32.wrap/i64	$push16=, $pop15
	i32.ne  	$push17=, $pop14, $pop16
	br_if   	$pop17, .LBB0_9
# BB#3:                                 # %for.cond.2
	i64.load	$1=, ffstesttab+24($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push18=, $2
	i32.add 	$push19=, $pop18, $3
	i32.select	$push20=, $2, $pop19, $0
	i64.shr_u	$push21=, $1, $4
	i32.wrap/i64	$push22=, $pop21
	i32.ne  	$push23=, $pop20, $pop22
	br_if   	$pop23, .LBB0_9
# BB#4:                                 # %for.cond.3
	i64.load	$1=, ffstesttab+32($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push24=, $2
	i32.add 	$push25=, $pop24, $3
	i32.select	$push26=, $2, $pop25, $0
	i64.shr_u	$push27=, $1, $4
	i32.wrap/i64	$push28=, $pop27
	i32.ne  	$push29=, $pop26, $pop28
	br_if   	$pop29, .LBB0_9
# BB#5:                                 # %for.cond.4
	i64.load	$1=, ffstesttab+40($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push30=, $2
	i32.add 	$push31=, $pop30, $3
	i32.select	$push32=, $2, $pop31, $0
	i64.shr_u	$push33=, $1, $4
	i32.wrap/i64	$push34=, $pop33
	i32.ne  	$push35=, $pop32, $pop34
	br_if   	$pop35, .LBB0_9
# BB#6:                                 # %for.cond.5
	i64.load	$1=, ffstesttab+48($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push36=, $2
	i32.add 	$push37=, $pop36, $3
	i32.select	$push38=, $2, $pop37, $0
	i64.shr_u	$push39=, $1, $4
	i32.wrap/i64	$push40=, $pop39
	i32.ne  	$push41=, $pop38, $pop40
	br_if   	$pop41, .LBB0_9
# BB#7:                                 # %for.cond.6
	i64.load	$1=, ffstesttab+56($0)
	i32.wrap/i64	$2=, $1
	i32.ctz 	$push42=, $2
	i32.add 	$push43=, $pop42, $3
	i32.select	$push44=, $2, $pop43, $0
	i64.shr_u	$push45=, $1, $4
	i32.wrap/i64	$push46=, $pop45
	i32.ne  	$push47=, $pop44, $pop46
	br_if   	$pop47, .LBB0_9
# BB#8:                                 # %for.cond.7
	call    	exit, $0
	unreachable
.LBB0_9:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	ffstesttab,@object      # @ffstesttab
	.data
	.globl	ffstesttab
	.align	4
ffstesttab:
	.int32	2147483648              # 0x80000000
	.int32	32                      # 0x20
	.int32	2779096485              # 0xa5a5a5a5
	.int32	1                       # 0x1
	.int32	1515870810              # 0x5a5a5a5a
	.int32	2                       # 0x2
	.int32	3405643776              # 0xcafe0000
	.int32	18                      # 0x12
	.int32	32768                   # 0x8000
	.int32	16                      # 0x10
	.int32	42405                   # 0xa5a5
	.int32	1                       # 0x1
	.int32	23130                   # 0x5a5a
	.int32	2                       # 0x2
	.int32	3232                    # 0xca0
	.int32	6                       # 0x6
	.size	ffstesttab, 64


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
