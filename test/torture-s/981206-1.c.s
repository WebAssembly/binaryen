	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/981206-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store8	y($pop1), $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 1
	i32.store8	x($pop3), $pop2
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
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store8	y($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, 1
	i32.store8	x($pop4), $pop3
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	x,@object               # @x
	.section	.bss.x,"aw",@nobits
	.p2align	1
x:
	.int8	0                       # 0x0
	.size	x, 1

	.type	y,@object               # @y
	.section	.bss.y,"aw",@nobits
	.p2align	1
y:
	.int8	0                       # 0x0
	.size	y, 1


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
