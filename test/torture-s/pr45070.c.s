	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45070.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i64.const	$push1=, 0
	i64.store	$discard=, 0($5), $pop1
	i32.const	$push0=, 0
	i32.store	$1=, 8($5):p2align=3, $pop0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.call	$0=, next@FUNCTION, $5
	block
	br_if   	0, $1           # 0: down to label3
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 65535
	i32.and 	$push2=, $0, $pop11
	i32.const	$push10=, 65535
	i32.ne  	$push3=, $pop2, $pop10
	br_if   	3, $pop3        # 3: down to label0
.LBB0_3:                                # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	block
	i32.const	$push12=, 1
	i32.lt_s	$push4=, $1, $pop12
	br_if   	0, $pop4        # 0: down to label4
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 65535
	i32.and 	$push5=, $0, $pop13
	br_if   	3, $pop5        # 3: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push9=, 1
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 15
	i32.le_s	$push6=, $1, $pop8
	br_if   	0, $pop6        # 0: up to label1
# BB#6:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push7=, 0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop7
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.next,"ax",@progbits
	.type	next,@function
next:                                   # @next
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block
	i32.load	$push0=, 0($0)
	i32.load	$push1=, 4($0)
	i32.lt_s	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label5
# BB#1:                                 # %if.then.lr.ph
	i32.const	$push3=, 8
	i32.add 	$1=, $0, $pop3
	i32.const	$push7=, 4
	i32.add 	$2=, $0, $pop7
.LBB1_2:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$push4=, 0($1)
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop4, $pop13
	br_if   	1, $pop14       # 1: down to label7
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push5=, 0
	i32.store	$3=, 0($1), $pop5
	call    	fetch@FUNCTION, $0
	i32.load	$push6=, 0($0)
	i32.load	$push8=, 0($2)
	i32.ge_s	$push9=, $pop6, $pop8
	br_if   	0, $pop9        # 0: up to label6
	br      	2               # 2: down to label5
.LBB1_4:                                # %if.end
	end_loop                        # label7:
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	i32.const	$push12=, 1
	i32.store	$discard=, 0($pop11), $pop12
	i32.const	$3=, 65535
.LBB1_5:                                # %cleanup
	end_block                       # label5:
	return  	$3
	.endfunc
.Lfunc_end1:
	.size	next, .Lfunc_end1-next

	.section	.text.fetch,"ax",@progbits
	.type	fetch,@function
fetch:                                  # @fetch
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 128
	i32.store	$discard=, 4($0), $pop0
	return
	.endfunc
.Lfunc_end2:
	.size	fetch, .Lfunc_end2-fetch


	.ident	"clang version 3.9.0 "
