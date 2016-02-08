	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921117-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block
	i32.load	$push0=, 12($0)
	i32.const	$push1=, 99
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, .L.str
	i32.call	$1=, strcmp@FUNCTION, $0, $pop3
.LBB0_2:                                # %return
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push0=, 99
	i32.store	$discard=, cell+12($pop13), $pop0
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.load8_u	$push2=, .L.str+10($pop11)
	i32.store8	$discard=, cell+10($pop12):p2align=1, $pop2
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load16_u	$push3=, .L.str+8($pop9):p2align=0
	i32.store16	$discard=, cell+8($pop10):p2align=2, $pop3
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i64.load	$push4=, .L.str($pop7):p2align=0
	i64.store	$discard=, cell($pop8):p2align=2, $pop4
	block
	i32.const	$push1=, cell
	i32.const	$push5=, .L.str
	i32.call	$push6=, strcmp@FUNCTION, $pop1, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"0123456789"
	.size	.L.str, 11

	.hidden	cell                    # @cell
	.type	cell,@object
	.section	.bss.cell,"aw",@nobits
	.globl	cell
	.p2align	2
cell:
	.skip	16
	.size	cell, 16


	.ident	"clang version 3.9.0 "
