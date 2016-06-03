	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr35472.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$drop=, p($pop0), $1
	i32.const	$push1=, -1
	i32.store	$drop=, 0($0), $pop1
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
	i32.sub 	$push20=, $pop8, $pop9
	i32.store	$push29=, __stack_pointer($pop10), $pop20
	tee_local	$push28=, $0=, $pop29
	i32.const	$push14=, 64
	i32.add 	$push15=, $pop28, $pop14
	i32.const	$push2=, 0
	i32.const	$push1=, 64
	i32.call	$drop=, memset@FUNCTION, $pop15, $pop2, $pop1
	i32.const	$push27=, 0
	i32.const	$push26=, 64
	i32.call	$push25=, memset@FUNCTION, $0, $pop27, $pop26
	tee_local	$push24=, $0=, $pop25
	i32.const	$push16=, 64
	i32.add 	$push17=, $pop24, $pop16
	call    	foo@FUNCTION, $pop17, $0
	i32.const	$push23=, 0
	i32.load	$push3=, p($pop23)
	i32.const	$push18=, 64
	i32.add 	$push19=, $0, $pop18
	i32.const	$push22=, 64
	i32.call	$push0=, memcpy@FUNCTION, $pop3, $pop19, $pop22
	i32.const	$push21=, 64
	i32.call	$drop=, memcpy@FUNCTION, $pop0, $0, $pop21
	block
	i32.load	$push5=, 0($0)
	i32.const	$push4=, -1
	i32.ne  	$push6=, $pop5, $pop4
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 128
	i32.add 	$push12=, $0, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
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
	i32.sub 	$push19=, $pop7, $pop8
	i32.store	$push29=, __stack_pointer($pop9), $pop19
	tee_local	$push28=, $0=, $pop29
	i32.const	$push13=, 64
	i32.add 	$push14=, $pop28, $pop13
	i32.const	$push27=, 0
	i32.const	$push1=, 64
	i32.call	$drop=, memset@FUNCTION, $pop14, $pop27, $pop1
	i32.const	$push26=, 0
	i32.const	$push25=, 64
	i32.call	$push24=, memset@FUNCTION, $0, $pop26, $pop25
	tee_local	$push23=, $0=, $pop24
	i32.const	$push15=, 64
	i32.add 	$push16=, $pop23, $pop15
	call    	foo@FUNCTION, $pop16, $0
	i32.const	$push22=, 0
	i32.load	$push2=, p($pop22)
	i32.const	$push17=, 64
	i32.add 	$push18=, $0, $pop17
	i32.const	$push21=, 64
	i32.call	$push0=, memcpy@FUNCTION, $pop2, $pop18, $pop21
	i32.const	$push20=, 64
	i32.call	$drop=, memcpy@FUNCTION, $pop0, $0, $pop20
	block
	i32.load	$push4=, 0($0)
	i32.const	$push3=, -1
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %test.exit
	i32.const	$push12=, 0
	i32.const	$push10=, 128
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push30=, 0
	return  	$pop30
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
