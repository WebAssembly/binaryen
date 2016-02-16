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
	.local  	f64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i64.const	$push0=, 9218868437227405312
	i64.store	$discard=, 0($5):p2align=4, $pop0
	i32.const	$push7=, 8
	i32.or  	$push6=, $5, $pop7
	tee_local	$push5=, $1=, $pop6
	i64.const	$push1=, 4627167142146473984
	i64.store	$discard=, 0($pop5), $pop1
	f64.const	$0=, infinity
.LBB1_1:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	f64.const	$push10=, infinity
	f64.ne  	$push2=, $0, $pop10
	br_if   	2, $pop2        # 2: down to label4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	f64.load	$0=, 0($1)
	i32.const	$push9=, 8
	i32.add 	$1=, $1, $pop9
	f64.const	$push8=, 0x1.7p4
	f64.ne  	$push3=, $0, $pop8
	br_if   	0, $pop3        # 0: up to label5
# BB#3:                                 # %add.exit
	end_loop                        # label6:
	i32.const	$push4=, 0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop4
.LBB1_4:                                # %if.then3.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
