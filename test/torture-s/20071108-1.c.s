	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071108-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, foo.s
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	foo.s+4($pop0), $1
	i32.const	$push2=, 0
	i32.store	foo.s($pop2), $0
	i32.const	$push1=, foo.s
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %lor.lhs.false
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push25=, $pop8, $pop9
	tee_local	$push24=, $1=, $pop25
	i32.store	__stack_pointer($pop10), $pop24
	block   	
	i32.const	$push14=, 12
	i32.add 	$push15=, $1, $pop14
	i32.const	$push16=, 8
	i32.add 	$push17=, $1, $pop16
	i32.call	$push23=, test@FUNCTION, $pop15, $pop17
	tee_local	$push22=, $0=, $pop23
	i32.load	$push0=, 0($pop22)
	i32.const	$push18=, 12
	i32.add 	$push19=, $1, $pop18
	i32.ne  	$push1=, $pop0, $pop19
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false2
	i32.load	$push2=, 4($0)
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	i32.ne  	$push3=, $pop2, $pop21
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %lor.lhs.false4
	i32.load8_u	$push4=, 8($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %lor.lhs.false5
	i32.load8_u	$push5=, 9($0)
	br_if   	0, $pop5        # 0: down to label0
# BB#4:                                 # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i32.const	$push6=, 0
	return  	$pop6
.LBB3_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	foo.s,@object           # @foo.s
	.section	.bss.foo.s,"aw",@nobits
	.p2align	2
foo.s:
	.skip	12
	.size	foo.s, 12


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
