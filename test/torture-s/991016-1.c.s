	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991016-1.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64, i32, i64
# BB#0:                                 # %entry
	block
	block
	i32.const	$push11=, 0
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, 0       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$5=, 1
	block
	i32.eq  	$push0=, $0, $5
	br_if   	$pop0, 0        # 0: down to label2
# BB#2:                                 # %entry
	block
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label3
# BB#3:                                 # %do.body11.preheader
	i64.load	$6=, 0($2)
.LBB0_4:                                # %do.body11
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push4=, -1
	i32.add 	$1=, $1, $pop4
	copy_local	$4=, $6
	i64.const	$push3=, 1
	i64.shl 	$6=, $4, $pop3
	br_if   	$1, 0           # 0: up to label4
# BB#5:                                 # %do.end16
	end_loop                        # label5:
	i64.store	$discard=, 0($2), $6
	i64.const	$push5=, 0
	i64.eq  	$1=, $4, $pop5
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
	i32.const	$push6=, -1
	i32.add 	$1=, $1, $pop6
	copy_local	$3=, $0
	i32.shl 	$0=, $3, $5
	br_if   	$1, 0           # 0: up to label6
# BB#9:                                 # %do.end7
	end_loop                        # label7:
	i32.store	$discard=, 0($2), $0
	i32.const	$push7=, 0
	i32.eq  	$1=, $3, $pop7
	br      	1               # 1: down to label0
.LBB0_10:                               # %do.body.preheader
	end_block                       # label1:
	i32.load	$0=, 0($2)
.LBB0_11:                               # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	i32.const	$push9=, -1
	i32.add 	$1=, $1, $pop9
	copy_local	$3=, $0
	i32.const	$push8=, 1
	i32.shl 	$0=, $3, $pop8
	br_if   	$1, 0           # 0: up to label8
# BB#12:                                # %do.end
	end_loop                        # label9:
	i32.store	$discard=, 0($2), $0
	i32.const	$push10=, 0
	i32.eq  	$1=, $3, $pop10
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
	.section	".note.GNU-stack","",@progbits
