	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081218-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, a
	i32.const	$push2=, 38
	i32.const	$push1=, 520
	call    	memset, $pop0, $pop2, $pop1
	i32.const	$push3=, 640034342
	return  	$pop3
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, a
	i32.const	$push2=, 54
	i32.const	$push1=, 520
	call    	memset, $pop0, $pop2, $pop1
	i32.const	$0=, 0
	i32.const	$push3=, 909522486
	i32.store	$discard=, a($0), $pop3
	i32.const	$push4=, 909588022
	i32.store	$discard=, a+4($0), $pop4
	return
func_end1:
	.size	bar, func_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$0=, foo
	i32.const	$3=, 0
	block   	BB2_11
	i32.const	$push0=, 640034342
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB2_11
BB2_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB2_10
	loop    	BB2_3
	i32.const	$0=, a
	i32.add 	$push2=, $0, $3
	i32.load8_u	$push3=, 0($pop2)
	i32.const	$push4=, 38
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB2_10
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 1
	i32.add 	$3=, $3, $1
	i32.const	$2=, 519
	i32.le_u	$push6=, $3, $2
	br_if   	$pop6, BB2_1
BB2_3:                                  # %for.end
	call    	bar
	i32.const	$3=, 0
	block   	BB2_9
	i32.load	$push7=, a+4($3)
	i32.const	$push8=, 909588022
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, BB2_9
# BB#4:                                 # %if.end9
	i32.const	$push10=, 909522486
	i32.store	$discard=, a+4($3), $pop10
BB2_5:                                  # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	block   	BB2_8
	loop    	BB2_7
	i32.add 	$push11=, $0, $3
	i32.load8_u	$push12=, 0($pop11)
	i32.const	$push13=, 54
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, BB2_8
# BB#6:                                 # %for.cond10
                                        #   in Loop: Header=BB2_5 Depth=1
	i32.add 	$3=, $3, $1
	i32.le_u	$push15=, $3, $2
	br_if   	$pop15, BB2_5
BB2_7:                                  # %for.end22
	i32.const	$push16=, 0
	return  	$pop16
BB2_8:                                  # %if.then18
	call    	abort
	unreachable
BB2_9:                                  # %if.then8
	call    	abort
	unreachable
BB2_10:                                 # %if.then4
	call    	abort
	unreachable
BB2_11:                                 # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.zero	520
	.size	a, 520


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
