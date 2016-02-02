	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.add 	$push0=, $0, $2
	tee_local	$push4=, $3=, $pop0
	i32.load8_u	$push1=, 0($pop4)
	br_if   	$pop1, 2        # 2: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $1, $pop7
	br_if   	$pop8, 0        # 0: down to label3
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	$discard=, 0($3), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, 25
	i32.lt_u	$push2=, $2, $pop5
	br_if   	$pop2, 0        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push3=, 0
	i32.store	$discard=, p($pop3), $0
	return
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 64
	i32.sub 	$17=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$17=, 0($11), $17
	i32.const	$push0=, 24
	i32.const	$13=, 32
	i32.add 	$13=, $17, $13
	i32.add 	$push1=, $13, $pop0
	tee_local	$push24=, $9=, $pop1
	i32.const	$push2=, 0
	i32.store8	$0=, 0($pop24):p2align=3, $pop2
	i32.const	$push7=, 8
	i32.const	$14=, 32
	i32.add 	$14=, $17, $14
	i32.add 	$push8=, $14, $pop7
	tee_local	$push23=, $8=, $pop8
	i32.const	$push3=, 16
	i32.const	$15=, 32
	i32.add 	$15=, $17, $15
	i32.add 	$push4=, $15, $pop3
	tee_local	$push22=, $7=, $pop4
	i64.const	$push5=, 0
	i64.store	$push6=, 0($pop22), $pop5
	i64.store	$push9=, 0($pop23), $pop6
	i64.store	$discard=, 32($17), $pop9
	i32.const	$16=, 32
	i32.add 	$16=, $17, $16
	call    	foo@FUNCTION, $16, $0
	i64.load	$1=, 0($7)
	i32.const	$push21=, 24
	i32.add 	$push10=, $17, $pop21
	tee_local	$push20=, $6=, $pop10
	i32.load8_u	$push11=, 0($9):p2align=3
	i32.store8	$discard=, 0($pop20):p2align=3, $pop11
	i64.load	$2=, 0($8)
	i32.const	$push19=, 16
	i32.add 	$push12=, $17, $pop19
	tee_local	$push18=, $5=, $pop12
	i64.store	$discard=, 0($pop18), $1
	i64.load	$1=, 32($17)
	i32.const	$push17=, 8
	i32.add 	$push13=, $17, $pop17
	tee_local	$push16=, $4=, $pop13
	i64.store	$discard=, 0($pop16), $2
	i64.store	$discard=, 0($17), $1
	i32.const	$push14=, 1
	call    	foo@FUNCTION, $17, $pop14
	i64.load	$1=, 0($7)
	i64.load	$2=, 0($8)
	i64.load	$3=, 32($17)
	i32.load8_u	$push15=, 0($9):p2align=3
	i32.store8	$discard=, 0($6):p2align=3, $pop15
	i64.store	$discard=, 0($5), $1
	i64.store	$discard=, 0($4), $2
	i64.store	$discard=, 0($17), $3
	call    	foo@FUNCTION, $17, $0
	i32.const	$12=, 64
	i32.add 	$17=, $17, $12
	i32.const	$12=, __stack_pointer
	i32.store	$17=, 0($12), $17
	return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 64
	i32.sub 	$16=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$16=, 0($10), $16
	i32.const	$push0=, 24
	i32.const	$12=, 32
	i32.add 	$12=, $16, $12
	i32.add 	$push1=, $12, $pop0
	tee_local	$push35=, $3=, $pop1
	i32.const	$push2=, 0
	i32.store8	$0=, 0($pop35):p2align=3, $pop2
	i32.const	$push7=, 8
	i32.const	$13=, 32
	i32.add 	$13=, $16, $13
	i32.add 	$push8=, $13, $pop7
	tee_local	$push34=, $8=, $pop8
	i32.const	$push3=, 16
	i32.const	$14=, 32
	i32.add 	$14=, $16, $14
	i32.add 	$push4=, $14, $pop3
	tee_local	$push33=, $7=, $pop4
	i64.const	$push5=, 0
	i64.store	$push6=, 0($pop33), $pop5
	i64.store	$push9=, 0($pop34), $pop6
	i64.store	$discard=, 32($16), $pop9
	i32.const	$15=, 32
	i32.add 	$15=, $16, $15
	call    	foo@FUNCTION, $15, $0
	i64.load	$1=, 0($7)
	i32.const	$push32=, 24
	i32.add 	$push10=, $16, $pop32
	tee_local	$push31=, $6=, $pop10
	i32.load8_u	$push11=, 0($3):p2align=3
	i32.store8	$discard=, 0($pop31):p2align=3, $pop11
	i64.load	$2=, 0($8)
	i32.const	$push30=, 16
	i32.add 	$push12=, $16, $pop30
	tee_local	$push29=, $5=, $pop12
	i64.store	$discard=, 0($pop29), $1
	i64.load	$1=, 32($16)
	i32.const	$push28=, 8
	i32.add 	$push13=, $16, $pop28
	tee_local	$push27=, $4=, $pop13
	i64.store	$discard=, 0($pop27), $2
	i64.store	$discard=, 0($16), $1
	i32.const	$push14=, 1
	call    	foo@FUNCTION, $16, $pop14
	i32.load8_u	$push15=, 0($3):p2align=3
	i32.store8	$discard=, 0($6):p2align=3, $pop15
	i64.load	$1=, 0($8)
	i64.load	$2=, 32($16)
	i32.load	$3=, p($0)
	i64.load	$push16=, 0($7)
	i64.store	$discard=, 0($5), $pop16
	i64.store	$discard=, 0($4), $1
	i64.store	$discard=, 0($16), $2
	i32.const	$push26=, 24
	i32.add 	$push17=, $3, $pop26
	i32.load8_u	$push18=, 0($pop17)
	i32.store8	$discard=, 0($6):p2align=3, $pop18
	i32.const	$push25=, 16
	i32.add 	$push19=, $3, $pop25
	i64.load	$push20=, 0($pop19):p2align=0
	i64.store	$discard=, 0($5), $pop20
	i32.const	$push24=, 8
	i32.add 	$push21=, $3, $pop24
	i64.load	$push22=, 0($pop21):p2align=0
	i64.store	$discard=, 0($4), $pop22
	i64.load	$push23=, 0($3):p2align=0
	i64.store	$discard=, 0($16), $pop23
	call    	foo@FUNCTION, $16, $0
	i32.const	$11=, 64
	i32.add 	$16=, $16, $11
	i32.const	$11=, __stack_pointer
	i32.store	$16=, 0($11), $16
	return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 64
	i32.sub 	$18=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$18=, 0($12), $18
	i32.const	$push0=, 24
	i32.const	$14=, 32
	i32.add 	$14=, $18, $14
	i32.add 	$push1=, $14, $pop0
	tee_local	$push42=, $10=, $pop1
	i32.const	$push2=, 0
	i32.store8	$0=, 0($pop42):p2align=3, $pop2
	i32.const	$push7=, 8
	i32.const	$15=, 32
	i32.add 	$15=, $18, $15
	i32.add 	$push8=, $15, $pop7
	tee_local	$push41=, $9=, $pop8
	i32.const	$push3=, 16
	i32.const	$16=, 32
	i32.add 	$16=, $18, $16
	i32.add 	$push4=, $16, $pop3
	tee_local	$push40=, $8=, $pop4
	i64.const	$push5=, 0
	i64.store	$push6=, 0($pop40), $pop5
	i64.store	$push9=, 0($pop41), $pop6
	i64.store	$discard=, 32($18), $pop9
	i32.const	$17=, 32
	i32.add 	$17=, $18, $17
	call    	foo@FUNCTION, $17, $0
	i64.load	$1=, 0($8)
	i32.const	$push39=, 24
	i32.add 	$push10=, $18, $pop39
	tee_local	$push38=, $7=, $pop10
	i32.load8_u	$push11=, 0($10):p2align=3
	i32.store8	$discard=, 0($pop38):p2align=3, $pop11
	i64.load	$2=, 0($9)
	i32.const	$push37=, 16
	i32.add 	$push12=, $18, $pop37
	tee_local	$push36=, $6=, $pop12
	i64.store	$discard=, 0($pop36), $1
	i64.load	$1=, 32($18)
	i32.const	$push35=, 8
	i32.add 	$push13=, $18, $pop35
	tee_local	$push34=, $5=, $pop13
	i64.store	$discard=, 0($pop34), $2
	i64.store	$discard=, 0($18), $1
	i32.const	$push14=, 1
	call    	foo@FUNCTION, $18, $pop14
	i32.load	$push15=, p($0)
	tee_local	$push33=, $4=, $pop15
	i32.const	$push32=, 24
	i32.add 	$push16=, $pop33, $pop32
	tee_local	$push31=, $3=, $pop16
	i32.load8_u	$push17=, 0($10):p2align=3
	i32.store8	$discard=, 0($pop31), $pop17
	i32.const	$push30=, 16
	i32.add 	$push18=, $4, $pop30
	tee_local	$push29=, $10=, $pop18
	i64.load	$push19=, 0($8)
	i64.store	$discard=, 0($pop29):p2align=0, $pop19
	i32.const	$push28=, 8
	i32.add 	$push20=, $4, $pop28
	tee_local	$push27=, $8=, $pop20
	i64.load	$push21=, 0($9)
	i64.store	$discard=, 0($pop27):p2align=0, $pop21
	i64.load	$push22=, 32($18)
	i64.store	$discard=, 0($4):p2align=0, $pop22
	i32.load8_u	$push23=, 0($7):p2align=3
	i32.store8	$discard=, 0($3), $pop23
	i64.load	$push24=, 0($6)
	i64.store	$discard=, 0($10):p2align=0, $pop24
	i64.load	$push25=, 0($5)
	i64.store	$discard=, 0($8):p2align=0, $pop25
	i64.load	$push26=, 0($18)
	i64.store	$discard=, 0($4):p2align=0, $pop26
	call    	foo@FUNCTION, $18, $0
	i32.const	$13=, 64
	i32.add 	$18=, $18, $13
	i32.const	$13=, __stack_pointer
	i32.store	$18=, 0($13), $18
	return
	.endfunc
.Lfunc_end3:
	.size	test3, .Lfunc_end3-test3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	test1@FUNCTION
	call    	test2@FUNCTION
	call    	test3@FUNCTION
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.9.0 "
