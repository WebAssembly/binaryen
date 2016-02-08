	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961125-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, .L.str
	i32.const	$1=, 1
.LBB0_1:                                # %land.rhs.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label0:
	i32.const	$push17=, 0
	i32.eq  	$push18=, $1, $pop17
	br_if   	1, $pop18       # 1: down to label1
# BB#2:                                 # %while.cond2.preheader.i
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push11=, .L.str+3
	i32.ge_u	$push0=, $2, $pop11
	br_if   	0, $pop0        # 0: down to label2
.LBB0_3:                                # %land.rhs4.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.load8_u	$0=, 0($2)
	i32.const	$push13=, 1
	i32.add 	$2=, $2, $pop13
	i32.const	$push12=, 58
	i32.eq  	$push1=, $0, $pop12
	br_if   	1, $pop1        # 1: down to label4
# BB#4:                                 # %land.rhs4.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push14=, .L.str+3
	i32.lt_u	$push2=, $2, $pop14
	br_if   	0, $pop2        # 0: up to label3
.LBB0_5:                                # %while.end.thread.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push16=, -1
	i32.add 	$1=, $1, $pop16
	i32.const	$push15=, .L.str+3
	i32.lt_u	$push3=, $2, $pop15
	br_if   	0, $pop3        # 0: up to label0
.LBB0_6:                                # %begfield.exit
	end_loop                        # label1:
	i32.const	$push4=, 1
	i32.add 	$0=, $2, $pop4
	block
	i32.const	$push5=, .L.str+3
	i32.gt_u	$push6=, $0, $pop5
	i32.select	$push7=, $2, $0, $pop6
	i32.const	$push8=, .L.str+2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label5
# BB#7:                                 # %if.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	":ab"
	.size	.L.str, 4


	.ident	"clang version 3.9.0 "
