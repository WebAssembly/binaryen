	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $2
	block
	block
	i32.store	$push3=, 12($2), $0
	tee_local	$push2=, $0=, $pop3
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop2, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$push11=, 12
	i32.add 	$push12=, $2, $pop11
	i32.call	$0=, f@FUNCTION, $pop1, $pop12
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.then
	end_block                       # label1:
	i32.load	$0=, 0($1)
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 16
	i32.add 	$push9=, $2, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 100
	i32.const	$push4=, 0
	i32.call	$push1=, f@FUNCTION, $pop0, $pop4
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
