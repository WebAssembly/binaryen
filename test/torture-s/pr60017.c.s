	.text
	.file	"pr60017.c"
	.section	.text.func,"ax",@progbits
	.hidden	func                    # -- Begin function func
	.globl	func
	.type	func,@function
func:                                   # @func
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i64.load	$push3=, x+8($pop2):p2align=2
	i64.store	0($pop1):p2align=2, $pop3
	i32.const	$push5=, 0
	i64.load	$push4=, x($pop5):p2align=2
	i64.store	0($0):p2align=2, $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	func, .Lfunc_end0-func
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load16_u	$push0=, x+12($pop3)
	i32.const	$push1=, 9
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int8	1                       # 0x1
	.ascii	"\002\003"
	.ascii	"\004\005"
	.skip	1
	.int16	6                       # 0x6
	.int16	7                       # 0x7
	.int16	8                       # 0x8
	.int16	9                       # 0x9
	.skip	2
	.size	x, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
