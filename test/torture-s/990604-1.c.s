	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, b($pop2)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %do.body.preheader
	i32.const	$push3=, 0
	i32.const	$push1=, 9
	i32.store	b($pop3), $pop1
.LBB0_2:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push6=, 0
	i32.load	$push5=, b($pop6)
	tee_local	$push4=, $0=, $pop5
	i32.const	$push0=, 9
	i32.eq  	$push1=, $pop4, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	br_if   	1, $0           # 1: down to label1
# BB#2:                                 # %f.exit.thread
	i32.const	$push3=, 0
	i32.const	$push2=, 9
	i32.store	b($pop3), $pop2
.LBB1_3:                                # %if.end
	end_block                       # label2:
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
