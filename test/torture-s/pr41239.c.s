	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41239.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push21=, $pop12, $pop13
	tee_local	$push20=, $3=, $pop21
	i32.store	__stack_pointer($pop14), $pop20
	i32.load	$1=, 4($0)
	block   	
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.load	$push19=, 0($pop1)
	tee_local	$push18=, $0=, $pop19
	br_if   	0, $pop18       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push5=, 20
	i32.const	$push4=, .L.str
	i32.const	$push3=, 924
	i32.const	$push2=, .L__func__.test
	i32.const	$push22=, 0
	i32.call	$push6=, fn1@FUNCTION, $pop5, $pop4, $pop3, $pop2, $pop22
	i32.eqz 	$push24=, $pop6
	br_if   	0, $pop24       # 0: down to label0
# BB#2:                                 # %cond.true
	i32.const	$push7=, 33816706
	i32.call	$2=, fn3@FUNCTION, $pop7
	i32.const	$push8=, .L.str.1
	i32.const	$push23=, 0
	i32.call	$push9=, fn4@FUNCTION, $pop8, $pop23
	i32.store	0($3), $pop9
	call    	fn2@FUNCTION, $2, $3
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push17=, 0
	i32.const	$push15=, 16
	i32.add 	$push16=, $3, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	i32.div_s	$push10=, $1, $0
                                        # fallthrough-return: $pop10
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
                                        # fallthrough-return: $pop2
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
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
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
                                        # fallthrough-return: $pop0
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
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push11=, $pop6, $pop7
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop8), $pop10
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.s+8($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push9=, 0
	i64.load	$push4=, .Lmain.s($pop9):p2align=2
	i64.store	0($0), $pop4
	i32.call	$drop=, test@FUNCTION, $0
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
