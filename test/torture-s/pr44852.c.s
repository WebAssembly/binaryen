	.text
	.file	"pr44852.c"
	.section	.text.sf,"ax",@progbits
	.hidden	sf                      # -- Begin function sf
	.globl	sf
	.type	sf,@function
sf:                                     # @sf
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	block   	
	block   	
	block   	
	i32.const	$push12=, -1
	i32.add 	$push11=, $0, $pop12
	tee_local	$push10=, $2=, $pop11
	i32.load8_u	$push9=, 0($pop10)
	tee_local	$push8=, $3=, $pop9
	i32.const	$push7=, 57
	i32.ne  	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label2
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.eq  	$push1=, $1, $2
	br_if   	2, $pop1        # 2: down to label1
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push18=, -1
	i32.add 	$push17=, $2, $pop18
	tee_local	$push16=, $2=, $pop17
	i32.load8_u	$push15=, 0($pop16)
	tee_local	$push14=, $3=, $pop15
	i32.const	$push13=, 57
	i32.eq  	$push2=, $pop14, $pop13
	br_if   	0, $pop2        # 0: up to label3
# BB#3:                                 # %while.end.loopexit
	end_loop
	i32.const	$push3=, 1
	i32.add 	$0=, $2, $pop3
.LBB0_4:                                # %while.end
	end_block                       # label2:
	copy_local	$1=, $2
	br      	1               # 1: down to label0
.LBB0_5:                                # %if.then
	end_block                       # label1:
	i32.const	$3=, 48
	i32.const	$push19=, 48
	i32.store8	0($1), $pop19
	i32.const	$push4=, 1
	i32.add 	$0=, $2, $pop4
.LBB0_6:                                # %while.end
	end_block                       # label0:
	i32.const	$push5=, 1
	i32.add 	$push6=, $3, $pop5
	i32.store8	0($1), $pop6
	copy_local	$push20=, $0
                                        # fallthrough-return: $pop20
	.endfunc
.Lfunc_end0:
	.size	sf, .Lfunc_end0-sf
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 16
	i32.sub 	$push35=, $pop17, $pop19
	tee_local	$push34=, $0=, $pop35
	i32.store	__stack_pointer($pop20), $pop34
	i32.const	$push2=, 14
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.s+6($pop0)
	i32.store8	0($pop3), $pop1
	i32.const	$push5=, 12
	i32.add 	$push6=, $0, $pop5
	i32.const	$push33=, 0
	i32.load16_u	$push4=, .Lmain.s+4($pop33):p2align=0
	i32.store16	0($pop6), $pop4
	i32.const	$push32=, 0
	i32.load	$push7=, .Lmain.s($pop32):p2align=0
	i32.store	8($0), $pop7
	block   	
	i32.const	$push26=, 8
	i32.add 	$push27=, $0, $pop26
	i32.const	$push10=, 2
	i32.or  	$push11=, $pop27, $pop10
	i32.const	$push28=, 8
	i32.add 	$push29=, $0, $pop28
	i32.call	$push12=, sf@FUNCTION, $pop11, $pop29
	i32.const	$push24=, 8
	i32.add 	$push25=, $0, $pop24
	i32.const	$push8=, 1
	i32.or  	$push9=, $pop25, $pop8
	i32.ne  	$push13=, $pop12, $pop9
	br_if   	0, $pop13       # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.const	$push30=, 8
	i32.add 	$push31=, $0, $pop30
	i32.const	$push14=, .L.str
	i32.call	$push15=, strcmp@FUNCTION, $pop31, $pop14
	br_if   	0, $pop15       # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $0, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	i32.const	$push16=, 0
	return  	$pop16
.LBB1_3:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lmain.s,@object        # @main.s
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.s:
	.asciz	"999999"
	.size	.Lmain.s, 7

	.type	.L.str,@object          # @.str
.L.str:
	.asciz	"199999"
	.size	.L.str, 7


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
