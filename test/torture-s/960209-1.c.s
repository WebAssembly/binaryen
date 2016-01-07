	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960209-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB0_2
	i32.const	$push1=, -1
	i32.select	$1=, $1, $pop1, $2
	i32.load	$push0=, yabba($2)
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %if.end24
	i32.const	$push4=, an_array
	i32.const	$push2=, 255
	i32.and 	$push3=, $0, $pop2
	i32.add 	$push5=, $pop4, $pop3
	i32.store	$discard=, a_ptr($2), $pop5
.LBB0_2:                                  # %cleanup
	return  	$1
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load	$push0=, yabba($0)
	br_if   	$pop0, .LBB1_2
# BB#1:                                 # %if.end24.i
	i32.const	$push1=, an_array+1
	i32.store	$discard=, a_ptr($0), $pop1
.LBB1_2:                                  # %if.end
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	yabba,@object           # @yabba
	.data
	.globl	yabba
	.align	2
yabba:
	.int32	1                       # 0x1
	.size	yabba, 4

	.type	an_array,@object        # @an_array
	.bss
	.globl	an_array
an_array:
	.zero	5
	.size	an_array, 5

	.type	a_ptr,@object           # @a_ptr
	.globl	a_ptr
	.align	2
a_ptr:
	.int32	0
	.size	a_ptr, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
