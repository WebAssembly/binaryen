	.text
	.file	"compndlit-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push5=, 160
	i32.const	$push4=, 320
	i32.const	$push9=, 0
	i32.load	$push0=, x($pop9)
	i32.const	$push1=, 7
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 1
	i32.eq  	$push8=, $pop2, $pop3
	tee_local	$push7=, $0=, $pop8
	i32.select	$push6=, $pop5, $pop4, $pop7
	i32.store	x($pop10), $pop6
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int8	25                      # 0x19
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.size	x, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
