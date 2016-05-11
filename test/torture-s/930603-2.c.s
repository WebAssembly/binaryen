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
	i32.const	$push1=, 0
	i32.const	$push3=, 0
	i32.const	$push2=, 1
	i32.store	$push0=, w($pop3), $pop2
	i32.store	$discard=, w+12($pop1), $pop0
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.load	$0=, w+8($pop6)
	i32.const	$push5=, 0
	i32.load	$1=, w+4($pop5)
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.store	$push0=, w($pop3), $pop1
	i32.store	$discard=, w+12($pop4), $pop0
	block
	i32.or  	$push2=, $1, $0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
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
