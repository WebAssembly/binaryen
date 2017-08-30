	.text
	.file	"20051110-2.c"
	.section	.text.add_unwind_adjustsp,"ax",@progbits
	.hidden	add_unwind_adjustsp     # -- Begin function add_unwind_adjustsp
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.const	$push14=, 0
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$push13=, $pop1, $pop2
	tee_local	$push12=, $5=, $pop13
	i32.const	$push11=, 127
	i32.and 	$push3=, $pop12, $pop11
	i32.store8	bytes($pop14), $pop3
	block   	
	i32.const	$push10=, 7
	i32.shr_u	$push9=, $5, $pop10
	tee_local	$push8=, $0=, $pop9
	i32.eqz 	$push30=, $pop8
	br_if   	0, $pop30       # 0: down to label0
# BB#1:                                 # %if.then.lr.ph.lr.ph
	i32.const	$push15=, 0
	i32.load	$1=, flag($pop15)
	i32.const	$4=, bytes
.LBB0_2:                                # %if.then.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	                # label1:
	copy_local	$push17=, $0
	tee_local	$push16=, $2=, $pop17
	copy_local	$0=, $pop16
.LBB0_3:                                # %if.then
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	block   	
	loop    	                # label4:
	copy_local	$3=, $0
	i32.eqz 	$push31=, $1
	br_if   	1, $pop31       # 1: down to label3
# BB#4:                                 # %a
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push20=, 7
	i32.shr_u	$push19=, $3, $pop20
	tee_local	$push18=, $0=, $pop19
	br_if   	0, $pop18       # 0: up to label4
	br      	2               # 2: down to label2
.LBB0_5:                                # %if.end7.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label3:
	i32.const	$push29=, 128
	i32.or  	$push6=, $5, $pop29
	i32.store8	0($4), $pop6
	i32.const	$push28=, bytes+1
	i32.add 	$push27=, $6, $pop28
	tee_local	$push26=, $4=, $pop27
	i32.const	$push25=, 127
	i32.and 	$push7=, $2, $pop25
	i32.store8	0($pop26), $pop7
	i32.const	$push24=, 1
	i32.add 	$6=, $6, $pop24
	copy_local	$5=, $2
	i32.const	$push23=, 7
	i32.shr_u	$push22=, $2, $pop23
	tee_local	$push21=, $0=, $pop22
	br_if   	1, $pop21       # 1: up to label1
	br      	2               # 2: down to label0
.LBB0_6:                                # %a.do.end_crit_edge
	end_block                       # label2:
	end_loop
	i32.const	$push4=, 127
	i32.and 	$push5=, $3, $pop4
	i32.store8	0($4), $pop5
.LBB0_7:                                # %do.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	add_unwind_adjustsp, .Lfunc_end0-add_unwind_adjustsp
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push0=, 8
	i32.store8	bytes($pop5), $pop0
	block   	
	i32.const	$push4=, 0
	i32.load	$push1=, flag($pop4)
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push3=, 1928
	i32.store16	bytes($pop7):p2align=0, $pop3
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label5:
	i32.const	$push8=, 0
	i32.const	$push2=, 7
	i32.store8	bytes($pop8), $pop2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	bytes                   # @bytes
	.type	bytes,@object
	.section	.bss.bytes,"aw",@nobits
	.globl	bytes
bytes:
	.skip	5
	.size	bytes, 5

	.hidden	flag                    # @flag
	.type	flag,@object
	.section	.bss.flag,"aw",@nobits
	.globl	flag
	.p2align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
