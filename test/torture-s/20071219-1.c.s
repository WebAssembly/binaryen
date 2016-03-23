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
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.load	$push26=, 0($pop25)
	i32.const	$push27=, 64
	i32.sub 	$10=, $pop26, $pop27
	i32.const	$push28=, __stack_pointer
	i32.store	$discard=, 0($pop28), $10
	i32.const	$push32=, 32
	i32.add 	$push33=, $10, $pop32
	i32.const	$push0=, 24
	i32.add 	$push24=, $pop33, $pop0
	tee_local	$push23=, $9=, $pop24
	i32.const	$push1=, 0
	i32.store8	$0=, 0($pop23):p2align=3, $pop1
	i32.const	$push34=, 32
	i32.add 	$push35=, $10, $pop34
	i32.const	$push5=, 8
	i32.add 	$push22=, $pop35, $pop5
	tee_local	$push21=, $8=, $pop22
	i32.const	$push36=, 32
	i32.add 	$push37=, $10, $pop36
	i32.const	$push2=, 16
	i32.add 	$push20=, $pop37, $pop2
	tee_local	$push19=, $7=, $pop20
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop19), $pop3
	i64.store	$push6=, 0($pop21), $pop4
	i64.store	$discard=, 32($10), $pop6
	i32.const	$push38=, 32
	i32.add 	$push39=, $10, $pop38
	call    	foo@FUNCTION, $pop39, $0
	i64.load	$1=, 0($7)
	i32.const	$push18=, 24
	i32.add 	$push17=, $10, $pop18
	tee_local	$push16=, $6=, $pop17
	i32.load8_u	$push7=, 0($9):p2align=3
	i32.store8	$discard=, 0($pop16):p2align=3, $pop7
	i64.load	$2=, 0($8)
	i32.const	$push15=, 16
	i32.add 	$push14=, $10, $pop15
	tee_local	$push13=, $5=, $pop14
	i64.store	$discard=, 0($pop13), $1
	i64.load	$1=, 32($10)
	i32.const	$push12=, 8
	i32.add 	$push11=, $10, $pop12
	tee_local	$push10=, $4=, $pop11
	i64.store	$discard=, 0($pop10), $2
	i64.store	$discard=, 0($10), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $10, $pop8
	i64.load	$1=, 0($7)
	i64.load	$2=, 0($8)
	i64.load	$3=, 32($10)
	i32.load8_u	$push9=, 0($9):p2align=3
	i32.store8	$discard=, 0($6):p2align=3, $pop9
	i64.store	$discard=, 0($5), $1
	i64.store	$discard=, 0($4), $2
	i64.store	$discard=, 0($10), $3
	call    	foo@FUNCTION, $10, $0
	i32.const	$push31=, __stack_pointer
	i32.const	$push29=, 64
	i32.add 	$push30=, $10, $pop29
	i32.store	$discard=, 0($pop31), $pop30
	return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i64, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push36=, __stack_pointer
	i32.load	$push37=, 0($pop36)
	i32.const	$push38=, 64
	i32.sub 	$9=, $pop37, $pop38
	i32.const	$push39=, __stack_pointer
	i32.store	$discard=, 0($pop39), $9
	i32.const	$push43=, 32
	i32.add 	$push44=, $9, $pop43
	i32.const	$push0=, 24
	i32.add 	$push35=, $pop44, $pop0
	tee_local	$push34=, $3=, $pop35
	i32.const	$push1=, 0
	i32.store8	$0=, 0($pop34):p2align=3, $pop1
	i32.const	$push45=, 32
	i32.add 	$push46=, $9, $pop45
	i32.const	$push5=, 8
	i32.add 	$push33=, $pop46, $pop5
	tee_local	$push32=, $8=, $pop33
	i32.const	$push47=, 32
	i32.add 	$push48=, $9, $pop47
	i32.const	$push2=, 16
	i32.add 	$push31=, $pop48, $pop2
	tee_local	$push30=, $7=, $pop31
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop30), $pop3
	i64.store	$push6=, 0($pop32), $pop4
	i64.store	$discard=, 32($9), $pop6
	i32.const	$push49=, 32
	i32.add 	$push50=, $9, $pop49
	call    	foo@FUNCTION, $pop50, $0
	i64.load	$1=, 0($7)
	i32.const	$push29=, 24
	i32.add 	$push28=, $9, $pop29
	tee_local	$push27=, $6=, $pop28
	i32.load8_u	$push7=, 0($3):p2align=3
	i32.store8	$discard=, 0($pop27):p2align=3, $pop7
	i64.load	$2=, 0($8)
	i32.const	$push26=, 16
	i32.add 	$push25=, $9, $pop26
	tee_local	$push24=, $5=, $pop25
	i64.store	$discard=, 0($pop24), $1
	i64.load	$1=, 32($9)
	i32.const	$push23=, 8
	i32.add 	$push22=, $9, $pop23
	tee_local	$push21=, $4=, $pop22
	i64.store	$discard=, 0($pop21), $2
	i64.store	$discard=, 0($9), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $9, $pop8
	i32.load8_u	$push9=, 0($3):p2align=3
	i32.store8	$discard=, 0($6):p2align=3, $pop9
	i64.load	$1=, 0($8)
	i64.load	$2=, 32($9)
	i32.load	$3=, p($0)
	i64.load	$push10=, 0($7)
	i64.store	$discard=, 0($5), $pop10
	i64.store	$discard=, 0($4), $1
	i64.store	$discard=, 0($9), $2
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
	i64.store	$discard=, 0($9), $pop17
	call    	foo@FUNCTION, $9, $0
	i32.const	$push42=, __stack_pointer
	i32.const	$push40=, 64
	i32.add 	$push41=, $9, $pop40
	i32.store	$discard=, 0($pop42), $pop41
	return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push43=, __stack_pointer
	i32.load	$push44=, 0($pop43)
	i32.const	$push45=, 64
	i32.sub 	$11=, $pop44, $pop45
	i32.const	$push46=, __stack_pointer
	i32.store	$discard=, 0($pop46), $11
	i32.const	$push50=, 32
	i32.add 	$push51=, $11, $pop50
	i32.const	$push0=, 24
	i32.add 	$push42=, $pop51, $pop0
	tee_local	$push41=, $10=, $pop42
	i32.const	$push1=, 0
	i32.store8	$0=, 0($pop41):p2align=3, $pop1
	i32.const	$push52=, 32
	i32.add 	$push53=, $11, $pop52
	i32.const	$push5=, 8
	i32.add 	$push40=, $pop53, $pop5
	tee_local	$push39=, $9=, $pop40
	i32.const	$push54=, 32
	i32.add 	$push55=, $11, $pop54
	i32.const	$push2=, 16
	i32.add 	$push38=, $pop55, $pop2
	tee_local	$push37=, $8=, $pop38
	i64.const	$push3=, 0
	i64.store	$push4=, 0($pop37), $pop3
	i64.store	$push6=, 0($pop39), $pop4
	i64.store	$discard=, 32($11), $pop6
	i32.const	$push56=, 32
	i32.add 	$push57=, $11, $pop56
	call    	foo@FUNCTION, $pop57, $0
	i64.load	$1=, 0($8)
	i32.const	$push36=, 24
	i32.add 	$push35=, $11, $pop36
	tee_local	$push34=, $7=, $pop35
	i32.load8_u	$push7=, 0($10):p2align=3
	i32.store8	$discard=, 0($pop34):p2align=3, $pop7
	i64.load	$2=, 0($9)
	i32.const	$push33=, 16
	i32.add 	$push32=, $11, $pop33
	tee_local	$push31=, $6=, $pop32
	i64.store	$discard=, 0($pop31), $1
	i64.load	$1=, 32($11)
	i32.const	$push30=, 8
	i32.add 	$push29=, $11, $pop30
	tee_local	$push28=, $5=, $pop29
	i64.store	$discard=, 0($pop28), $2
	i64.store	$discard=, 0($11), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $11, $pop8
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
	i64.load	$push12=, 32($11)
	i64.store	$discard=, 0($4):p2align=0, $pop12
	i32.load8_u	$push13=, 0($7):p2align=3
	i32.store8	$discard=, 0($3), $pop13
	i64.load	$push14=, 0($6)
	i64.store	$discard=, 0($10):p2align=0, $pop14
	i64.load	$push15=, 0($5)
	i64.store	$discard=, 0($8):p2align=0, $pop15
	i64.load	$push16=, 0($11)
	i64.store	$discard=, 0($4):p2align=0, $pop16
	call    	foo@FUNCTION, $11, $0
	i32.const	$push49=, __stack_pointer
	i32.const	$push47=, 64
	i32.add 	$push48=, $11, $pop47
	i32.store	$discard=, 0($pop49), $pop48
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
