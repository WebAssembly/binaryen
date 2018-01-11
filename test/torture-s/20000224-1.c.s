	.text
	.file	"20000224-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$0=, loop_1($pop9)
	block   	
	i32.const	$push8=, 1
	i32.lt_s	$push0=, $0, $pop8
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push11=, 0
	i32.load	$2=, flag($pop11)
	i32.const	$push10=, 0
	i32.load	$1=, loop_2($pop10)
	i32.const	$3=, 0
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push16=, 0
	i32.const	$push15=, 1
	i32.and 	$push3=, $2, $pop15
	i32.sub 	$push4=, $pop16, $pop3
	i32.const	$push14=, 0
	i32.const	$push13=, 1
	i32.lt_s	$push1=, $1, $pop13
	i32.select	$push2=, $pop14, $1, $pop1
	i32.and 	$push5=, $pop4, $pop2
	i32.add 	$3=, $3, $pop5
	i32.const	$push12=, 1
	i32.add 	$2=, $2, $pop12
	i32.gt_s	$push6=, $0, $3
	br_if   	0, $pop6        # 0: up to label1
# %bb.3:                                # %while.cond.while.end_crit_edge
	end_loop
	i32.const	$push7=, 0
	i32.store	flag($pop7), $2
.LBB0_4:                                # %while.end
	end_block                       # label0:
	i32.const	$push17=, 1
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.call	$drop=, test@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	loop_1                  # @loop_1
	.type	loop_1,@object
	.section	.data.loop_1,"aw",@progbits
	.globl	loop_1
	.p2align	2
loop_1:
	.int32	100                     # 0x64
	.size	loop_1, 4

	.hidden	loop_2                  # @loop_2
	.type	loop_2,@object
	.section	.data.loop_2,"aw",@progbits
	.globl	loop_2
	.p2align	2
loop_2:
	.int32	7                       # 0x7
	.size	loop_2, 4

	.hidden	flag                    # @flag
	.type	flag,@object
	.section	.bss.flag,"aw",@nobits
	.globl	flag
	.p2align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
