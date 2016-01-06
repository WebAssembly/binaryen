	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/950426-1.c"
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
	i32.const	$push3=, .str.1+1
	i32.store	$discard=, s1+16($0), $pop3
	call    	exit, $0
	unreachable
func_end0:
	.size	main, func_end0-main

	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($0)
	return  	$pop0
func_end1:
	.size	func1, func_end1-func1

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$1
func_end2:
	.size	foo, func_end2-foo

	.type	s1,@object              # @s1
	.bss
	.globl	s1
	.align	2
s1:
	.zero	24
	.size	s1, 24

	.type	p1,@object              # @p1
	.globl	p1
	.align	2
p1:
	.int32	0
	.size	p1, 4

	.type	i,@object               # @i
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	.str.1,@object          # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.1:
	.asciz	"123"
	.size	.str.1, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
