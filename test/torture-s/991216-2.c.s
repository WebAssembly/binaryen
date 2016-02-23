	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991216-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 16
	i32.sub 	$5=, $pop25, $pop26
	i32.const	$push27=, __stack_pointer
	i32.store	$discard=, 0($pop27), $5
	i32.store	$3=, 12($5), $1
	block
	block
	block
	i32.const	$push1=, 2
	i32.lt_s	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# BB#1:
	i32.const	$1=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	copy_local	$push21=, $3
	tee_local	$push20=, $4=, $pop21
	i32.const	$push19=, 4
	i32.add 	$push0=, $pop20, $pop19
	i32.store	$3=, 12($5), $pop0
	i32.const	$push18=, 1
	i32.add 	$1=, $1, $pop18
	i32.load	$push3=, 0($4)
	i32.ne  	$push4=, $1, $pop3
	br_if   	3, $pop4        # 3: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.lt_s	$push5=, $1, $0
	br_if   	0, $pop5        # 0: up to label3
.LBB0_4:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push6=, 7
	i32.add 	$push7=, $3, $pop6
	i32.const	$push8=, -8
	i32.and 	$push23=, $pop7, $pop8
	tee_local	$push22=, $1=, $pop23
	i64.load	$2=, 0($pop22)
	i32.const	$push9=, 8
	i32.add 	$push10=, $1, $pop9
	i32.store	$3=, 12($5), $pop10
	i64.const	$push11=, 81985529216486895
	i64.ne  	$push12=, $2, $pop11
	br_if   	1, $pop12       # 1: down to label0
# BB#5:                                 # %if.end7
	i32.const	$push13=, 12
	i32.add 	$push14=, $1, $pop13
	i32.store	$discard=, 12($5), $pop14
	i32.load	$push15=, 0($3):p2align=3
	i32.const	$push16=, 85
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	1, $pop17       # 1: down to label0
# BB#6:                                 # %if.end12
	i32.const	$push28=, 16
	i32.add 	$5=, $5, $pop28
	i32.const	$push29=, __stack_pointer
	i32.store	$discard=, 0($pop29), $5
	return
