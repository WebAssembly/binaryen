	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031204-1.c"
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	copy_local	$4=, $0
.LBB1_1:                                # %while.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	block   	
	block   	
	loop    	                # label2:
	i32.const	$5=, 0
	copy_local	$6=, $4
.LBB1_2:                                # %while.cond1
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	copy_local	$push30=, $6
	tee_local	$push29=, $7=, $pop30
	i32.const	$push28=, 1
	i32.add 	$6=, $pop29, $pop28
	i32.add 	$3=, $4, $5
	i32.const	$push27=, 1
	i32.add 	$push26=, $5, $pop27
	tee_local	$push25=, $2=, $pop26
	copy_local	$5=, $pop25
	i32.load8_u	$push24=, 0($3)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, -48
	i32.add 	$push1=, $pop23, $pop22
	i32.const	$push21=, 255
	i32.and 	$push2=, $pop1, $pop21
	i32.const	$push20=, 10
	i32.lt_u	$push3=, $pop2, $pop20
	br_if   	0, $pop3        # 0: up to label3
# BB#3:                                 # %while.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	block   	
	i32.const	$push31=, 1
	i32.eq  	$push4=, $2, $pop31
	br_if   	0, $pop4        # 0: down to label4
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$push35=, $4, $2
	tee_local	$push34=, $5=, $pop35
	i32.const	$push33=, -1
	i32.add 	$push0=, $pop34, $pop33
	i32.sub 	$push5=, $pop0, $4
	i32.const	$push32=, 4
	i32.ge_s	$push6=, $pop5, $pop32
	br_if   	2, $pop6        # 2: down to label1
# BB#5:                                 # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$4=, $5
	i32.const	$push41=, 3
	i32.eq  	$push7=, $1, $pop41
	i32.const	$push40=, 255
	i32.and 	$push8=, $3, $pop40
	i32.const	$push39=, 46
	i32.eq  	$push9=, $pop8, $pop39
	i32.or  	$push10=, $pop7, $pop9
	i32.add 	$push38=, $pop10, $1
	tee_local	$push37=, $1=, $pop38
	i32.const	$push36=, 4
	i32.lt_s	$push11=, $pop37, $pop36
	br_if   	1, $pop11       # 1: up to label2
	br      	3               # 3: down to label0
.LBB1_6:
	end_block                       # label4:
	end_loop
	copy_local	$7=, $4
	br      	1               # 1: down to label0
.LBB1_7:                                # %lor.lhs.false.while.end25_crit_edge
	end_block                       # label1:
	i32.add 	$push12=, $4, $2
	i32.const	$push13=, -1
	i32.add 	$7=, $pop12, $pop13
.LBB1_8:                                # %while.end25
	end_block                       # label0:
	i32.const	$5=, -1
	block   	
	i32.const	$push14=, 4
	i32.ne  	$push15=, $1, $pop14
	br_if   	0, $pop15       # 0: down to label5
# BB#9:                                 # %land.lhs.true
	block   	
	i32.load8_u	$push43=, 0($7)
	tee_local	$push42=, $6=, $pop43
	i32.eqz 	$push44=, $pop42
	br_if   	0, $pop44       # 0: down to label6
# BB#10:                                # %land.lhs.true
	i32.const	$push16=, 58
	i32.ne  	$push17=, $6, $pop16
	br_if   	1, $pop17       # 1: down to label5
# BB#11:                                # %if.then39
	i32.const	$push18=, 0
	i32.store8	0($7), $pop18
	i32.const	$push19=, 1
	i32.add 	$7=, $7, $pop19
.LBB1_12:                               # %if.end41
	end_block                       # label6:
	i32.call	$drop=, strcpy@FUNCTION, $0, $7
	i32.const	$5=, 168496141
.LBB1_13:                               # %if.end43
	end_block                       # label5:
	copy_local	$push45=, $5
                                        # fallthrough-return: $pop45
	.endfunc
.Lfunc_end1:
	.size	root_nfs_parse_addr, .Lfunc_end1-root_nfs_parse_addr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$3=, main.addr
.LBB2_1:                                # %while.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	block   	
	block   	
	loop    	                # label9:
	i32.const	$4=, 0
	copy_local	$5=, $3
.LBB2_2:                                # %while.cond1.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label10:
	copy_local	$push32=, $5
	tee_local	$push31=, $6=, $pop32
	i32.const	$push30=, 1
	i32.add 	$5=, $pop31, $pop30
	i32.add 	$2=, $3, $4
	i32.const	$push29=, 1
	i32.add 	$push28=, $4, $pop29
	tee_local	$push27=, $1=, $pop28
	copy_local	$4=, $pop27
	i32.load8_u	$push26=, 0($2)
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, -48
	i32.add 	$push1=, $pop25, $pop24
	i32.const	$push23=, 255
	i32.and 	$push2=, $pop1, $pop23
	i32.const	$push22=, 10
	i32.lt_u	$push3=, $pop2, $pop22
	br_if   	0, $pop3        # 0: up to label10
# BB#3:                                 # %while.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	block   	
	i32.const	$push33=, 1
	i32.eq  	$push4=, $1, $pop33
	br_if   	0, $pop4        # 0: down to label11
# BB#4:                                 # %lor.lhs.false.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$push37=, $3, $1
	tee_local	$push36=, $4=, $pop37
	i32.const	$push35=, -1
	i32.add 	$push0=, $pop36, $pop35
	i32.sub 	$push5=, $pop0, $3
	i32.const	$push34=, 4
	i32.ge_s	$push6=, $pop5, $pop34
	br_if   	2, $pop6        # 2: down to label8
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	copy_local	$3=, $4
	i32.const	$push43=, 3
	i32.eq  	$push7=, $0, $pop43
	i32.const	$push42=, 255
	i32.and 	$push8=, $2, $pop42
	i32.const	$push41=, 46
	i32.eq  	$push9=, $pop8, $pop41
	i32.or  	$push10=, $pop7, $pop9
	i32.add 	$push40=, $pop10, $0
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 4
	i32.lt_s	$push11=, $pop39, $pop38
	br_if   	1, $pop11       # 1: up to label9
	br      	3               # 3: down to label7
.LBB2_6:
	end_block                       # label11:
	end_loop
	copy_local	$6=, $3
	br      	1               # 1: down to label7
.LBB2_7:                                # %lor.lhs.false.i.while.end25.i_crit_edge
	end_block                       # label8:
	i32.add 	$push12=, $3, $1
	i32.const	$push13=, -1
	i32.add 	$6=, $pop12, $pop13
.LBB2_8:                                # %while.end25.i
	end_block                       # label7:
	block   	
	i32.const	$push14=, 4
	i32.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label12
# BB#9:                                 # %land.lhs.true.i
	block   	
	i32.load8_u	$push45=, 0($6)
	tee_local	$push44=, $4=, $pop45
	i32.eqz 	$push46=, $pop44
	br_if   	0, $pop46       # 0: down to label13
# BB#10:                                # %land.lhs.true.i
	i32.const	$push16=, 58
	i32.ne  	$push17=, $4, $pop16
	br_if   	1, $pop17       # 1: down to label12
# BB#11:                                # %if.then39.i
	i32.const	$push18=, 0
	i32.store8	0($6), $pop18
	i32.const	$push19=, 1
	i32.add 	$6=, $6, $pop19
.LBB2_12:                               # %if.end
	end_block                       # label13:
	i32.const	$push20=, main.addr
	i32.call	$drop=, strcpy@FUNCTION, $pop20, $6
	i32.const	$push21=, 0
	return  	$pop21
.LBB2_13:                               # %if.then
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
