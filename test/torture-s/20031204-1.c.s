	.text
	.file	"20031204-1.c"
	.section	.text.in_aton,"ax",@progbits
	.hidden	in_aton                 # -- Begin function in_aton
	.globl	in_aton
	.type	in_aton,@function
in_aton:                                # @in_aton
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 168496141
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	in_aton, .Lfunc_end0-in_aton
                                        # -- End function
	.section	.text.root_nfs_parse_addr,"ax",@progbits
	.hidden	root_nfs_parse_addr     # -- Begin function root_nfs_parse_addr
	.globl	root_nfs_parse_addr
	.type	root_nfs_parse_addr,@function
root_nfs_parse_addr:                    # @root_nfs_parse_addr
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, 0
	copy_local	$4=, $0
.LBB1_1:                                # %while.body
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
	copy_local	$7=, $6
	i32.const	$push25=, 1
	i32.add 	$3=, $5, $pop25
	i32.const	$push24=, 1
	i32.add 	$6=, $7, $pop24
	i32.add 	$push1=, $4, $5
	i32.load8_u	$2=, 0($pop1)
	copy_local	$5=, $3
	i32.const	$push23=, -48
	i32.add 	$push2=, $2, $pop23
	i32.const	$push22=, 255
	i32.and 	$push3=, $pop2, $pop22
	i32.const	$push21=, 10
	i32.lt_u	$push4=, $pop3, $pop21
	br_if   	0, $pop4        # 0: up to label3
# %bb.3:                                # %while.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	block   	
	i32.const	$push26=, 1
	i32.eq  	$push5=, $3, $pop26
	br_if   	0, $pop5        # 0: down to label4
# %bb.4:                                # %lor.lhs.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$5=, $4, $3
	i32.const	$push28=, -1
	i32.add 	$push0=, $5, $pop28
	i32.sub 	$push6=, $pop0, $4
	i32.const	$push27=, 4
	i32.ge_s	$push7=, $pop6, $pop27
	br_if   	2, $pop7        # 2: down to label1
# %bb.5:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push32=, 3
	i32.eq  	$push8=, $1, $pop32
	i32.const	$push31=, 255
	i32.and 	$push9=, $2, $pop31
	i32.const	$push30=, 46
	i32.eq  	$push10=, $pop9, $pop30
	i32.or  	$push11=, $pop8, $pop10
	i32.add 	$1=, $1, $pop11
	copy_local	$4=, $5
	i32.const	$push29=, 4
	i32.lt_u	$push12=, $1, $pop29
	br_if   	1, $pop12       # 1: up to label2
	br      	3               # 3: down to label0
.LBB1_6:
	end_block                       # label4:
	end_loop
	copy_local	$7=, $4
	br      	1               # 1: down to label0
.LBB1_7:                                # %lor.lhs.false.while.end25_crit_edge
	end_block                       # label1:
	i32.add 	$push13=, $4, $3
	i32.const	$push14=, -1
	i32.add 	$7=, $pop13, $pop14
.LBB1_8:                                # %while.end25
	end_block                       # label0:
	i32.const	$5=, -1
	block   	
	i32.const	$push15=, 4
	i32.ne  	$push16=, $1, $pop15
	br_if   	0, $pop16       # 0: down to label5
# %bb.9:                                # %land.lhs.true
	i32.load8_u	$3=, 0($7)
	block   	
	i32.eqz 	$push33=, $3
	br_if   	0, $pop33       # 0: down to label6
# %bb.10:                               # %land.lhs.true
	i32.const	$push17=, 58
	i32.ne  	$push18=, $3, $pop17
	br_if   	1, $pop18       # 1: down to label5
# %bb.11:                               # %if.then39
	i32.const	$push19=, 0
	i32.store8	0($7), $pop19
	i32.const	$push20=, 1
	i32.add 	$7=, $7, $pop20
.LBB1_12:                               # %if.end41
	end_block                       # label6:
	i32.call	$drop=, strcpy@FUNCTION, $0, $7
	i32.const	$5=, 168496141
