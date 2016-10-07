	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030203-1.c"
	.section	.text.do_layer3,"ax",@progbits
	.hidden	do_layer3
	.globl	do_layer3
	.type	do_layer3,@function
do_layer3:                              # @do_layer3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	do_layer3, .Lfunc_end0-do_layer3

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

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
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
