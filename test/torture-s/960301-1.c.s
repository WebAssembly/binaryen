	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960301-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load16_u	$2=, foo($1)
	i32.const	$3=, 12
	i32.shr_u	$push0=, $2, $3
	i32.store	$discard=, oldfoo($1), $pop0
	i32.const	$push2=, 4095
	i32.and 	$push3=, $2, $pop2
	i32.shl 	$push1=, $0, $3
	i32.or  	$push4=, $pop3, $pop1
	i32.store16	$discard=, foo($1), $pop4
	i32.const	$push6=, 1
	i32.const	$push5=, 2
	i32.select	$push7=, $0, $pop6, $pop5
	return  	$pop7
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.load16_u	$1=, foo($0)
	i32.const	$push0=, 12
	i32.shr_u	$push1=, $1, $pop0
	i32.store	$discard=, oldfoo($0), $pop1
	i32.const	$push2=, 4095
	i32.and 	$push3=, $1, $pop2
	i32.const	$push4=, 4096
	i32.or  	$push5=, $pop3, $pop4
	i32.store16	$discard=, foo($0), $pop5
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.align	2
foo:
	.skip	4
	.size	foo, 4

	.hidden	oldfoo                  # @oldfoo
	.type	oldfoo,@object
	.section	.bss.oldfoo,"aw",@nobits
	.globl	oldfoo
	.align	2
oldfoo:
	.int32	0                       # 0x0
	.size	oldfoo, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
