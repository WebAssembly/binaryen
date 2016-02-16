	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-13.c"
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
	block
	block
	block
	block
	block
	block
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label12
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label11
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 2($1)
	i32.const	$push7=, 30
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label10
# BB#3:                                 # %if.end11
	i32.load8_u	$push9=, 3($1)
	i32.const	$push10=, 40
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	3, $pop11       # 3: down to label9
# BB#4:                                 # %if.end16
	i32.load8_u	$push12=, 0($2)
	i32.const	$push13=, 11
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	4, $pop14       # 4: down to label8
# BB#5:                                 # %if.end22
	i32.load8_u	$push15=, 1($2)
	i32.const	$push16=, 21
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	5, $pop17       # 5: down to label7
# BB#6:                                 # %if.end28
	i32.load8_u	$push18=, 2($2)
	i32.const	$push19=, 31
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	6, $pop20       # 6: down to label6
# BB#7:                                 # %if.end34
	i32.load8_u	$push21=, 3($2)
	i32.const	$push22=, 41
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	7, $pop23       # 7: down to label5
# BB#8:                                 # %if.end40
	i32.load8_u	$push24=, 0($3)
	i32.const	$push25=, 12
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	8, $pop26       # 8: down to label4
# BB#9:                                 # %if.end46
	i32.load8_u	$push27=, 1($3)
	i32.const	$push28=, 22
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	9, $pop29       # 9: down to label3
# BB#10:                                # %if.end52
	i32.load8_u	$push30=, 2($3)
	i32.const	$push31=, 32
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	10, $pop32      # 10: down to label2
# BB#11:                                # %if.end58
	i32.load8_u	$push33=, 3($3)
	i32.const	$push34=, 42
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	11, $pop35      # 11: down to label1
# BB#12:                                # %if.end64
	i32.const	$push36=, 123
	i32.ne  	$push37=, $4, $pop36
	br_if   	12, $pop37      # 12: down to label0
# BB#13:                                # %if.end68
	return  	$1
.LBB0_14:                               # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then5
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then10
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then15
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then21
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then27
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then33
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %if.then39
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %if.then45
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_23:                               # %if.then51
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %if.then57
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then63
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_26:                               # %if.then67
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
