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
	return  	$pop0
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
	i32.const	$1=, 0
	copy_local	$2=, $0
.LBB1_1:                                # %while.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	block
	loop                            # label1:
	copy_local	$3=, $2
.LBB1_2:                                # %while.cond1
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	copy_local	$push25=, $3
	tee_local	$push24=, $5=, $pop25
	i32.const	$push23=, 1
	i32.add 	$3=, $pop24, $pop23
	i32.load8_u	$push22=, 0($5)
	tee_local	$push21=, $4=, $pop22
	i32.const	$push20=, -48
	i32.add 	$push1=, $pop21, $pop20
	i32.const	$push19=, 255
	i32.and 	$push2=, $pop1, $pop19
	i32.const	$push18=, 10
	i32.lt_u	$push3=, $pop2, $pop18
	br_if   	0, $pop3        # 0: up to label3
# BB#3:                                 # %while.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label4:
	i32.eq  	$push4=, $5, $2
	br_if   	1, $pop4        # 1: down to label2
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.sub 	$push5=, $5, $2
	i32.const	$push26=, 3
	i32.gt_s	$push6=, $pop5, $pop26
	br_if   	2, $pop6        # 2: down to label0
# BB#5:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push30=, 3
	i32.eq  	$push9=, $1, $pop30
	i32.const	$push29=, 255
	i32.and 	$push7=, $4, $pop29
	i32.const	$push28=, 46
	i32.eq  	$push8=, $pop7, $pop28
	i32.or  	$push10=, $pop9, $pop8
	i32.add 	$1=, $pop10, $1
	copy_local	$2=, $3
	i32.const	$push27=, 4
	i32.lt_s	$push11=, $1, $pop27
	br_if   	0, $pop11       # 0: up to label1
	br      	2               # 2: down to label0
.LBB1_6:
	end_loop                        # label2:
	copy_local	$5=, $2
.LBB1_7:                                # %while.end25
	end_block                       # label0:
	i32.const	$3=, -1
	block
	i32.const	$push12=, 4
	i32.ne  	$push13=, $1, $pop12
	br_if   	0, $pop13       # 0: down to label5
# BB#8:                                 # %land.lhs.true
	block
	i32.load8_u	$push32=, 0($5)
	tee_local	$push31=, $4=, $pop32
	i32.const	$push33=, 0
	i32.eq  	$push34=, $pop31, $pop33
	br_if   	0, $pop34       # 0: down to label6
# BB#9:                                 # %land.lhs.true
	i32.const	$push14=, 58
	i32.ne  	$push15=, $4, $pop14
	br_if   	1, $pop15       # 1: down to label5
# BB#10:                                # %if.then39
	i32.const	$push17=, 0
	i32.store8	$discard=, 0($5), $pop17
	i32.const	$push16=, 1
	i32.add 	$push0=, $5, $pop16
	copy_local	$5=, $pop0
.LBB1_11:                               # %if.end41
	end_block                       # label6:
	i32.call	$discard=, strcpy@FUNCTION, $0, $5
	i32.const	$3=, 168496141
.LBB1_12:                               # %if.end43
	end_block                       # label5:
	return  	$3
	.endfunc
.Lfunc_end1:
	.size	root_nfs_parse_addr, .Lfunc_end1-root_nfs_parse_addr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, main.addr
.LBB2_1:                                # %while.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	block
	loop                            # label8:
	copy_local	$2=, $1
.LBB2_2:                                # %while.cond1.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	copy_local	$push27=, $2
	tee_local	$push26=, $4=, $pop27
	i32.const	$push25=, 1
	i32.add 	$2=, $pop26, $pop25
	i32.load8_u	$push24=, 0($4)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, -48
	i32.add 	$push1=, $pop23, $pop22
	i32.const	$push21=, 255
	i32.and 	$push2=, $pop1, $pop21
	i32.const	$push20=, 10
	i32.lt_u	$push3=, $pop2, $pop20
	br_if   	0, $pop3        # 0: up to label10
# BB#3:                                 # %while.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label11:
	i32.eq  	$push4=, $4, $1
	br_if   	1, $pop4        # 1: down to label9
# BB#4:                                 # %lor.lhs.false.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.sub 	$push5=, $4, $1
	i32.const	$push28=, 3
	i32.gt_s	$push6=, $pop5, $pop28
	br_if   	2, $pop6        # 2: down to label7
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push32=, 3
	i32.eq  	$push9=, $0, $pop32
	i32.const	$push31=, 255
	i32.and 	$push7=, $3, $pop31
	i32.const	$push30=, 46
	i32.eq  	$push8=, $pop7, $pop30
	i32.or  	$push10=, $pop9, $pop8
	i32.add 	$0=, $pop10, $0
	copy_local	$1=, $2
	i32.const	$push29=, 4
	i32.lt_s	$push11=, $0, $pop29
	br_if   	0, $pop11       # 0: up to label8
	br      	2               # 2: down to label7
.LBB2_6:
	end_loop                        # label9:
	copy_local	$4=, $1
.LBB2_7:                                # %while.end25.i
	end_block                       # label7:
	block
	i32.const	$push12=, 4
	i32.ne  	$push13=, $0, $pop12
	br_if   	0, $pop13       # 0: down to label12
# BB#8:                                 # %land.lhs.true.i
	block
	i32.load8_u	$push34=, 0($4)
	tee_local	$push33=, $2=, $pop34
	i32.const	$push35=, 0
	i32.eq  	$push36=, $pop33, $pop35
	br_if   	0, $pop36       # 0: down to label13
# BB#9:                                 # %land.lhs.true.i
	i32.const	$push14=, 58
	i32.ne  	$push15=, $2, $pop14
	br_if   	1, $pop15       # 1: down to label12
# BB#10:                                # %if.then39.i
	i32.const	$push17=, 0
	i32.store8	$discard=, 0($4), $pop17
	i32.const	$push16=, 1
	i32.add 	$push0=, $4, $pop16
	copy_local	$4=, $pop0
.LBB2_11:                               # %if.end
	end_block                       # label13:
	i32.const	$push18=, main.addr
	i32.call	$discard=, strcpy@FUNCTION, $pop18, $4
	i32.const	$push19=, 0
	return  	$pop19
.LBB2_12:                               # %if.then
	end_block                       # label12:
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


	.ident	"clang version 3.9.0 "
