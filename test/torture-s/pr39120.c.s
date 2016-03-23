	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39120.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	i32.const	$push2=, 1
	i32.store	$discard=, 0($pop1), $pop2
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $1
	i32.const	$push0=, 0
	i32.store	$push6=, 12($1), $pop0
	tee_local	$push5=, $0=, $pop6
	i32.const	$push14=, 12
	i32.add 	$push15=, $1, $pop14
	i32.call	$push1=, foo@FUNCTION, $pop15
	i32.store	$discard=, x($pop5), $pop1
	call    	bar@FUNCTION
	block
	i32.load	$push2=, 12($1)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	return  	$0
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.skip	4
	.size	x, 4


	.ident	"clang version 3.9.0 "
