	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr35472.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	p($pop0), $1
	i32.const	$push1=, -1
	i32.store	0($0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 128
	i32.sub 	$push28=, $pop8, $pop9
	tee_local	$push27=, $0=, $pop28
	i32.store	__stack_pointer($pop10), $pop27
	i32.const	$push14=, 64
	i32.add 	$push15=, $0, $pop14
	i32.const	$push2=, 0
	i32.const	$push1=, 64
	i32.call	$drop=, memset@FUNCTION, $pop15, $pop2, $pop1
	i32.const	$push26=, 0
	i32.const	$push25=, 64
	i32.call	$push24=, memset@FUNCTION, $0, $pop26, $pop25
	tee_local	$push23=, $0=, $pop24
	i32.const	$push16=, 64
	i32.add 	$push17=, $pop23, $pop16
	call    	foo@FUNCTION, $pop17, $0
	i32.const	$push22=, 0
	i32.load	$push3=, p($pop22)
	i32.const	$push18=, 64
	i32.add 	$push19=, $0, $pop18
	i32.const	$push21=, 64
	i32.call	$push0=, memcpy@FUNCTION, $pop3, $pop19, $pop21
	i32.const	$push20=, 64
	i32.call	$drop=, memcpy@FUNCTION, $pop0, $0, $pop20
	block   	
	i32.load	$push5=, 0($0)
	i32.const	$push4=, -1
	i32.ne  	$push6=, $pop5, $pop4
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 128
	i32.add 	$push12=, $0, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 128
	i32.sub 	$push28=, $pop7, $pop8
	tee_local	$push27=, $0=, $pop28
	i32.store	__stack_pointer($pop9), $pop27
	i32.const	$push13=, 64
	i32.add 	$push14=, $0, $pop13
	i32.const	$push26=, 0
	i32.const	$push1=, 64
	i32.call	$drop=, memset@FUNCTION, $pop14, $pop26, $pop1
	i32.const	$push25=, 0
	i32.const	$push24=, 64
	i32.call	$push23=, memset@FUNCTION, $0, $pop25, $pop24
	tee_local	$push22=, $0=, $pop23
	i32.const	$push15=, 64
	i32.add 	$push16=, $pop22, $pop15
	call    	foo@FUNCTION, $pop16, $0
	i32.const	$push21=, 0
	i32.load	$push2=, p($pop21)
	i32.const	$push17=, 64
	i32.add 	$push18=, $0, $pop17
	i32.const	$push20=, 64
	i32.call	$push0=, memcpy@FUNCTION, $pop2, $pop18, $pop20
	i32.const	$push19=, 64
	i32.call	$drop=, memcpy@FUNCTION, $pop0, $0, $pop19
	block   	
	i32.load	$push4=, 0($0)
	i32.const	$push3=, -1
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %test.exit
	i32.const	$push12=, 0
	i32.const	$push10=, 128
	i32.add 	$push11=, $0, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push29=, 0
	return  	$pop29
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
