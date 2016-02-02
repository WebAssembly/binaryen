	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push1=, 8
	i32.or  	$push2=, $3, $pop1
	i32.const	$push11=, 0
	i64.load	$push0=, .Lmain.buf+8($pop11)
	i64.store	$discard=, 0($pop2), $pop0
	i32.const	$push10=, 0
	i64.load	$push3=, .Lmain.buf($pop10):p2align=4
	i64.store	$discard=, 0($3):p2align=4, $pop3
	block
	i32.call	$push4=, strlen@FUNCTION, $3
	i32.store8	$push5=, 0($3):p2align=4, $pop4
	i32.const	$push6=, 255
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop12
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.Lmain.buf,@object      # @main.buf
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.Lmain.buf:
	.asciz	"1234567890\000\000\000\000\000"
	.size	.Lmain.buf, 16


	.ident	"clang version 3.9.0 "