.LBB0_7:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then11
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
	.local  	i32, i64, i64, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push47=, __stack_pointer
	i32.load	$push48=, 0($pop47)
	i32.const	$push49=, 288
	i32.sub 	$25=, $pop48, $pop49
	i32.const	$push50=, __stack_pointer
	i32.store	$discard=, 0($pop50), $25
	i32.const	$push0=, 85
	i32.store	$0=, 280($25):p2align=3, $pop0
	i64.const	$push1=, 81985529216486895
	i64.store	$1=, 272($25):p2align=4, $pop1
	i32.const	$push2=, 1
	i32.const	$6=, 272
	i32.add 	$6=, $25, $6
	call    	test@FUNCTION, $pop2, $6
	i32.const	$push3=, 16
	i32.const	$7=, 240
	i32.add 	$7=, $25, $7
	i32.add 	$push4=, $7, $pop3
	i32.store	$discard=, 0($pop4):p2align=4, $0
	i64.store	$discard=, 248($25), $1
	i32.const	$push5=, 2
	i32.store	$push6=, 240($25):p2align=4, $pop5
	i32.const	$8=, 240
	i32.add 	$8=, $25, $8
	call    	test@FUNCTION, $pop6, $8
	i32.const	$push46=, 16
	i32.const	$9=, 208
	i32.add 	$9=, $25, $9
	i32.add 	$push7=, $9, $pop46
	i32.store	$discard=, 0($pop7):p2align=4, $0
	i64.store	$discard=, 216($25), $1
	i64.const	$push8=, 12884901890
	i64.store	$2=, 208($25):p2align=4, $pop8
	i32.const	$push9=, 3
	i32.const	$10=, 208
	i32.add 	$10=, $25, $10
	call    	test@FUNCTION, $pop9, $10
	i32.const	$push10=, 24
	i32.const	$11=, 176
	i32.add 	$11=, $25, $11
	i32.add 	$push11=, $11, $pop10
	i32.store	$discard=, 0($pop11):p2align=3, $0
	i32.const	$push45=, 16
	i32.const	$12=, 176
	i32.add 	$12=, $25, $12
	i32.add 	$push12=, $12, $pop45
	i64.store	$discard=, 0($pop12):p2align=4, $1
	i32.const	$push13=, 4
	i32.store	$3=, 184($25):p2align=3, $pop13
	i64.store	$discard=, 176($25):p2align=4, $2
	i32.const	$13=, 176
	i32.add 	$13=, $25, $13
	call    	test@FUNCTION, $3, $13
	i32.const	$push44=, 24
	i32.const	$14=, 144
	i32.add 	$14=, $25, $14
	i32.add 	$push14=, $14, $pop44
	i32.store	$discard=, 0($pop14):p2align=3, $0
	i32.const	$push43=, 16
	i32.const	$15=, 144
	i32.add 	$15=, $25, $15
	i32.add 	$push15=, $15, $pop43
	i64.store	$discard=, 0($pop15):p2align=4, $1
	i64.const	$push16=, 21474836484
	i64.store	$4=, 152($25), $pop16
	i64.store	$discard=, 144($25):p2align=4, $2
	i32.const	$push17=, 5
	i32.const	$16=, 144
	i32.add 	$16=, $25, $16
	call    	test@FUNCTION, $pop17, $16
	i32.const	$push18=, 32
	i32.const	$17=, 96
	i32.add 	$17=, $25, $17
	i32.add 	$push19=, $17, $pop18
	i32.store	$discard=, 0($pop19):p2align=4, $0
	i32.const	$push42=, 24
	i32.const	$18=, 96
	i32.add 	$18=, $25, $18
	i32.add 	$push20=, $18, $pop42
	i64.store	$discard=, 0($pop20), $1
	i32.const	$push41=, 16
	i32.const	$19=, 96
	i32.add 	$19=, $25, $19
	i32.add 	$push21=, $19, $pop41
	i32.const	$push22=, 6
	i32.store	$3=, 0($pop21):p2align=4, $pop22
	i64.store	$discard=, 104($25), $4
	i64.store	$discard=, 96($25):p2align=4, $2
	i32.const	$20=, 96
	i32.add 	$20=, $25, $20
	call    	test@FUNCTION, $3, $20
	i32.const	$push40=, 32
	i32.const	$21=, 48
	i32.add 	$21=, $25, $21
	i32.add 	$push23=, $21, $pop40
	i32.store	$discard=, 0($pop23):p2align=4, $0
	i32.const	$push39=, 24
	i32.const	$22=, 48
	i32.add 	$22=, $25, $22
	i32.add 	$push24=, $22, $pop39
	i64.store	$discard=, 0($pop24), $1
	i32.const	$push38=, 16
	i32.const	$23=, 48
	i32.add 	$23=, $25, $23
	i32.add 	$push25=, $23, $pop38
	i64.const	$push26=, 30064771078
	i64.store	$5=, 0($pop25):p2align=4, $pop26
	i64.store	$discard=, 56($25), $4
	i64.store	$discard=, 48($25):p2align=4, $2
	i32.const	$push27=, 7
	i32.const	$24=, 48
	i32.add 	$24=, $25, $24
	call    	test@FUNCTION, $pop27, $24
	i32.const	$push28=, 40
	i32.add 	$push29=, $25, $pop28
	i32.store	$discard=, 0($pop29):p2align=3, $0
	i32.const	$push37=, 32
	i32.add 	$push30=, $25, $pop37
	i64.store	$discard=, 0($pop30):p2align=4, $1
	i32.const	$push36=, 24
	i32.add 	$push31=, $25, $pop36
	i32.const	$push32=, 8
	i32.store	$0=, 0($pop31):p2align=3, $pop32
	i32.const	$push35=, 16
	i32.add 	$push33=, $25, $pop35
	i64.store	$discard=, 0($pop33):p2align=4, $5
	i64.store	$discard=, 8($25), $4
	i64.store	$discard=, 0($25):p2align=4, $2
	call    	test@FUNCTION, $0, $25
	i32.const	$push34=, 0
	call    	exit@FUNCTION, $pop34
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
