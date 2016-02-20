	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-11.c"
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
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 2($1)
	i32.const	$push7=, 30
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end11
	i32.load8_u	$push9=, 0($2)
	i32.const	$push10=, 11
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end17
	i32.load8_u	$push12=, 1($2)
	i32.const	$push13=, 21
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end23
	i32.load8_u	$push15=, 2($2)
	i32.const	$push16=, 31
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end29
	i32.load8_u	$push18=, 0($3)
	i32.const	$push19=, 12
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#7:                                 # %if.end35
	i32.load8_u	$push21=, 1($3)
	i32.const	$push22=, 22
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#8:                                 # %if.end41
	i32.load8_u	$push24=, 2($3)
	i32.const	$push25=, 32
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#9:                                 # %if.end47
	i32.const	$push27=, 123
	i32.ne  	$push28=, $4, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#10:                                # %if.end51
	return  	$1
.LBB0_11:                               # %if.then50
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
