	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031204-1.c"
	.section	.text.in_aton,"ax",@progbits
	.hidden	in_aton
	.globl	in_aton
	.type	in_aton,@function
in_aton:                                # @in_aton
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 168496141
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	in_aton, .Lfunc_end0-in_aton

	.section	.text.root_nfs_parse_addr,"ax",@progbits
	.hidden	root_nfs_parse_addr
	.globl	root_nfs_parse_addr
	.type	root_nfs_parse_addr,@function
root_nfs_parse_addr:                    # @root_nfs_parse_addr
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 16
	i32.sub 	$push29=, $pop22, $pop23
	tee_local	$push28=, $5=, $pop29
	i32.store	$drop=, __stack_pointer($pop24), $pop28
	i32.const	$1=, 0
	copy_local	$4=, $0
.LBB1_1:                                # %while.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	loop                            # label0:
	i32.store	$drop=, 12($5), $4
	copy_local	$2=, $4
	block
	i32.load8_u	$push35=, 0($4)
	tee_local	$push34=, $3=, $pop35
	i32.const	$push33=, -48
	i32.add 	$push0=, $pop34, $pop33
	i32.const	$push32=, 255
	i32.and 	$push1=, $pop0, $pop32
	i32.const	$push31=, 9
	i32.gt_u	$push2=, $pop1, $pop31
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %while.body7.preheader
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$2=, $4
.LBB1_3:                                # %while.body7
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.const	$push43=, 1
	i32.add 	$push42=, $2, $pop43
	tee_local	$push41=, $2=, $pop42
	i32.load8_u	$push40=, 0($pop41)
	tee_local	$push39=, $3=, $pop40
	i32.const	$push38=, -48
	i32.add 	$push3=, $pop39, $pop38
	i32.const	$push37=, 255
	i32.and 	$push4=, $pop3, $pop37
	i32.const	$push36=, 10
	i32.lt_u	$push5=, $pop4, $pop36
	br_if   	0, $pop5        # 0: up to label3
# BB#4:                                 # %while.cond1.while.end_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label4:
	i32.store	$drop=, 12($5), $2
.LBB1_5:                                # %while.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.eq  	$push6=, $2, $4
	br_if   	1, $pop6        # 1: down to label1
# BB#6:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.sub 	$push7=, $2, $4
	i32.const	$push44=, 3
	i32.gt_s	$push8=, $pop7, $pop44
	br_if   	1, $pop8        # 1: down to label1
# BB#7:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push50=, 3
	i32.eq  	$push9=, $1, $pop50
	i32.const	$push49=, 255
	i32.and 	$push10=, $3, $pop49
	i32.const	$push48=, 46
	i32.eq  	$push11=, $pop10, $pop48
	i32.or  	$push12=, $pop9, $pop11
	i32.add 	$push47=, $pop12, $1
	tee_local	$push46=, $1=, $pop47
	i32.const	$push45=, 3
	i32.gt_s	$push13=, $pop46, $pop45
	br_if   	1, $pop13       # 1: down to label1
# BB#8:                                 # %if.end24.thread
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push30=, 1
	i32.add 	$4=, $2, $pop30
	br      	0               # 0: up to label0
.LBB1_9:                                # %while.end25
	end_loop                        # label1:
	i32.const	$3=, -1
	block
	i32.const	$push14=, 4
	i32.ne  	$push15=, $1, $pop14
	br_if   	0, $pop15       # 0: down to label5
# BB#10:                                # %land.lhs.true
	block
	i32.load8_u	$push52=, 0($2)
	tee_local	$push51=, $4=, $pop52
	i32.eqz 	$push53=, $pop51
	br_if   	0, $pop53       # 0: down to label6
# BB#11:                                # %land.lhs.true
	i32.const	$push16=, 58
	i32.ne  	$push17=, $4, $pop16
	br_if   	1, $pop17       # 1: down to label5
# BB#12:                                # %if.then39
	i32.const	$push18=, 1
	i32.add 	$push19=, $2, $pop18
	i32.store	$drop=, 12($5), $pop19
	i32.const	$push20=, 0
	i32.store8	$drop=, 0($2), $pop20
	i32.load	$2=, 12($5)
.LBB1_13:                               # %if.end41
	end_block                       # label6:
	i32.call	$drop=, strcpy@FUNCTION, $0, $2
	i32.const	$3=, 168496141
.LBB1_14:                               # %if.end43
	end_block                       # label5:
	i32.const	$push27=, 0
	i32.const	$push25=, 16
	i32.add 	$push26=, $5, $pop25
	i32.store	$drop=, __stack_pointer($pop27), $pop26
	copy_local	$push54=, $3
                                        # fallthrough-return: $pop54
	.endfunc
