	.text
	.file	"frame-address.c"
	.section	.text.check_fa_work,"ax",@progbits
	.hidden	check_fa_work           # -- Begin function check_fa_work
	.globl	check_fa_work
	.type	check_fa_work,@function
check_fa_work:                          # @check_fa_work
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$2=, $pop8, $pop10
	i32.const	$push0=, 0
	i32.store8	15($2), $pop0
	block   	
	i32.const	$push11=, 15
	i32.add 	$push12=, $2, $pop11
	i32.le_u	$push1=, $pop12, $0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.else
	i32.le_u	$push4=, $0, $1
	i32.const	$push13=, 15
	i32.add 	$push14=, $2, $pop13
	i32.ge_u	$push5=, $pop14, $1
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.ge_u	$push2=, $0, $1
	i32.const	$push15=, 15
	i32.add 	$push16=, $2, $pop15
	i32.le_u	$push3=, $pop16, $1
	i32.and 	$push7=, $pop2, $pop3
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	check_fa_work, .Lfunc_end0-check_fa_work
                                        # -- End function
	.section	.text.check_fa_mid,"ax",@progbits
	.hidden	check_fa_mid            # -- Begin function check_fa_mid
	.globl	check_fa_mid
	.type	check_fa_mid,@function
check_fa_mid:                           # @check_fa_mid
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$push4=, __stack_pointer($pop2)
	copy_local	$1=, $pop4
	i32.call	$0=, check_fa_work@FUNCTION, $0, $1
	i32.const	$push3=, 0
	i32.store	__stack_pointer($pop3), $1
	i32.const	$push0=, 0
	i32.ne  	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	check_fa_mid, .Lfunc_end1-check_fa_mid
                                        # -- End function
	.section	.text.check_fa,"ax",@progbits
	.hidden	check_fa                # -- Begin function check_fa
	.globl	check_fa
	.type	check_fa,@function
check_fa:                               # @check_fa
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$2=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $2
	i32.const	$push9=, 15
	i32.add 	$push10=, $2, $pop9
	i32.call	$1=, check_fa_mid@FUNCTION, $pop10
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $2, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push0=, 0
	i32.ne  	$push1=, $1, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	check_fa, .Lfunc_end2-check_fa
                                        # -- End function
	.section	.text.how_much,"ax",@progbits
	.hidden	how_much                # -- Begin function how_much
	.globl	how_much
	.type	how_much,@function
how_much:                               # @how_much
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	how_much, .Lfunc_end3-how_much
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.call	$push0=, check_fa@FUNCTION, $0
	i32.eqz 	$push2=, $pop0
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push1=, 0
	return  	$pop1
.LBB4_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
