	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strlen-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, u
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	block
	loop                            # label1:
	i32.const	$push7=, u
	i32.add 	$0=, $1, $pop7
	i32.const	$3=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.const	$4=, u
	block
	i32.const	$push19=, 0
	i32.eq  	$push20=, $1, $pop19
	br_if   	0, $pop20       # 0: down to label5
# BB#3:                                 # %for.body6.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push9=, u
	i32.const	$push8=, 0
	i32.call	$discard=, memset@FUNCTION, $pop9, $pop8, $1
	copy_local	$4=, $2
.LBB0_4:                                # %for.cond7.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label5:
	block
	i32.const	$push21=, 0
	i32.eq  	$push22=, $3, $pop21
	br_if   	0, $pop22       # 0: down to label6
# BB#5:                                 # %for.body9.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push10=, 97
	i32.call	$push0=, memset@FUNCTION, $4, $pop10, $3
	i32.add 	$4=, $pop0, $3
.LBB0_6:                                # %for.end13
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label6:
	i32.const	$push13=, 0
	i32.store8	$discard=, 0($4), $pop13
	i32.const	$push12=, 1
	i32.add 	$push6=, $4, $pop12
	i64.const	$push11=, 7089336938131513954
	i64.store	$discard=, 0($pop6):p2align=0, $pop11
	i32.call	$push1=, strlen@FUNCTION, $0
	i32.ne  	$push2=, $3, $pop1
	br_if   	4, $pop2        # 4: down to label0
# BB#7:                                 # %for.cond1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push15=, 1
	i32.add 	$3=, $3, $pop15
	i32.const	$push14=, 63
	i32.le_u	$push3=, $3, $pop14
	br_if   	0, $pop3        # 0: up to label3
# BB#8:                                 # %for.inc26
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push18=, 1
	i32.add 	$1=, $1, $pop18
	i32.const	$push17=, 1
	i32.add 	$2=, $2, $pop17
	i32.const	$push16=, 8
	i32.lt_u	$push4=, $1, $pop16
	br_if   	0, $pop4        # 0: up to label1
# BB#9:                                 # %for.end28
	end_loop                        # label2:
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB0_10:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u,@object               # @u
	.lcomm	u,96,4

	.ident	"clang version 3.9.0 "
