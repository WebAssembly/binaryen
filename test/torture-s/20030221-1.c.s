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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push15=, $pop9, $pop10
	i32.store	$push19=, __stack_pointer($pop11), $pop15
	tee_local	$push18=, $0=, $pop19
	i32.const	$push17=, 0
	i64.load	$push1=, .Lmain.buf+8($pop17)
	i64.store	$drop=, 8($pop18), $pop1
	i32.const	$push16=, 0
	i64.load	$push2=, .Lmain.buf($pop16)
	i64.store	$drop=, 0($0), $pop2
	block
	i32.call	$push3=, strlen@FUNCTION, $0
	i32.store8	$push0=, 0($0), $pop3
	i32.const	$push4=, 255
	i32.and 	$push5=, $pop0, $pop4
	i32.const	$push6=, 10
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i32.store	$drop=, __stack_pointer($pop14), $pop13
	i32.const	$push20=, 0
	return  	$pop20
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
	.functype	strlen, i32, i32
	.functype	abort, void
