	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930603-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.inc.1.1
	i32.const	$push2=, 0
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.store	$push0=, w+12($pop3), $pop1
	i32.store	$drop=, w($pop2), $pop0
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.const	$push1=, 1
	i32.store	$push0=, w+12($pop7), $pop1
	i32.store	$drop=, w($pop8), $pop0
	block
	i32.const	$push6=, 0
	i32.load	$push3=, w+4($pop6)
	i32.const	$push5=, 0
	i32.load	$push2=, w+8($pop5)
	i32.or  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	w                       # @w
	.type	w,@object
	.section	.bss.w,"aw",@nobits
	.globl	w
	.p2align	4
w:
	.skip	16
	.size	w, 16


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
