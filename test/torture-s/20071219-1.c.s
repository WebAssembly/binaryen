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
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.add 	$push4=, $0, $3
	tee_local	$push3=, $2=, $pop4
	i32.load8_u	$push0=, 0($pop3)
	br_if   	2, $pop0        # 2: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.eqz 	$push9=, $1
	br_if   	0, $pop9        # 0: down to label3
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	$drop=, 0($2), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push8=, 1
	i32.add 	$push7=, $3, $pop8
	tee_local	$push6=, $3=, $pop7
	i32.const	$push5=, 25
	i32.lt_u	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push2=, 0
	i32.store	$drop=, p($pop2), $0
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 64
	i32.sub 	$push31=, $pop17, $pop18
	i32.store	$push48=, __stack_pointer($pop19), $pop31
	tee_local	$push47=, $1=, $pop48
	i32.const	$push23=, 32
	i32.add 	$push24=, $pop47, $pop23
	i32.const	$push2=, 24
	i32.add 	$push46=, $pop24, $pop2
	tee_local	$push45=, $2=, $pop46
	i32.const	$push3=, 0
	i32.store8	$0=, 0($pop45), $pop3
	i32.const	$push27=, 32
	i32.add 	$push28=, $1, $pop27
	i32.const	$push6=, 8
	i32.add 	$push44=, $pop28, $pop6
	tee_local	$push43=, $4=, $pop44
	i32.const	$push25=, 32
	i32.add 	$push26=, $1, $pop25
	i32.const	$push4=, 16
	i32.add 	$push42=, $pop26, $pop4
	tee_local	$push41=, $3=, $pop42
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop41), $pop5
	i64.store	$push1=, 0($pop43), $pop0
	i64.store	$drop=, 32($1), $pop1
	i32.const	$push29=, 32
	i32.add 	$push30=, $1, $pop29
	call    	foo@FUNCTION, $pop30, $0
	i32.const	$push40=, 24
	i32.add 	$push39=, $1, $pop40
	tee_local	$push38=, $5=, $pop39
	i32.load8_u	$push7=, 0($2)
	i32.store8	$drop=, 0($pop38), $pop7
	i32.const	$push37=, 16
	i32.add 	$push36=, $1, $pop37
	tee_local	$push35=, $6=, $pop36
	i64.load	$push8=, 0($3)
	i64.store	$drop=, 0($pop35), $pop8
	i32.const	$push34=, 8
	i32.add 	$push33=, $1, $pop34
	tee_local	$push32=, $7=, $pop33
	i64.load	$push9=, 0($4)
	i64.store	$drop=, 0($pop32), $pop9
	i64.load	$push10=, 32($1)
	i64.store	$drop=, 0($1), $pop10
	i32.const	$push11=, 1
	call    	foo@FUNCTION, $1, $pop11
	i32.load8_u	$push12=, 0($2)
	i32.store8	$drop=, 0($5), $pop12
	i64.load	$push13=, 0($3)
	i64.store	$drop=, 0($6), $pop13
	i64.load	$push14=, 0($4)
	i64.store	$drop=, 0($7), $pop14
	i64.load	$push15=, 32($1)
	i64.store	$drop=, 0($1), $pop15
	call    	foo@FUNCTION, $1, $0
	i32.const	$push22=, 0
	i32.const	$push20=, 64
	i32.add 	$push21=, $1, $pop20
	i32.store	$drop=, __stack_pointer($pop22), $pop21
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push26=, 0
	i32.const	$push23=, 0
	i32.load	$push24=, __stack_pointer($pop23)
	i32.const	$push25=, 64
	i32.sub 	$push38=, $pop24, $pop25
	i32.store	$push60=, __stack_pointer($pop26), $pop38
	tee_local	$push59=, $1=, $pop60
	i32.const	$push30=, 32
	i32.add 	$push31=, $pop59, $pop30
	i32.const	$push2=, 24
	i32.add 	$push58=, $pop31, $pop2
	tee_local	$push57=, $7=, $pop58
	i32.const	$push3=, 0
	i32.store8	$0=, 0($pop57), $pop3
	i32.const	$push34=, 32
	i32.add 	$push35=, $1, $pop34
	i32.const	$push6=, 8
	i32.add 	$push56=, $pop35, $pop6
	tee_local	$push55=, $3=, $pop56
	i32.const	$push32=, 32
	i32.add 	$push33=, $1, $pop32
	i32.const	$push4=, 16
	i32.add 	$push54=, $pop33, $pop4
	tee_local	$push53=, $2=, $pop54
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop53), $pop5
	i64.store	$push1=, 0($pop55), $pop0
	i64.store	$drop=, 32($1), $pop1
	i32.const	$push36=, 32
	i32.add 	$push37=, $1, $pop36
	call    	foo@FUNCTION, $pop37, $0
	i32.const	$push52=, 24
	i32.add 	$push51=, $1, $pop52
	tee_local	$push50=, $4=, $pop51
	i32.load8_u	$push7=, 0($7)
	i32.store8	$drop=, 0($pop50), $pop7
	i32.const	$push49=, 16
	i32.add 	$push48=, $1, $pop49
	tee_local	$push47=, $5=, $pop48
	i64.load	$push8=, 0($2)
	i64.store	$drop=, 0($pop47), $pop8
	i32.const	$push46=, 8
	i32.add 	$push45=, $1, $pop46
	tee_local	$push44=, $6=, $pop45
	i64.load	$push9=, 0($3)
	i64.store	$drop=, 0($pop44), $pop9
	i64.load	$push10=, 32($1)
	i64.store	$drop=, 0($1), $pop10
	i32.const	$push11=, 1
	call    	foo@FUNCTION, $1, $pop11
	i32.load8_u	$push12=, 0($7)
	i32.store8	$drop=, 0($4), $pop12
	i64.load	$push13=, 0($2)
	i64.store	$drop=, 0($5), $pop13
	i64.load	$push14=, 0($3)
	i64.store	$drop=, 0($6), $pop14
	i64.load	$push15=, 32($1)
	i64.store	$drop=, 0($1), $pop15
	i32.load	$push43=, p($0)
	tee_local	$push42=, $7=, $pop43
	i32.const	$push41=, 24
	i32.add 	$push16=, $pop42, $pop41
	i32.load8_u	$push17=, 0($pop16)
	i32.store8	$drop=, 0($4), $pop17
	i32.const	$push40=, 16
	i32.add 	$push18=, $7, $pop40
	i64.load	$push19=, 0($pop18):p2align=0
	i64.store	$drop=, 0($5), $pop19
	i32.const	$push39=, 8
	i32.add 	$push20=, $7, $pop39
	i64.load	$push21=, 0($pop20):p2align=0
	i64.store	$drop=, 0($6), $pop21
	i64.load	$push22=, 0($7):p2align=0
	i64.store	$drop=, 0($1), $pop22
	call    	foo@FUNCTION, $1, $0
	i32.const	$push29=, 0
	i32.const	$push27=, 64
	i32.add 	$push28=, $1, $pop27
	i32.store	$drop=, __stack_pointer($pop29), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push34=, 0
	i32.const	$push31=, 0
	i32.load	$push32=, __stack_pointer($pop31)
	i32.const	$push33=, 64
	i32.sub 	$push50=, $pop32, $pop33
	i32.store	$push80=, __stack_pointer($pop34), $pop50
	tee_local	$push79=, $1=, $pop80
	i32.const	$push38=, 32
	i32.add 	$push39=, $pop79, $pop38
	i32.const	$push2=, 24
	i32.add 	$push78=, $pop39, $pop2
	tee_local	$push77=, $2=, $pop78
	i32.const	$push3=, 0
	i32.store8	$0=, 0($pop77), $pop3
	i32.const	$push42=, 32
	i32.add 	$push43=, $1, $pop42
	i32.const	$push6=, 8
	i32.add 	$push76=, $pop43, $pop6
	tee_local	$push75=, $4=, $pop76
	i32.const	$push40=, 32
	i32.add 	$push41=, $1, $pop40
	i32.const	$push4=, 16
	i32.add 	$push74=, $pop41, $pop4
	tee_local	$push73=, $3=, $pop74
	i64.const	$push5=, 0
	i64.store	$push0=, 0($pop73), $pop5
	i64.store	$push1=, 0($pop75), $pop0
	i64.store	$drop=, 32($1), $pop1
	i32.const	$push44=, 32
	i32.add 	$push45=, $1, $pop44
	call    	foo@FUNCTION, $pop45, $0
	i32.const	$push72=, 24
	i32.add 	$push71=, $1, $pop72
	tee_local	$push70=, $5=, $pop71
	i32.load8_u	$push7=, 0($2)
	i32.store8	$drop=, 0($pop70), $pop7
	i32.const	$push69=, 16
	i32.add 	$push68=, $1, $pop69
	tee_local	$push67=, $6=, $pop68
	i64.load	$push8=, 0($3)
	i64.store	$drop=, 0($pop67), $pop8
	i32.const	$push66=, 8
	i32.add 	$push65=, $1, $pop66
	tee_local	$push64=, $7=, $pop65
	i64.load	$push9=, 0($4)
	i64.store	$drop=, 0($pop64), $pop9
	i64.load	$push10=, 32($1)
	i64.store	$drop=, 0($1), $pop10
	i32.const	$push11=, 1
	call    	foo@FUNCTION, $1, $pop11
	i32.load	$push63=, p($0)
	tee_local	$push62=, $8=, $pop63
	i32.load	$push12=, 32($1)
	i32.store	$drop=, 0($pop62):p2align=0, $pop12
	i32.const	$push61=, 24
	i32.add 	$push60=, $8, $pop61
	tee_local	$push59=, $9=, $pop60
	i32.load8_u	$push13=, 0($2)
	i32.store8	$drop=, 0($pop59), $pop13
	i32.const	$push14=, 20
	i32.add 	$push15=, $8, $pop14
	i32.const	$push46=, 32
	i32.add 	$push47=, $1, $pop46
	i32.const	$push58=, 20
	i32.add 	$push16=, $pop47, $pop58
	i32.load	$push17=, 0($pop16)
	i32.store	$drop=, 0($pop15):p2align=0, $pop17
	i32.const	$push57=, 16
	i32.add 	$push56=, $8, $pop57
	tee_local	$push55=, $2=, $pop56
	i32.load	$push18=, 0($3)
	i32.store	$drop=, 0($pop55):p2align=0, $pop18
	i32.const	$push19=, 12
	i32.add 	$push20=, $8, $pop19
	i32.const	$push48=, 32
	i32.add 	$push49=, $1, $pop48
	i32.const	$push54=, 12
	i32.add 	$push21=, $pop49, $pop54
	i32.load	$push22=, 0($pop21)
	i32.store	$drop=, 0($pop20):p2align=0, $pop22
	i32.const	$push53=, 8
	i32.add 	$push52=, $8, $pop53
	tee_local	$push51=, $3=, $pop52
	i32.load	$push23=, 0($4)
	i32.store	$drop=, 0($pop51):p2align=0, $pop23
	i32.const	$push24=, 4
	i32.add 	$push25=, $8, $pop24
	i32.load	$push26=, 36($1)
	i32.store	$drop=, 0($pop25):p2align=0, $pop26
	i32.load8_u	$push27=, 0($5)
	i32.store8	$drop=, 0($9), $pop27
	i64.load	$push28=, 0($6)
	i64.store	$drop=, 0($2):p2align=0, $pop28
	i64.load	$push29=, 0($7)
	i64.store	$drop=, 0($3):p2align=0, $pop29
	i64.load	$push30=, 0($1)
	i64.store	$drop=, 0($8):p2align=0, $pop30
	call    	foo@FUNCTION, $1, $0
	i32.const	$push37=, 0
	i32.const	$push35=, 64
	i32.add 	$push36=, $1, $pop35
	i32.store	$drop=, __stack_pointer($pop37), $pop36
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop0
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
	.functype	abort, void
