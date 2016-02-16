	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/divconst-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2147483648
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.r,"ax",@progbits
	.hidden	r
	.globl	r
	.type	r,@function
r:                                      # @r
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push0=, 31
	i32.shr_s	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $0, $pop3
	i32.const	$push11=, 31
	i32.shr_u	$push5=, $pop4, $pop11
	i32.sub 	$push7=, $pop6, $pop5
	i32.const	$push10=, 31
	i32.shl 	$push8=, $pop7, $pop10
	i32.sub 	$push9=, $0, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end1:
	.size	r, .Lfunc_end1-r

	.section	.text.std_eqn,"ax",@progbits
	.hidden	std_eqn
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
	.endfunc
.Lfunc_end2:
	.size	std_eqn, .Lfunc_end2-std_eqn

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push45=, 0
	i32.load	$push44=, nums($pop45)
	tee_local	$push43=, $0=, $pop44
	i32.const	$push42=, -2147483648
	i32.eq  	$push0=, $pop43, $pop42
	i32.const	$push41=, 31
	i32.shl 	$push8=, $pop0, $pop41
	i32.const	$push40=, 0
	i32.const	$push39=, 31
	i32.shr_s	$push1=, $0, $pop39
	i32.const	$push38=, 1
	i32.shr_u	$push2=, $pop1, $pop38
	i32.add 	$push3=, $0, $pop2
	i32.const	$push37=, 31
	i32.shr_u	$push4=, $pop3, $pop37
	i32.sub 	$push5=, $pop40, $pop4
	i32.const	$push36=, 31
	i32.shl 	$push6=, $pop5, $pop36
	i32.sub 	$push7=, $0, $pop6
	i32.add 	$push9=, $pop8, $pop7
	i32.ne  	$push10=, $pop9, $0
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push55=, 0
	i32.load	$push54=, nums+4($pop55)
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, -2147483648
	i32.eq  	$push11=, $pop53, $pop52
	i32.const	$push51=, 31
	i32.shl 	$push19=, $pop11, $pop51
	i32.const	$push50=, 0
	i32.const	$push49=, 31
	i32.shr_s	$push12=, $0, $pop49
	i32.const	$push48=, 1
	i32.shr_u	$push13=, $pop12, $pop48
	i32.add 	$push14=, $0, $pop13
	i32.const	$push47=, 31
	i32.shr_u	$push15=, $pop14, $pop47
	i32.sub 	$push16=, $pop50, $pop15
	i32.const	$push46=, 31
	i32.shl 	$push17=, $pop16, $pop46
	i32.sub 	$push18=, $0, $pop17
	i32.add 	$push20=, $pop19, $pop18
	i32.ne  	$push21=, $pop20, $0
	br_if   	0, $pop21       # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push62=, 0
	i32.load	$push61=, nums+8($pop62)
	tee_local	$push60=, $0=, $pop61
	i32.const	$push22=, -2147483648
	i32.eq  	$push23=, $pop60, $pop22
	i32.const	$push24=, 31
	i32.shl 	$push33=, $pop23, $pop24
	i32.const	$push59=, 0
	i32.const	$push58=, 31
	i32.shr_s	$push25=, $0, $pop58
	i32.const	$push26=, 1
	i32.shr_u	$push27=, $pop25, $pop26
	i32.add 	$push28=, $0, $pop27
	i32.const	$push57=, 31
	i32.shr_u	$push29=, $pop28, $pop57
	i32.sub 	$push30=, $pop59, $pop29
	i32.const	$push56=, 31
	i32.shl 	$push31=, $pop30, $pop56
	i32.sub 	$push32=, $0, $pop31
	i32.add 	$push34=, $pop33, $pop32
	i32.ne  	$push35=, $pop34, $0
	br_if   	0, $pop35       # 0: down to label0
# BB#3:                                 # %for.cond.2
	i32.const	$push63=, 0
	call    	exit@FUNCTION, $pop63
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	nums                    # @nums
	.type	nums,@object
	.section	.data.nums,"aw",@progbits
	.globl	nums
	.p2align	2
nums:
	.int32	4294967295              # 0xffffffff
	.int32	2147483647              # 0x7fffffff
	.int32	2147483648              # 0x80000000
	.size	nums, 12


	.ident	"clang version 3.9.0 "
