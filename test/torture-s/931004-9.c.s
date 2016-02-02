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
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %if.end6
	block
	i32.load8_u	$push6=, 0($2)
	i32.const	$push7=, 11
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label2
# BB#3:                                 # %if.end12
	block
	i32.load8_u	$push9=, 1($2)
	i32.const	$push10=, 21
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, 0       # 0: down to label3
# BB#4:                                 # %if.end18
	block
	i32.load8_u	$push12=, 0($3)
	i32.const	$push13=, 12
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label4
# BB#5:                                 # %if.end24
	block
	i32.load8_u	$push15=, 1($3)
	i32.const	$push16=, 22
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, 0       # 0: down to label5
# BB#6:                                 # %if.end30
	block
	i32.const	$push18=, 123
	i32.ne  	$push19=, $4, $pop18
	br_if   	$pop19, 0       # 0: down to label6
# BB#7:                                 # %if.end34
	return  	$1
.LBB0_8:                                # %if.then33
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then29
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then23
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then11
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then
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
