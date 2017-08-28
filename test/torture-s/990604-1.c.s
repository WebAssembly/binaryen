	.text
	.file	"990604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, b($pop2)
	i32.eqz 	$push4=, $pop0
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push3=, 0
	i32.const	$push1=, 9
	i32.store	b($pop3), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push6=, 0
	i32.load	$push5=, b($pop6)
	tee_local	$push4=, $0=, $pop5
	i32.const	$push0=, 9
	i32.eq  	$push1=, $pop4, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	br_if   	1, $0           # 1: down to label1
# BB#2:                                 # %f.exit.thread
	i32.const	$push3=, 0
	i32.const	$push2=, 9
	i32.store	b($pop3), $pop2
.LBB1_3:                                # %if.end
	end_block                       # label2:
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
