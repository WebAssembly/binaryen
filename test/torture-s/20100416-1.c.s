	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100416-1.c"
	.globl	movegt
	.type	movegt,@function
movegt:                                 # @movegt
	.param  	i32, i32, i64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.gt_s	$push0=, $1, $3
	i64.const	$push1=, -1152921504606846977
	i64.gt_s	$push2=, $2, $pop1
	i32.select	$push3=, $pop2, $0, $1
	i32.select	$push4=, $pop0, $pop3, $3
	return  	$pop4
.Lfunc_end0:
	.size	movegt, .Lfunc_end0-movegt

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.const	$1=, -1152921504606846977
	i32.const	$2=, 1
	i32.const	$3=, -1
	block   	.LBB1_6
	i64.load	$push0=, tests($0)
	i64.gt_s	$push1=, $pop0, $1
	i32.select	$push2=, $pop1, $3, $2
	i32.load	$push3=, tests+8($0)
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB1_6
# BB#1:                                 # %for.cond
	i64.load	$push5=, tests+16($0)
	i64.gt_s	$push6=, $pop5, $1
	i32.select	$push7=, $pop6, $3, $2
	i32.load	$push8=, tests+24($0)
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, .LBB1_6
# BB#2:                                 # %for.cond.1
	i64.load	$push10=, tests+32($0)
	i64.gt_s	$push11=, $pop10, $1
	i32.select	$push12=, $pop11, $3, $2
	i32.load	$push13=, tests+40($0)
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, .LBB1_6
# BB#3:                                 # %for.cond.2
	i64.load	$push15=, tests+48($0)
	i64.gt_s	$push16=, $pop15, $1
	i32.select	$push17=, $pop16, $3, $2
	i32.load	$push18=, tests+56($0)
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	$pop19, .LBB1_6
# BB#4:                                 # %for.cond.3
	i64.load	$push20=, tests+64($0)
	i64.gt_s	$push21=, $pop20, $1
	i32.select	$push22=, $pop21, $3, $2
	i32.load	$push23=, tests+72($0)
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, .LBB1_6
# BB#5:                                 # %for.cond.4
	return  	$0
.LBB1_6:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	tests,@object           # @tests
	.data
	.globl	tests
	.align	4
tests:
	.int64	-1152921504606846976    # 0xf000000000000000
	.int32	4294967295              # 0xffffffff
	.zero	4
	.int64	-1152921504606846977    # 0xefffffffffffffff
	.int32	1                       # 0x1
	.zero	4
	.int64	-1152921504606846975    # 0xf000000000000001
	.int32	4294967295              # 0xffffffff
	.zero	4
	.int64	0                       # 0x0
	.int32	4294967295              # 0xffffffff
	.zero	4
	.int64	-9223372036854775808    # 0x8000000000000000
	.int32	1                       # 0x1
	.zero	4
	.size	tests, 80


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
