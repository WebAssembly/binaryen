	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031012-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 15008
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$2=, 13371
	i32.const	$push0=, 205
	i32.const	$7=, 0
	i32.add 	$7=, $7, $7
	call    	memset@FUNCTION, $7, $pop0, $2
	i32.const	$push1=, 0
	i32.store8	$3=, 13371($7), $pop1
	i32.const	$8=, 0
	i32.add 	$8=, $7, $8
	block
	i32.call	$push2=, strlen@FUNCTION, $8
	i32.ne  	$push3=, $pop2, $2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %foo.exit
	i32.const	$6=, 15008
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$3
.LBB0_2:                                # %if.then.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
