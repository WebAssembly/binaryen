	.text
	.file	"20051110-2.c"
	.section	.text.add_unwind_adjustsp,"ax",@progbits
	.hidden	add_unwind_adjustsp     # -- Begin function add_unwind_adjustsp
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$5=, $pop1, $pop2
	i32.const	$6=, 0
	i32.const	$push10=, 0
	i32.const	$push9=, 127
	i32.and 	$push3=, $5, $pop9
	i32.store8	bytes($pop10), $pop3
	i32.const	$push8=, 7
	i32.shr_u	$0=, $5, $pop8
	block   	
	block   	
	i32.eqz 	$push18=, $0
	br_if   	0, $pop18       # 0: down to label1
# %bb.1:                                # %if.then.lr.ph.preheader
	i32.const	$push11=, 0
	i32.load	$1=, flag($pop11)
	i32.const	$4=, bytes
.LBB0_2:                                # %if.then.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	                # label2:
	copy_local	$2=, $0
	copy_local	$0=, $2
.LBB0_3:                                # %if.then
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label4:
	copy_local	$3=, $0
	i32.eqz 	$push19=, $1
	br_if   	1, $pop19       # 1: down to label3
# %bb.4:                                # %a
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push12=, 7
	i32.shr_u	$0=, $3, $pop12
	br_if   	0, $0           # 0: up to label4
	br      	4               # 4: down to label0
.LBB0_5:                                # %if.end7
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label3:
	i32.const	$push17=, 128
	i32.or  	$push6=, $5, $pop17
	i32.store8	0($4), $pop6
	i32.const	$push16=, bytes+1
	i32.add 	$4=, $6, $pop16
	i32.const	$push15=, 127
	i32.and 	$push7=, $2, $pop15
	i32.store8	0($4), $pop7
	i32.const	$push14=, 7
	i32.shr_u	$0=, $2, $pop14
	i32.const	$push13=, 1
	i32.add 	$6=, $6, $pop13
	copy_local	$5=, $2
	br_if   	0, $0           # 0: up to label2
.LBB0_6:                                # %do.end
	end_loop
	end_block                       # label1:
	return
.LBB0_7:                                # %a.if.end7_crit_edge
	end_block                       # label0:
	i32.const	$push4=, 127
	i32.and 	$push5=, $3, $pop4
	i32.store8	0($4), $pop5
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
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.const	$push0=, 8
	i32.store8	bytes($pop5), $pop0
	block   	
	i32.const	$push4=, 0
	i32.load	$push1=, flag($pop4)
	br_if   	0, $pop1        # 0: down to label5
# %bb.1:                                # %if.end
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
