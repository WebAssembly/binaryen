	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr22630.c"
	.section	.text.bla,"ax",@progbits
	.hidden	bla
	.globl	bla
	.type	bla,@function
bla:                                    # @bla
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, j
	i32.select	$push1=, $0, $0, $pop0
	i32.eq  	$push2=, $pop1, $0
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.then1
	i32.const	$push3=, 0
	i32.const	$push4=, 1
	i32.store	$discard=, j($pop3), $pop4
.LBB0_2:                                # %if.end2
	end_block                       # label0:
	return
.Lfunc_end0:
	.size	bla, .Lfunc_end0-bla

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, j($0), $pop0
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
