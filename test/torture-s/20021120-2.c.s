	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, 10
	i32.store	$discard=, g1($1), $pop0
	i32.const	$push1=, 7930
	i32.div_s	$push2=, $pop1, $0
	i32.store	$discard=, g2($1), $pop2
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 10
	i32.store	$push1=, g1($0), $pop0
	i32.store	$discard=, g2($0), $pop1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	g1                      # @g1
	.type	g1,@object
	.section	.bss.g1,"aw",@nobits
	.globl	g1
	.align	2
g1:
	.int32	0                       # 0x0
	.size	g1, 4

	.hidden	g2                      # @g2
	.type	g2,@object
	.section	.bss.g2,"aw",@nobits
	.globl	g2
	.align	2
g2:
	.int32	0                       # 0x0
	.size	g2, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
