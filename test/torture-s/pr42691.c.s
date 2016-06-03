	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42691.c"
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
	loop                            # label2:
	f64.const	$push10=, infinity
	f64.ne  	$push2=, $3, $pop10
	br_if   	3, $pop2        # 3: down to label0
# BB#3:                                 # %while.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	f64.load	$3=, 0($1)
	i32.const	$push11=, 8
	i32.add 	$push0=, $1, $pop11
	copy_local	$1=, $pop0
	f64.ne  	$push3=, $3, $2
	br_if   	0, $pop3        # 0: up to label2
.LBB0_4:                                # %if.end10
	end_loop                        # label3:
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
	.local  	i32, i32, f64
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, __stack_pointer($pop9), $pop13
	tee_local	$push15=, $0=, $pop16
	i64.const	$push1=, 4627167142146473984
	i64.store	$drop=, 8($pop15), $pop1
	i64.const	$push2=, 9218868437227405312
	i64.store	$drop=, 0($0), $pop2
	i32.const	$push14=, 8
	i32.or  	$1=, $0, $pop14
	f64.const	$2=, infinity
.LBB1_1:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	f64.const	$push17=, infinity
	f64.ne  	$push3=, $2, $pop17
	br_if   	2, $pop3        # 2: down to label4
# BB#2:                                 # %while.cond.i
                                        #   in Loop: Header=BB1_1 Depth=1
	f64.load	$2=, 0($1)
	i32.const	$push19=, 8
	i32.add 	$push0=, $1, $pop19
	copy_local	$1=, $pop0
	f64.const	$push18=, 0x1.7p4
	f64.ne  	$push4=, $2, $pop18
	br_if   	0, $pop4        # 0: up to label5
# BB#3:                                 # %add.exit
	end_loop                        # label6:
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_4:                                # %if.then3.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
