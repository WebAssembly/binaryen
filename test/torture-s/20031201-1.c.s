	.text
	.file	"20031201-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	i($pop0), $0
	i32.const	$push1=, 32
	i32.store	4($0), $pop1
	i32.const	$push5=, 32
	i32.store	0($0), $pop5
	call    	f0@FUNCTION
	i32.const	$push4=, 0
	i32.load	$0=, i($pop4)
	i32.const	$push2=, 8
	i32.store	4($0), $pop2
	i32.const	$push3=, 8
	i32.store	0($0), $pop3
	call    	test@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f0,"ax",@progbits
	.hidden	f0                      # -- Begin function f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$0=, f0.washere($pop7)
	i32.const	$push6=, 0
	i32.const	$push0=, 1
	i32.add 	$push1=, $0, $pop0
	i32.store	f0.washere($pop6), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push9=, 0
	i32.load	$0=, i($pop9)
	i32.load16_u	$push2=, 0($0)
	i32.const	$push8=, 32
	i32.ne  	$push3=, $pop2, $pop8
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %lor.lhs.false1
	i32.load16_u	$push4=, 4($0)
	i32.const	$push10=, 32
	i32.ne  	$push5=, $pop4, $pop10
	br_if   	0, $pop5        # 0: down to label0
# %bb.3:                                # %if.end
	return
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f0, .Lfunc_end1-f0
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, i($pop0)
	block   	
	i32.load16_u	$push1=, 0($0)
	i32.const	$push6=, 8
	i32.ne  	$push2=, $pop1, $pop6
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %lor.lhs.false
	i32.load16_u	$push3=, 4($0)
	i32.const	$push7=, 8
	i32.ne  	$push4=, $pop3, $pop7
	br_if   	0, $pop4        # 0: down to label1
# %bb.2:                                # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 16
	i32.sub 	$0=, $pop0, $pop2
	i32.const	$push3=, 0
	i32.store	__stack_pointer($pop3), $0
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.call	$drop=, f1@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.type	i,@object               # @i
	.section	.bss.i,"aw",@nobits
	.p2align	2
i:
	.int32	0
	.size	i, 4

	.type	f0.washere,@object      # @f0.washere
	.section	.bss.f0.washere,"aw",@nobits
	.p2align	2
f0.washere:
	.int32	0                       # 0x0
	.size	f0.washere, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
