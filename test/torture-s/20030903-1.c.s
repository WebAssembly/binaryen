	.text
	.file	"20030903-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push0=, test($pop4)
	i32.const	$push1=, -1
	i32.add 	$0=, $pop0, $pop1
	block   	
	i32.const	$push2=, 3
	i32.le_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %sw.epilog
	i32.const	$push5=, 0
	return  	$pop5
.LBB0_2:                                # %entry
	end_block                       # label0:
	block   	
	br_table 	$0, 0, 0, 0, 0, 0 # 0: down to label1
.LBB0_3:                                # %sw.bb
	end_block                       # label1:
	call    	y@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.y,"ax",@progbits
	.type	y,@function             # -- Begin function y
y:                                      # @y
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	y, .Lfunc_end1-y
                                        # -- End function
	.type	test,@object            # @test
	.section	.bss.test,"aw",@nobits
	.p2align	2
test:
	.int32	0                       # 0x0
	.size	test, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
