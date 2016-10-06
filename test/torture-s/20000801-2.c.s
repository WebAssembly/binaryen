	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000801-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push3=, $0
	br_if   	0, $pop3        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push2=, 0($0)
	tee_local	$push1=, $0=, $pop2
	br_if   	0, $pop1        # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

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

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push11=, $pop3, $pop4
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop5), $pop10
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	i32.store	12($0), $pop7
	i32.const	$push0=, 0
	i32.store	8($0), $pop0
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	copy_local	$0=, $pop9
.LBB3_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load	$push13=, 0($0)
	tee_local	$push12=, $0=, $pop13
	br_if   	0, $pop12       # 0: up to label2
# BB#2:                                 # %if.end
	end_loop
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
