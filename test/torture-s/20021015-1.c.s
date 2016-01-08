	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021015-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.load	$push0=, 0($4)
	i32.const	$push1=, g_list
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.end
	i32.const	$4=, 0
	i32.store8	$discard=, g_list($4), $4
	return
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load8_u	$push0=, g_list($0)
	i32.const	$push1=, 0
	i32.eq  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB1_2
# BB#1:                                 # %g.exit
	i32.store8	$discard=, g_list($0), $0
.LBB1_2:                                # %for.end
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	g_list                  # @g_list
	.type	g_list,@object
	.section	.data.g_list,"aw",@progbits
	.globl	g_list
g_list:
	.int8	49
	.size	g_list, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
