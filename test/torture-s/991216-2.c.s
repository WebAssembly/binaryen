	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $1
	i32.const	$1=, 1
	block
	block
	block
	block
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push2=, 12($6)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push33=, $pop4, $pop5
	tee_local	$push32=, $2=, $pop33
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop32, $pop6
	i32.store	$discard=, 12($6), $pop7
	i32.const	$push31=, 1
	i32.add 	$push9=, $1, $pop31
	i32.load	$push8=, 0($2)
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	3, $pop10       # 3: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 1
	i32.add 	$1=, $1, $pop11
	i32.lt_s	$push12=, $1, $0
	br_if   	0, $pop12       # 0: up to label4
.LBB0_3:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.load	$push13=, 12($6)
	i32.const	$push14=, 7
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -8
	i32.and 	$push35=, $pop15, $pop16
	tee_local	$push34=, $1=, $pop35
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop34, $pop17
	i32.store	$discard=, 12($6), $pop18
	i64.load	$push19=, 0($1)
	i64.const	$push20=, 81985529216486895
	i64.ne  	$push21=, $pop19, $pop20
	br_if   	1, $pop21       # 1: down to label1
# BB#4:                                 # %if.end5
	i32.load	$push22=, 12($6)
	i32.const	$push23=, 3
	i32.add 	$push24=, $pop22, $pop23
	i32.const	$push25=, -4
	i32.and 	$push37=, $pop24, $pop25
	tee_local	$push36=, $1=, $pop37
	i32.const	$push26=, 4
	i32.add 	$push27=, $pop36, $pop26
	i32.store	$discard=, 12($6), $pop27
	i32.load	$push28=, 0($1)
	i32.const	$push29=, 85
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	2, $pop30       # 2: down to label0
# BB#5:                                 # %if.end8
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB0_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then4
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 288
	i32.sub 	$34=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$34=, 0($7), $34
	i32.const	$push0=, 8
	i32.const	$8=, 272
	i32.add 	$8=, $34, $8
	i32.or  	$push1=, $8, $pop0
	i32.const	$push2=, 85
	i32.store	$5=, 0($pop1):p2align=3, $pop2
	i64.const	$push3=, 81985529216486895
	i64.store	$0=, 272($34):p2align=4, $pop3
	i32.const	$push4=, 1
	i32.const	$9=, 272
	i32.add 	$9=, $34, $9
	call    	test@FUNCTION, $pop4, $9
	i32.const	$push5=, 16
	i32.const	$10=, 240
	i32.add 	$10=, $34, $10
	i32.add 	$push6=, $10, $pop5
	i32.store	$discard=, 0($pop6):p2align=4, $5
	i32.const	$push61=, 8
	i32.const	$11=, 240
	i32.add 	$11=, $34, $11
	i32.or  	$push7=, $11, $pop61
	i64.store	$discard=, 0($pop7), $0
	i32.const	$push8=, 2
	i32.store	$push9=, 240($34):p2align=4, $pop8
	i32.const	$12=, 240
	i32.add 	$12=, $34, $12
	call    	test@FUNCTION, $pop9, $12
	i32.const	$push60=, 16
	i32.const	$13=, 208
	i32.add 	$13=, $34, $13
	i32.add 	$push10=, $13, $pop60
	i32.store	$discard=, 0($pop10):p2align=4, $5
	i32.const	$push59=, 8
	i32.const	$14=, 208
	i32.add 	$14=, $34, $14
	i32.or  	$push11=, $14, $pop59
	i64.store	$discard=, 0($pop11), $0
	i64.const	$push12=, 12884901890
	i64.store	$1=, 208($34):p2align=4, $pop12
	i32.const	$push13=, 3
	i32.const	$15=, 208
	i32.add 	$15=, $34, $15
	call    	test@FUNCTION, $pop13, $15
	i32.const	$push14=, 24
	i32.const	$16=, 176
	i32.add 	$16=, $34, $16
	i32.add 	$push15=, $16, $pop14
	i32.store	$discard=, 0($pop15):p2align=3, $5
	i32.const	$push58=, 16
	i32.const	$17=, 176
	i32.add 	$17=, $34, $17
	i32.add 	$push16=, $17, $pop58
	i64.store	$discard=, 0($pop16):p2align=4, $0
	i32.const	$push57=, 8
	i32.const	$18=, 176
	i32.add 	$18=, $34, $18
	i32.or  	$push17=, $18, $pop57
	i32.const	$push18=, 4
	i32.store	$2=, 0($pop17):p2align=3, $pop18
	i64.store	$discard=, 176($34):p2align=4, $1
	i32.const	$19=, 176
	i32.add 	$19=, $34, $19
	call    	test@FUNCTION, $2, $19
	i32.const	$push56=, 24
	i32.const	$20=, 144
	i32.add 	$20=, $34, $20
	i32.add 	$push19=, $20, $pop56
	i32.store	$discard=, 0($pop19):p2align=3, $5
	i32.const	$push55=, 16
	i32.const	$21=, 144
	i32.add 	$21=, $34, $21
	i32.add 	$push20=, $21, $pop55
	i64.store	$discard=, 0($pop20):p2align=4, $0
	i32.const	$push54=, 8
	i32.const	$22=, 144
	i32.add 	$22=, $34, $22
	i32.or  	$push21=, $22, $pop54
	i64.const	$push22=, 21474836484
	i64.store	$3=, 0($pop21), $pop22
	i64.store	$discard=, 144($34):p2align=4, $1
	i32.const	$push23=, 5
	i32.const	$23=, 144
	i32.add 	$23=, $34, $23
	call    	test@FUNCTION, $pop23, $23
	i32.const	$push24=, 32
	i32.const	$24=, 96
	i32.add 	$24=, $34, $24
	i32.add 	$push25=, $24, $pop24
	i32.store	$discard=, 0($pop25):p2align=4, $5
	i32.const	$push53=, 24
	i32.const	$25=, 96
	i32.add 	$25=, $34, $25
	i32.add 	$push26=, $25, $pop53
	i64.store	$discard=, 0($pop26), $0
	i32.const	$push52=, 16
	i32.const	$26=, 96
	i32.add 	$26=, $34, $26
	i32.add 	$push27=, $26, $pop52
	i32.const	$push28=, 6
	i32.store	$2=, 0($pop27):p2align=4, $pop28
	i32.const	$push51=, 8
	i32.const	$27=, 96
	i32.add 	$27=, $34, $27
	i32.or  	$push29=, $27, $pop51
	i64.store	$discard=, 0($pop29), $3
	i64.store	$discard=, 96($34):p2align=4, $1
	i32.const	$28=, 96
	i32.add 	$28=, $34, $28
	call    	test@FUNCTION, $2, $28
	i32.const	$push50=, 32
	i32.const	$29=, 48
	i32.add 	$29=, $34, $29
	i32.add 	$push30=, $29, $pop50
	i32.store	$discard=, 0($pop30):p2align=4, $5
	i32.const	$push49=, 24
	i32.const	$30=, 48
	i32.add 	$30=, $34, $30
	i32.add 	$push31=, $30, $pop49
	i64.store	$discard=, 0($pop31), $0
	i32.const	$push48=, 16
	i32.const	$31=, 48
	i32.add 	$31=, $34, $31
	i32.add 	$push32=, $31, $pop48
	i64.const	$push33=, 30064771078
	i64.store	$4=, 0($pop32):p2align=4, $pop33
	i32.const	$push47=, 8
	i32.const	$32=, 48
	i32.add 	$32=, $34, $32
	i32.or  	$push34=, $32, $pop47
	i64.store	$discard=, 0($pop34), $3
	i64.store	$discard=, 48($34):p2align=4, $1
	i32.const	$push35=, 7
	i32.const	$33=, 48
	i32.add 	$33=, $34, $33
	call    	test@FUNCTION, $pop35, $33
	i32.const	$push36=, 40
	i32.add 	$push37=, $34, $pop36
	i32.store	$discard=, 0($pop37):p2align=3, $5
	i32.const	$push46=, 32
	i32.add 	$push38=, $34, $pop46
	i64.store	$discard=, 0($pop38):p2align=4, $0
	i32.const	$push45=, 24
	i32.add 	$push39=, $34, $pop45
	i32.const	$push44=, 8
	i32.store	$5=, 0($pop39):p2align=3, $pop44
	i32.const	$push43=, 16
	i32.add 	$push40=, $34, $pop43
	i64.store	$discard=, 0($pop40):p2align=4, $4
	i32.or  	$push41=, $34, $5
	i64.store	$discard=, 0($pop41), $3
	i64.store	$discard=, 0($34):p2align=4, $1
	call    	test@FUNCTION, $5, $34
	i32.const	$push42=, 0
	call    	exit@FUNCTION, $pop42
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
