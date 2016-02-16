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
	i32.const	$push0=, 1
	i32.store	$4=, 12($12), $pop0
	i32.const	$0=, 2
	i32.const	$1=, 2
	copy_local	$2=, $4
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label5:
	i32.const	$push18=, 16
	i32.const	$10=, 12
	i32.add 	$10=, $12, $10
	i32.call	$3=, foo@FUNCTION, $10, $pop18
	copy_local	$5=, $0
	block
	i32.const	$push17=, -1
	i32.add 	$push16=, $1, $pop17
	tee_local	$push15=, $6=, $pop16
	i32.const	$push14=, -8
	i32.and 	$push1=, $pop15, $pop14
	i32.const	$push13=, 8
	i32.eq  	$push2=, $pop1, $pop13
	br_if   	0, $pop2        # 0: down to label7
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push20=, -4
	i32.and 	$push3=, $6, $pop20
	i32.const	$push19=, 4
	i32.ne  	$push4=, $pop3, $pop19
	br_if   	0, $pop4        # 0: down to label8
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 2
	i32.shl 	$5=, $2, $pop21
	br      	1               # 1: down to label7
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push24=, 24
	i32.const	$push23=, 16
	i32.const	$push22=, 4
	i32.eq  	$push5=, $1, $pop22
	i32.select	$5=, $pop24, $pop23, $pop5
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.ne  	$push6=, $3, $5
	br_if   	2, $pop6        # 2: down to label4
# BB#6:                                 # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push26=, 7
	i32.const	$11=, 12
	i32.add 	$11=, $12, $11
	i32.call	$3=, foo@FUNCTION, $11, $pop26
	copy_local	$5=, $2
	block
	i32.const	$push25=, 6
	i32.gt_s	$push7=, $6, $pop25
	br_if   	0, $pop7        # 0: down to label9
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$5=, $0
	i32.const	$push27=, 3
	i32.gt_s	$push8=, $6, $pop27
	br_if   	0, $pop8        # 0: down to label9
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push30=, 12
	i32.const	$push29=, 8
	i32.const	$push28=, 4
	i32.eq  	$push9=, $1, $pop28
	i32.select	$5=, $pop30, $pop29, $pop9
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push10=, $3, $5
	br_if   	3, $pop10       # 3: down to label3
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$2=, $2, $4
	i32.const	$push34=, 2
	i32.add 	$0=, $0, $pop34
	i32.store	$push33=, 12($12), $1
	tee_local	$push32=, $6=, $pop33
	i32.add 	$1=, $pop32, $4
	i32.const	$push31=, 17
	i32.lt_s	$push11=, $6, $pop31
	br_if   	0, $pop11       # 0: up to label5
# BB#11:                                # %for.end
	end_loop                        # label6:
	i32.const	$push12=, 0
	i32.const	$9=, 16
	i32.add 	$12=, $12, $9
	i32.const	$9=, __stack_pointer
	i32.store	$12=, 0($9), $12
	return  	$pop12
.LBB1_12:                               # %if.then17
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %if.then36
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
