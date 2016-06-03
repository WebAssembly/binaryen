	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/zerolen-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store16	$drop=, entry($pop1):p2align=0, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.set,"ax",@progbits
	.hidden	set
	.globl	set
	.type	set,@function
set:                                    # @set
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store16	$drop=, 0($0):p2align=0, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	set, .Lfunc_end1-set

	.hidden	entry                   # @entry
	.type	entry,@object
	.section	.bss.entry,"aw",@nobits
	.globl	entry
entry:
	.skip	4
	.size	entry, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
