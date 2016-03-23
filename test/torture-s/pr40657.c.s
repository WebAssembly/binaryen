	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40657.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, __stack_pointer
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, 16
	i32.sub 	$2=, $pop1, $pop2
	i32.store	$discard=, 12($2), $0
	i32.const	$1=, 12
	i32.add 	$1=, $2, $1
	#APP
	#NO_APP
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $0
	i32.const	$push9=, 12
	i32.add 	$push10=, $0, $pop9
	call    	bar@FUNCTION, $pop10
	i32.const	$push0=, 0
	i64.load	$push1=, v($pop0)
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	$discard=, 0($pop8), $pop7
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i64.call	$push0=, foo@FUNCTION
	i32.const	$push3=, 0
	i64.load	$push1=, v($pop3)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	3
v:
	.int64	20015998343868          # 0x123456789abc
	.size	v, 8


	.ident	"clang version 3.9.0 "
