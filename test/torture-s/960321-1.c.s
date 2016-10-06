	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960321-1.c"
	.section	.text.acc_a,"ax",@progbits
	.hidden	acc_a
	.globl	acc_a
	.type	acc_a,@function
acc_a:                                  # @acc_a
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, a-2000000000
	i32.add 	$push1=, $0, $pop0
	i32.load8_s	$push2=, 0($pop1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	acc_a, .Lfunc_end0-acc_a

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 0
	i32.load8_u	$push0=, a($pop3)
	i32.const	$push1=, 100
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
a:
	.asciz	"deadbeef\000"
	.size	a, 10


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
