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
	i32.const	$push16=, 0
	i32.const	$push0=, 99
	i32.store	$drop=, cell+12($pop16), $pop0
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.load8_u	$push2=, .L.str+10($pop14)
	i32.store8	$drop=, cell+10($pop15), $pop2
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.load16_u	$push3=, .L.str+8($pop12):p2align=0
	i32.store16	$drop=, cell+8($pop13), $pop3
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load	$push4=, .L.str+4($pop10):p2align=0
	i32.store	$drop=, cell+4($pop11), $pop4
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load	$push5=, .L.str($pop8):p2align=0
	i32.store	$drop=, cell($pop9), $pop5
	block
	i32.const	$push1=, cell
	i32.const	$push6=, .L.str
	i32.call	$push7=, strcmp@FUNCTION, $pop1, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
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
