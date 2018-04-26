	.text
	.file	"20030606-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 55
	i32.store	0($0), $pop0
	block   	
	i32.eqz 	$push7=, $1
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push5=, 4
	i32.add 	$push1=, $0, $pop5
	i32.store	0($pop1), $1
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	return  	$pop3
.LBB0_2:
	end_block                       # label0:
	i32.const	$push6=, 4
	i32.add 	$push4=, $0, $pop6
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
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
