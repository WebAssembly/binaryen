	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36321.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$discard=, argp($2)
	return  	$2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	argp,@object            # @argp
	.section	.data.argp,"aw",@progbits
	.align	2
argp:
	.int32	.L.str
	.size	argp, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"pr36321.x"
	.size	.L.str, 10


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
