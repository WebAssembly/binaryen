	.text
	.file	"20080502-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64
# %bb.0:                                # %entry
	i64.const	$push0=, 63
	i64.shr_s	$2=, $2, $pop0
	i64.const	$push1=, 4611846683310179025
	i64.and 	$push2=, $2, $pop1
	i64.store	8($0), $pop2
	i64.const	$push3=, -8905435550453399112
	i64.and 	$push4=, $2, $pop3
	i64.store	0($0), $pop4
                                        # fallthrough-return
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$0=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $0
	i64.const	$push1=, 0
	i64.const	$push0=, -4611967493404098560
	call    	foo@FUNCTION, $0, $pop1, $pop0
	block   	
	i64.load	$push5=, 0($0)
	i64.load	$push4=, 8($0)
	i64.const	$push3=, -8905435550453399112
	i64.const	$push2=, 4611846683310179025
	i32.call	$push6=, __eqtf2@FUNCTION, $pop5, $pop4, $pop3, $pop2
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
