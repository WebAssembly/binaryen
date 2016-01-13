	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$push1=, 992($0), $pop0
	i32.store	$push2=, 996($0), $pop1
	i32.store	$push3=, 1000($0), $pop2
	i32.store	$push4=, 1004($0), $pop3
	i32.store	$push5=, 1008($0), $pop4
	i32.store	$push6=, 1012($0), $pop5
	i32.store	$push7=, 1016($0), $pop6
	i32.store	$push8=, 1020($0), $pop7
	i32.store	$push9=, 0($0), $pop8
	i32.store	$push10=, 4($0), $pop9
	i32.store	$push11=, 8($0), $pop10
	i32.store	$push12=, 12($0), $pop11
	i32.store	$push13=, 16($0), $pop12
	i32.store	$push14=, 20($0), $pop13
	i32.store	$push15=, 24($0), $pop14
	i32.store	$discard=, 28($0), $pop15
	return
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 1024
	i32.sub 	$12=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$12=, 0($7), $12
	i32.const	$4=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$8=, 0
	i32.add 	$8=, $12, $8
	i32.add 	$push0=, $8, $4
	i32.const	$push1=, 1
	i32.store	$5=, 0($pop0), $pop1
	i32.const	$0=, 4
	i32.add 	$4=, $4, $0
	i32.const	$push2=, 1024
	i32.ne  	$push3=, $4, $pop2
	br_if   	$pop3, 0        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push7=, 0
	i32.store	$push8=, 1016($12), $pop7
	i32.store	$push9=, 1020($12), $pop8
	i32.store	$2=, 0($12), $pop9
	i32.const	$9=, 0
	i32.add 	$9=, $12, $9
	i32.or  	$4=, $9, $0
	i32.store	$discard=, 0($4), $2
	i32.const	$push10=, 8
	i32.const	$10=, 0
	i32.add 	$10=, $12, $10
	i32.or  	$push11=, $10, $pop10
	i32.store	$discard=, 0($pop11), $2
	i32.const	$push12=, 12
	i32.const	$11=, 0
	i32.add 	$11=, $12, $11
	i32.or  	$push13=, $11, $pop12
	i32.store	$discard=, 0($pop13), $2
	i64.const	$push4=, 0
	i64.store	$push5=, 992($12), $pop4
	i64.store	$push6=, 1000($12), $pop5
	i64.store	$discard=, 1008($12), $pop6
	i32.store	$push14=, 16($12), $2
	i32.store	$push15=, 20($12), $pop14
	i32.store	$push16=, 24($12), $pop15
	i32.store	$1=, 28($12), $pop16
.LBB1_3:                                # %for.cond1
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.const	$push17=, 255
	i32.gt_s	$push18=, $5, $pop17
	br_if   	$pop18, 2       # 2: down to label2
# BB#4:                                 # %for.cond1.for.body3_crit_edge
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.load	$2=, 0($4)
	i32.const	$push19=, -8
	i32.add 	$3=, $5, $pop19
	i32.const	$push23=, 1
	i32.add 	$5=, $5, $pop23
	i32.add 	$4=, $4, $0
	i32.const	$push20=, 240
	i32.lt_u	$push21=, $3, $pop20
	i32.eq  	$push22=, $2, $pop21
	br_if   	$pop22, 0       # 0: up to label3
# BB#5:                                 # %if.then
	end_loop                        # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %for.end10
	end_block                       # label2:
	call    	exit@FUNCTION, $1
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
