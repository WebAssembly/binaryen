	.text
	.file	"restrict-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	4($0), $pop0
	i32.load	$push2=, 0($2)
	i32.load	$push1=, 0($1)
	i32.add 	$push3=, $pop2, $pop1
	i32.store	0($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$1=, 0($0)
	i32.const	$push0=, 1
	i32.shl 	$push1=, $1, $pop0
	i64.extend_u/i32	$push2=, $pop1
	i64.store	0($0):p2align=2, $pop2
	block   	
	i32.const	$push4=, 1
	i32.ne  	$push3=, $1, $pop4
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %bar.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
