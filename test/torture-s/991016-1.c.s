	.text
	.file	"991016-1.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit                    # -- Begin function doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 2
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	block   	
	i32.const	$push6=, 1
	i32.eq  	$push2=, $0, $pop6
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %entry
	br_if   	2, $0           # 2: down to label0
# BB#3:                                 # %sw.bb
	i32.load	$0=, 0($2)
.LBB0_4:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	copy_local	$push12=, $0
	tee_local	$push11=, $3=, $pop12
	i32.const	$push10=, 1
	i32.shl 	$0=, $pop11, $pop10
	i32.const	$push9=, -1
	i32.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	br_if   	0, $pop7        # 0: up to label3
# BB#5:                                 # %do.end
	end_loop
	i32.store	0($2), $0
	i32.eqz 	$push5=, $3
	return  	$pop5
.LBB0_6:                                # %sw.bb1
	end_block                       # label2:
	i32.load	$0=, 0($2)
.LBB0_7:                                # %do.body2
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	copy_local	$push18=, $0
	tee_local	$push17=, $3=, $pop18
	i32.const	$push16=, 1
	i32.shl 	$0=, $pop17, $pop16
	i32.const	$push15=, -1
	i32.add 	$push14=, $1, $pop15
	tee_local	$push13=, $1=, $pop14
	br_if   	0, $pop13       # 0: up to label4
# BB#8:                                 # %do.end7
	end_loop
	i32.store	0($2), $0
	i32.eqz 	$push4=, $3
	return  	$pop4
.LBB0_9:                                # %sw.bb10
	end_block                       # label1:
	i64.load	$5=, 0($2)
.LBB0_10:                               # %do.body11
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	copy_local	$push24=, $5
	tee_local	$push23=, $4=, $pop24
	i64.const	$push22=, 1
	i64.shl 	$5=, $pop23, $pop22
	i32.const	$push21=, -1
	i32.add 	$push20=, $1, $pop21
	tee_local	$push19=, $1=, $pop20
	br_if   	0, $pop19       # 0: up to label5
# BB#11:                                # %do.end16
	end_loop
	i64.store	0($2), $5
	i64.eqz 	$push3=, $4
	return  	$pop3
.LBB0_12:                               # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	doit, .Lfunc_end0-doit
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
