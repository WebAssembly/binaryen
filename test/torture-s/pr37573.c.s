	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37573.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	bar@FUNCTION
	block
	i32.const	$push1=, p
	i32.const	$push0=, q
	i32.const	$push2=, 23
	i32.call	$push3=, memcmp@FUNCTION, $pop1, $pop0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.bar,"ax",@progbits
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 2512
	i32.sub 	$34=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$34=, 0($6), $34
	i32.const	$push2=, 8
	i32.const	$8=, 8
	i32.add 	$8=, $34, $8
	i32.add 	$push3=, $8, $pop2
	i32.const	$push1=, 41589
	i32.store	$3=, 0($pop3), $pop1
	i32.const	$0=, 1
	i32.const	$push4=, 12
	i32.const	$9=, 8
	i32.add 	$9=, $34, $9
	i32.add 	$2=, $9, $pop4
	copy_local	$4=, $0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push5=, 30
	i32.shr_u	$push6=, $3, $pop5
	i32.xor 	$push7=, $pop6, $3
	i32.const	$push8=, 1812433253
	i32.mul 	$push9=, $pop7, $pop8
	i32.add 	$push0=, $pop9, $4
	i32.store	$3=, 0($2), $pop0
	i32.add 	$4=, $4, $0
	i32.const	$1=, 4
	i32.add 	$2=, $2, $1
	i32.const	$push10=, 624
	i32.ne  	$push11=, $4, $pop10
	br_if   	$pop11, 0       # 0: up to label1
