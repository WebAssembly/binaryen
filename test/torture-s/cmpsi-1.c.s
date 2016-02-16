	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cmpsi-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.sub 	$push3=, $0, $1
	tee_local	$push2=, $1=, $pop3
	i32.const	$push0=, 0
	i32.ge_s	$push1=, $pop2, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end3
	return  	$1
.LBB0_2:                                # %if.then2
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.sub 	$push3=, $0, $1
	tee_local	$push2=, $1=, $pop3
	i32.const	$push0=, 0
	i32.ge_s	$push1=, $pop2, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end3
	return  	$1
.LBB1_2:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
	.endfunc
.Lfunc_end2:
	.size	dummy, .Lfunc_end2-dummy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
