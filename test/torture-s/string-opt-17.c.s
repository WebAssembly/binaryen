	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-17.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	i32.add 	$push1=, $1, $pop0
	i32.call	$drop=, strcpy@FUNCTION, $0, $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.check2,"ax",@progbits
	.hidden	check2
	.globl	check2
	.type	check2,@function
check2:                                 # @check2
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push0=, check2.r($pop4)
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	i32.const	$push3=, 6
	i32.store	check2.r($pop6), $pop3
	i32.const	$push5=, 6
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check2, .Lfunc_end1-check2

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push5=, 0
	i32.load	$push0=, check2.r($pop5)
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %check2.exit
	i32.const	$push6=, 0
	i32.const	$push3=, 6
	i32.store	check2.r($pop6), $pop3
	i32.const	$push4=, 8020322
	i32.store	0($0):p2align=0, $pop4
	return
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %lor.lhs.false
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push20=, $pop12, $pop13
	tee_local	$push19=, $0=, $pop20
	i32.store	__stack_pointer($pop14), $pop19
	i32.const	$push18=, 0
	i32.load8_u	$push0=, .L.str+9($pop18)
	i32.store8	6($0), $pop0
	i32.const	$push17=, 0
	i32.load16_u	$push1=, .L.str+7($pop17):p2align=0
	i32.store16	4($0), $pop1
	block   	
	i32.const	$push15=, 4
	i32.add 	$push16=, $0, $pop15
	i32.const	$push3=, .L.str.1
	i32.const	$push2=, 3
	i32.call	$push4=, memcmp@FUNCTION, $pop16, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push21=, 0
	i32.load	$push5=, check2.r($pop21)
	i32.const	$push6=, 5
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %test2.exit
	i32.const	$push22=, 0
	i32.const	$push8=, 6
	i32.store	check2.r($pop22), $pop8
	i32.const	$push9=, 8020322
	i32.store	4($0), $pop9
	i32.const	$push10=, 1
	i32.eqz 	$push24=, $pop10
	br_if   	0, $pop24       # 0: down to label2
# BB#3:                                 # %if.end8
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
.LBB3_4:                                # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"foobarbaz"
	.size	.L.str, 10

	.type	check2.r,@object        # @check2.r
	.section	.data.check2.r,"aw",@progbits
	.p2align	2
check2.r:
	.int32	5                       # 0x5
	.size	check2.r, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"az"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"baz"
	.size	.L.str.2, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
	.functype	exit, void, i32
