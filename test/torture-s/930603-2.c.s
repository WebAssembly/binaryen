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
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$push1=, w($0), $pop0
	i32.store	$discard=, w+12($0), $pop1
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, w+8($0)
	i32.load	$2=, w+4($0)
	block
	i32.const	$push0=, 1
	i32.store	$push1=, w($0), $pop0
	i32.store	$discard=, w+12($0), $pop1
	i32.or  	$push2=, $2, $1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
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
	.align	4
w:
	.skip	16
	.size	w, 16


	.ident	"clang version 3.9.0 "
