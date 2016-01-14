	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59358.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($0)
	copy_local	$0=, $2
	block
	i32.const	$push0=, 16
	i32.gt_s	$push1=, $1, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %entry
	copy_local	$0=, $2
	i32.ge_s	$push2=, $2, $1
	br_if   	$pop2, 0        # 0: down to label0
.LBB0_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$0=, $2
	i32.const	$push4=, 1
	i32.shl 	$2=, $0, $pop4
	i32.lt_s	$push3=, $0, $1
	br_if   	$pop3, 0        # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$13=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$13=, 0($9), $13
	i32.const	$0=, 2
	i32.const	$push0=, 1
	i32.store	$2=, 12($13), $pop0
	copy_local	$1=, $0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label5:
	i32.const	$5=, 16
	i32.const	$push1=, -1
	i32.add 	$3=, $1, $pop1
	i32.const	$11=, 12
	i32.add 	$11=, $13, $11
	i32.call	$4=, foo@FUNCTION, $11, $5
	i32.const	$6=, 8
	copy_local	$7=, $0
	block
	i32.const	$push2=, -8
	i32.and 	$push3=, $3, $pop2
	i32.eq  	$push4=, $pop3, $6
	br_if   	$pop4, 0        # 0: down to label7
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$7=, 4
	block
	i32.const	$push5=, -4
	i32.and 	$push6=, $3, $pop5
	i32.ne  	$push7=, $pop6, $7
	br_if   	$pop7, 0        # 0: down to label8
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 2
	i32.shl 	$7=, $2, $pop10
	br      	1               # 1: down to label7
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.eq  	$push8=, $1, $7
	i32.const	$push9=, 24
	i32.select	$7=, $pop8, $pop9, $5
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.ne  	$push11=, $4, $7
	br_if   	$pop11, 3       # 3: down to label3
# BB#6:                                 # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 7
	i32.const	$12=, 12
	i32.add 	$12=, $13, $12
	i32.call	$5=, foo@FUNCTION, $12, $pop12
	copy_local	$7=, $2
	block
	i32.const	$push13=, 6
	i32.gt_s	$push14=, $3, $pop13
	br_if   	$pop14, 0       # 0: down to label9
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$7=, $0
	i32.const	$push15=, 3
	i32.gt_s	$push16=, $3, $pop15
	br_if   	$pop16, 0       # 0: down to label9
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push17=, 4
	i32.eq  	$push18=, $1, $pop17
	i32.const	$push19=, 12
	i32.select	$7=, $pop18, $pop19, $6
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push20=, $5, $7
	br_if   	$pop20, 2       # 2: down to label4
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 2
	i32.add 	$0=, $0, $pop21
	i32.const	$3=, 1
	i32.add 	$2=, $2, $3
	i32.store	$7=, 12($13), $1
	i32.add 	$1=, $7, $3
	i32.const	$push22=, 17
	i32.lt_s	$push23=, $7, $pop22
	br_if   	$pop23, 0       # 0: up to label5
# BB#11:                                # %for.end
	end_loop                        # label6:
	i32.const	$push24=, 0
	i32.const	$10=, 16
	i32.add 	$13=, $13, $10
	i32.const	$10=, __stack_pointer
	i32.store	$13=, 0($10), $13
	return  	$pop24
.LBB1_12:                               # %if.then36
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %if.then17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
