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
	i32.eqz 	$push25=, $0
	br_if   	0, $pop25       # 0: down to label4
# BB#2:                                 # %for.cond15.preheader
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eqz 	$push26=, $0
	br_if   	3, $pop26       # 3: down to label1
.LBB1_3:                                # %for.inc36.1.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.const	$push9=, -64
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 4
	i32.lt_s	$push0=, $pop6, $pop5
	br_if   	0, $pop0        # 0: up to label2
# BB#4:                                 # %for.inc45
	end_loop                        # label3:
	i32.const	$0=, 0
	i32.const	$1=, 1
.LBB1_5:                                # %for.cond4.preheader.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	block
	i32.eqz 	$push27=, $0
	br_if   	0, $pop27       # 0: down to label7
# BB#6:                                 # %for.cond15.preheader.1
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.eqz 	$push28=, $0
	br_if   	3, $pop28       # 3: down to label1
.LBB1_7:                                # %for.inc36.1.1.1
                                        #   in Loop: Header=BB1_5 Depth=1
	end_block                       # label7:
	i32.const	$push14=, -64
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 4
	i32.lt_s	$push1=, $pop11, $pop10
	br_if   	0, $pop1        # 0: up to label5
# BB#8:                                 # %for.inc45.1
	end_loop                        # label6:
	i32.const	$1=, 2
	i32.const	$0=, 0
.LBB1_9:                                # %for.cond4.preheader.2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	block
	i32.eqz 	$push29=, $0
	br_if   	0, $pop29       # 0: down to label10
# BB#10:                                # %for.cond15.preheader.2
                                        #   in Loop: Header=BB1_9 Depth=1
	i32.eqz 	$push30=, $0
	br_if   	3, $pop30       # 3: down to label1
.LBB1_11:                               # %for.inc36.1.1.2
                                        #   in Loop: Header=BB1_9 Depth=1
	end_block                       # label10:
	i32.const	$push19=, -64
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, 1
	i32.add 	$push17=, $1, $pop18
	tee_local	$push16=, $1=, $pop17
	i32.const	$push15=, 4
	i32.lt_s	$push2=, $pop16, $pop15
	br_if   	0, $pop2        # 0: up to label8
# BB#12:                                # %for.inc45.2
	end_loop                        # label9:
	i32.const	$1=, 3
	i32.const	$0=, 0
.LBB1_13:                               # %for.cond4.preheader.3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	block
	i32.eqz 	$push31=, $0
	br_if   	0, $pop31       # 0: down to label13
# BB#14:                                # %for.cond15.preheader.3
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.eqz 	$push32=, $0
	br_if   	3, $pop32       # 3: down to label1
.LBB1_15:                               # %for.inc36.1.1.3
                                        #   in Loop: Header=BB1_13 Depth=1
	end_block                       # label13:
	i32.const	$push24=, -64
	i32.add 	$0=, $0, $pop24
	i32.const	$push23=, 1
	i32.add 	$push22=, $1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 4
	i32.lt_s	$push3=, $pop21, $pop20
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
	.functype	abort, void
	.functype	exit, void, i32
