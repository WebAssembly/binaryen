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
	i32.eqz 	$push7=, $1
	br_if   	0, $pop7        # 0: down to label3
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
	i32.const	$push13=, __stack_pointer
	i32.const	$push10=, __stack_pointer
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 64
	i32.sub 	$push25=, $pop11, $pop12
	i32.store	$push42=, 0($pop13), $pop25
	tee_local	$push41=, $10=, $pop42
	i32.const	$push17=, 32
	i32.add 	$push18=, $pop41, $pop17
	i32.const	$push2=, 24
	i32.add 	$push40=, $pop18, $pop2
	tee_local	$push39=, $9=, $pop40
	i32.const	$push3=, 0
	i32.store8	$0=, 0($pop39), $pop3
	i32.const	$push21=, 32
	i32.add 	$push22=, $10, $pop21
	i32.const	$push6=, 8
	i32.add 	$push38=, $pop22, $pop6
	tee_local	$push37=, $8=, $pop38
	i32.const	$push19=, 32
	i32.add 	$push20=, $10, $pop19
	i32.const	$push4=, 16
	i32.add 	$push36=, $pop20, $pop4
	tee_local	$push35=, $7=, $pop36
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop35), $pop5
	i64.store	$push1=, 0($pop37), $pop0
	i64.store	$discard=, 32($10), $pop1
	i32.const	$push23=, 32
	i32.add 	$push24=, $10, $pop23
	call    	foo@FUNCTION, $pop24, $0
	i64.load	$1=, 0($7)
	i32.const	$push34=, 24
	i32.add 	$push33=, $10, $pop34
	tee_local	$push32=, $6=, $pop33
	i32.load8_u	$push7=, 0($9)
	i32.store8	$discard=, 0($pop32), $pop7
	i64.load	$2=, 0($8)
	i32.const	$push31=, 16
	i32.add 	$push30=, $10, $pop31
	tee_local	$push29=, $5=, $pop30
	i64.store	$discard=, 0($pop29), $1
	i64.load	$1=, 32($10)
	i32.const	$push28=, 8
	i32.add 	$push27=, $10, $pop28
	tee_local	$push26=, $4=, $pop27
	i64.store	$discard=, 0($pop26), $2
	i64.store	$discard=, 0($10), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $10, $pop8
	i64.load	$1=, 0($7)
	i64.load	$2=, 0($8)
	i64.load	$3=, 32($10)
	i32.load8_u	$push9=, 0($9)
	i32.store8	$discard=, 0($6), $pop9
	i64.store	$discard=, 0($5), $1
	i64.store	$discard=, 0($4), $2
	i64.store	$discard=, 0($10), $3
	call    	foo@FUNCTION, $10, $0
	i32.const	$push16=, __stack_pointer
	i32.const	$push14=, 64
	i32.add 	$push15=, $10, $pop14
	i32.store	$discard=, 0($pop16), $pop15
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
	i32.const	$push21=, __stack_pointer
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 64
	i32.sub 	$push33=, $pop19, $pop20
	i32.store	$push53=, 0($pop21), $pop33
	tee_local	$push52=, $9=, $pop53
	i32.const	$push25=, 32
	i32.add 	$push26=, $pop52, $pop25
	i32.const	$push2=, 24
	i32.add 	$push51=, $pop26, $pop2
	tee_local	$push50=, $3=, $pop51
	i32.const	$push3=, 0
	i32.store8	$0=, 0($pop50), $pop3
	i32.const	$push29=, 32
	i32.add 	$push30=, $9, $pop29
	i32.const	$push6=, 8
	i32.add 	$push49=, $pop30, $pop6
	tee_local	$push48=, $8=, $pop49
	i32.const	$push27=, 32
	i32.add 	$push28=, $9, $pop27
	i32.const	$push4=, 16
	i32.add 	$push47=, $pop28, $pop4
	tee_local	$push46=, $7=, $pop47
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop46), $pop5
	i64.store	$push1=, 0($pop48), $pop0
	i64.store	$discard=, 32($9), $pop1
	i32.const	$push31=, 32
	i32.add 	$push32=, $9, $pop31
	call    	foo@FUNCTION, $pop32, $0
	i64.load	$1=, 0($7)
	i32.const	$push45=, 24
	i32.add 	$push44=, $9, $pop45
	tee_local	$push43=, $6=, $pop44
	i32.load8_u	$push7=, 0($3)
	i32.store8	$discard=, 0($pop43), $pop7
	i64.load	$2=, 0($8)
	i32.const	$push42=, 16
	i32.add 	$push41=, $9, $pop42
	tee_local	$push40=, $5=, $pop41
	i64.store	$discard=, 0($pop40), $1
	i64.load	$1=, 32($9)
	i32.const	$push39=, 8
	i32.add 	$push38=, $9, $pop39
	tee_local	$push37=, $4=, $pop38
	i64.store	$discard=, 0($pop37), $2
	i64.store	$discard=, 0($9), $1
	i32.const	$push8=, 1
	call    	foo@FUNCTION, $9, $pop8
	i32.load8_u	$push9=, 0($3)
	i32.store8	$discard=, 0($6), $pop9
	i64.load	$1=, 0($8)
	i64.load	$2=, 32($9)
	i32.load	$3=, p($0)
	i64.load	$push10=, 0($7)
	i64.store	$discard=, 0($5), $pop10
	i64.store	$discard=, 0($4), $1
	i64.store	$discard=, 0($9), $2
	i32.const	$push36=, 24
	i32.add 	$push11=, $3, $pop36
	i32.load8_u	$push12=, 0($pop11)
	i32.store8	$discard=, 0($6), $pop12
	i32.const	$push35=, 16
	i32.add 	$push13=, $3, $pop35
	i64.load	$push14=, 0($pop13):p2align=0
	i64.store	$discard=, 0($5), $pop14
	i32.const	$push34=, 8
	i32.add 	$push15=, $3, $pop34
	i64.load	$push16=, 0($pop15):p2align=0
	i64.store	$discard=, 0($4), $pop16
	i64.load	$push17=, 0($3):p2align=0
	i64.store	$discard=, 0($9), $pop17
	call    	foo@FUNCTION, $9, $0
	i32.const	$push24=, __stack_pointer
	i32.const	$push22=, 64
	i32.add 	$push23=, $9, $pop22
	i32.store	$discard=, 0($pop24), $pop23
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
	i32.const	$push31=, __stack_pointer
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 64
	i32.sub 	$push47=, $pop29, $pop30
	i32.store	$push77=, 0($pop31), $pop47
	tee_local	$push76=, $11=, $pop77
	i32.const	$push35=, 32
	i32.add 	$push36=, $pop76, $pop35
	i32.const	$push2=, 24
	i32.add 	$push75=, $pop36, $pop2
	tee_local	$push74=, $10=, $pop75
	i32.const	$push3=, 0
	i32.store8	$0=, 0($pop74), $pop3
	i32.const	$push39=, 32
	i32.add 	$push40=, $11, $pop39
	i32.const	$push6=, 8
	i32.add 	$push73=, $pop40, $pop6
	tee_local	$push72=, $9=, $pop73
	i32.const	$push37=, 32
	i32.add 	$push38=, $11, $pop37
	i32.const	$push4=, 16
	i32.add 	$push71=, $pop38, $pop4
	tee_local	$push70=, $8=, $pop71
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop70), $pop5
	i64.store	$push1=, 0($pop72), $pop0
	i64.store	$discard=, 32($11), $pop1
	i32.const	$push45=, 32
	i32.add 	$push46=, $11, $pop45
	call    	foo@FUNCTION, $pop46, $0
	i64.load	$1=, 0($8)
	i32.const	$push69=, 24
	i32.add 	$push68=, $11, $pop69
	tee_local	$push67=, $7=, $pop68
	i32.load8_u	$push11=, 0($10)
	i32.store8	$discard=, 0($pop67), $pop11
	i64.load	$2=, 0($9)
	i32.const	$push66=, 16
	i32.add 	$push65=, $11, $pop66
	tee_local	$push64=, $6=, $pop65
	i64.store	$discard=, 0($pop64), $1
	i64.load	$1=, 32($11)
	i32.const	$push63=, 8
	i32.add 	$push62=, $11, $pop63
	tee_local	$push61=, $5=, $pop62
	i64.store	$discard=, 0($pop61), $2
	i64.store	$discard=, 0($11), $1
	i32.const	$push12=, 1
	call    	foo@FUNCTION, $11, $pop12
	i32.load	$push60=, p($0)
	tee_local	$push59=, $4=, $pop60
	i32.load	$push13=, 32($11)
	i32.store	$discard=, 0($pop59):p2align=0, $pop13
	i32.const	$push58=, 24
	i32.add 	$push57=, $4, $pop58
	tee_local	$push56=, $3=, $pop57
	i32.load8_u	$push14=, 0($10)
	i32.store8	$discard=, 0($pop56), $pop14
	i32.const	$push9=, 20
	i32.add 	$push15=, $4, $pop9
	i32.const	$push43=, 32
	i32.add 	$push44=, $11, $pop43
	i32.const	$push55=, 20
	i32.add 	$push10=, $pop44, $pop55
	i32.load	$push16=, 0($pop10)
	i32.store	$discard=, 0($pop15):p2align=0, $pop16
	i32.const	$push54=, 16
	i32.add 	$push53=, $4, $pop54
	tee_local	$push52=, $10=, $pop53
	i32.load	$push17=, 0($8)
	i32.store	$discard=, 0($pop52):p2align=0, $pop17
	i32.const	$push7=, 12
	i32.add 	$push18=, $4, $pop7
	i32.const	$push41=, 32
	i32.add 	$push42=, $11, $pop41
	i32.const	$push51=, 12
	i32.add 	$push8=, $pop42, $pop51
	i32.load	$push19=, 0($pop8)
	i32.store	$discard=, 0($pop18):p2align=0, $pop19
	i32.const	$push50=, 8
	i32.add 	$push49=, $4, $pop50
	tee_local	$push48=, $8=, $pop49
	i32.load	$push20=, 0($9)
	i32.store	$discard=, 0($pop48):p2align=0, $pop20
	i32.const	$push21=, 4
	i32.add 	$push22=, $4, $pop21
	i32.load	$push23=, 36($11)
	i32.store	$discard=, 0($pop22):p2align=0, $pop23
	i32.load8_u	$push24=, 0($7)
	i32.store8	$discard=, 0($3), $pop24
	i64.load	$push25=, 0($6)
	i64.store	$discard=, 0($10):p2align=0, $pop25
	i64.load	$push26=, 0($5)
	i64.store	$discard=, 0($8):p2align=0, $pop26
	i64.load	$push27=, 0($11)
	i64.store	$discard=, 0($4):p2align=0, $pop27
	call    	foo@FUNCTION, $11, $0
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 64
	i32.add 	$push33=, $11, $pop32
	i32.store	$discard=, 0($pop34), $pop33
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
