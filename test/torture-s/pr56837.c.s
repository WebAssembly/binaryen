	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56837.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i64, i32
# BB#0:                                 # %entry
	i64.const	$0=, 4294967295
	i32.const	$1=, -8192
BB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$push0=, a
	i32.add 	$push1=, $pop0, $1
	i32.const	$push2=, 8192
	i32.add 	$push3=, $pop1, $pop2
	i64.store	$discard=, 0($pop3), $0
	i32.const	$push4=, 8
	i32.add 	$1=, $1, $pop4
	br_if   	$1, BB0_1
BB0_2:                                  # %for.end
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	call    	foo
	i32.const	$1=, 0
	i32.const	$0=, a
BB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB1_5
	loop    	BB1_4
	i32.load	$push1=, 0($0)
	i32.const	$push4=, -1
	i32.ne  	$push5=, $pop1, $pop4
	br_if   	$pop5, BB1_5
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.load	$push0=, 0($pop3)
	br_if   	$pop0, BB1_5
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push7=, 8
	i32.add 	$0=, $0, $pop7
	i32.const	$push8=, 1023
	i32.le_s	$push9=, $1, $pop8
	br_if   	$pop9, BB1_1
BB1_4:                                  # %for.end
	i32.const	$push10=, 0
	return  	$pop10
BB1_5:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	4
a:
	.zero	8192
	.size	a, 8192


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
