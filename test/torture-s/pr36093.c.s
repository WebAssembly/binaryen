	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36093.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, -129
.LBB0_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$0=, foo
	i32.const	$2=, 129
	i32.add 	$push0=, $0, $3
	i32.add 	$push1=, $pop0, $2
	i32.const	$push2=, 97
	i32.store8	$discard=, 0($pop1), $pop2
	i32.const	$1=, 1
	i32.add 	$3=, $3, $1
	br_if   	$3, .LBB0_1
.LBB0_2:                                # %for.body4.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.add 	$push3=, $0, $2
	i32.const	$push4=, 98
	i32.store8	$discard=, 0($pop3), $pop4
	i32.add 	$2=, $2, $1
	i32.const	$3=, 258
	i32.ne  	$push5=, $2, $3
	br_if   	$pop5, .LBB0_2
.LBB0_3:                                # %for.body4.2
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_4
	i32.add 	$push6=, $0, $3
	i32.const	$push7=, 99
	i32.store8	$discard=, 0($pop6), $pop7
	i32.add 	$3=, $3, $1
	i32.const	$2=, 387
	i32.ne  	$push8=, $3, $2
	br_if   	$pop8, .LBB0_3
.LBB0_4:                                # %for.body4.3
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_5
	i32.add 	$push9=, $0, $2
	i32.const	$push10=, 100
	i32.store8	$3=, 0($pop9), $pop10
	i32.add 	$2=, $2, $1
	i32.const	$push11=, 516
	i32.ne  	$push12=, $2, $pop11
	br_if   	$pop12, .LBB0_4
.LBB0_5:                                # %for.end.3
	i32.const	$2=, 0
	block   	.LBB0_7
	i32.load8_u	$push13=, foo+515($2)
	i32.ne  	$push14=, $pop13, $3
	br_if   	$pop14, .LBB0_7
# BB#6:                                 # %if.end
	return  	$2
.LBB0_7:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.align	7
foo:
	.skip	2560
	.size	foo, 2560


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
