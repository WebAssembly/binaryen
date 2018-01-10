	.text
	.file	"pr31605.c"
	.section	.text.put_field,"ax",@progbits
	.hidden	put_field               # -- Begin function put_field
	.globl	put_field
	.type	put_field,@function
put_field:                              # @put_field
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.add 	$push0=, $1, $0
	i32.const	$push1=, -8
	i32.or  	$push2=, $pop0, $pop1
	i32.const	$push5=, -8
	i32.ne  	$push3=, $pop2, $pop5
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end0:
	.size	put_field, .Lfunc_end0-put_field
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
