	.text
	.file	"990130-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, count($pop6)
	tee_local	$push4=, $1=, $pop5
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop4, $pop0
	i32.store	count($pop7), $pop1
	i32.const	$push3=, 0
	i32.load	$0=, dummy($pop3)
	#APP
	#NO_APP
	i32.const	$push2=, 0
	i32.store	dummy($pop2), $0
	block   	
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4

	.hidden	dummy                   # @dummy
	.type	dummy,@object
	.section	.bss.dummy,"aw",@nobits
	.globl	dummy
	.p2align	2
dummy:
	.int32	0                       # 0x0
	.size	dummy, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
