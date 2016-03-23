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
	f64.load	$push7=, 0($1)
	tee_local	$push6=, $3=, $pop7
	f64.load	$push5=, 0($0)
	tee_local	$push4=, $2=, $pop5
	f64.eq  	$push0=, $pop6, $pop4
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %if.end.preheader
	i32.const	$push8=, 8
	i32.add 	$1=, $1, $pop8
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	f64.const	$push10=, infinity
	f64.ne  	$push1=, $3, $pop10
	br_if   	3, $pop1        # 3: down to label0
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB0_2 Depth=1
	f64.load	$3=, 0($1)
	i32.const	$push9=, 8
	i32.add 	$1=, $1, $pop9
	f64.ne  	$push2=, $3, $2
	br_if   	0, $pop2        # 0: up to label2
.LBB0_4:                                # %if.end10
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push3=, 0
	return  	$pop3
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
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$2=, $pop10, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $2
	i64.const	$push0=, 9218868437227405312
	i64.store	$discard=, 0($2):p2align=4, $pop0
	i64.const	$push1=, 4627167142146473984
	i64.store	$discard=, 8($2), $pop1
	i32.const	$push5=, 8
	i32.or  	$0=, $2, $pop5
	f64.const	$1=, infinity
.LBB1_1:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	f64.const	$push8=, infinity
	f64.ne  	$push2=, $1, $pop8
	br_if   	2, $pop2        # 2: down to label4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	f64.load	$1=, 0($0)
	i32.const	$push7=, 8
	i32.add 	$0=, $0, $pop7
	f64.const	$push6=, 0x1.7p4
	f64.ne  	$push3=, $1, $pop6
	br_if   	0, $pop3        # 0: up to label5
# BB#3:                                 # %add.exit
	end_loop                        # label6:
	i32.const	$push4=, 0
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 16
	i32.add 	$push14=, $2, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	return  	$pop4
.LBB1_4:                                # %if.then3.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
