	.text
	.file	"20030903-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push6=, 0
	i32.load	$push0=, test($pop6)
	i32.const	$push1=, -1
	i32.add 	$push5=, $pop0, $pop1
	tee_local	$push4=, $0=, $pop5
	i32.const	$push2=, 3
	i32.le_u	$push3=, $pop4, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %sw.epilog
	i32.const	$push7=, 0
	return  	$pop7
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
# BB#0:                                 # %entry
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
