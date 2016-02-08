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
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	copy_local	$0=, $2
	i32.ge_s	$push2=, $2, $1
	br_if   	0, $pop2        # 0: down to label0
.LBB0_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$0=, $2
	i32.const	$push4=, 1
	i32.shl 	$2=, $0, $pop4
	i32.lt_s	$push3=, $0, $1
	br_if   	0, $pop3        # 0: up to label1
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$12=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	i32.const	$push1=, 1
	i32.store	$4=, 12($12), $pop1
	i32.const	$0=, 2
	i32.const	$1=, 2
	copy_local	$2=, $4
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label5:
	i32.const	$push19=, 16
	i32.const	$10=, 12
	i32.add 	$10=, $12, $10
	i32.call	$3=, foo@FUNCTION, $10, $pop19
	copy_local	$5=, $0
	block
	i32.const	$push18=, -1
	i32.add 	$push0=, $1, $pop18
	tee_local	$push17=, $6=, $pop0
	i32.const	$push16=, -8
	i32.and 	$push2=, $pop17, $pop16
	i32.const	$push15=, 8
	i32.eq  	$push3=, $pop2, $pop15
	br_if   	0, $pop3        # 0: down to label7
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push21=, -4
	i32.and 	$push4=, $6, $pop21
	i32.const	$push20=, 4
	i32.ne  	$push5=, $pop4, $pop20
	br_if   	0, $pop5        # 0: down to label8
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push22=, 2
	i32.shl 	$5=, $2, $pop22
	br      	1               # 1: down to label7
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push25=, 24
	i32.const	$push24=, 16
	i32.const	$push23=, 4
	i32.eq  	$push6=, $1, $pop23
	i32.select	$5=, $pop25, $pop24, $pop6
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.ne  	$push7=, $3, $5
	br_if   	3, $pop7        # 3: down to label3
# BB#6:                                 # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push27=, 7
	i32.const	$11=, 12
	i32.add 	$11=, $12, $11
	i32.call	$3=, foo@FUNCTION, $11, $pop27
	copy_local	$5=, $2
	block
	i32.const	$push26=, 6
	i32.gt_s	$push8=, $6, $pop26
	br_if   	0, $pop8        # 0: down to label9
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$5=, $0
	i32.const	$push28=, 3
	i32.gt_s	$push9=, $6, $pop28
	br_if   	0, $pop9        # 0: down to label9
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push31=, 12
	i32.const	$push30=, 8
	i32.const	$push29=, 4
	i32.eq  	$push10=, $1, $pop29
	i32.select	$5=, $pop31, $pop30, $pop10
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push11=, $3, $5
	br_if   	2, $pop11       # 2: down to label4
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$2=, $2, $4
	i32.const	$push34=, 2
	i32.add 	$0=, $0, $pop34
	i32.store	$push12=, 12($12), $1
	tee_local	$push33=, $6=, $pop12
	i32.add 	$1=, $pop33, $4
	i32.const	$push32=, 17
	i32.lt_s	$push13=, $6, $pop32
	br_if   	0, $pop13       # 0: up to label5
# BB#11:                                # %for.end
	end_loop                        # label6:
	i32.const	$push14=, 0
	i32.const	$9=, 16
	i32.add 	$12=, $12, $9
	i32.const	$9=, __stack_pointer
	i32.store	$12=, 0($9), $12
	return  	$pop14
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
