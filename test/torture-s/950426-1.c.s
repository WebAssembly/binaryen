	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950426-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.then
	i32.const	$0=, 0
	i32.const	$push0=, -1
	i32.store	$discard=, s1($0), $pop0
	i32.const	$push1=, s1
	i32.store	$discard=, p1($0), $pop1
	i32.const	$push2=, 3
	i32.store	$discard=, i($0), $pop2
	i32.const	$push3=, .L.str.1+1
	i32.store	$discard=, s1+16($0), $pop3
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.func1,"ax",@progbits
	.hidden	func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	func1, .Lfunc_end1-func1

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$1
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.hidden	s1                      # @s1
	.type	s1,@object
	.section	.bss.s1,"aw",@nobits
	.globl	s1
	.align	2
s1:
	.skip	24
	.size	s1, 24

	.hidden	p1                      # @p1
	.type	p1,@object
	.section	.bss.p1,"aw",@nobits
	.globl	p1
	.align	2
p1:
	.int32	0
	.size	p1, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"123"
	.size	.L.str.1, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
