	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 10
	i32.store	$drop=, g1($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push2=, 7930
	i32.div_s	$push3=, $pop2, $0
	i32.store	$drop=, g2($pop4), $pop3
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
	i32.const	$push2=, 0
	i32.const	$push4=, 0
	i32.const	$push1=, 10
	i32.store	$push0=, g2($pop4), $pop1
	i32.store	$drop=, g1($pop2), $pop0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	g1                      # @g1
	.type	g1,@object
	.section	.bss.g1,"aw",@nobits
	.globl	g1
	.p2align	2
g1:
	.int32	0                       # 0x0
	.size	g1, 4

	.hidden	g2                      # @g2
	.type	g2,@object
	.section	.bss.g2,"aw",@nobits
	.globl	g2
	.p2align	2
g2:
	.int32	0                       # 0x0
	.size	g2, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
