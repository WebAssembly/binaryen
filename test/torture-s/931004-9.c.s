	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-9.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	block
	block
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label5
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 0($2)
	i32.const	$push7=, 11
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label4
# BB#3:                                 # %if.end12
	i32.load8_u	$push9=, 1($2)
	i32.const	$push10=, 21
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	3, $pop11       # 3: down to label3
# BB#4:                                 # %if.end18
	i32.load8_u	$push12=, 0($3)
	i32.const	$push13=, 12
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	4, $pop14       # 4: down to label2
# BB#5:                                 # %if.end24
	i32.load8_u	$push15=, 1($3)
	i32.const	$push16=, 22
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	5, $pop17       # 5: down to label1
# BB#6:                                 # %if.end30
	i32.const	$push18=, 123
	i32.ne  	$push19=, $4, $pop18
	br_if   	6, $pop19       # 6: down to label0
# BB#7:                                 # %if.end34
	return  	$1
.LBB0_8:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then5
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then11
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then23
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then29
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then33
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %f.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