.Lfunc_end1:
	.size	root_nfs_parse_addr, .Lfunc_end1-root_nfs_parse_addr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.const	$push32=, 0
	i32.load8_u	$push0=, main.addr($pop32)
	i32.const	$push31=, -48
	i32.add 	$push1=, $pop0, $pop31
	i32.const	$push30=, 255
	i32.and 	$push2=, $pop1, $pop30
	i32.const	$push3=, 9
	i32.gt_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label7
# BB#1:                                 # %while.body7.i.preheader.preheader
	i32.const	$1=, main.addr
.LBB2_2:                                # %while.body7.i.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
	block
	block
	loop                            # label10:
	i32.const	$4=, 0
	copy_local	$5=, $1
.LBB2_3:                                # %while.body7.i
                                        #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i32.const	$push42=, 1
	i32.add 	$5=, $5, $pop42
	i32.add 	$3=, $1, $4
	i32.const	$push41=, 1
	i32.add 	$push40=, $4, $pop41
	tee_local	$push39=, $2=, $pop40
	copy_local	$4=, $pop39
	i32.const	$push38=, 1
	i32.add 	$push5=, $3, $pop38
	i32.load8_u	$push37=, 0($pop5)
	tee_local	$push36=, $3=, $pop37
	i32.const	$push35=, -48
	i32.add 	$push6=, $pop36, $pop35
	i32.const	$push34=, 255
	i32.and 	$push7=, $pop6, $pop34
	i32.const	$push33=, 10
	i32.lt_u	$push8=, $pop7, $pop33
	br_if   	0, $pop8        # 0: up to label12
# BB#4:                                 # %while.end.i
                                        #   in Loop: Header=BB2_2 Depth=1
	end_loop                        # label13:
	i32.eqz 	$push60=, $2
	br_if   	1, $pop60       # 1: down to label11
# BB#5:                                 # %lor.lhs.false.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.add 	$push45=, $1, $2
	tee_local	$push44=, $4=, $pop45
	i32.sub 	$push9=, $pop44, $1
	i32.const	$push43=, 3
	i32.gt_s	$push10=, $pop9, $pop43
	br_if   	2, $pop10       # 2: down to label9
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push51=, 3
	i32.eq  	$push11=, $0, $pop51
	i32.const	$push50=, 255
	i32.and 	$push12=, $3, $pop50
	i32.const	$push49=, 46
	i32.eq  	$push13=, $pop12, $pop49
	i32.or  	$push14=, $pop11, $pop13
	i32.add 	$push48=, $pop14, $0
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 4
	i32.ge_s	$push15=, $pop47, $pop46
	br_if   	3, $pop15       # 3: down to label8
# BB#7:                                 # %if.end24.thread.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.add 	$push16=, $1, $2
	i32.const	$push57=, 1
	i32.add 	$push56=, $pop16, $pop57
	tee_local	$push55=, $1=, $pop56
	i32.load8_u	$push17=, 0($pop55)
	i32.const	$push54=, -48
	i32.add 	$push18=, $pop17, $pop54
	i32.const	$push53=, 255
	i32.and 	$push19=, $pop18, $pop53
	i32.const	$push52=, 10
	i32.lt_u	$push20=, $pop19, $pop52
	br_if   	0, $pop20       # 0: up to label10
	br      	4               # 4: down to label7
.LBB2_8:
	end_loop                        # label11:
	copy_local	$4=, $1
	br      	1               # 1: down to label8
.LBB2_9:
	end_block                       # label9:
	copy_local	$4=, $5
.LBB2_10:                               # %while.end25.i
	end_block                       # label8:
	i32.const	$push21=, 4
	i32.ne  	$push22=, $0, $pop21
	br_if   	0, $pop22       # 0: down to label7
# BB#11:                                # %land.lhs.true.i
	block
	i32.load8_u	$push59=, 0($4)
	tee_local	$push58=, $5=, $pop59
	i32.eqz 	$push61=, $pop58
	br_if   	0, $pop61       # 0: down to label14
# BB#12:                                # %land.lhs.true.i
	i32.const	$push23=, 58
	i32.ne  	$push24=, $5, $pop23
	br_if   	1, $pop24       # 1: down to label7
# BB#13:                                # %if.then39.i
	i32.const	$push25=, 0
	i32.store8	$drop=, 0($4), $pop25
	i32.add 	$push26=, $1, $2
	i32.const	$push27=, 1
	i32.add 	$4=, $pop26, $pop27
.LBB2_14:                               # %if.end
	end_block                       # label14:
	i32.const	$push28=, main.addr
	i32.call	$drop=, strcpy@FUNCTION, $pop28, $4
	i32.const	$push29=, 0
	return  	$pop29
.LBB2_15:                               # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	main.addr,@object       # @main.addr
	.section	.data.main.addr,"aw",@progbits
	.p2align	4
main.addr:
	.asciz	"10.11.12.13:/hello"
	.size	main.addr, 19


	.ident	"clang version 4.0.0 "
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
