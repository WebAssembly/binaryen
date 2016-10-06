	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/divconst-2.c"
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
                                        # fallthrough-return: $pop1
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
	i32.const	$push0=, -2147483648
	i32.rem_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push22=, 0
	i32.load	$push21=, nums($pop22)
	tee_local	$push20=, $0=, $pop21
	i32.const	$push19=, -2147483648
	i32.eq  	$push1=, $pop20, $pop19
	i32.const	$push18=, 31
	i32.shl 	$push2=, $pop1, $pop18
	i32.const	$push17=, -2147483648
	i32.rem_s	$push0=, $0, $pop17
	i32.add 	$push3=, $pop2, $pop0
	i32.ne  	$push4=, $pop3, $0
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push28=, 0
	i32.load	$push27=, nums+4($pop28)
	tee_local	$push26=, $0=, $pop27
	i32.const	$push25=, -2147483648
	i32.eq  	$push6=, $pop26, $pop25
	i32.const	$push24=, 31
	i32.shl 	$push7=, $pop6, $pop24
	i32.const	$push23=, -2147483648
	i32.rem_s	$push5=, $0, $pop23
	i32.add 	$push8=, $pop7, $pop5
	i32.ne  	$push9=, $pop8, $0
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push32=, 0
	i32.load	$push31=, nums+8($pop32)
	tee_local	$push30=, $0=, $pop31
	i32.const	$push10=, -2147483648
	i32.eq  	$push12=, $pop30, $pop10
	i32.const	$push13=, 31
	i32.shl 	$push14=, $pop12, $pop13
	i32.const	$push29=, -2147483648
	i32.rem_s	$push11=, $0, $pop29
	i32.add 	$push15=, $pop14, $pop11
	i32.ne  	$push16=, $pop15, $0
	br_if   	0, $pop16       # 0: down to label0
# BB#3:                                 # %for.cond.2
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
