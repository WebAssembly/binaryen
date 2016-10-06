	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/zero-struct-2.c"
	.section	.text.one_raw_spinlock,"ax",@progbits
	.hidden	one_raw_spinlock
	.globl	one_raw_spinlock
	.type	one_raw_spinlock,@function
one_raw_spinlock:                       # @one_raw_spinlock
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, ii($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	ii($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	one_raw_spinlock, .Lfunc_end0-one_raw_spinlock

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, ii($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop2, $pop0
	i32.store	ii($pop5), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
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

	.hidden	ii                      # @ii
	.type	ii,@object
	.section	.bss.ii,"aw",@nobits
	.globl	ii
	.p2align	2
ii:
	.int32	0                       # 0x0
	.size	ii, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
