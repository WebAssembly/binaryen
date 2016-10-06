	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37882.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load8_u	$push1=, s($pop7)
	i32.const	$push2=, 248
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 4
	i32.or  	$push5=, $pop3, $pop4
	i32.store8	s($pop0), $pop5
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
s:
	.skip	1
	.size	s, 1


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
