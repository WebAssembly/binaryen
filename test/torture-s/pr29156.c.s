	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29156.c"
	.section	.text.bla,"ax",@progbits
	.hidden	bla
	.globl	bla
	.type	bla,@function
bla:                                    # @bla
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store	4($1), $pop0
	i32.const	$push1=, 0
	i32.const	$push4=, 1
	i32.store	global($pop1), $pop4
	i32.const	$push2=, 8
	i32.store	0($0), $pop2
	i32.load	$push3=, 4($1)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	bla, .Lfunc_end0-bla

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	global($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
