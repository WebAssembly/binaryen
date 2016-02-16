	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991016-1.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
	.result 	i32
	.local  	i64, i32, i64
# BB#0:                                 # %entry
	block
	block
	block
	block
	i32.const	$push19=, 0
	i32.eq  	$push20=, $0, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push6=, 1
	i32.eq  	$push0=, $0, $pop6
	br_if   	1, $pop0        # 1: down to label2
# BB#2:                                 # %entry
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	3, $pop2        # 3: down to label0
# BB#3:                                 # %do.body11.preheader
	i64.load	$3=, 0($2)
.LBB0_4:                                # %do.body11
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push18=, -1
	i32.add 	$1=, $1, $pop18
	copy_local	$push17=, $3
	tee_local	$push16=, $5=, $pop17
	i64.const	$push15=, 1
	i64.shl 	$3=, $pop16, $pop15
	br_if   	0, $1           # 0: up to label4
# BB#5:                                 # %do.end16
	end_loop                        # label5:
	i64.store	$discard=, 0($2), $3
	i64.const	$push3=, 0
	i64.eq  	$1=, $5, $pop3
	br      	2               # 2: down to label1
.LBB0_6:                                # %do.body.preheader
	end_block                       # label3:
	i32.load	$0=, 0($2)
.LBB0_7:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push10=, -1
	i32.add 	$1=, $1, $pop10
	copy_local	$push9=, $0
	tee_local	$push8=, $4=, $pop9
	i32.const	$push7=, 1
	i32.shl 	$0=, $pop8, $pop7
	br_if   	0, $1           # 0: up to label6
# BB#8:                                 # %do.end
	end_loop                        # label7:
	i32.store	$discard=, 0($2), $0
	i32.const	$push5=, 0
	i32.eq  	$1=, $4, $pop5
	br      	1               # 1: down to label1
.LBB0_9:                                # %do.body2.preheader
	end_block                       # label2:
	i32.load	$0=, 0($2)
.LBB0_10:                               # %do.body2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.const	$push14=, -1
	i32.add 	$1=, $1, $pop14
	copy_local	$push13=, $0
	tee_local	$push12=, $4=, $pop13
	i32.const	$push11=, 1
	i32.shl 	$0=, $pop12, $pop11
	br_if   	0, $1           # 0: up to label8
# BB#11:                                # %do.end7
	end_loop                        # label9:
	i32.store	$discard=, 0($2), $0
	i32.const	$push4=, 0
	i32.eq  	$1=, $4, $pop4
.LBB0_12:                               # %cleanup
	end_block                       # label1:
	return  	$1
.LBB0_13:                               # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	doit, .Lfunc_end0-doit

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end8
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
