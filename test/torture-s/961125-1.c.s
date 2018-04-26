	.text
	.file	"961125-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, .L.str
	i32.const	$1=, 1
.LBB0_1:                                # %land.rhs.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	block   	
	loop    	                # label1:
	i32.eqz 	$push18=, $1
	br_if   	1, $pop18       # 1: down to label0
# %bb.2:                                # %while.body.i
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.const	$push12=, .L.str+3
	i32.ge_u	$push0=, $0, $pop12
	br_if   	0, $pop0        # 0: down to label2
# %bb.3:                                # %land.rhs4.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$2=, $0
.LBB0_4:                                # %land.rhs4.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	i32.const	$push14=, 1
	i32.add 	$0=, $2, $pop14
	i32.load8_u	$push1=, 0($2)
	i32.const	$push13=, 58
	i32.eq  	$push2=, $pop1, $pop13
	br_if   	1, $pop2        # 1: down to label2
# %bb.5:                                # %land.rhs4.i
                                        #   in Loop: Header=BB0_4 Depth=2
	copy_local	$2=, $0
	i32.const	$push15=, .L.str+3
	i32.lt_u	$push3=, $0, $pop15
	br_if   	0, $pop3        # 0: up to label3
.LBB0_6:                                # %while.end.thread.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label2:
	i32.const	$push17=, -1
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, .L.str+3
	i32.lt_u	$push4=, $0, $pop16
	br_if   	0, $pop4        # 0: up to label1
.LBB0_7:                                # %begfield.exit
	end_loop
	end_block                       # label0:
	i32.const	$push5=, 1
	i32.add 	$2=, $0, $pop5
	block   	
	i32.const	$push6=, .L.str+3
	i32.gt_u	$push7=, $2, $pop6
	i32.select	$push8=, $0, $2, $pop7
	i32.const	$push9=, .L.str+2
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label4
# %bb.8:                                # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	":ab"
	.size	.L.str, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