# BB#2:                                 # %for.end
	end_loop                        # label2:
	i32.const	$10=, 8
	i32.add 	$10=, $34, $10
	i32.or  	$push12=, $10, $1
	i32.const	$push13=, 1
	i32.store	$discard=, 0($pop12), $pop13
	i32.const	$11=, 8
	i32.add 	$11=, $34, $11
	i32.call	$3=, foo@FUNCTION, $11
	i32.const	$4=, 0
	i32.load8_u	$push14=, p($4)
	i32.xor 	$push15=, $pop14, $3
	i32.store8	$discard=, p($4), $pop15
	i32.const	$12=, 8
	i32.add 	$12=, $34, $12
	i32.call	$3=, foo@FUNCTION, $12
	i32.load8_u	$push16=, p+1($4)
	i32.xor 	$push17=, $pop16, $3
	i32.store8	$discard=, p+1($4), $pop17
	i32.const	$13=, 8
	i32.add 	$13=, $34, $13
	i32.call	$3=, foo@FUNCTION, $13
	i32.load8_u	$push18=, p+2($4)
	i32.xor 	$push19=, $pop18, $3
	i32.store8	$discard=, p+2($4), $pop19
	i32.const	$14=, 8
	i32.add 	$14=, $34, $14
	i32.call	$3=, foo@FUNCTION, $14
	i32.load8_u	$push20=, p+3($4)
	i32.xor 	$push21=, $pop20, $3
	i32.store8	$discard=, p+3($4), $pop21
	i32.const	$15=, 8
	i32.add 	$15=, $34, $15
	i32.call	$3=, foo@FUNCTION, $15
	i32.load8_u	$push22=, p+4($4)
	i32.xor 	$push23=, $pop22, $3
	i32.store8	$discard=, p+4($4), $pop23
	i32.const	$16=, 8
	i32.add 	$16=, $34, $16
	i32.call	$3=, foo@FUNCTION, $16
	i32.load8_u	$push24=, p+5($4)
	i32.xor 	$push25=, $pop24, $3
	i32.store8	$discard=, p+5($4), $pop25
	i32.const	$17=, 8
	i32.add 	$17=, $34, $17
	i32.call	$3=, foo@FUNCTION, $17
	i32.load8_u	$push26=, p+6($4)
	i32.xor 	$push27=, $pop26, $3
	i32.store8	$discard=, p+6($4), $pop27
	i32.const	$18=, 8
	i32.add 	$18=, $34, $18
	i32.call	$3=, foo@FUNCTION, $18
	i32.load8_u	$push28=, p+7($4)
	i32.xor 	$push29=, $pop28, $3
	i32.store8	$discard=, p+7($4), $pop29
	i32.const	$19=, 8
	i32.add 	$19=, $34, $19
	i32.call	$3=, foo@FUNCTION, $19
	i32.load8_u	$push30=, p+8($4)
	i32.xor 	$push31=, $pop30, $3
	i32.store8	$discard=, p+8($4), $pop31
	i32.const	$20=, 8
	i32.add 	$20=, $34, $20
	i32.call	$3=, foo@FUNCTION, $20
	i32.load8_u	$push32=, p+9($4)
	i32.xor 	$push33=, $pop32, $3
	i32.store8	$discard=, p+9($4), $pop33
	i32.const	$21=, 8
	i32.add 	$21=, $34, $21
	i32.call	$3=, foo@FUNCTION, $21
	i32.load8_u	$push34=, p+10($4)
	i32.xor 	$push35=, $pop34, $3
	i32.store8	$discard=, p+10($4), $pop35
	i32.const	$22=, 8
	i32.add 	$22=, $34, $22
	i32.call	$3=, foo@FUNCTION, $22
	i32.load8_u	$push36=, p+11($4)
	i32.xor 	$push37=, $pop36, $3
	i32.store8	$discard=, p+11($4), $pop37
	i32.const	$23=, 8
	i32.add 	$23=, $34, $23
	i32.call	$3=, foo@FUNCTION, $23
	i32.load8_u	$push38=, p+12($4)
	i32.xor 	$push39=, $pop38, $3
	i32.store8	$discard=, p+12($4), $pop39
	i32.const	$24=, 8
	i32.add 	$24=, $34, $24
	i32.call	$3=, foo@FUNCTION, $24
	i32.load8_u	$push40=, p+13($4)
	i32.xor 	$push41=, $pop40, $3
	i32.store8	$discard=, p+13($4), $pop41
	i32.const	$25=, 8
	i32.add 	$25=, $34, $25
	i32.call	$3=, foo@FUNCTION, $25
	i32.load8_u	$push42=, p+14($4)
	i32.xor 	$push43=, $pop42, $3
	i32.store8	$discard=, p+14($4), $pop43
	i32.const	$26=, 8
	i32.add 	$26=, $34, $26
	i32.call	$3=, foo@FUNCTION, $26
	i32.load8_u	$push44=, p+15($4)
	i32.xor 	$push45=, $pop44, $3
	i32.store8	$discard=, p+15($4), $pop45
	i32.const	$27=, 8
	i32.add 	$27=, $34, $27
	i32.call	$3=, foo@FUNCTION, $27
	i32.load8_u	$push46=, p+16($4)
	i32.xor 	$push47=, $pop46, $3
	i32.store8	$discard=, p+16($4), $pop47
	i32.const	$28=, 8
	i32.add 	$28=, $34, $28
	i32.call	$3=, foo@FUNCTION, $28
	i32.load8_u	$push48=, p+17($4)
	i32.xor 	$push49=, $pop48, $3
	i32.store8	$discard=, p+17($4), $pop49
	i32.const	$29=, 8
	i32.add 	$29=, $34, $29
	i32.call	$3=, foo@FUNCTION, $29
	i32.load8_u	$push50=, p+18($4)
	i32.xor 	$push51=, $pop50, $3
	i32.store8	$discard=, p+18($4), $pop51
	i32.const	$30=, 8
	i32.add 	$30=, $34, $30
	i32.call	$3=, foo@FUNCTION, $30
	i32.load8_u	$push52=, p+19($4)
	i32.xor 	$push53=, $pop52, $3
	i32.store8	$discard=, p+19($4), $pop53
	i32.const	$31=, 8
	i32.add 	$31=, $34, $31
	i32.call	$3=, foo@FUNCTION, $31
	i32.load8_u	$push54=, p+20($4)
	i32.xor 	$push55=, $pop54, $3
	i32.store8	$discard=, p+20($4), $pop55
	i32.const	$32=, 8
	i32.add 	$32=, $34, $32
	i32.call	$3=, foo@FUNCTION, $32
	i32.load8_u	$push56=, p+21($4)
	i32.xor 	$push57=, $pop56, $3
	i32.store8	$discard=, p+21($4), $pop57
	i32.const	$33=, 8
	i32.add 	$33=, $34, $33
	i32.call	$3=, foo@FUNCTION, $33
	i32.load8_u	$push58=, p+22($4)
	i32.xor 	$push59=, $pop58, $3
	i32.store8	$discard=, p+22($4), $pop59
	i32.const	$7=, 2512
	i32.add 	$34=, $34, $7
	i32.const	$7=, __stack_pointer
	i32.store	$34=, 0($7), $34
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 4($0)
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$push3=, 4($0), $pop2
	br_if   	$pop3, 0        # 0: down to label3
