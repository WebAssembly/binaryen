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
	i32.const	$1=, 0
	copy_local	$3=, $0
.LBB1_1:                                # %while.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	block
	loop                            # label1:
	copy_local	$4=, $3
.LBB1_2:                                # %while.cond1
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	copy_local	$push24=, $4
	tee_local	$push23=, $5=, $pop24
	i32.const	$push22=, 1
	i32.add 	$4=, $pop23, $pop22
	i32.load8_u	$push21=, 0($5)
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, -48
	i32.add 	$push0=, $pop20, $pop19
	i32.const	$push18=, 255
	i32.and 	$push1=, $pop0, $pop18
	i32.const	$push17=, 10
	i32.lt_u	$push2=, $pop1, $pop17
	br_if   	0, $pop2        # 0: up to label3
# BB#3:                                 # %while.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label4:
	i32.eq  	$push3=, $5, $3
	br_if   	1, $pop3        # 1: down to label2
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.sub 	$push4=, $5, $3
	i32.const	$push25=, 3
	i32.gt_s	$push5=, $pop4, $pop25
	br_if   	2, $pop5        # 2: down to label0
# BB#5:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$3=, $4
	i32.const	$push31=, 3
	i32.eq  	$push6=, $1, $pop31
	i32.const	$push30=, 255
	i32.and 	$push7=, $2, $pop30
	i32.const	$push29=, 46
	i32.eq  	$push8=, $pop7, $pop29
	i32.or  	$push9=, $pop6, $pop8
	i32.add 	$push28=, $pop9, $1
	tee_local	$push27=, $1=, $pop28
	i32.const	$push26=, 4
	i32.lt_s	$push10=, $pop27, $pop26
	br_if   	0, $pop10       # 0: up to label1
	br      	2               # 2: down to label0
.LBB1_6:
	end_loop                        # label2:
	copy_local	$5=, $3
.LBB1_7:                                # %while.end25
	end_block                       # label0:
	i32.const	$4=, -1
	block
	i32.const	$push11=, 4
	i32.ne  	$push12=, $1, $pop11
	br_if   	0, $pop12       # 0: down to label5
# BB#8:                                 # %land.lhs.true
	block
	i32.load8_u	$push33=, 0($5)
	tee_local	$push32=, $2=, $pop33
	i32.eqz 	$push34=, $pop32
	br_if   	0, $pop34       # 0: down to label6
# BB#9:                                 # %land.lhs.true
	i32.const	$push13=, 58
	i32.ne  	$push14=, $2, $pop13
	br_if   	1, $pop14       # 1: down to label5
# BB#10:                                # %if.then39
	i32.const	$push15=, 0
	i32.store8	$drop=, 0($5), $pop15
	i32.const	$push16=, 1
	i32.add 	$5=, $5, $pop16
.LBB1_11:                               # %if.end41
	end_block                       # label6:
	i32.call	$drop=, strcpy@FUNCTION, $0, $5
	i32.const	$4=, 168496141
.LBB1_12:                               # %if.end43
	end_block                       # label5:
	copy_local	$push35=, $4
                                        # fallthrough-return: $pop35
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
	i32.const	$2=, main.addr
.LBB2_1:                                # %while.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	block
	loop                            # label8:
	copy_local	$3=, $2
.LBB2_2:                                # %while.cond1.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	copy_local	$push26=, $3
	tee_local	$push25=, $4=, $pop26
	i32.const	$push24=, 1
	i32.add 	$3=, $pop25, $pop24
	i32.load8_u	$push23=, 0($4)
	tee_local	$push22=, $1=, $pop23
	i32.const	$push21=, -48
	i32.add 	$push0=, $pop22, $pop21
	i32.const	$push20=, 255
	i32.and 	$push1=, $pop0, $pop20
	i32.const	$push19=, 10
	i32.lt_u	$push2=, $pop1, $pop19
	br_if   	0, $pop2        # 0: up to label10
# BB#3:                                 # %while.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label11:
	i32.eq  	$push3=, $4, $2
	br_if   	1, $pop3        # 1: down to label9
# BB#4:                                 # %lor.lhs.false.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.sub 	$push4=, $4, $2
	i32.const	$push27=, 3
	i32.gt_s	$push5=, $pop4, $pop27
	br_if   	2, $pop5        # 2: down to label7
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$2=, $3
	i32.const	$push33=, 3
	i32.eq  	$push6=, $0, $pop33
	i32.const	$push32=, 255
	i32.and 	$push7=, $1, $pop32
	i32.const	$push31=, 46
	i32.eq  	$push8=, $pop7, $pop31
	i32.or  	$push9=, $pop6, $pop8
	i32.add 	$push30=, $pop9, $0
	tee_local	$push29=, $0=, $pop30
	i32.const	$push28=, 4
	i32.lt_s	$push10=, $pop29, $pop28
	br_if   	0, $pop10       # 0: up to label8
	br      	2               # 2: down to label7
.LBB2_6:
	end_loop                        # label9:
	copy_local	$4=, $2
.LBB2_7:                                # %while.end25.i
	end_block                       # label7:
	block
	i32.const	$push11=, 4
	i32.ne  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label12
# BB#8:                                 # %land.lhs.true.i
	block
	i32.load8_u	$push35=, 0($4)
	tee_local	$push34=, $3=, $pop35
	i32.eqz 	$push36=, $pop34
	br_if   	0, $pop36       # 0: down to label13
# BB#9:                                 # %land.lhs.true.i
	i32.const	$push13=, 58
	i32.ne  	$push14=, $3, $pop13
	br_if   	1, $pop14       # 1: down to label12
# BB#10:                                # %if.then39.i
	i32.const	$push15=, 0
	i32.store8	$drop=, 0($4), $pop15
	i32.const	$push16=, 1
	i32.add 	$4=, $4, $pop16
.LBB2_11:                               # %if.end
	end_block                       # label13:
	i32.const	$push17=, main.addr
	i32.call	$drop=, strcpy@FUNCTION, $pop17, $4
	i32.const	$push18=, 0
	return  	$pop18
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
