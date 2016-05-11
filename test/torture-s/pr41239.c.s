	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41239.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, __stack_pointer
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push19=, $pop13, $pop14
	i32.store	$1=, 0($pop15), $pop19
	i32.load	$2=, 4($0)
	block
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.load	$push21=, 0($pop1)
	tee_local	$push20=, $0=, $pop21
	br_if   	0, $pop20       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push5=, 20
	i32.const	$push3=, .L.str
	i32.const	$push4=, 924
	i32.const	$push2=, .L__func__.test
	i32.const	$push22=, 0
	i32.call	$push6=, fn1@FUNCTION, $pop5, $pop3, $pop4, $pop2, $pop22
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push24=, 0
	i32.eq  	$push25=, $pop8, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#2:                                 # %cond.true
	i32.const	$push9=, 33816706
	i32.call	$3=, fn3@FUNCTION, $pop9
	i32.const	$push10=, .L.str.1
	i32.const	$push23=, 0
	i32.call	$push11=, fn4@FUNCTION, $pop10, $pop23
	i32.store	$discard=, 0($1), $pop11
	call    	fn2@FUNCTION, $3, $1
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.div_s	$0=, $2, $0
	i32.const	$push18=, __stack_pointer
	i32.const	$push16=, 16
	i32.add 	$push17=, $1, $pop16
	i32.store	$discard=, 0($pop18), $pop17
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	#APP
	#NO_APP
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push3=, 24
	i32.shr_s	$push2=, $pop1, $pop3
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	fn1, .Lfunc_end1-fn1

	.section	.text.fn2,"ax",@progbits
	.hidden	fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.param  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	block
	br_if   	0, $0           # 0: down to label1
# BB#1:                                 # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label1:
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	fn2, .Lfunc_end2-fn2

	.section	.text.fn3,"ax",@progbits
	.hidden	fn3
	.globl	fn3
	.type	fn3,@function
fn3:                                    # @fn3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return  	$0
	.endfunc
.Lfunc_end3:
	.size	fn3, .Lfunc_end3-fn3

	.section	.text.fn4,"ax",@progbits
	.hidden	fn4
	.globl	fn4
	.type	fn4,@function
fn4:                                    # @fn4
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i32.load8_s	$push0=, 0($0)
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	fn4, .Lfunc_end4-fn4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push9=, $pop6, $pop7
	i32.store	$push12=, 0($pop8), $pop9
	tee_local	$push11=, $0=, $pop12
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop11, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.s+8($pop0)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push10=, 0
	i64.load	$push4=, .Lmain.s($pop10):p2align=2
	i64.store	$discard=, 0($0), $pop4
	i32.call	$discard=, test@FUNCTION, $0
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"foo"
	.size	.L.str, 4

	.type	.L__func__.test,@object # @__func__.test
.L__func__.test:
	.asciz	"test"
	.size	.L__func__.test, 5

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"division by zero"
	.size	.L.str.1, 17

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
	.p2align	2
.Lmain.s:
	.int16	2                       # 0x2
	.skip	2
	.int32	5                       # 0x5
	.int32	0                       # 0x0
	.size	.Lmain.s, 12


	.ident	"clang version 3.9.0 "
