	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991016-1.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
	.result 	i32
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push19=, 0
	i32.eq  	$push20=, $0, $pop19
	br_if   	0, $pop20       # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push6=, 1
	i32.eq  	$push0=, $0, $pop6
	br_if   	1, $pop0        # 1: down to label1
# BB#2:                                 # %entry
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	2, $pop2        # 2: down to label0
# BB#3:                                 # %do.body11.preheader
	i64.load	$3=, 0($2)
.LBB0_4:                                # %do.body11
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push10=, -1
	i32.add 	$1=, $1, $pop10
	copy_local	$push9=, $3
	tee_local	$push8=, $4=, $pop9
	i64.const	$push7=, 1
	i64.shl 	$3=, $pop8, $pop7
	br_if   	0, $1           # 0: up to label3
# BB#5:                                 # %do.end16
	end_loop                        # label4:
	i64.store	$discard=, 0($2), $3
	i64.eqz 	$push3=, $4
	return  	$pop3
.LBB0_6:                                # %do.body.preheader
	end_block                       # label2:
	i32.load	$0=, 0($2)
.LBB0_7:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.const	$push14=, -1
	i32.add 	$1=, $1, $pop14
	copy_local	$push13=, $0
	tee_local	$push12=, $5=, $pop13
	i32.const	$push11=, 1
	i32.shl 	$0=, $pop12, $pop11
	br_if   	0, $1           # 0: up to label5
# BB#8:                                 # %do.end
	end_loop                        # label6:
	i32.store	$discard=, 0($2), $0
	i32.eqz 	$push5=, $5
	return  	$pop5
.LBB0_9:                                # %do.body2.preheader
	end_block                       # label1:
	i32.load	$0=, 0($2)
.LBB0_10:                               # %do.body2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$push18=, -1
	i32.add 	$1=, $1, $pop18
	copy_local	$push17=, $0
	tee_local	$push16=, $5=, $pop17
	i32.const	$push15=, 1
	i32.shl 	$0=, $pop16, $pop15
	br_if   	0, $1           # 0: up to label7
# BB#11:                                # %do.end7
	end_loop                        # label8:
	i32.store	$discard=, 0($2), $0
	i32.eqz 	$push4=, $5
	return  	$pop4
.LBB0_12:                               # %sw.default
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
