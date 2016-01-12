	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr35472.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.store	$discard=, p($pop1), $1
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 128
	i32.sub 	$29=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$29=, 0($9), $29
	i32.const	$0=, 56
	i32.const	$11=, 64
	i32.add 	$11=, $29, $11
	i32.add 	$push0=, $11, $0
	i64.const	$push1=, 0
	i64.store	$1=, 0($pop0), $pop1
	i32.const	$2=, 48
	i32.const	$12=, 64
	i32.add 	$12=, $29, $12
	i32.add 	$push2=, $12, $2
	i64.store	$discard=, 0($pop2), $1
	i32.const	$3=, 40
	i32.const	$13=, 64
	i32.add 	$13=, $29, $13
	i32.add 	$push3=, $13, $3
	i64.store	$discard=, 0($pop3), $1
	i32.const	$4=, 32
	i32.const	$14=, 64
	i32.add 	$14=, $29, $14
	i32.add 	$push4=, $14, $4
	i64.store	$discard=, 0($pop4), $1
	i32.const	$5=, 24
	i32.const	$15=, 64
	i32.add 	$15=, $29, $15
	i32.add 	$push5=, $15, $5
	i64.store	$discard=, 0($pop5), $1
	i32.const	$6=, 16
	i32.const	$16=, 64
	i32.add 	$16=, $29, $16
	i32.add 	$push6=, $16, $6
	i64.store	$discard=, 0($pop6), $1
	i32.const	$7=, 8
	i32.const	$17=, 64
	i32.add 	$17=, $29, $17
	i32.add 	$push7=, $17, $7
	i64.store	$push8=, 0($pop7), $1
	i64.store	$1=, 64($29), $pop8
	i32.const	$18=, 0
	i32.add 	$18=, $29, $18
	i32.add 	$push9=, $18, $0
	i64.store	$discard=, 0($pop9), $1
	i32.const	$19=, 0
	i32.add 	$19=, $29, $19
	i32.add 	$push10=, $19, $2
	i64.store	$discard=, 0($pop10), $1
	i32.const	$20=, 0
	i32.add 	$20=, $29, $20
	i32.add 	$push11=, $20, $3
	i64.store	$discard=, 0($pop11), $1
	i32.const	$21=, 0
	i32.add 	$21=, $29, $21
	i32.add 	$push12=, $21, $4
	i64.store	$discard=, 0($pop12), $1
	i32.const	$22=, 0
	i32.add 	$22=, $29, $22
	i32.add 	$push13=, $22, $5
	i64.store	$discard=, 0($pop13), $1
	i32.const	$23=, 0
	i32.add 	$23=, $29, $23
	i32.add 	$push14=, $23, $6
	i64.store	$discard=, 0($pop14), $1
	i32.const	$24=, 0
	i32.add 	$24=, $29, $24
	i32.add 	$push15=, $24, $7
	i64.store	$push16=, 0($pop15), $1
	i64.store	$discard=, 0($29), $pop16
	i32.const	$25=, 64
	i32.add 	$25=, $29, $25
	i32.const	$26=, 0
	i32.add 	$26=, $29, $26
	call    	foo@FUNCTION, $25, $26
	i32.const	$push17=, 0
	i32.load	$0=, p($pop17)
	i32.const	$2=, 64
	i32.const	$27=, 64
	i32.add 	$27=, $29, $27
	call    	memcpy@FUNCTION, $0, $27, $2
	i32.const	$28=, 0
	i32.add 	$28=, $29, $28
	call    	memcpy@FUNCTION, $0, $28, $2
	block   	.LBB1_2
	i32.load	$push18=, 0($29)
	i32.const	$push19=, -1
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	$pop20, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$10=, 128
	i32.add 	$29=, $29, $10
	i32.const	$10=, __stack_pointer
	i32.store	$29=, 0($10), $29
	return
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	test, .Lfunc_end1-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 128
	i32.sub 	$29=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$29=, 0($9), $29
	i32.const	$0=, 56
	i32.const	$11=, 64
	i32.add 	$11=, $29, $11
	i32.add 	$push0=, $11, $0
	i64.const	$push1=, 0
	i64.store	$1=, 0($pop0), $pop1
	i32.const	$2=, 48
	i32.const	$12=, 64
	i32.add 	$12=, $29, $12
	i32.add 	$push2=, $12, $2
	i64.store	$discard=, 0($pop2), $1
	i32.const	$3=, 40
	i32.const	$13=, 64
	i32.add 	$13=, $29, $13
	i32.add 	$push3=, $13, $3
	i64.store	$discard=, 0($pop3), $1
	i32.const	$4=, 32
	i32.const	$14=, 64
	i32.add 	$14=, $29, $14
	i32.add 	$push4=, $14, $4
	i64.store	$discard=, 0($pop4), $1
	i32.const	$5=, 24
	i32.const	$15=, 64
	i32.add 	$15=, $29, $15
	i32.add 	$push5=, $15, $5
	i64.store	$discard=, 0($pop5), $1
	i32.const	$6=, 16
	i32.const	$16=, 64
	i32.add 	$16=, $29, $16
	i32.add 	$push6=, $16, $6
	i64.store	$discard=, 0($pop6), $1
	i32.const	$7=, 8
	i32.const	$17=, 64
	i32.add 	$17=, $29, $17
	i32.add 	$push7=, $17, $7
	i64.store	$push8=, 0($pop7), $1
	i64.store	$1=, 64($29), $pop8
	i32.const	$18=, 0
	i32.add 	$18=, $29, $18
	i32.add 	$push9=, $18, $0
	i64.store	$discard=, 0($pop9), $1
	i32.const	$19=, 0
	i32.add 	$19=, $29, $19
	i32.add 	$push10=, $19, $2
	i64.store	$discard=, 0($pop10), $1
	i32.const	$20=, 0
	i32.add 	$20=, $29, $20
	i32.add 	$push11=, $20, $3
	i64.store	$discard=, 0($pop11), $1
	i32.const	$21=, 0
	i32.add 	$21=, $29, $21
	i32.add 	$push12=, $21, $4
	i64.store	$discard=, 0($pop12), $1
	i32.const	$22=, 0
	i32.add 	$22=, $29, $22
	i32.add 	$push13=, $22, $5
	i64.store	$discard=, 0($pop13), $1
	i32.const	$23=, 0
	i32.add 	$23=, $29, $23
	i32.add 	$push14=, $23, $6
	i64.store	$discard=, 0($pop14), $1
	i32.const	$24=, 0
	i32.add 	$24=, $29, $24
	i32.add 	$push15=, $24, $7
	i64.store	$push16=, 0($pop15), $1
	i64.store	$discard=, 0($29), $pop16
	i32.const	$25=, 64
	i32.add 	$25=, $29, $25
	i32.const	$26=, 0
	i32.add 	$26=, $29, $26
	call    	foo@FUNCTION, $25, $26
	i32.const	$3=, 0
	i32.load	$0=, p($3)
	i32.const	$2=, 64
	i32.const	$27=, 64
	i32.add 	$27=, $29, $27
	call    	memcpy@FUNCTION, $0, $27, $2
	i32.const	$28=, 0
	i32.add 	$28=, $29, $28
	call    	memcpy@FUNCTION, $0, $28, $2
	block   	.LBB2_2
	i32.load	$push17=, 0($29)
	i32.const	$push18=, -1
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	$pop19, .LBB2_2
# BB#1:                                 # %test.exit
	i32.const	$10=, 128
	i32.add 	$29=, $29, $10
	i32.const	$10=, __stack_pointer
	i32.store	$29=, 0($10), $29
	return  	$3
.LBB2_2:                                # %if.then.i
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
