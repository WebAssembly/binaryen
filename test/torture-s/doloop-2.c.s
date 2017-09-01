	.text
	.file	"doloop-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.load	$push0=, i($pop11)
	i32.const	$push10=, 1
	i32.add 	$push1=, $pop0, $pop10
	i32.store	i($pop12), $pop1
	i32.const	$push9=, -1
	i32.add 	$push8=, $0, $pop9
	tee_local	$push7=, $0=, $pop8
	i32.const	$push6=, 65535
	i32.and 	$push2=, $pop7, $pop6
	br_if   	0, $pop2        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop
	block   	
	i32.const	$push13=, 0
	i32.load	$push3=, i($pop13)
	i32.const	$push4=, 65536
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
