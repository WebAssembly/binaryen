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
	i32.add 	$push3=, $pop2, $1
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, check2.r($0)
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 6
	i32.store	$push4=, check2.r($0), $pop3
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.load	$push0=, check2.r($1)
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %check2.exit
	i32.const	$push3=, 6
	i32.store	$discard=, check2.r($1), $pop3
	i32.const	$push4=, 3
	i32.add 	$push5=, $0, $pop4
	i32.store8	$discard=, 0($pop5), $1
	i32.const	$push6=, 2
	i32.add 	$push7=, $0, $pop6
	i32.const	$push8=, 122
	i32.store8	$discard=, 0($pop7), $pop8
	i32.const	$push9=, 1
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 97
	i32.store8	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 98
	i32.store8	$discard=, 0($0), $pop12
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %lor.lhs.false
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$6=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	i32.const	$0=, 0
	i32.const	$1=, 1
	i32.const	$push1=, 2
	i32.const	$4=, 4
	i32.add 	$4=, $6, $4
	i32.or  	$push2=, $4, $pop1
	i32.load8_u	$push0=, .L.str+9($0)
	i32.store8	$discard=, 0($pop2), $pop0
	i32.const	$push3=, .L.str+7
	i32.add 	$push4=, $pop3, $1
	i32.load8_u	$push5=, 0($pop4)
	i32.const	$push6=, 8
	i32.shl 	$push7=, $pop5, $pop6
	i32.load8_u	$push8=, .L.str+7($0)
	i32.or  	$push9=, $pop7, $pop8
	i32.store16	$discard=, 4($6), $pop9
	i32.const	$push10=, .L.str.1
	i32.const	$push11=, 3
	i32.const	$5=, 4
	i32.add 	$5=, $6, $5
	block
	i32.call	$push12=, memcmp@FUNCTION, $5, $pop10, $pop11
	br_if   	$pop12, 0       # 0: down to label2
# BB#1:                                 # %if.end
	block
	i32.load	$push13=, check2.r($0)
	i32.const	$push14=, 5
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label3
# BB#2:                                 # %test2.exit
	block
	i32.const	$push16=, 6
	i32.store	$discard=, check2.r($0), $pop16
	i32.const	$push17=, 8020322
	i32.store	$discard=, 4($6), $pop17
	i32.const	$push18=, 0
	i32.eq  	$push19=, $1, $pop18
	br_if   	$pop19, 0       # 0: down to label4
# BB#3:                                 # %if.end8
	call    	exit@FUNCTION, $0
	unreachable
.LBB3_4:                                # %if.then7
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %if.then.i.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then
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
	.align	2
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