.LBB1_13:                               # %if.end43
	end_block                       # label5:
	copy_local	$push34=, $5
                                        # fallthrough-return: $pop34
	.endfunc
.Lfunc_end1:
	.size	root_nfs_parse_addr, .Lfunc_end1-root_nfs_parse_addr
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
	i32.const	$3=, main.addr
.LBB2_1:                                # %while.body.i
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
	copy_local	$6=, $5
	i32.const	$push27=, 1
	i32.add 	$2=, $4, $pop27
	i32.const	$push26=, 1
	i32.add 	$5=, $6, $pop26
	i32.add 	$push1=, $3, $4
	i32.load8_u	$1=, 0($pop1)
	copy_local	$4=, $2
	i32.const	$push25=, -48
	i32.add 	$push2=, $1, $pop25
	i32.const	$push24=, 255
	i32.and 	$push3=, $pop2, $pop24
	i32.const	$push23=, 10
	i32.lt_u	$push4=, $pop3, $pop23
	br_if   	0, $pop4        # 0: up to label10
# %bb.3:                                # %while.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	block   	
	i32.const	$push28=, 1
	i32.eq  	$push5=, $2, $pop28
	br_if   	0, $pop5        # 0: down to label11
# %bb.4:                                # %lor.lhs.false.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$4=, $3, $2
	i32.const	$push30=, -1
	i32.add 	$push0=, $4, $pop30
	i32.sub 	$push6=, $pop0, $3
	i32.const	$push29=, 4
	i32.ge_s	$push7=, $pop6, $pop29
	br_if   	2, $pop7        # 2: down to label8
# %bb.5:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push34=, 3
	i32.eq  	$push8=, $0, $pop34
	i32.const	$push33=, 255
	i32.and 	$push9=, $1, $pop33
	i32.const	$push32=, 46
	i32.eq  	$push10=, $pop9, $pop32
	i32.or  	$push11=, $pop8, $pop10
	i32.add 	$0=, $0, $pop11
	copy_local	$3=, $4
	i32.const	$push31=, 4
	i32.lt_u	$push12=, $0, $pop31
	br_if   	1, $pop12       # 1: up to label9
	br      	3               # 3: down to label7
.LBB2_6:
	end_block                       # label11:
	end_loop
	copy_local	$6=, $3
	br      	1               # 1: down to label7
.LBB2_7:                                # %lor.lhs.false.i.while.end25.i_crit_edge
	end_block                       # label8:
	i32.add 	$push13=, $3, $2
	i32.const	$push14=, -1
	i32.add 	$6=, $pop13, $pop14
.LBB2_8:                                # %while.end25.i
	end_block                       # label7:
	block   	
	i32.const	$push15=, 4
	i32.ne  	$push16=, $0, $pop15
	br_if   	0, $pop16       # 0: down to label12
# %bb.9:                                # %land.lhs.true.i
	i32.load8_u	$4=, 0($6)
	block   	
	i32.eqz 	$push35=, $4
	br_if   	0, $pop35       # 0: down to label13
# %bb.10:                               # %land.lhs.true.i
	i32.const	$push17=, 58
	i32.ne  	$push18=, $4, $pop17
	br_if   	1, $pop18       # 1: down to label12
# %bb.11:                               # %if.then39.i
	i32.const	$push19=, 0
	i32.store8	0($6), $pop19
	i32.const	$push20=, 1
	i32.add 	$6=, $6, $pop20
.LBB2_12:                               # %if.end
	end_block                       # label13:
	i32.const	$push21=, main.addr
	i32.call	$drop=, strcpy@FUNCTION, $pop21, $6
	i32.const	$push22=, 0
	return  	$pop22
.LBB2_13:                               # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	main.addr,@object       # @main.addr
	.section	.data.main.addr,"aw",@progbits
	.p2align	4
main.addr:
	.asciz	"10.11.12.13:/hello"
	.size	main.addr, 19


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
