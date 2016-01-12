	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060420-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$25=, 0
	i32.const	$8=, 1
	block   	.LBB0_6
	i32.lt_s	$push0=, $3, $8
	br_if   	$pop0, .LBB0_6
# BB#1:                                 # %land.rhs.lr.ph
	i32.const	$9=, 4
	i32.add 	$14=, $1, $9
	i32.const	$12=, -1
	i32.add 	$15=, $2, $12
	i32.const	$25=, 0
.LBB0_2:                                # %land.rhs
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop    	.LBB0_6
	i32.add 	$push1=, $25, $0
	i32.const	$push2=, 15
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push81=, 0
	i32.eq  	$push82=, $pop3, $pop81
	br_if   	$pop82, .LBB0_6
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$13=, 2
	i32.shl 	$27=, $25, $13
	i32.load	$push4=, 0($1)
	i32.add 	$push5=, $pop4, $27
	f32.load	$43=, 0($pop5)
	copy_local	$24=, $15
	copy_local	$26=, $14
	block   	.LBB0_5
	i32.lt_s	$push6=, $2, $13
	br_if   	$pop6, .LBB0_5
.LBB0_4:                                # %for.body4
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_5
	i32.load	$push7=, 0($26)
	i32.add 	$push8=, $pop7, $27
	f32.load	$push9=, 0($pop8)
	f32.add 	$43=, $43, $pop9
	i32.add 	$26=, $26, $9
	i32.add 	$24=, $24, $12
	br_if   	$24, .LBB0_4
.LBB0_5:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$push10=, $0, $27
	f32.store	$discard=, 0($pop10), $43
	i32.add 	$25=, $25, $8
	i32.lt_s	$push11=, $25, $3
	br_if   	$pop11, .LBB0_2
.LBB0_6:                                # %for.cond12.preheader
	block   	.LBB0_12
	i32.const	$push12=, -15
	i32.add 	$4=, $3, $pop12
	i32.ge_s	$push13=, $25, $4
	br_if   	$pop13, .LBB0_12
# BB#7:                                 # %for.body15.lr.ph
	i32.const	$24=, -16
	i32.add 	$push14=, $3, $24
	i32.sub 	$push15=, $pop14, $25
	i32.and 	$push16=, $pop15, $24
	i32.add 	$5=, $25, $pop16
	i32.const	$9=, 4
	i32.add 	$6=, $1, $9
	i32.const	$10=, -1
	i32.add 	$7=, $2, $10
.LBB0_8:                                # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_9 Depth 2
	loop    	.LBB0_11
	i32.const	$11=, 2
	i32.shl 	$12=, $25, $11
	i32.load	$push17=, 0($1)
	i32.add 	$24=, $pop17, $12
	i32.const	$13=, 12
	i32.add 	$push18=, $24, $13
	f32.load	$43=, 0($pop18)
	i32.const	$14=, 8
	i32.const	$15=, 28
	i32.const	$16=, 24
	i32.const	$17=, 20
	i32.const	$18=, 44
	i32.const	$19=, 40
	i32.const	$20=, 36
	i32.const	$21=, 60
	i32.const	$22=, 56
	i32.const	$23=, 52
	i32.add 	$push19=, $24, $14
	f32.load	$42=, 0($pop19)
	i32.add 	$push20=, $24, $9
	f32.load	$41=, 0($pop20)
	i32.add 	$push21=, $24, $15
	f32.load	$39=, 0($pop21)
	i32.add 	$push22=, $24, $16
	f32.load	$38=, 0($pop22)
	i32.add 	$push23=, $24, $17
	f32.load	$37=, 0($pop23)
	i32.add 	$push24=, $24, $18
	f32.load	$35=, 0($pop24)
	i32.add 	$push25=, $24, $19
	f32.load	$34=, 0($pop25)
	i32.add 	$push26=, $24, $20
	f32.load	$33=, 0($pop26)
	f32.load	$40=, 0($24)
	f32.load	$36=, 16($24)
	f32.load	$32=, 32($24)
	f32.load	$28=, 48($24)
	i32.add 	$push27=, $24, $21
	f32.load	$31=, 0($pop27)
	i32.add 	$push28=, $24, $22
	f32.load	$30=, 0($pop28)
	i32.add 	$push29=, $24, $23
	f32.load	$29=, 0($pop29)
	copy_local	$26=, $7
	copy_local	$27=, $6
	block   	.LBB0_10
	i32.lt_s	$push30=, $2, $11
	br_if   	$pop30, .LBB0_10
