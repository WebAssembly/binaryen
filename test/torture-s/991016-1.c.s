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
	i32.const	$push19=, 0
	i32.eq  	$push20=, $0, $pop19
	br_if   	$pop20, 0       # 0: down to label1
# BB#1:                                 # %entry
	block
	i32.const	$push9=, 1
	i32.eq  	$push3=, $0, $pop9
	br_if   	$pop3, 0        # 0: down to label2
# BB#2:                                 # %entry
	block
	i32.const	$push4=, 2
	i32.ne  	$push5=, $0, $pop4
	br_if   	$pop5, 0        # 0: down to label3
# BB#3:                                 # %do.body11.preheader
	i64.load	$3=, 0($2)
.LBB0_4:                                # %do.body11
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push18=, -1
	i32.add 	$1=, $1, $pop18
	copy_local	$push2=, $3
	tee_local	$push17=, $5=, $pop2
	i64.const	$push16=, 1
	i64.shl 	$3=, $pop17, $pop16
	br_if   	$1, 0           # 0: up to label4
# BB#5:                                 # %do.end16
	end_loop                        # label5:
	i64.store	$discard=, 0($2), $3
	i64.const	$push6=, 0
	i64.eq  	$1=, $5, $pop6
	br      	3               # 3: down to label0
.LBB0_6:                                # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %do.body2.preheader
	end_block                       # label2:
	i32.load	$0=, 0($2)
.LBB0_8:                                # %do.body2
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push15=, -1
	i32.add 	$1=, $1, $pop15
	copy_local	$push1=, $0
	tee_local	$push14=, $4=, $pop1
	i32.const	$push13=, 1
	i32.shl 	$0=, $pop14, $pop13
	br_if   	$1, 0           # 0: up to label6
# BB#9:                                 # %do.end7
	end_loop                        # label7:
	i32.store	$discard=, 0($2), $0
	i32.const	$push7=, 0
	i32.eq  	$1=, $4, $pop7
	br      	1               # 1: down to label0
.LBB0_10:                               # %do.body.preheader
	end_block                       # label1:
	i32.load	$0=, 0($2)
.LBB0_11:                               # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.const	$push12=, -1
	i32.add 	$1=, $1, $pop12
	copy_local	$push0=, $0
	tee_local	$push11=, $4=, $pop0
	i32.const	$push10=, 1
	i32.shl 	$0=, $pop11, $pop10
	br_if   	$1, 0           # 0: up to label8
# BB#12:                                # %do.end
	end_loop                        # label9:
	i32.store	$discard=, 0($2), $0
	i32.const	$push8=, 0
	i32.eq  	$1=, $4, $pop8
.LBB0_13:                               # %cleanup
	end_block                       # label0:
	return  	$1
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
