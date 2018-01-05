	.text
	.file	"arith-1.c"
	.section	.text.sat_add,"ax",@progbits
	.hidden	sat_add                 # -- Begin function sat_add
	.globl	sat_add
	.type	sat_add,@function
sat_add:                                # @sat_add
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.const	$push5=, -1
	i32.eq  	$push1=, $0, $pop5
	i32.select	$push4=, $pop0, $pop3, $pop1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	sat_add, .Lfunc_end0-sat_add
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