.LBB0_9:                                # %for.body33
                                        #   Parent Loop BB0_8 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_10
	i32.load	$push31=, 0($27)
	i32.add 	$24=, $pop31, $12
	f32.load	$push38=, 0($24)
	f32.add 	$40=, $40, $pop38
	i32.add 	$push36=, $24, $13
	f32.load	$push37=, 0($pop36)
	f32.add 	$43=, $43, $pop37
	i32.add 	$push34=, $24, $14
	f32.load	$push35=, 0($pop34)
	f32.add 	$42=, $42, $pop35
	i32.add 	$push32=, $24, $9
	f32.load	$push33=, 0($pop32)
	f32.add 	$41=, $41, $pop33
	f32.load	$push45=, 16($24)
	f32.add 	$36=, $36, $pop45
	i32.add 	$push43=, $24, $15
	f32.load	$push44=, 0($pop43)
	f32.add 	$39=, $39, $pop44
	i32.add 	$push41=, $24, $16
	f32.load	$push42=, 0($pop41)
	f32.add 	$38=, $38, $pop42
	i32.add 	$push39=, $24, $17
	f32.load	$push40=, 0($pop39)
	f32.add 	$37=, $37, $pop40
	f32.load	$push52=, 32($24)
	f32.add 	$32=, $32, $pop52
	i32.add 	$push50=, $24, $18
	f32.load	$push51=, 0($pop50)
	f32.add 	$35=, $35, $pop51
	i32.add 	$push48=, $24, $19
	f32.load	$push49=, 0($pop48)
	f32.add 	$34=, $34, $pop49
	i32.add 	$push46=, $24, $20
	f32.load	$push47=, 0($pop46)
	f32.add 	$33=, $33, $pop47
	f32.load	$push59=, 48($24)
	f32.add 	$28=, $28, $pop59
	i32.add 	$push57=, $24, $21
	f32.load	$push58=, 0($pop57)
	f32.add 	$31=, $31, $pop58
	i32.add 	$push55=, $24, $22
	f32.load	$push56=, 0($pop55)
	f32.add 	$30=, $30, $pop56
	i32.add 	$push53=, $24, $23
	f32.load	$push54=, 0($pop53)
	f32.add 	$29=, $29, $pop54
	i32.add 	$27=, $27, $9
	i32.add 	$26=, $26, $10
	br_if   	$26, .LBB0_9
.LBB0_10:                               # %for.end56
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.add 	$24=, $0, $12
	f32.store	$discard=, 0($24), $40
	i32.add 	$push60=, $24, $13
	f32.store	$discard=, 0($pop60), $43
	i32.add 	$push61=, $24, $14
	f32.store	$discard=, 0($pop61), $42
	i32.add 	$push62=, $24, $9
	f32.store	$discard=, 0($pop62), $41
	f32.store	$discard=, 16($24), $36
	i32.add 	$push63=, $24, $15
	f32.store	$discard=, 0($pop63), $39
	i32.add 	$push64=, $24, $16
	f32.store	$discard=, 0($pop64), $38
	i32.add 	$push65=, $24, $17
	f32.store	$discard=, 0($pop65), $37
	f32.store	$discard=, 32($24), $32
	i32.add 	$push66=, $24, $18
	f32.store	$discard=, 0($pop66), $35
	i32.add 	$push67=, $24, $19
	f32.store	$discard=, 0($pop67), $34
	i32.add 	$push68=, $24, $20
	f32.store	$discard=, 0($pop68), $33
	f32.store	$discard=, 48($24), $28
	i32.add 	$push69=, $24, $21
	f32.store	$discard=, 0($pop69), $31
	i32.add 	$push70=, $24, $22
	f32.store	$discard=, 0($pop70), $30
	i32.add 	$push71=, $24, $23
	f32.store	$discard=, 0($pop71), $29
	i32.const	$24=, 16
	i32.add 	$25=, $25, $24
	i32.lt_s	$push72=, $25, $4
	br_if   	$pop72, .LBB0_8
.LBB0_11:                               # %for.cond73.preheader.loopexit
	i32.add 	$25=, $5, $24
.LBB0_12:                               # %for.cond73.preheader
	block   	.LBB0_17
	i32.ge_s	$push73=, $25, $3
	br_if   	$pop73, .LBB0_17
