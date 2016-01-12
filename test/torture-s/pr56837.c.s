	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56837.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i64, i32
# BB#0:                                 # %entry
	i64.const	$0=, 4294967295
	i32.const	$1=, -8192
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $1
	i32.const	$push2=, 8192
	i32.add 	$push3=, $pop1, $pop2
	i64.store	$discard=, 0($pop3), $0
	i32.const	$push4=, 8
	i32.add 	$1=, $1, $pop4
	br_if   	$1, .LBB0_1
.LBB0_2:                                # %for.end
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	call    	foo@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, a
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_5
	loop    	.LBB1_4
	i32.load	$push1=, 0($0)
	i32.const	$push4=, -1
	i32.ne  	$push5=, $pop1, $pop4
	br_if   	$pop5, .LBB1_5
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.load	$push0=, 0($pop3)
	br_if   	$pop0, .LBB1_5
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push7=, 8
	i32.add 	$0=, $0, $pop7
	i32.const	$push8=, 1023
	i32.le_s	$push9=, $1, $pop8
	br_if   	$pop9, .LBB1_1
.LBB1_4:                                # %for.end
	i32.const	$push10=, 0
	return  	$pop10
.LBB1_5:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	4
a:
	.skip	8192
	.size	a, 8192


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
