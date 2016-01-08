	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$6=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	i32.const	$0=, 0
	i32.const	$push1=, 8
	i32.const	$4=, 0
	i32.add 	$4=, $6, $4
	i32.or  	$push2=, $4, $pop1
	i64.load	$push0=, .Lmain.buf+8($0)
	i64.store	$discard=, 0($pop2), $pop0
	i64.load	$push3=, .Lmain.buf($0)
	i64.store	$discard=, 0($6), $pop3
	i32.const	$5=, 0
	i32.add 	$5=, $6, $5
	block   	.LBB0_2
	i32.call	$push4=, strlen, $5
	i32.store8	$push5=, 0($6), $pop4
	i32.const	$push6=, 255
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, .LBB0_2
# BB#1:                                 # %if.end
	i32.const	$3=, 16
	i32.add 	$6=, $6, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	return  	$0
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.Lmain.buf,@object      # @main.buf
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
.Lmain.buf:
	.asciz	"1234567890\000\000\000\000\000"
	.size	.Lmain.buf, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
