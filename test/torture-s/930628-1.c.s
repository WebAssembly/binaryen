	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930628-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.eq  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 0
.LBB1_1:                                # %for.cond4.preheader
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	block
	i32.eqz 	$push17=, $0
	br_if   	0, $pop17       # 0: down to label4
# BB#2:                                 # %for.cond15.preheader
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eqz 	$push18=, $0
	br_if   	3, $pop18       # 3: down to label1
.LBB1_3:                                # %for.inc36.1.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push7=, 1
	i32.add 	$1=, $1, $pop7
	i32.const	$push6=, -64
	i32.add 	$0=, $0, $pop6
	i32.const	$push5=, 4
	i32.lt_s	$push0=, $1, $pop5
	br_if   	0, $pop0        # 0: up to label2
# BB#4:                                 # %for.inc45
	end_loop                        # label3:
	i32.const	$0=, 0
	i32.const	$1=, 1
.LBB1_5:                                # %for.cond4.preheader.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	block
	i32.eqz 	$push19=, $0
	br_if   	0, $pop19       # 0: down to label7
# BB#6:                                 # %for.cond15.preheader.1
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.eqz 	$push20=, $0
	br_if   	3, $pop20       # 3: down to label1
.LBB1_7:                                # %for.inc36.1.1.1
                                        #   in Loop: Header=BB1_5 Depth=1
	end_block                       # label7:
	i32.const	$push10=, 1
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, -64
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 4
	i32.lt_s	$push1=, $1, $pop8
	br_if   	0, $pop1        # 0: up to label5
# BB#8:                                 # %for.inc45.1
	end_loop                        # label6:
	i32.const	$1=, 2
	i32.const	$0=, 0
.LBB1_9:                                # %for.cond4.preheader.2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	block
	i32.eqz 	$push21=, $0
	br_if   	0, $pop21       # 0: down to label10
# BB#10:                                # %for.cond15.preheader.2
                                        #   in Loop: Header=BB1_9 Depth=1
	i32.eqz 	$push22=, $0
	br_if   	3, $pop22       # 3: down to label1
.LBB1_11:                               # %for.inc36.1.1.2
                                        #   in Loop: Header=BB1_9 Depth=1
	end_block                       # label10:
	i32.const	$push13=, 1
	i32.add 	$1=, $1, $pop13
	i32.const	$push12=, -64
	i32.add 	$0=, $0, $pop12
	i32.const	$push11=, 4
	i32.lt_s	$push2=, $1, $pop11
	br_if   	0, $pop2        # 0: up to label8
# BB#12:                                # %for.inc45.2
	end_loop                        # label9:
	i32.const	$1=, 3
	i32.const	$0=, 0
.LBB1_13:                               # %for.cond4.preheader.3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	block
	i32.eqz 	$push23=, $0
	br_if   	0, $pop23       # 0: down to label13
# BB#14:                                # %for.cond15.preheader.3
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.eqz 	$push24=, $0
	br_if   	3, $pop24       # 3: down to label1
.LBB1_15:                               # %for.inc36.1.1.3
                                        #   in Loop: Header=BB1_13 Depth=1
	end_block                       # label13:
	i32.const	$push16=, 1
	i32.add 	$1=, $1, $pop16
	i32.const	$push15=, -64
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, 4
	i32.lt_s	$push3=, $1, $pop14
	br_if   	0, $pop3        # 0: up to label11
# BB#16:                                # %for.inc45.3
	end_loop                        # label12:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_17:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
