	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49039.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	block   	BB0_6
	i32.eq  	$push0=, $0, $3
	br_if   	$pop0, BB0_6
# BB#1:                                 # %entry
	i32.const	$4=, -2
	i32.eq  	$push1=, $1, $4
	br_if   	$pop1, BB0_6
# BB#2:                                 # %if.end
	block   	BB0_4
	i32.gt_u	$push4=, $0, $1
	i32.select	$2=, $pop4, $0, $1
	i32.lt_u	$push2=, $0, $1
	i32.select	$push3=, $pop2, $0, $1
	i32.ne  	$push5=, $pop3, $3
	br_if   	$pop5, BB0_4
# BB#3:                                 # %if.then9
	i32.const	$0=, 0
	i32.load	$push6=, cnt($0)
	i32.add 	$push7=, $pop6, $3
	i32.store	$discard=, cnt($0), $pop7
BB0_4:                                  # %if.end10
	i32.ne  	$push8=, $2, $4
	br_if   	$pop8, BB0_6
# BB#5:                                 # %if.then12
	i32.const	$0=, 0
	i32.load	$push9=, cnt($0)
	i32.add 	$push10=, $pop9, $3
	i32.store	$discard=, cnt($0), $pop10
BB0_6:                                  # %cleanup
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, -2
	i32.const	$push0=, 1
	call    	foo, $pop1, $pop0
	i32.const	$0=, 0
	block   	BB1_2
	i32.load	$push2=, cnt($0)
	i32.const	$push3=, 2
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %if.end
	return  	$0
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	cnt,@object             # @cnt
	.bss
	.globl	cnt
	.align	2
cnt:
	.int32	0                       # 0x0
	.size	cnt, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
