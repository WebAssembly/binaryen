	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19689.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, f($pop7)
	i32.const	$push4=, -536870912
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push0=, 536870911
	i32.and 	$push1=, $0, $pop0
	i32.or  	$push6=, $pop5, $pop1
	i32.store	f($pop2), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, f($pop7)
	i32.const	$push2=, -536870912
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 536870857
	i32.or  	$push5=, $pop3, $pop4
	i32.store	f($pop0), $pop5
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	4
	.size	f, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
