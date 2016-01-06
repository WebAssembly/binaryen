	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/divconst-2.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2147483648
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
func_end0:
	.size	f, func_end0-f

	.globl	r
	.type	r,@function
r:                                      # @r
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 31
	i32.const	$push5=, 0
	i32.shr_s	$push0=, $0, $1
	i32.const	$push1=, 1
	i32.shr_u	$push2=, $pop0, $pop1
	i32.add 	$push3=, $0, $pop2
	i32.shr_u	$push4=, $pop3, $1
	i32.sub 	$push6=, $pop5, $pop4
	i32.shl 	$push7=, $pop6, $1
	i32.sub 	$push8=, $0, $pop7
	return  	$pop8
func_end1:
	.size	r, func_end1-r

	.globl	std_eqn
	.type	std_eqn,@function
std_eqn:                                # @std_eqn
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shl 	$push1=, $2, $pop0
	i32.add 	$push2=, $pop1, $3
	i32.eq  	$push3=, $pop2, $0
	return  	$pop3
func_end2:
	.size	std_eqn, func_end2-std_eqn

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, nums($0)
	i32.const	$3=, 31
	i32.const	$4=, 1
	i32.const	$2=, -2147483648
	block   	BB3_4
	i32.eq  	$push0=, $1, $2
	i32.shl 	$push8=, $pop0, $3
	i32.shr_s	$push1=, $1, $3
	i32.shr_u	$push2=, $pop1, $4
	i32.add 	$push3=, $1, $pop2
	i32.shr_u	$push4=, $pop3, $3
	i32.sub 	$push5=, $0, $pop4
	i32.shl 	$push6=, $pop5, $3
	i32.sub 	$push7=, $1, $pop6
	i32.add 	$push9=, $pop8, $pop7
	i32.ne  	$push10=, $pop9, $1
	br_if   	$pop10, BB3_4
# BB#1:                                 # %for.cond
	i32.load	$1=, nums+4($0)
	i32.eq  	$push11=, $1, $2
	i32.shl 	$push19=, $pop11, $3
	i32.shr_s	$push12=, $1, $3
	i32.shr_u	$push13=, $pop12, $4
	i32.add 	$push14=, $1, $pop13
	i32.shr_u	$push15=, $pop14, $3
	i32.sub 	$push16=, $0, $pop15
	i32.shl 	$push17=, $pop16, $3
	i32.sub 	$push18=, $1, $pop17
	i32.add 	$push20=, $pop19, $pop18
	i32.ne  	$push21=, $pop20, $1
	br_if   	$pop21, BB3_4
# BB#2:                                 # %for.cond.1
	i32.load	$1=, nums+8($0)
	i32.eq  	$push22=, $1, $2
	i32.shl 	$push30=, $pop22, $3
	i32.shr_s	$push23=, $1, $3
	i32.shr_u	$push24=, $pop23, $4
	i32.add 	$push25=, $1, $pop24
	i32.shr_u	$push26=, $pop25, $3
	i32.sub 	$push27=, $0, $pop26
	i32.shl 	$push28=, $pop27, $3
	i32.sub 	$push29=, $1, $pop28
	i32.add 	$push31=, $pop30, $pop29
	i32.ne  	$push32=, $pop31, $1
	br_if   	$pop32, BB3_4
# BB#3:                                 # %for.cond.2
	call    	exit, $0
	unreachable
BB3_4:                                  # %if.then
	call    	abort
	unreachable
func_end3:
	.size	main, func_end3-main

	.type	nums,@object            # @nums
	.data
	.globl	nums
	.align	2
nums:
	.int32	4294967295              # 0xffffffff
	.int32	2147483647              # 0x7fffffff
	.int32	2147483648              # 0x80000000
	.size	nums, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
