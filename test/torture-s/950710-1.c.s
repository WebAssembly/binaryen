	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950710-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 32
	i32.sub 	$3=, $pop9, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $3
	i32.const	$2=, 16
	i32.add 	$2=, $3, $2
	i32.sub 	$0=, $3, $2
	block
	i32.const	$push0=, 31
	i32.shr_s	$push7=, $0, $pop0
	tee_local	$push6=, $1=, $pop7
	i32.add 	$push1=, $0, $pop6
	i32.xor 	$push2=, $pop1, $1
	i32.const	$push3=, 11
	i32.gt_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.then.i
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %f.exit
	end_block                       # label0:
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
