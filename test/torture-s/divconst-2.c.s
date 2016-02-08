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
	i32.const	$push47=, 0
	i32.load	$push0=, nums($pop47)
	tee_local	$push46=, $0=, $pop0
	i32.const	$push45=, -2147483648
	i32.eq  	$push1=, $pop46, $pop45
	i32.const	$push44=, 31
	i32.shl 	$push9=, $pop1, $pop44
	i32.const	$push43=, 0
	i32.const	$push42=, 31
	i32.shr_s	$push2=, $0, $pop42
	i32.const	$push41=, 1
	i32.shr_u	$push3=, $pop2, $pop41
	i32.add 	$push4=, $0, $pop3
	i32.const	$push40=, 31
	i32.shr_u	$push5=, $pop4, $pop40
	i32.sub 	$push6=, $pop43, $pop5
	i32.const	$push39=, 31
	i32.shl 	$push7=, $pop6, $pop39
	i32.sub 	$push8=, $0, $pop7
	i32.add 	$push10=, $pop9, $pop8
	i32.ne  	$push11=, $pop10, $0
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push56=, 0
	i32.load	$push12=, nums+4($pop56)
	tee_local	$push55=, $0=, $pop12
	i32.const	$push54=, -2147483648
	i32.eq  	$push13=, $pop55, $pop54
	i32.const	$push53=, 31
	i32.shl 	$push21=, $pop13, $pop53
	i32.const	$push52=, 0
	i32.const	$push51=, 31
	i32.shr_s	$push14=, $0, $pop51
	i32.const	$push50=, 1
	i32.shr_u	$push15=, $pop14, $pop50
	i32.add 	$push16=, $0, $pop15
	i32.const	$push49=, 31
	i32.shr_u	$push17=, $pop16, $pop49
	i32.sub 	$push18=, $pop52, $pop17
	i32.const	$push48=, 31
	i32.shl 	$push19=, $pop18, $pop48
	i32.sub 	$push20=, $0, $pop19
	i32.add 	$push22=, $pop21, $pop20
	i32.ne  	$push23=, $pop22, $0
	br_if   	0, $pop23       # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push62=, 0
	i32.load	$push24=, nums+8($pop62)
	tee_local	$push61=, $0=, $pop24
	i32.const	$push25=, -2147483648
	i32.eq  	$push26=, $pop61, $pop25
	i32.const	$push27=, 31
	i32.shl 	$push36=, $pop26, $pop27
	i32.const	$push60=, 0
	i32.const	$push59=, 31
	i32.shr_s	$push28=, $0, $pop59
	i32.const	$push29=, 1
	i32.shr_u	$push30=, $pop28, $pop29
	i32.add 	$push31=, $0, $pop30
	i32.const	$push58=, 31
	i32.shr_u	$push32=, $pop31, $pop58
	i32.sub 	$push33=, $pop60, $pop32
	i32.const	$push57=, 31
	i32.shl 	$push34=, $pop33, $pop57
	i32.sub 	$push35=, $0, $pop34
	i32.add 	$push37=, $pop36, $pop35
	i32.ne  	$push38=, $pop37, $0
	br_if   	0, $pop38       # 0: down to label0
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