# BB#13:                                # %for.body75.lr.ph
	i32.load	$14=, 0($1)
	i32.const	$9=, 4
	i32.add 	$15=, $1, $9
	i32.const	$12=, -1
	i32.add 	$16=, $2, $12
.LBB0_14:                               # %for.body75
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_15 Depth 2
	loop    	.LBB0_17
	i32.const	$13=, 2
	i32.shl 	$27=, $25, $13
	i32.add 	$push74=, $14, $27
	f32.load	$43=, 0($pop74)
	copy_local	$24=, $16
	copy_local	$26=, $15
	block   	.LBB0_16
	i32.lt_s	$push75=, $2, $13
	br_if   	$pop75, .LBB0_16
.LBB0_15:                               # %for.body81
                                        #   Parent Loop BB0_14 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_16
	i32.load	$push76=, 0($26)
	i32.add 	$push77=, $pop76, $27
	f32.load	$push78=, 0($pop77)
	f32.add 	$43=, $43, $pop78
	i32.add 	$26=, $26, $9
	i32.add 	$24=, $24, $12
	br_if   	$24, .LBB0_15
.LBB0_16:                               # %for.end87
                                        #   in Loop: Header=BB0_14 Depth=1
	i32.add 	$push79=, $0, $27
	f32.store	$discard=, 0($pop79), $43
	i32.add 	$25=, $25, $8
	i32.ne  	$push80=, $25, $3
	br_if   	$pop80, .LBB0_14
.LBB0_17:                               # %for.end91
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, f32, f32, f32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 16
	i32.sub 	$15=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$15=, 0($12), $15
	i32.const	$0=, buffer
	i32.const	$10=, 0
	i32.const	$1=, 63
	i32.sub 	$push1=, $10, $0
	i32.and 	$push2=, $pop1, $1
	i32.add 	$9=, $0, $pop2
	i32.const	$push3=, 128
	i32.add 	$push4=, $9, $pop3
	i32.store	$discard=, 12($15), $pop4
	i32.const	$2=, 64
	i32.add 	$push0=, $9, $2
	i32.store	$9=, 8($15), $pop0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	f32.convert_s/i32	$3=, $10
	f32.const	$4=, 0x1.6p3
	f32.mul 	$push5=, $3, $4
	f32.add 	$push6=, $3, $pop5
	f32.store	$discard=, 0($9), $pop6
	f32.const	$5=, 0x1.8p3
	i32.add 	$push9=, $9, $2
	f32.mul 	$push7=, $3, $5
	f32.add 	$push8=, $3, $pop7
	f32.store	$discard=, 0($pop9), $pop8
	i32.const	$6=, 1
	i32.add 	$10=, $10, $6
	i32.const	$7=, 4
	i32.add 	$9=, $9, $7
	i32.const	$8=, 16
	i32.ne  	$push10=, $10, $8
	br_if   	$pop10, .LBB1_1
.LBB1_2:                                # %for.end
	i32.const	$10=, 0
	i32.sub 	$push11=, $10, $0
	i32.and 	$push12=, $pop11, $1
	i32.add 	$9=, $0, $pop12
	i32.const	$push13=, 2
	i32.const	$14=, 8
	i32.add 	$14=, $15, $14
	call    	foo@FUNCTION, $9, $14, $pop13, $8
.LBB1_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_6
	loop    	.LBB1_5
	f32.convert_s/i32	$3=, $10
	f32.load	$push19=, 0($9)
	f32.mul 	$push17=, $3, $5
	f32.mul 	$push14=, $3, $4
	f32.add 	$push15=, $3, $pop14
	f32.add 	$push16=, $3, $pop15
	f32.add 	$push18=, $pop17, $pop16
	f32.ne  	$push20=, $pop19, $pop18
	br_if   	$pop20, .LBB1_6
# BB#4:                                 # %for.cond13
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.add 	$10=, $10, $6
	i32.add 	$9=, $9, $7
	i32.const	$push21=, 15
	i32.le_s	$push22=, $10, $pop21
	br_if   	$pop22, .LBB1_3
.LBB1_5:                                # %for.end31
	i32.const	$push23=, 0
	i32.const	$13=, 16
	i32.add 	$15=, $15, $13
	i32.const	$13=, __stack_pointer
	i32.store	$15=, 0($13), $15
	return  	$pop23
.LBB1_6:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buffer                  # @buffer
	.type	buffer,@object
	.section	.bss.buffer,"aw",@nobits
	.globl	buffer
	.align	4
buffer:
	.skip	256
	.size	buffer, 256


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
