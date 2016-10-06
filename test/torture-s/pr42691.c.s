	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42691.c"
	.section	.text.add,"ax",@progbits
	.hidden	add
	.globl	add
	.type	add,@function
add:                                    # @add
	.param  	i32, i32
	.result 	i32
	.local  	f64, f64
# BB#0:                                 # %entry
	block   	
	block   	
	f64.load	$push8=, 0($1)
	tee_local	$push7=, $3=, $pop8
	f64.load	$push6=, 0($0)
	tee_local	$push5=, $2=, $pop6
	f64.eq  	$push1=, $pop7, $pop5
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end.preheader
	i32.const	$push9=, 8
	i32.add 	$1=, $1, $pop9
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	f64.const	$push10=, infinity
	f64.ne  	$push2=, $3, $pop10
	br_if   	2, $pop2        # 2: down to label0
# BB#3:                                 # %while.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	f64.load	$3=, 0($1)
	i32.const	$push11=, 8
	i32.add 	$push0=, $1, $pop11
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push15=, $pop7, $pop8
	tee_local	$push14=, $2=, $pop15
	i32.store	__stack_pointer($pop9), $pop14
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
	f64.const	$push16=, infinity
	f64.ne  	$push3=, $1, $pop16
	br_if   	1, $pop3        # 1: down to label3
# BB#2:                                 # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	f64.load	$1=, 0($0)
	i32.const	$push18=, 8
	i32.add 	$push0=, $0, $pop18
	copy_local	$0=, $pop0
	f64.const	$push17=, 0x1.7p4
	f64.ne  	$push4=, $1, $pop17
	br_if   	0, $pop4        # 0: up to label4
# BB#3:                                 # %add.exit
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
