	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$4=, __stack_pointer($pop3)
	i32.const	$push0=, 0
	i32.store	0($3), $pop0
	i32.const	$push4=, 16
	i32.sub 	$push8=, $4, $pop4
	tee_local	$push7=, $3=, $pop8
	i32.store	12($pop7), $0
	i32.const	$push5=, 12
	i32.add 	$push6=, $3, $pop5
	i32.select	$push1=, $pop6, $2, $1
	i32.load	$push2=, 0($pop1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
