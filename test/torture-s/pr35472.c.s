	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr35472.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.store	$discard=, p($pop1), $1
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 128
	i32.sub 	$3=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $3
	i32.const	$push1=, 0
	i32.const	$push0=, 64
	i32.const	$0=, 64
	i32.add 	$0=, $3, $0
	i32.call	$discard=, memset@FUNCTION, $0, $pop1, $pop0
	i32.const	$push11=, 0
	i32.const	$push10=, 64
	i32.call	$discard=, memset@FUNCTION, $3, $pop11, $pop10
	i32.const	$1=, 64
	i32.add 	$1=, $3, $1
	call    	foo@FUNCTION, $1, $3
	i32.const	$push9=, 0
	i32.load	$push2=, p($pop9)
	i32.const	$push8=, 64
	i32.const	$2=, 64
	i32.add 	$2=, $3, $2
	i32.call	$push3=, memcpy@FUNCTION, $pop2, $2, $pop8
	i32.const	$push7=, 64
	i32.call	$discard=, memcpy@FUNCTION, $pop3, $3, $pop7
	block
	i32.load	$push4=, 0($3):p2align=3
	i32.const	$push5=, -1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push16=, 128
	i32.add 	$3=, $3, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $3
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 128
	i32.sub 	$3=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $3
	i32.const	$push11=, 0
	i32.const	$push0=, 64
	i32.const	$0=, 64
	i32.add 	$0=, $3, $0
	i32.call	$discard=, memset@FUNCTION, $0, $pop11, $pop0
	i32.const	$push10=, 0
	i32.const	$push9=, 64
	i32.call	$discard=, memset@FUNCTION, $3, $pop10, $pop9
	i32.const	$1=, 64
	i32.add 	$1=, $3, $1
	call    	foo@FUNCTION, $1, $3
	i32.const	$push8=, 0
	i32.load	$push1=, p($pop8)
	i32.const	$push7=, 64
	i32.const	$2=, 64
	i32.add 	$2=, $3, $2
	i32.call	$push2=, memcpy@FUNCTION, $pop1, $2, $pop7
	i32.const	$push6=, 64
	i32.call	$discard=, memcpy@FUNCTION, $pop2, $3, $pop6
	block
	i32.load	$push3=, 0($3):p2align=3
	i32.const	$push4=, -1
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %test.exit
	i32.const	$push12=, 0
	i32.const	$push17=, 128
	i32.add 	$3=, $3, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $3
	return  	$pop12
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
