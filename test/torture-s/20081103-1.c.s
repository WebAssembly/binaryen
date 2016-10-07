	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081103-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push2=, 1($0):p2align=0
	i32.const	$push0=, 0
	i32.load	$push1=, A($pop0)
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push14=, $pop3, $pop4
	tee_local	$push13=, $1=, $pop14
	i32.store	__stack_pointer($pop5), $pop13
	i32.const	$push12=, 0
	i32.load	$push11=, A($pop12)
	tee_local	$push10=, $0=, $pop11
	i32.store	1($1):p2align=0, $pop10
	block   	
	i32.const	$push9=, 0
	i32.load	$push0=, A($pop9)
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %foo.exit
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	A                       # @A
	.type	A,@object
	.section	.data.A,"aw",@progbits
	.globl	A
	.p2align	2
A:
	.ascii	"1234"
	.size	A, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
