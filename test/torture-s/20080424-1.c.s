	.text
	.file	"20080424-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push13=, 0
	i32.load	$push12=, bar.i($pop13)
	tee_local	$push11=, $2=, $pop12
	i32.const	$push0=, 36
	i32.mul 	$push10=, $pop11, $pop0
	tee_local	$push9=, $3=, $pop10
	i32.const	$push1=, g+288
	i32.add 	$push2=, $pop9, $pop1
	i32.ne  	$push3=, $pop2, $0
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push14=, 0
	i32.const	$push4=, 1
	i32.add 	$push5=, $2, $pop4
	i32.store	bar.i($pop14), $pop5
	i32.const	$push6=, g
	i32.add 	$push7=, $3, $pop6
	i32.ne  	$push8=, $pop7, $1
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, g+288
	i32.const	$push0=, g
	call    	bar@FUNCTION, $pop1, $pop0
	i32.const	$push3=, g+324
	i32.const	$push2=, g+36
	call    	bar@FUNCTION, $pop3, $pop2
	i32.const	$push5=, g+360
	i32.const	$push4=, g+72
	call    	bar@FUNCTION, $pop5, $pop4
	i32.const	$push7=, g+396
	i32.const	$push6=, g+108
	call    	bar@FUNCTION, $pop7, $pop6
	i32.const	$push9=, g+432
	i32.const	$push8=, g+144
	call    	bar@FUNCTION, $pop9, $pop8
	i32.const	$push11=, g+468
	i32.const	$push10=, g+180
	call    	bar@FUNCTION, $pop11, $pop10
	i32.const	$push13=, g+504
	i32.const	$push12=, g+216
	call    	bar@FUNCTION, $pop13, $pop12
	i32.const	$push15=, g+540
	i32.const	$push14=, g+252
	call    	bar@FUNCTION, $pop15, $pop14
	i32.const	$push16=, 0
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	bar.i,@object           # @bar.i
	.section	.bss.bar.i,"aw",@nobits
	.p2align	2
bar.i:
	.int32	0                       # 0x0
	.size	bar.i, 4

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	4
g:
	.skip	1728
	.size	g, 1728


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
