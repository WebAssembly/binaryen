	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-15.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.le_u	$push0=, $1, $0
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push5=, -4
	i32.add 	$push4=, $1, $pop5
	tee_local	$push3=, $2=, $pop4
	i32.load	$push1=, 0($pop3)
	i32.store	0($1), $pop1
	copy_local	$1=, $2
	i32.gt_u	$push2=, $2, $0
	br_if   	0, $pop2        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 32
	i32.sub 	$push28=, $pop17, $pop19
	tee_local	$push27=, $11=, $pop28
	i32.store	__stack_pointer($pop20), $pop27
	i32.const	$6=, 0
	i32.const	$2=, -1
	i32.const	$push2=, 16
	i32.add 	$7=, $11, $pop2
	i32.const	$push26=, 4
	i32.or  	$push25=, $11, $pop26
	tee_local	$push24=, $0=, $pop25
	copy_local	$1=, $pop24
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_13 Depth 3
	block   	
	loop    	                # label3:
	copy_local	$push31=, $6
	tee_local	$push30=, $3=, $pop31
	i32.const	$push29=, 2
	i32.shl 	$push1=, $pop30, $pop29
	i32.add 	$4=, $11, $pop1
	copy_local	$5=, $0
	i32.const	$6=, 0
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_13 Depth 3
	loop    	                # label4:
	i32.const	$push34=, 4
	i32.store	0($7), $pop34
	i64.const	$push33=, 4294967296
	i64.store	0($11), $pop33
	i64.const	$push32=, 12884901890
	i64.store	8($11), $pop32
	block   	
	i32.le_s	$push3=, $6, $3
	br_if   	0, $pop3        # 0: down to label5
# BB#3:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push35=, 2
	i32.shl 	$push4=, $6, $pop35
	i32.add 	$10=, $11, $pop4
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label6:
	i32.const	$push38=, -4
	i32.add 	$push37=, $10, $pop38
	tee_local	$push36=, $9=, $pop37
	i32.load	$push5=, 0($pop36)
	i32.store	0($10), $pop5
	copy_local	$10=, $9
	i32.gt_u	$push6=, $9, $4
	br_if   	0, $pop6        # 0: up to label6
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label5:
	i32.const	$10=, -1
	copy_local	$9=, $11
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label7:
	i32.const	$push41=, 1
	i32.add 	$push40=, $10, $pop41
	tee_local	$push39=, $10=, $pop40
	i32.load	$push7=, 0($9)
	i32.ne  	$push8=, $pop39, $pop7
	br_if   	3, $pop8        # 3: down to label2
# BB#7:                                 # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.const	$push42=, 4
	i32.add 	$9=, $9, $pop42
	i32.lt_s	$push9=, $10, $3
	br_if   	0, $pop9        # 0: up to label7
# BB#8:                                 #   in Loop: Header=BB1_2 Depth=2
	end_loop
	copy_local	$9=, $1
	copy_local	$10=, $2
.LBB1_9:                                # %for.cond17
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label9:
	i32.const	$push45=, 1
	i32.add 	$push44=, $10, $pop45
	tee_local	$push43=, $10=, $pop44
	i32.ge_s	$push10=, $pop43, $6
	br_if   	1, $pop10       # 1: down to label8
# BB#10:                                # %for.body19
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.load	$8=, 0($9)
	i32.const	$push46=, 4
	i32.add 	$push0=, $9, $pop46
	copy_local	$9=, $pop0
	i32.eq  	$push16=, $10, $8
	br_if   	0, $pop16       # 0: up to label9
	br      	4               # 4: down to label2
.LBB1_11:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label8:
	block   	
	i32.const	$push49=, 3
	i32.gt_s	$push48=, $6, $pop49
	tee_local	$push47=, $9=, $pop48
	br_if   	0, $pop47       # 0: down to label10
# BB#12:                                #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push50=, 1
	i32.add 	$8=, $6, $pop50
	copy_local	$10=, $5
.LBB1_13:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label11:
	i32.const	$push53=, 1
	i32.add 	$push52=, $6, $pop53
	tee_local	$push51=, $6=, $pop52
	i32.load	$push11=, 0($10)
	i32.ne  	$push12=, $pop51, $pop11
	br_if   	4, $pop12       # 4: down to label2
# BB#14:                                # %for.cond28
                                        #   in Loop: Header=BB1_13 Depth=3
	i32.const	$push55=, 4
	i32.add 	$10=, $10, $pop55
	i32.const	$push54=, 3
	i32.le_s	$push13=, $6, $pop54
	br_if   	0, $pop13       # 0: up to label11
# BB#15:                                # %for.cond1.loopexit
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push56=, 4
	i32.add 	$5=, $5, $pop56
	copy_local	$6=, $8
	i32.eqz 	$push61=, $9
	br_if   	1, $pop61       # 1: up to label4
.LBB1_16:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	end_loop
	i32.const	$push60=, 4
	i32.add 	$1=, $1, $pop60
	i32.const	$push59=, 1
	i32.add 	$2=, $2, $pop59
	i32.const	$push58=, 1
	i32.add 	$6=, $3, $pop58
	i32.const	$push57=, 4
	i32.lt_s	$push14=, $3, $pop57
	br_if   	0, $pop14       # 0: up to label3
# BB#17:                                # %for.end43
	end_loop
	i32.const	$push23=, 0
	i32.const	$push21=, 32
	i32.add 	$push22=, $11, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_18:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
