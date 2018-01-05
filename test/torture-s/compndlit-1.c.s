	.text
	.file	"compndlit-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push0=, x($pop8)
	i32.const	$push1=, 7
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 1
	i32.eq  	$0=, $pop2, $pop3
	i32.const	$push7=, 0
	i32.const	$push5=, 160
	i32.const	$push4=, 320
	i32.select	$push6=, $pop5, $pop4, $0
	i32.store	x($pop7), $pop6
	block   	
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
