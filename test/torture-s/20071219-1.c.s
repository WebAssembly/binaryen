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
	i32.add 	$push4=, $0, $2
	tee_local	$push3=, $3=, $pop4
	i32.load8_u	$push0=, 0($pop3)
	br_if   	2, $pop0        # 2: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $1, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	$discard=, 0($3), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, 25
	i32.lt_u	$push1=, $2, $pop5
	br_if   	0, $pop1        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push2=, 0
	i32.store	$discard=, p($pop2), $0
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
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.load	$push26=, 0($pop25)
	i32.const	$push27=, 64
	i32.sub 	$14=, $pop26, $pop27
	i32.const	$push28=, __stack_pointer
	i32.store	$discard=, 0($pop28), $14
	i32.const	$push0=, 24
	i32.const	$10=, 32
	i32.add 	$10=, $14, $10
	i32.add 	$push24=, $10, $pop0
	tee_local	$push23=, $9=, $pop24
	i32.const	$push1=, 0
	i32.store8	$0=, 0($pop23):p2align=3, $pop1
	i32.const	$push5=, 8
	i32.const	$11=, 32
	i32.add 	$11=, $14, $11
	i32.add 	$push22=, $11, $pop5
	tee_local	$push21=, $8=, $pop22
	i32.const	$push2=, 16
	i32.const	$12=, 32
	i32.add 	$12=, $14, $12
	i32.add 	$push20=, $12, $pop2
	tee_local	$push19=, $7=, $pop20
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop19), $pop3
	i64.store	$push6=, 0($pop21), $pop4
	i64.store	$discard=, 32($14), $pop6
	i32.const	$13=, 32
	i32.add 	$13=, $14, $13
	call    	foo@FUNCTION, $13, $0
	i64.load	$1=, 0($7)
	i32.const	$push18=, 24
	i32.add 	$push17=, $14, $pop18
	tee_local	$push16=, $6=, $pop17
	i32.load8_u	$push7=, 0($9):p2align=3
	i32.store8	$discard=, 0($pop16):p2align=3, $pop7
	i64.load	$2=, 0($8)
	i32.const	$push15=, 16
	i32.add 	$push14=, $14, $pop15
	tee_local	$push13=, $5=, $pop14
	i64.store	$discard=, 0($pop13), $1
	i64.load	$1=, 32($14)
	i32.const	$push12=, 8
	i32.add 	$push11=, $14, $pop12
	tee_local	$push10=, $4=, $pop11
	i64.store	$discard=, 0($pop10), $2
	i64.store	$discard=, 0($14), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $14, $pop8
	i64.load	$1=, 0($7)
	i64.load	$2=, 0($8)
	i64.load	$3=, 32($14)
	i32.load8_u	$push9=, 0($9):p2align=3
	i32.store8	$discard=, 0($6):p2align=3, $pop9
	i64.store	$discard=, 0($5), $1
	i64.store	$discard=, 0($4), $2
	i64.store	$discard=, 0($14), $3
	call    	foo@FUNCTION, $14, $0
	i32.const	$push29=, 64
	i32.add 	$14=, $14, $pop29
	i32.const	$push30=, __stack_pointer
	i32.store	$discard=, 0($pop30), $14
	return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push36=, __stack_pointer
	i32.load	$push37=, 0($pop36)
	i32.const	$push38=, 64
	i32.sub 	$13=, $pop37, $pop38
	i32.const	$push39=, __stack_pointer
	i32.store	$discard=, 0($pop39), $13
	i32.const	$push0=, 24
	i32.const	$9=, 32
	i32.add 	$9=, $13, $9
	i32.add 	$push35=, $9, $pop0
	tee_local	$push34=, $3=, $pop35
	i32.const	$push1=, 0
	i32.store8	$0=, 0($pop34):p2align=3, $pop1
	i32.const	$push5=, 8
	i32.const	$10=, 32
	i32.add 	$10=, $13, $10
	i32.add 	$push33=, $10, $pop5
	tee_local	$push32=, $8=, $pop33
	i32.const	$push2=, 16
	i32.const	$11=, 32
	i32.add 	$11=, $13, $11
	i32.add 	$push31=, $11, $pop2
	tee_local	$push30=, $7=, $pop31
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop30), $pop3
	i64.store	$push6=, 0($pop32), $pop4
	i64.store	$discard=, 32($13), $pop6
	i32.const	$12=, 32
	i32.add 	$12=, $13, $12
	call    	foo@FUNCTION, $12, $0
	i64.load	$1=, 0($7)
	i32.const	$push29=, 24
	i32.add 	$push28=, $13, $pop29
	tee_local	$push27=, $6=, $pop28
	i32.load8_u	$push7=, 0($3):p2align=3
	i32.store8	$discard=, 0($pop27):p2align=3, $pop7
	i64.load	$2=, 0($8)
	i32.const	$push26=, 16
	i32.add 	$push25=, $13, $pop26
	tee_local	$push24=, $5=, $pop25
	i64.store	$discard=, 0($pop24), $1
	i64.load	$1=, 32($13)
	i32.const	$push23=, 8
	i32.add 	$push22=, $13, $pop23
	tee_local	$push21=, $4=, $pop22
	i64.store	$discard=, 0($pop21), $2
	i64.store	$discard=, 0($13), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $13, $pop8
	i32.load8_u	$push9=, 0($3):p2align=3
	i32.store8	$discard=, 0($6):p2align=3, $pop9
	i64.load	$1=, 0($8)
	i64.load	$2=, 32($13)
	i32.load	$3=, p($0)
	i64.load	$push10=, 0($7)
	i64.store	$discard=, 0($5), $pop10
	i64.store	$discard=, 0($4), $1
	i64.store	$discard=, 0($13), $2
	i32.const	$push20=, 24
	i32.add 	$push11=, $3, $pop20
	i32.load8_u	$push12=, 0($pop11)
	i32.store8	$discard=, 0($6):p2align=3, $pop12
	i32.const	$push19=, 16
	i32.add 	$push13=, $3, $pop19
	i64.load	$push14=, 0($pop13):p2align=0
	i64.store	$discard=, 0($5), $pop14
	i32.const	$push18=, 8
	i32.add 	$push15=, $3, $pop18
	i64.load	$push16=, 0($pop15):p2align=0
	i64.store	$discard=, 0($4), $pop16
	i64.load	$push17=, 0($3):p2align=0
	i64.store	$discard=, 0($13), $pop17
	call    	foo@FUNCTION, $13, $0
	i32.const	$push40=, 64
	i32.add 	$13=, $13, $pop40
	i32.const	$push41=, __stack_pointer
	i32.store	$discard=, 0($pop41), $13
	return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push43=, __stack_pointer
	i32.load	$push44=, 0($pop43)
	i32.const	$push45=, 64
	i32.sub 	$15=, $pop44, $pop45
	i32.const	$push46=, __stack_pointer
	i32.store	$discard=, 0($pop46), $15
	i32.const	$push0=, 24
	i32.const	$11=, 32
	i32.add 	$11=, $15, $11
	i32.add 	$push42=, $11, $pop0
	tee_local	$push41=, $10=, $pop42
	i32.const	$push1=, 0
	i32.store8	$0=, 0($pop41):p2align=3, $pop1
	i32.const	$push5=, 8
	i32.const	$12=, 32
	i32.add 	$12=, $15, $12
	i32.add 	$push40=, $12, $pop5
	tee_local	$push39=, $9=, $pop40
	i32.const	$push2=, 16
	i32.const	$13=, 32
	i32.add 	$13=, $15, $13
	i32.add 	$push38=, $13, $pop2
	tee_local	$push37=, $8=, $pop38
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop37), $pop3
	i64.store	$push6=, 0($pop39), $pop4
	i64.store	$discard=, 32($15), $pop6
	i32.const	$14=, 32
	i32.add 	$14=, $15, $14
	call    	foo@FUNCTION, $14, $0
	i64.load	$1=, 0($8)
	i32.const	$push36=, 24
	i32.add 	$push35=, $15, $pop36
	tee_local	$push34=, $7=, $pop35
	i32.load8_u	$push7=, 0($10):p2align=3
	i32.store8	$discard=, 0($pop34):p2align=3, $pop7
	i64.load	$2=, 0($9)
	i32.const	$push33=, 16
	i32.add 	$push32=, $15, $pop33
	tee_local	$push31=, $6=, $pop32
	i64.store	$discard=, 0($pop31), $1
	i64.load	$1=, 32($15)
	i32.const	$push30=, 8
	i32.add 	$push29=, $15, $pop30
	tee_local	$push28=, $5=, $pop29
	i64.store	$discard=, 0($pop28), $2
	i64.store	$discard=, 0($15), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $15, $pop8
	i32.load	$push27=, p($0)
	tee_local	$push26=, $4=, $pop27
	i32.const	$push25=, 24
	i32.add 	$push24=, $pop26, $pop25
	tee_local	$push23=, $3=, $pop24
	i32.load8_u	$push9=, 0($10):p2align=3
	i32.store8	$discard=, 0($pop23), $pop9
	i32.const	$push22=, 16
	i32.add 	$push21=, $4, $pop22
	tee_local	$push20=, $10=, $pop21
	i64.load	$push10=, 0($8)
	i64.store	$discard=, 0($pop20):p2align=0, $pop10
	i32.const	$push19=, 8
	i32.add 	$push18=, $4, $pop19
	tee_local	$push17=, $8=, $pop18
	i64.load	$push11=, 0($9)
	i64.store	$discard=, 0($pop17):p2align=0, $pop11
	i64.load	$push12=, 32($15)
	i64.store	$discard=, 0($4):p2align=0, $pop12
	i32.load8_u	$push13=, 0($7):p2align=3
	i32.store8	$discard=, 0($3), $pop13
	i64.load	$push14=, 0($6)
	i64.store	$discard=, 0($10):p2align=0, $pop14
	i64.load	$push15=, 0($5)
	i64.store	$discard=, 0($8):p2align=0, $pop15
	i64.load	$push16=, 0($15)
	i64.store	$discard=, 0($4):p2align=0, $pop16
	call    	foo@FUNCTION, $15, $0
	i32.const	$push47=, 64
	i32.add 	$15=, $15, $pop47
	i32.const	$push48=, __stack_pointer
	i32.store	$discard=, 0($pop48), $15
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
