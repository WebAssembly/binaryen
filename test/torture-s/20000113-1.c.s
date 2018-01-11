	.text
	.file	"20000113-1.c"
	.section	.text.foobar,"ax",@progbits
	.hidden	foobar                  # -- Begin function foobar
	.globl	foobar
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 1
	i32.and 	$0=, $0, $pop1
	block   	
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push0=, 3
	i32.and 	$1=, $1, $pop0
	i32.sub 	$push2=, $1, $0
	i32.mul 	$push3=, $pop2, $1
	i32.add 	$push4=, $pop3, $2
	i32.const	$push5=, 7
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foobar, .Lfunc_end0-foobar
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
	.functype	abort, void
	.functype	exit, void, i32
