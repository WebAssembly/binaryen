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
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push0=, 2
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	block   	
	i32.const	$push6=, 1
	i32.eq  	$push2=, $0, $pop6
	br_if   	0, $pop2        # 0: down to label2
# %bb.2:                                # %entry
	br_if   	2, $0           # 2: down to label0
# %bb.3:                                # %sw.bb
	i32.load	$0=, 0($2)
.LBB0_4:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	copy_local	$3=, $0
	i32.const	$push8=, -1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 1
	i32.shl 	$0=, $3, $pop7
	br_if   	0, $1           # 0: up to label3
# %bb.5:                                # %do.end
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
	copy_local	$3=, $0
	i32.const	$push10=, -1
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, 1
	i32.shl 	$0=, $3, $pop9
	br_if   	0, $1           # 0: up to label4
# %bb.8:                                # %do.end7
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
	copy_local	$4=, $5
	i32.const	$push12=, -1
	i32.add 	$1=, $1, $pop12
	i64.const	$push11=, 1
	i64.shl 	$5=, $4, $pop11
	br_if   	0, $1           # 0: up to label5
# %bb.11:                               # %do.end16
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
# %bb.0:                                # %if.end8
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
