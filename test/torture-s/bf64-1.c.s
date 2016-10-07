	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf64-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, -8690468286197432320
	i64.or  	$push2=, $pop0, $pop1
	i64.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub

	.section	.text.sub2,"ax",@progbits
	.hidden	sub2
	.globl	sub2
	.type	sub2,@function
sub2:                                   # @sub2
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, 2381903268435576
	i64.or  	$push2=, $pop0, $pop1
	i64.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	sub2, .Lfunc_end1-sub2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end22
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
