	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640-2.c"
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.load	$push2=, a+36($0)
	i32.store	$push3=, a($0), $pop2
	i32.store	$discard=, a+4($0), $pop3
	i32.const	$push0=, 1
	i32.store	$push1=, a+48($0), $pop0
	i32.store	$push4=, c($0), $pop1
	i32.store	$1=, c($0), $pop4
	i32.load	$2=, a+60($0)
	i32.store	$push5=, a($0), $1
	i32.store	$push6=, a+4($0), $pop5
	i32.store	$discard=, c($0), $pop6
	i32.store	$push7=, a($0), $2
	i32.store	$discard=, a+4($0), $pop7
	return  	$0
func_end0:
	.size	fn1, func_end0-fn1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, a+60($0)
	block   	BB1_2
	i32.const	$push0=, 1
	i32.store	$push1=, a+48($0), $pop0
	i32.store	$discard=, c($0), $pop1
	i32.store	$push2=, a($0), $1
	i32.store	$push3=, a+4($0), $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.end
	return  	$0
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	4
a:
	.zero	80
	.size	a, 80

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
