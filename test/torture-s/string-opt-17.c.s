	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-17.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, .L.str
	i32.add 	$push3=, $1, $pop2
	i32.call	$discard=, strcpy@FUNCTION, $0, $pop3
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	return  	$pop1
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
	i32.const	$push5=, 0
	i32.load	$push0=, check2.r($pop5)
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	i32.const	$push3=, 6
	i32.store	$push4=, check2.r($pop6), $pop3
	return  	$pop4
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
	i32.store	$discard=, check2.r($pop6), $pop3
	i32.const	$push4=, 8020322
	i32.store	$discard=, 0($0):p2align=0, $pop4
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %lor.lhs.false
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push1=, 2
	i32.const	$2=, 4
	i32.add 	$2=, $4, $2
	i32.or  	$push2=, $2, $pop1
	i32.const	$push14=, 0
	i32.load8_u	$push0=, .L.str+9($pop14)
	i32.store8	$discard=, 0($pop2):p2align=1, $pop0
	i32.const	$push13=, 0
	i32.load16_u	$push3=, .L.str+7($pop13):p2align=0
	i32.store16	$discard=, 4($4):p2align=2, $pop3
	i32.const	$push4=, .L.str.1
	i32.const	$push5=, 3
	i32.const	$3=, 4
	i32.add 	$3=, $4, $3
	block
	block
	block
	i32.call	$push6=, memcmp@FUNCTION, $3, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push15=, 0
	i32.load	$push7=, check2.r($pop15)
	i32.const	$push8=, 5
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label3
# BB#2:                                 # %test2.exit
	i32.const	$push16=, 0
	i32.const	$push10=, 6
	i32.store	$discard=, check2.r($pop16), $pop10
	i32.const	$push11=, 8020322
	i32.store	$discard=, 4($4), $pop11
	i32.const	$push12=, 1
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop12, $pop18
	br_if   	2, $pop19       # 2: down to label2
# BB#3:                                 # %if.end8
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %if.then.i.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then7
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


	.ident	"clang version 3.9.0 "
