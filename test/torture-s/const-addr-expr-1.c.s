	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/const-addr-expr-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	.LBB0_4
	i32.load	$push0=, Upgd_minor_ID($2)
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_4
# BB#1:                                 # %if.end
	block   	.LBB0_3
	i32.load	$push4=, Upgd_minor_ID1($2)
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB0_3
# BB#2:                                 # %if.end3
	return  	$2
.LBB0_3:                                # %if.then2
	call    	abort
	unreachable
.LBB0_4:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"1"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"2"
	.size	.L.str.1, 2

	.hidden	Upgrade_items           # @Upgrade_items
	.type	Upgrade_items,@object
	.section	.data.Upgrade_items,"aw",@progbits
	.globl	Upgrade_items
	.align	4
Upgrade_items:
	.int32	1                       # 0x1
	.int32	.L.str
	.int32	2                       # 0x2
	.int32	.L.str.1
	.skip	8
	.size	Upgrade_items, 24

	.hidden	Upgd_minor_ID           # @Upgd_minor_ID
	.type	Upgd_minor_ID,@object
	.section	.data.Upgd_minor_ID,"aw",@progbits
	.globl	Upgd_minor_ID
	.align	2
Upgd_minor_ID:
	.int32	Upgrade_items+8
	.size	Upgd_minor_ID, 4

	.hidden	Upgd_minor_ID1          # @Upgd_minor_ID1
	.type	Upgd_minor_ID1,@object
	.section	.data.Upgd_minor_ID1,"aw",@progbits
	.globl	Upgd_minor_ID1
	.align	2
Upgd_minor_ID1:
	.int32	Upgrade_items
	.size	Upgd_minor_ID1, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
