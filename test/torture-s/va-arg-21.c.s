	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-21.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	i32.store	$push8=, 0($pop5), $pop6
	tee_local	$push7=, $0=, $pop8
	i32.const	$push0=, .L.str.1
	i32.store	$discard=, 0($pop7), $pop0
	call    	doit@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.doit,"ax",@progbits
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 4
	i32.call	$2=, malloc@FUNCTION, $pop1
	i32.const	$push10=, 4
	i32.call	$3=, malloc@FUNCTION, $pop10
	i32.const	$push2=, 0
	i32.load	$push3=, stdout($pop2)
	i32.const	$push4=, .L.str
	i32.store	$push9=, 0($2), $1
	tee_local	$push8=, $1=, $pop9
	i32.call	$discard=, vfprintf@FUNCTION, $pop3, $pop4, $pop8
	i32.const	$push7=, 0
	i32.load	$push5=, stdout($pop7)
	i32.const	$push6=, .L.str
	i32.store	$push0=, 0($3), $1
	i32.call	$discard=, vfprintf@FUNCTION, $pop5, $pop6, $pop0
	block
	i32.const	$push11=, 0
	i32.eq  	$push12=, $3, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	doit, .Lfunc_end1-doit

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%s"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello world\n"
	.size	.L.str.1, 13


	.ident	"clang version 3.9.0 "