# BB#1:                                 # %if.then
	i32.const	$3=, 8
	i32.add 	$push4=, $0, $3
	i32.store	$discard=, 0($0), $pop4
	i32.load	$7=, 8($0)
	i32.const	$2=, 0
	copy_local	$6=, $2
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.add 	$4=, $0, $6
	i32.const	$push5=, 12
	i32.add 	$push6=, $4, $pop5
	i32.load	$1=, 0($pop6)
	i32.const	$5=, 1
	i32.add 	$push21=, $4, $3
	i32.and 	$push12=, $1, $5
	i32.sub 	$push13=, $2, $pop12
	i32.const	$push14=, -1727483681
	i32.and 	$push15=, $pop13, $pop14
	i32.const	$push16=, 1596
	i32.add 	$push17=, $4, $pop16
	i32.load	$push18=, 0($pop17)
	i32.xor 	$push19=, $pop15, $pop18
	i32.xor 	$push7=, $1, $7
	i32.const	$push8=, 2147483646
	i32.and 	$push9=, $pop7, $pop8
	i32.xor 	$push10=, $pop9, $7
	i32.shr_u	$push11=, $pop10, $5
	i32.xor 	$push20=, $pop19, $pop11
	i32.store	$discard=, 0($pop21), $pop20
	i32.const	$push22=, 4
	i32.add 	$6=, $6, $pop22
	copy_local	$7=, $1
	i32.const	$push23=, 908
	i32.ne  	$push24=, $6, $pop23
	br_if   	$pop24, 0       # 0: up to label4
.LBB2_3:                                # %if.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.load	$6=, 0($0)
	i32.const	$push25=, 4
	i32.add 	$push26=, $6, $pop25
	i32.store	$discard=, 0($0), $pop26
	i32.load	$6=, 0($6)
	i32.const	$push27=, 11
	i32.shr_u	$push28=, $6, $pop27
	i32.xor 	$6=, $pop28, $6
	i32.const	$push29=, 7
	i32.shl 	$push30=, $6, $pop29
	i32.const	$push31=, -1658038656
	i32.and 	$push32=, $pop30, $pop31
	i32.xor 	$6=, $pop32, $6
	i32.const	$push33=, 15
	i32.shl 	$push34=, $6, $pop33
	i32.const	$push35=, 130023424
	i32.and 	$push36=, $pop34, $pop35
	i32.xor 	$push37=, $pop36, $6
	i32.const	$push38=, 18
	i32.shr_u	$push39=, $pop37, $pop38
	i32.xor 	$push40=, $pop39, $6
	i32.const	$push41=, 1
	i32.shr_u	$push42=, $pop40, $pop41
	i32.const	$push43=, 255
	i32.and 	$push44=, $pop42, $pop43
	return  	$pop44
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.type	p,@object               # @p
	.section	.data.p,"aw",@progbits
	.align	4
p:
	.ascii	"\300I\0272b\036.\325L\031(I\221\344r\203\221=\223\203\263a8"
	.size	p, 23

	.type	q,@object               # @q
	.section	.data.q,"aw",@progbits
	.align	4
q:
	.ascii	">AUTOIT UNICODE SCRIPT<"
	.size	q, 23


	.ident	"clang version 3.9.0 "
