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
	i32.load	$0=, 0($0)
	block
	block
	i32.const	$push0=, 16
	i32.gt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.ge_s	$push2=, $0, $1
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %while.cond.preheader
.LBB0_3:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push8=, $0
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 1
	i32.shl 	$0=, $pop7, $pop6
	i32.lt_s	$push3=, $2, $1
	br_if   	0, $pop3        # 0: up to label2
# BB#4:                                 # %if.end
	end_loop                        # label3:
	return  	$2
.LBB0_5:
	end_block                       # label1:
	copy_local	$push5=, $0
	return  	$pop5
.LBB0_6:
	end_block                       # label0:
	copy_local	$push4=, $0
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push25=, $pop15, $pop16
	i32.store	$push27=, 0($pop17), $pop25
	tee_local	$push26=, $6=, $pop27
	i32.const	$push1=, 1
	i32.store	$0=, 12($pop26), $pop1
	i32.const	$1=, 2
	i32.const	$2=, 2
	i32.const	$3=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	i32.const	$push21=, 12
	i32.add 	$push22=, $6, $pop21
	i32.const	$push33=, 16
	i32.call	$4=, foo@FUNCTION, $pop22, $pop33
	copy_local	$5=, $1
	block
	i32.const	$push32=, -1
	i32.add 	$push31=, $2, $pop32
	tee_local	$push30=, $7=, $pop31
	i32.const	$push29=, -8
	i32.and 	$push2=, $pop30, $pop29
	i32.const	$push28=, 8
	i32.eq  	$push3=, $pop2, $pop28
	br_if   	0, $pop3        # 0: down to label7
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push35=, -4
	i32.and 	$push4=, $7, $pop35
	i32.const	$push34=, 4
	i32.ne  	$push5=, $pop4, $pop34
	br_if   	0, $pop5        # 0: down to label8
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push36=, 2
	i32.shl 	$5=, $3, $pop36
	br      	1               # 1: down to label7
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push39=, 24
	i32.const	$push38=, 16
	i32.const	$push37=, 4
	i32.eq  	$push6=, $2, $pop37
	i32.select	$5=, $pop39, $pop38, $pop6
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.ne  	$push7=, $4, $5
	br_if   	2, $pop7        # 2: down to label4
# BB#6:                                 # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push23=, 12
	i32.add 	$push24=, $6, $pop23
	i32.const	$push41=, 7
	i32.call	$4=, foo@FUNCTION, $pop24, $pop41
	copy_local	$5=, $3
	block
	i32.const	$push40=, 6
	i32.gt_s	$push8=, $7, $pop40
	br_if   	0, $pop8        # 0: down to label9
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$5=, $1
	i32.const	$push42=, 3
	i32.gt_s	$push9=, $7, $pop42
	br_if   	0, $pop9        # 0: down to label9
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push45=, 12
	i32.const	$push44=, 8
	i32.const	$push43=, 4
	i32.eq  	$push10=, $2, $pop43
	i32.select	$5=, $pop45, $pop44, $pop10
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push11=, $4, $5
	br_if   	2, $pop11       # 2: down to label4
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$3=, $3, $0
	i32.const	$push49=, 2
	i32.add 	$1=, $1, $pop49
	i32.store	$push48=, 12($6), $2
	tee_local	$push47=, $7=, $pop48
	i32.add 	$push0=, $pop47, $0
	copy_local	$2=, $pop0
	i32.const	$push46=, 17
	i32.lt_s	$push12=, $7, $pop46
	br_if   	0, $pop12       # 0: up to label5
# BB#11:                                # %for.end
	end_loop                        # label6:
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 16
	i32.add 	$push19=, $6, $pop18
	i32.store	$discard=, 0($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_12:                               # %if.then36
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
