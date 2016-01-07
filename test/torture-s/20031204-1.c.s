	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031204-1.c"
	.globl	in_aton
	.type	in_aton,@function
in_aton:                                # @in_aton
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 168496141
	return  	$pop0
.Lfunc_end0:
	.size	in_aton, .Lfunc_end0-in_aton

	.globl	root_nfs_parse_addr
	.type	root_nfs_parse_addr,@function
root_nfs_parse_addr:                    # @root_nfs_parse_addr
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, 0
	copy_local	$6=, $0
.LBB1_1:                                  # %while.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop .LBB1_2 Depth 2
	loop    	.LBB1_6
	copy_local	$7=, $6
.LBB1_2:                                  # %while.cond1
                                        #   Parent Loop .LBB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB1_3
	copy_local	$2=, $7
	i32.load8_u	$1=, 0($2)
	i32.const	$3=, 255
	i32.const	$4=, 1
	i32.add 	$7=, $2, $4
	i32.const	$push0=, -48
	i32.add 	$push1=, $1, $pop0
	i32.and 	$push2=, $pop1, $3
	i32.const	$push3=, 10
	i32.lt_u	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB1_2
.LBB1_3:                                  # %while.end
                                        #   in Loop: Header=.LBB1_1 Depth=1
	copy_local	$9=, $6
	i32.eq  	$push5=, $2, $6
	br_if   	$pop5, .LBB1_6
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=.LBB1_1 Depth=1
	i32.const	$5=, 3
	copy_local	$9=, $2
	i32.sub 	$push6=, $2, $6
	i32.gt_s	$push7=, $pop6, $5
	br_if   	$pop7, .LBB1_6
# BB#5:                                 # %if.end
                                        #   in Loop: Header=.LBB1_1 Depth=1
	i32.eq  	$push11=, $8, $5
	i32.and 	$push8=, $1, $3
	i32.const	$push9=, 46
	i32.eq  	$push10=, $pop8, $pop9
	i32.or  	$push12=, $pop11, $pop10
	i32.add 	$8=, $pop12, $8
	copy_local	$6=, $7
	copy_local	$9=, $2
	i32.const	$push13=, 4
	i32.lt_s	$push14=, $8, $pop13
	br_if   	$pop14, .LBB1_1
.LBB1_6:                                  # %while.end25
	i32.const	$2=, -1
	block   	.LBB1_11
	i32.const	$push15=, 4
	i32.ne  	$push16=, $8, $pop15
	br_if   	$pop16, .LBB1_11
# BB#7:                                 # %land.lhs.true
	i32.load8_u	$7=, 0($9)
	block   	.LBB1_10
	i32.const	$push20=, 0
	i32.eq  	$push21=, $7, $pop20
	br_if   	$pop21, .LBB1_10
# BB#8:                                 # %land.lhs.true
	i32.const	$push17=, 58
	i32.ne  	$push18=, $7, $pop17
	br_if   	$pop18, .LBB1_11
# BB#9:                                 # %if.then39
	i32.add 	$2=, $9, $4
	i32.const	$push19=, 0
	i32.store8	$discard=, 0($9), $pop19
	copy_local	$9=, $2
.LBB1_10:                                 # %if.end41
	i32.call	$discard=, strcpy, $0, $9
	i32.const	$2=, 168496141
.LBB1_11:                                 # %if.end43
	return  	$2
.Lfunc_end1:
	.size	root_nfs_parse_addr, .Lfunc_end1-root_nfs_parse_addr

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, 0
	i32.const	$5=, main.addr
.LBB2_1:                                  # %while.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop .LBB2_2 Depth 2
	loop    	.LBB2_6
	copy_local	$6=, $5
.LBB2_2:                                  # %while.cond1.i
                                        #   Parent Loop .LBB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_3
	copy_local	$1=, $6
	i32.load8_u	$0=, 0($1)
	i32.const	$2=, 255
	i32.const	$3=, 1
	i32.add 	$6=, $1, $3
	i32.const	$push0=, -48
	i32.add 	$push1=, $0, $pop0
	i32.and 	$push2=, $pop1, $2
	i32.const	$push3=, 10
	i32.lt_u	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB2_2
.LBB2_3:                                  # %while.end.i
                                        #   in Loop: Header=.LBB2_1 Depth=1
	copy_local	$8=, $5
	i32.eq  	$push5=, $1, $5
	br_if   	$pop5, .LBB2_6
# BB#4:                                 # %lor.lhs.false.i
                                        #   in Loop: Header=.LBB2_1 Depth=1
	i32.const	$4=, 3
	copy_local	$8=, $1
	i32.sub 	$push6=, $1, $5
	i32.gt_s	$push7=, $pop6, $4
	br_if   	$pop7, .LBB2_6
# BB#5:                                 # %if.end.i
                                        #   in Loop: Header=.LBB2_1 Depth=1
	i32.eq  	$push11=, $7, $4
	i32.and 	$push8=, $0, $2
	i32.const	$push9=, 46
	i32.eq  	$push10=, $pop8, $pop9
	i32.or  	$push12=, $pop11, $pop10
	i32.add 	$7=, $pop12, $7
	copy_local	$5=, $6
	copy_local	$8=, $1
	i32.const	$push13=, 4
	i32.lt_s	$push14=, $7, $pop13
	br_if   	$pop14, .LBB2_1
.LBB2_6:                                  # %while.end25.i
	block   	.LBB2_11
	i32.const	$push15=, 4
	i32.ne  	$push16=, $7, $pop15
	br_if   	$pop16, .LBB2_11
# BB#7:                                 # %land.lhs.true.i
	i32.load8_u	$1=, 0($8)
	block   	.LBB2_10
	i32.const	$push22=, 0
	i32.eq  	$push23=, $1, $pop22
	br_if   	$pop23, .LBB2_10
# BB#8:                                 # %land.lhs.true.i
	i32.const	$push17=, 58
	i32.ne  	$push18=, $1, $pop17
	br_if   	$pop18, .LBB2_11
# BB#9:                                 # %if.then39.i
	i32.add 	$1=, $8, $3
	i32.const	$push19=, 0
	i32.store8	$discard=, 0($8), $pop19
	copy_local	$8=, $1
.LBB2_10:                                 # %if.end
	i32.const	$push20=, main.addr
	i32.call	$discard=, strcpy, $pop20, $8
	i32.const	$push21=, 0
	return  	$pop21
.LBB2_11:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	main.addr,@object       # @main.addr
	.data
	.align	4
main.addr:
	.asciz	"10.11.12.13:/hello"
	.size	main.addr, 19


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
