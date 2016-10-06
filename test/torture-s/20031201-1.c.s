	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031201-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	i($pop0), $0
	i32.const	$push1=, 32
	i32.store	4($0), $pop1
	i32.const	$push7=, 32
	i32.store	0($0), $pop7
	call    	f0@FUNCTION
	i32.const	$push6=, 0
	i32.load	$push5=, i($pop6)
	tee_local	$push4=, $0=, $pop5
	i32.const	$push2=, 8
	i32.store	4($pop4), $pop2
	i32.const	$push3=, 8
	i32.store	0($0), $pop3
	call    	test@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, f0.washere($pop8)
	tee_local	$push6=, $0=, $pop7
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop6, $pop0
	i32.store	f0.washere($pop9), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push13=, 0
	i32.load	$push12=, i($pop13)
	tee_local	$push11=, $0=, $pop12
	i32.load16_u	$push2=, 0($pop11)
	i32.const	$push10=, 32
	i32.ne  	$push3=, $pop2, $pop10
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %lor.lhs.false1
	i32.load16_u	$push4=, 4($0)
	i32.const	$push14=, 32
	i32.ne  	$push5=, $pop4, $pop14
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f0, .Lfunc_end1-f0

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push8=, i($pop0)
	tee_local	$push7=, $0=, $pop8
	i32.load16_u	$push1=, 0($pop7)
	i32.const	$push6=, 8
	i32.ne  	$push2=, $pop1, $pop6
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push3=, 4($0)
	i32.const	$push9=, 8
	i32.ne  	$push4=, $pop3, $pop9
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %if.end
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 16
	i32.sub 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.store	__stack_pointer($pop3), $pop6
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.call	$drop=, f1@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
