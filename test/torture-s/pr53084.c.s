	.text
	.file	"pr53084.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.load8_u	$push0=, 0($0)
	i32.const	$push5=, 111
	i32.ne  	$push1=, $pop0, $pop5
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	i32.const	$push6=, 111
	i32.ne  	$push3=, $pop2, $pop6
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %lor.lhs.false6
	i32.load8_u	$push4=, 2($0)
	br_if   	0, $pop4        # 0: down to label0
# %bb.3:                                # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, .L.str+1
	call    	bar@FUNCTION, $pop0
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"foo"
	.size	.L.str, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
