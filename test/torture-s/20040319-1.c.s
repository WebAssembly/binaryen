	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040319-1.c"
	.section	.text.blah,"ax",@progbits
	.hidden	blah
	.globl	blah
	.type	blah,@function
blah:                                   # @blah
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 1
	i32.const	$push2=, 0
	i32.sub 	$push3=, $pop2, $0
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	i32.select	$push5=, $pop4, $pop3, $pop1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	blah, .Lfunc_end0-blah

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
