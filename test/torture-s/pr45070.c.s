	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45070.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push17=, 0($pop10), $pop14
	tee_local	$push16=, $2=, $pop17
	i64.const	$push0=, 0
	i64.store	$discard=, 0($pop16), $pop0
	i32.const	$1=, 0
	i32.const	$push15=, 0
	i32.store	$discard=, 8($2), $pop15
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.call	$0=, next@FUNCTION, $2
	block
	br_if   	0, $1           # 0: down to label3
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push19=, 65535
	i32.and 	$push1=, $0, $pop19
	i32.const	$push18=, 65535
	i32.ne  	$push2=, $pop1, $pop18
	br_if   	3, $pop2        # 3: down to label0
.LBB0_3:                                # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	block
	i32.const	$push20=, 1
	i32.lt_s	$push3=, $1, $pop20
	br_if   	0, $pop3        # 0: down to label4
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push21=, 65535
	i32.and 	$push4=, $0, $pop21
	br_if   	3, $pop4        # 3: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push23=, 1
	i32.add 	$1=, $1, $pop23
	i32.const	$push22=, 15
	i32.le_s	$push5=, $1, $pop22
	br_if   	0, $pop5        # 0: up to label1
# BB#6:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $2, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	i32.const	$push6=, 0
	return  	$pop6
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
	i32.const	$push6=, 4
	i32.add 	$2=, $0, $pop6
.LBB1_2:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load	$push4=, 0($1)
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop4, $pop13
	br_if   	1, $pop14       # 1: down to label7
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$3=, 0
	i32.const	$push12=, 0
	i32.store	$discard=, 0($1), $pop12
	call    	fetch@FUNCTION, $0
	i32.load	$push5=, 0($0)
	i32.load	$push7=, 0($2)
	i32.ge_s	$push8=, $pop5, $pop7
	br_if   	0, $pop8        # 0: up to label6
	br      	2               # 2: down to label5
.LBB1_4:                                # %if.end
	end_loop                        # label7:
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 1
	i32.store	$discard=, 0($pop10), $pop11
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
