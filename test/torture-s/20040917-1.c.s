	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040917-1.c"
	.section	.text.not_inlinable,"ax",@progbits
	.hidden	not_inlinable
	.globl	not_inlinable
	.type	not_inlinable,@function
not_inlinable:                          # @not_inlinable
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, -10
	i32.store	test_var($pop1), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	not_inlinable, .Lfunc_end0-not_inlinable

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push0=, 10
	i32.store	test_var($pop5), $pop0
	call    	not_inlinable@FUNCTION
	block   	
	i32.const	$push4=, 0
	i32.load	$push1=, test_var($pop4)
	i32.const	$push3=, 10
	i32.eq  	$push2=, $pop1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	test_var,@object        # @test_var
	.section	.bss.test_var,"aw",@nobits
	.p2align	2
test_var:
	.int32	0                       # 0x0
	.size	test_var, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
