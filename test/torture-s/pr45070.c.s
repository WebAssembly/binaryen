	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45070.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	i32.const	$push0=, 0
	i32.store	$2=, 0($8), $pop0
	i32.const	$push1=, 4
	i32.const	$6=, 0
	i32.add 	$6=, $8, $6
	i32.or  	$push2=, $6, $pop1
	i32.store	$push3=, 0($pop2), $2
	i32.store	$2=, 8($8), $pop3
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$7=, 0
	i32.add 	$7=, $8, $7
	i32.call	$0=, next@FUNCTION, $7
	block
	block
	block
	br_if   	$2, 0           # 0: down to label4
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$1=, 65535
	i32.and 	$push4=, $0, $1
	i32.ne  	$push5=, $pop4, $1
	br_if   	$pop5, 1        # 1: down to label3
.LBB0_3:                                # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$1=, 1
	i32.lt_s	$push6=, $2, $1
	br_if   	$pop6, 1        # 1: down to label2
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push7=, 65535
	i32.and 	$push8=, $0, $pop7
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop8, $pop12
	br_if   	$pop13, 1       # 1: down to label2
.LBB0_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$2=, $2, $1
	i32.const	$push9=, 15
	i32.le_s	$push10=, $2, $pop9
	br_if   	$pop10, 0       # 0: up to label0
# BB#7:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push11=, 0
	i32.const	$5=, 16
	i32.add 	$8=, $8, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	return  	$pop11
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.next,"ax",@progbits
	.type	next,@function
next:                                   # @next
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.load	$push0=, 0($0)
	i32.load	$push1=, 4($0)
	i32.lt_s	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label5
.LBB1_1:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push3=, 8
	i32.add 	$1=, $0, $pop3
	i32.load	$push4=, 0($1)
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop4, $pop12
	br_if   	$pop13, 1       # 1: down to label7
# BB#2:                                 # %if.then1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push5=, 0
	i32.store	$1=, 0($1), $pop5
	call    	fetch@FUNCTION, $0
	i32.load	$push6=, 0($0)
	i32.const	$push7=, 4
	i32.add 	$push8=, $0, $pop7
	i32.load	$push9=, 0($pop8)
	i32.ge_s	$push10=, $pop6, $pop9
	br_if   	$pop10, 0       # 0: up to label6
	br      	2               # 2: down to label5
.LBB1_3:                                # %if.end
	end_loop                        # label7:
	i32.const	$push11=, 1
	i32.store	$discard=, 0($1), $pop11
	i32.const	$1=, 65535
.LBB1_4:                                # %cleanup
	end_block                       # label5:
	return  	$1
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
