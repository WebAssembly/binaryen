	.text
	.file	"pr32244-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i64
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 0
	i64.load	$push1=, x($pop0)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.ne  	$push4=, $pop3, $0
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.then.i
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i64.load	$push1=, x($pop6)
	i64.const	$push2=, -1099511627776
	i64.and 	$push3=, $pop1, $pop2
	i64.const	$push4=, 256
	i64.or  	$push5=, $pop3, $pop4
	i64.store	x($pop0), $pop5
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	8
	.size	x, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
