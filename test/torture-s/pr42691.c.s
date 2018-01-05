	.text
	.file	"pr42691.c"
	.section	.text.add,"ax",@progbits
	.hidden	add                     # -- Begin function add
	.globl	add
	.type	add,@function
add:                                    # @add
	.param  	i32, i32
	.result 	i32
	.local  	f64, f64
# %bb.0:                                # %entry
	f64.load	$2=, 0($0)
	f64.load	$3=, 0($1)
	block   	
	block   	
	f64.eq  	$push1=, $3, $2
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.end.preheader
	i32.const	$push5=, 8
	i32.add 	$1=, $1, $pop5
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	f64.const	$push6=, infinity
	f64.ne  	$push2=, $3, $pop6
	br_if   	2, $pop2        # 2: down to label0
# %bb.3:                                # %while.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	f64.load	$3=, 0($1)
	i32.const	$push7=, 8
	i32.add 	$push0=, $1, $pop7
	copy_local	$1=, $pop0
	f64.ne  	$push3=, $3, $2
	br_if   	0, $pop3        # 0: up to label2
.LBB0_4:                                # %if.end10
	end_loop
	end_block                       # label1:
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_5:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	add, .Lfunc_end0-add
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, i32
# %bb.0:                                # %if.end.lr.ph.i
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$2=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $2
	i64.const	$push1=, 4627167142146473984
	i64.store	8($2), $pop1
	i64.const	$push2=, 9218868437227405312
	i64.store	0($2), $pop2
	i32.const	$push13=, 8
	i32.or  	$0=, $2, $pop13
	f64.const	$1=, infinity
.LBB1_1:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	f64.const	$push14=, infinity
	f64.ne  	$push3=, $1, $pop14
	br_if   	1, $pop3        # 1: down to label3
# %bb.2:                                # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	f64.load	$1=, 0($0)
	i32.const	$push16=, 8
	i32.add 	$push0=, $0, $pop16
	copy_local	$0=, $pop0
	f64.const	$push15=, 0x1.7p4
	f64.ne  	$push4=, $1, $pop15
	br_if   	0, $pop4        # 0: up to label4
# %bb.3:                                # %add.exit
	end_loop
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $2, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_4:                                # %if.then3.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
