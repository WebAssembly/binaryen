	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-4.c"
	.section	.text.my_set_a,"ax",@progbits
	.hidden	my_set_a
	.globl	my_set_a
	.type	my_set_a,@function
my_set_a:                               # @my_set_a
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 171
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	my_set_a, .Lfunc_end0-my_set_a

	.section	.text.my_set_b,"ax",@progbits
	.hidden	my_set_b
	.globl	my_set_b
	.type	my_set_b,@function
my_set_b:                               # @my_set_b
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4660
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	my_set_b, .Lfunc_end1-my_set_b

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
