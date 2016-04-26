	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$0=, $pop12, $pop13
	i32.const	$push14=, __stack_pointer
	i32.store	$discard=, 0($pop14), $0
	i32.const	$push9=, 0
	i64.load	$push0=, .Lmain.buf+8($pop9)
	i64.store	$discard=, 8($0), $pop0
	i32.const	$push8=, 0
	i64.load	$push1=, .Lmain.buf($pop8)
	i64.store	$discard=, 0($0), $pop1
	block
	i32.call	$push2=, strlen@FUNCTION, $0
	i32.store8	$push3=, 0($0), $pop2
	i32.const	$push4=, 255
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 10
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push17=, __stack_pointer
	i32.const	$push15=, 16
	i32.add 	$push16=, $0, $pop15
	i32.store	$discard=, 0($pop17), $pop16
	return  	$pop10
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
