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
	loop    	                # label1:
	i32.add 	$push4=, $0, $3
	tee_local	$push3=, $2=, $pop4
	i32.load8_u	$push0=, 0($pop3)
	br_if   	1, $pop0        # 1: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.eqz 	$push9=, $1
	br_if   	0, $pop9        # 0: down to label2
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	0($2), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push8=, 1
	i32.add 	$push7=, $3, $pop8
	tee_local	$push6=, $3=, $pop7
	i32.const	$push5=, 25
	i32.lt_u	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop
	i32.const	$push2=, 0
	i32.store	p($pop2), $0
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 64
	i32.sub 	$push49=, $pop14, $pop16
	tee_local	$push48=, $6=, $pop49
	i32.store	__stack_pointer($pop17), $pop48
	i32.const	$push21=, 32
	i32.add 	$push22=, $6, $pop21
	i32.const	$push0=, 24
	i32.add 	$push47=, $pop22, $pop0
	tee_local	$push46=, $0=, $pop47
	i32.const	$push1=, 0
	i32.store8	0($pop46), $pop1
	i32.const	$push23=, 32
	i32.add 	$push24=, $6, $pop23
	i32.const	$push2=, 16
	i32.add 	$push45=, $pop24, $pop2
	tee_local	$push44=, $1=, $pop45
	i64.const	$push3=, 0
	i64.store	0($pop44), $pop3
	i32.const	$push25=, 32
	i32.add 	$push26=, $6, $pop25
	i32.const	$push4=, 8
	i32.add 	$push43=, $pop26, $pop4
	tee_local	$push42=, $2=, $pop43
	i64.const	$push41=, 0
	i64.store	0($pop42), $pop41
	i64.const	$push40=, 0
	i64.store	32($6), $pop40
	i32.const	$push27=, 32
	i32.add 	$push28=, $6, $pop27
	i32.const	$push39=, 0
	call    	foo@FUNCTION, $pop28, $pop39
	i32.const	$push38=, 24
	i32.add 	$push37=, $6, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.load8_u	$push5=, 0($0)
	i32.store8	0($pop36), $pop5
	i32.const	$push35=, 16
	i32.add 	$push34=, $6, $pop35
	tee_local	$push33=, $4=, $pop34
	i64.load	$push6=, 0($1)
	i64.store	0($pop33), $pop6
	i32.const	$push32=, 8
	i32.add 	$push31=, $6, $pop32
	tee_local	$push30=, $5=, $pop31
	i64.load	$push7=, 0($2)
	i64.store	0($pop30), $pop7
	i64.load	$push8=, 32($6)
	i64.store	0($6), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $6, $pop9
	i32.load8_u	$push10=, 0($0)
	i32.store8	0($3), $pop10
	i64.load	$push11=, 0($1)
	i64.store	0($4), $pop11
	i64.load	$push12=, 0($2)
	i64.store	0($5), $pop12
	i64.load	$push13=, 32($6)
	i64.store	0($6), $pop13
	i32.const	$push29=, 0
	call    	foo@FUNCTION, $6, $pop29
	i32.const	$push20=, 0
	i32.const	$push18=, 64
	i32.add 	$push19=, $6, $pop18
	i32.store	__stack_pointer($pop20), $pop19
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push35=, 0
	i32.const	$push33=, 0
	i32.load	$push32=, __stack_pointer($pop33)
	i32.const	$push34=, 64
	i32.sub 	$push75=, $pop32, $pop34
	tee_local	$push74=, $6=, $pop75
	i32.store	__stack_pointer($pop35), $pop74
	i32.const	$push39=, 32
	i32.add 	$push40=, $6, $pop39
	i32.const	$push0=, 24
	i32.add 	$push73=, $pop40, $pop0
	tee_local	$push72=, $5=, $pop73
	i32.const	$push1=, 0
	i32.store8	0($pop72), $pop1
	i32.const	$push41=, 32
	i32.add 	$push42=, $6, $pop41
	i32.const	$push2=, 16
	i32.add 	$push71=, $pop42, $pop2
	tee_local	$push70=, $0=, $pop71
	i64.const	$push3=, 0
	i64.store	0($pop70), $pop3
	i32.const	$push43=, 32
	i32.add 	$push44=, $6, $pop43
	i32.const	$push4=, 8
	i32.add 	$push69=, $pop44, $pop4
	tee_local	$push68=, $1=, $pop69
	i64.const	$push67=, 0
	i64.store	0($pop68), $pop67
	i64.const	$push66=, 0
	i64.store	32($6), $pop66
	i32.const	$push45=, 32
	i32.add 	$push46=, $6, $pop45
	i32.const	$push65=, 0
	call    	foo@FUNCTION, $pop46, $pop65
	i32.const	$push64=, 24
	i32.add 	$push63=, $6, $pop64
	tee_local	$push62=, $2=, $pop63
	i32.load8_u	$push5=, 0($5)
	i32.store8	0($pop62), $pop5
	i32.const	$push61=, 16
	i32.add 	$push60=, $6, $pop61
	tee_local	$push59=, $3=, $pop60
	i64.load	$push6=, 0($0)
	i64.store	0($pop59), $pop6
	i32.const	$push58=, 8
	i32.add 	$push57=, $6, $pop58
	tee_local	$push56=, $4=, $pop57
	i64.load	$push7=, 0($1)
	i64.store	0($pop56), $pop7
	i64.load	$push8=, 32($6)
	i64.store	0($6), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $6, $pop9
	i32.load8_u	$push10=, 0($5)
	i32.store8	0($2), $pop10
	i64.load	$push11=, 0($0)
	i64.store	0($3), $pop11
	i64.load	$push12=, 0($1)
	i64.store	0($4), $pop12
	i64.load	$push13=, 32($6)
	i64.store	0($6), $pop13
	i32.const	$push55=, 0
	i32.load	$push54=, p($pop55)
	tee_local	$push53=, $5=, $pop54
	i32.const	$push52=, 24
	i32.add 	$push14=, $pop53, $pop52
	i32.load8_u	$push15=, 0($pop14)
	i32.store8	0($2), $pop15
	i32.const	$push16=, 20
	i32.add 	$push19=, $6, $pop16
	i32.const	$push51=, 20
	i32.add 	$push17=, $5, $pop51
	i32.load	$push18=, 0($pop17):p2align=0
	i32.store	0($pop19), $pop18
	i32.const	$push50=, 16
	i32.add 	$push20=, $5, $pop50
	i32.load	$push21=, 0($pop20):p2align=0
	i32.store	0($3), $pop21
	i32.const	$push22=, 12
	i32.add 	$push25=, $6, $pop22
	i32.const	$push49=, 12
	i32.add 	$push23=, $5, $pop49
	i32.load	$push24=, 0($pop23):p2align=0
	i32.store	0($pop25), $pop24
	i32.const	$push48=, 8
	i32.add 	$push26=, $5, $pop48
	i32.load	$push27=, 0($pop26):p2align=0
	i32.store	0($4), $pop27
	i32.const	$push28=, 4
	i32.add 	$push29=, $5, $pop28
	i32.load	$push30=, 0($pop29):p2align=0
	i32.store	4($6), $pop30
	i32.load	$push31=, 0($5):p2align=0
	i32.store	0($6), $pop31
	i32.const	$push47=, 0
	call    	foo@FUNCTION, $6, $pop47
	i32.const	$push38=, 0
	i32.const	$push36=, 64
	i32.add 	$push37=, $6, $pop36
	i32.store	__stack_pointer($pop38), $pop37
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push34=, 0
	i32.const	$push32=, 0
	i32.load	$push31=, __stack_pointer($pop32)
	i32.const	$push33=, 64
	i32.sub 	$push92=, $pop31, $pop33
	tee_local	$push91=, $10=, $pop92
	i32.store	__stack_pointer($pop34), $pop91
	i32.const	$push38=, 32
	i32.add 	$push39=, $10, $pop38
	i32.const	$push0=, 24
	i32.add 	$push90=, $pop39, $pop0
	tee_local	$push89=, $0=, $pop90
	i32.const	$push1=, 0
	i32.store8	0($pop89), $pop1
	i32.const	$push40=, 32
	i32.add 	$push41=, $10, $pop40
	i32.const	$push2=, 16
	i32.add 	$push88=, $pop41, $pop2
	tee_local	$push87=, $1=, $pop88
	i64.const	$push3=, 0
	i64.store	0($pop87), $pop3
	i32.const	$push42=, 32
	i32.add 	$push43=, $10, $pop42
	i32.const	$push4=, 8
	i32.add 	$push86=, $pop43, $pop4
	tee_local	$push85=, $2=, $pop86
	i64.const	$push84=, 0
	i64.store	0($pop85), $pop84
	i64.const	$push83=, 0
	i64.store	32($10), $pop83
	i32.const	$push44=, 32
	i32.add 	$push45=, $10, $pop44
	i32.const	$push82=, 0
	call    	foo@FUNCTION, $pop45, $pop82
	i32.const	$push81=, 24
	i32.add 	$push80=, $10, $pop81
	tee_local	$push79=, $3=, $pop80
	i32.load8_u	$push5=, 0($0)
	i32.store8	0($pop79), $pop5
	i32.const	$push78=, 16
	i32.add 	$push77=, $10, $pop78
	tee_local	$push76=, $4=, $pop77
	i64.load	$push6=, 0($1)
	i64.store	0($pop76), $pop6
	i32.const	$push75=, 8
	i32.add 	$push74=, $10, $pop75
	tee_local	$push73=, $5=, $pop74
	i64.load	$push7=, 0($2)
	i64.store	0($pop73), $pop7
	i64.load	$push8=, 32($10)
	i64.store	0($10), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $10, $pop9
	i32.const	$push72=, 0
	i32.load	$push71=, p($pop72)
	tee_local	$push70=, $6=, $pop71
	i32.load	$push10=, 32($10)
	i32.store	0($pop70):p2align=0, $pop10
	i32.const	$push69=, 24
	i32.add 	$push68=, $6, $pop69
	tee_local	$push67=, $7=, $pop68
	i32.load8_u	$push11=, 0($0)
	i32.store8	0($pop67), $pop11
	i32.const	$push12=, 20
	i32.add 	$push66=, $6, $pop12
	tee_local	$push65=, $0=, $pop66
	i32.const	$push46=, 32
	i32.add 	$push47=, $10, $pop46
	i32.const	$push64=, 20
	i32.add 	$push13=, $pop47, $pop64
	i32.load	$push14=, 0($pop13)
	i32.store	0($pop65):p2align=0, $pop14
	i32.const	$push63=, 16
	i32.add 	$push62=, $6, $pop63
	tee_local	$push61=, $8=, $pop62
	i32.load	$push15=, 0($1)
	i32.store	0($pop61):p2align=0, $pop15
	i32.const	$push16=, 12
	i32.add 	$push60=, $6, $pop16
	tee_local	$push59=, $1=, $pop60
	i32.const	$push48=, 32
	i32.add 	$push49=, $10, $pop48
	i32.const	$push58=, 12
	i32.add 	$push17=, $pop49, $pop58
	i32.load	$push18=, 0($pop17)
	i32.store	0($pop59):p2align=0, $pop18
	i32.const	$push57=, 8
	i32.add 	$push56=, $6, $pop57
	tee_local	$push55=, $9=, $pop56
	i32.load	$push19=, 0($2)
	i32.store	0($pop55):p2align=0, $pop19
	i32.const	$push20=, 4
	i32.add 	$push54=, $6, $pop20
	tee_local	$push53=, $2=, $pop54
	i32.load	$push21=, 36($10)
	i32.store	0($pop53):p2align=0, $pop21
	i32.load8_u	$push22=, 0($3)
	i32.store8	0($7), $pop22
	i32.const	$push52=, 20
	i32.add 	$push23=, $10, $pop52
	i32.load	$push24=, 0($pop23)
	i32.store	0($0):p2align=0, $pop24
	i32.load	$push25=, 0($4)
	i32.store	0($8):p2align=0, $pop25
	i32.const	$push51=, 12
	i32.add 	$push26=, $10, $pop51
	i32.load	$push27=, 0($pop26)
	i32.store	0($1):p2align=0, $pop27
	i32.load	$push28=, 0($5)
	i32.store	0($9):p2align=0, $pop28
	i32.load	$push29=, 4($10)
	i32.store	0($2):p2align=0, $pop29
	i32.load	$push30=, 0($10)
	i32.store	0($6):p2align=0, $pop30
	i32.const	$push50=, 0
	call    	foo@FUNCTION, $10, $pop50
	i32.const	$push37=, 0
	i32.const	$push35=, 64
	i32.add 	$push36=, $10, $pop35
	i32.store	__stack_pointer($pop37), $pop36
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
