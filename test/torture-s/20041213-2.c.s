	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041213-2.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	i32.const	$2=, 0
	block   	BB0_6
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, BB0_6
BB0_1:                                  # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_5
	block   	BB0_4
	block   	BB0_3
	i32.ge_s	$push0=, $2, $3
	br_if   	$pop0, BB0_3
# BB#2:                                 # %for.end.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push2=, 1
	i32.shl 	$push3=, $3, $pop2
	i32.sub 	$1=, $pop3, $2
	br      	BB0_4
BB0_3:                                  # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$1=, $3
	i32.ne  	$push1=, $2, $3
	br_if   	$pop1, BB0_5
BB0_4:                                  # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
	copy_local	$2=, $3
	copy_local	$3=, $1
	br_if   	$0, BB0_1
	br      	BB0_6
BB0_5:                                  # %if.then
	call    	abort
	unreachable
BB0_6:                                  # %for.end7
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	call    	foo, $pop0
	i32.const	$push1=, 0
	call    	exit, $pop1
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
