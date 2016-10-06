	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041011-1.c"
	.section	.text.t1,"ax",@progbits
	.hidden	t1
	.globl	t1
	.type	t1,@function
t1:                                     # @t1
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 11
	i64.shl 	$2=, $pop1, $pop2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push68=, 0
	i32.load	$3=, gvol+4($pop68)
	i32.const	$push67=, 0
	i32.load	$4=, gvol+8($pop67)
	i32.const	$push66=, 0
	i32.load	$5=, gvol+12($pop66)
	i32.const	$push65=, 0
	i32.load	$6=, gvol+16($pop65)
	i32.const	$push64=, 0
	i32.load	$7=, gvol+20($pop64)
	i32.const	$push63=, 0
	i32.load	$8=, gvol+24($pop63)
	i32.const	$push62=, 0
	i32.load	$9=, gvol+28($pop62)
	i32.const	$push61=, 0
	i32.load	$10=, gvol+32($pop61)
	i32.const	$push60=, 0
	i32.load	$11=, gvol+36($pop60)
	i32.const	$push59=, 0
	i32.load	$12=, gvol+40($pop59)
	i32.const	$push58=, 0
	i32.load	$13=, gvol+44($pop58)
	i32.const	$push57=, 0
	i32.load	$14=, gvol+48($pop57)
	i32.const	$push56=, 0
	i32.load	$15=, gvol+52($pop56)
	i32.const	$push55=, 0
	i32.load	$16=, gvol+56($pop55)
	i32.const	$push54=, 0
	i32.load	$17=, gvol+60($pop54)
	i32.const	$push53=, 0
	i32.load	$18=, gvol+64($pop53)
	i32.const	$push52=, 0
	i32.load	$19=, gvol+68($pop52)
	i32.const	$push51=, 0
	i32.load	$20=, gvol+72($pop51)
	i32.const	$push50=, 0
	i32.load	$21=, gvol+76($pop50)
	i32.const	$push49=, 0
	i32.load	$22=, gvol+80($pop49)
	i32.const	$push48=, 0
	i32.load	$23=, gvol+84($pop48)
	i32.const	$push47=, 0
	i32.load	$24=, gvol+88($pop47)
	i32.const	$push46=, 0
	i32.load	$25=, gvol+92($pop46)
	i32.const	$push45=, 0
	i32.load	$26=, gvol+96($pop45)
	i32.const	$push44=, 0
	i32.load	$27=, gvol+100($pop44)
	i32.const	$push43=, 0
	i32.load	$28=, gvol+104($pop43)
	i32.const	$push42=, 0
	i32.load	$29=, gvol+108($pop42)
	i32.const	$push41=, 0
	i32.load	$30=, gvol+112($pop41)
	i32.const	$push40=, 0
	i32.load	$31=, gvol+116($pop40)
	i32.const	$push39=, 0
	i32.load	$32=, gvol+120($pop39)
	i32.const	$push38=, 0
	i32.store	gvol+4($pop38), $3
	i32.const	$push37=, 0
	i32.store	gvol+8($pop37), $4
	i32.const	$push36=, 0
	i32.store	gvol+12($pop36), $5
	i32.const	$push35=, 0
	i32.store	gvol+16($pop35), $6
	i32.const	$push34=, 0
	i32.store	gvol+20($pop34), $7
	i32.const	$push33=, 0
	i32.store	gvol+24($pop33), $8
	i32.const	$push32=, 0
	i32.store	gvol+28($pop32), $9
	i32.const	$push31=, 0
	i32.store	gvol+32($pop31), $10
	i32.const	$push30=, 0
	i32.store	gvol+36($pop30), $11
	i32.const	$push29=, 0
	i32.store	gvol+40($pop29), $12
	i32.const	$push28=, 0
	i32.store	gvol+44($pop28), $13
	i32.const	$push27=, 0
	i32.store	gvol+48($pop27), $14
	i32.const	$push26=, 0
	i32.store	gvol+52($pop26), $15
	i32.const	$push25=, 0
	i32.store	gvol+56($pop25), $16
	i32.const	$push24=, 0
	i32.store	gvol+60($pop24), $17
	i32.const	$push23=, 0
	i32.store	gvol+64($pop23), $18
	i32.const	$push22=, 0
	i32.store	gvol+68($pop22), $19
	i32.const	$push21=, 0
	i32.store	gvol+72($pop21), $20
	i32.const	$push20=, 0
	i32.store	gvol+76($pop20), $21
	i32.const	$push19=, 0
	i32.store	gvol+80($pop19), $22
	i32.const	$push18=, 0
	i32.store	gvol+84($pop18), $23
	i32.const	$push17=, 0
	i32.store	gvol+88($pop17), $24
	i32.const	$push16=, 0
	i32.store	gvol+92($pop16), $25
	i32.const	$push15=, 0
	i32.store	gvol+96($pop15), $26
	i32.const	$push14=, 0
	i32.store	gvol+100($pop14), $27
	i32.const	$push13=, 0
	i32.store	gvol+104($pop13), $28
	i32.const	$push12=, 0
	i32.store	gvol+108($pop12), $29
	i32.const	$push11=, 0
	i32.store	gvol+112($pop11), $30
	i32.const	$push10=, 0
	i32.store	gvol+116($pop10), $31
	i32.const	$push9=, 0
	i32.store	gvol+120($pop9), $32
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push3=, -2048
	i64.add 	$push4=, $1, $pop3
	i64.sub 	$1=, $pop4, $2
.LBB0_4:                                # %while.end
	end_block                       # label0:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end0:
	.size	t1, .Lfunc_end0-t1

	.section	.text.t2,"ax",@progbits
	.hidden	t2
	.globl	t2
	.type	t2,@function
t2:                                     # @t2
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label2
# BB#1:                                 # %while.body.preheader
	i32.const	$push4=, -1
	i32.add 	$push0=, $0, $pop4
	i64.extend_u/i32	$2=, $pop0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push67=, 0
	i32.load	$3=, gvol+4($pop67)
	i32.const	$push66=, 0
	i32.load	$4=, gvol+8($pop66)
	i32.const	$push65=, 0
	i32.load	$5=, gvol+12($pop65)
	i32.const	$push64=, 0
	i32.load	$6=, gvol+16($pop64)
	i32.const	$push63=, 0
	i32.load	$7=, gvol+20($pop63)
	i32.const	$push62=, 0
	i32.load	$8=, gvol+24($pop62)
	i32.const	$push61=, 0
	i32.load	$9=, gvol+28($pop61)
	i32.const	$push60=, 0
	i32.load	$10=, gvol+32($pop60)
	i32.const	$push59=, 0
	i32.load	$11=, gvol+36($pop59)
	i32.const	$push58=, 0
	i32.load	$12=, gvol+40($pop58)
	i32.const	$push57=, 0
	i32.load	$13=, gvol+44($pop57)
	i32.const	$push56=, 0
	i32.load	$14=, gvol+48($pop56)
	i32.const	$push55=, 0
	i32.load	$15=, gvol+52($pop55)
	i32.const	$push54=, 0
	i32.load	$16=, gvol+56($pop54)
	i32.const	$push53=, 0
	i32.load	$17=, gvol+60($pop53)
	i32.const	$push52=, 0
	i32.load	$18=, gvol+64($pop52)
	i32.const	$push51=, 0
	i32.load	$19=, gvol+68($pop51)
	i32.const	$push50=, 0
	i32.load	$20=, gvol+72($pop50)
	i32.const	$push49=, 0
	i32.load	$21=, gvol+76($pop49)
	i32.const	$push48=, 0
	i32.load	$22=, gvol+80($pop48)
	i32.const	$push47=, 0
	i32.load	$23=, gvol+84($pop47)
	i32.const	$push46=, 0
	i32.load	$24=, gvol+88($pop46)
	i32.const	$push45=, 0
	i32.load	$25=, gvol+92($pop45)
	i32.const	$push44=, 0
	i32.load	$26=, gvol+96($pop44)
	i32.const	$push43=, 0
	i32.load	$27=, gvol+100($pop43)
	i32.const	$push42=, 0
	i32.load	$28=, gvol+104($pop42)
	i32.const	$push41=, 0
	i32.load	$29=, gvol+108($pop41)
	i32.const	$push40=, 0
	i32.load	$30=, gvol+112($pop40)
	i32.const	$push39=, 0
	i32.load	$31=, gvol+116($pop39)
	i32.const	$push38=, 0
	i32.load	$32=, gvol+120($pop38)
	i32.const	$push37=, 0
	i32.store	gvol+4($pop37), $3
	i32.const	$push36=, 0
	i32.store	gvol+8($pop36), $4
	i32.const	$push35=, 0
	i32.store	gvol+12($pop35), $5
	i32.const	$push34=, 0
	i32.store	gvol+16($pop34), $6
	i32.const	$push33=, 0
	i32.store	gvol+20($pop33), $7
	i32.const	$push32=, 0
	i32.store	gvol+24($pop32), $8
	i32.const	$push31=, 0
	i32.store	gvol+28($pop31), $9
	i32.const	$push30=, 0
	i32.store	gvol+32($pop30), $10
	i32.const	$push29=, 0
	i32.store	gvol+36($pop29), $11
	i32.const	$push28=, 0
	i32.store	gvol+40($pop28), $12
	i32.const	$push27=, 0
	i32.store	gvol+44($pop27), $13
	i32.const	$push26=, 0
	i32.store	gvol+48($pop26), $14
	i32.const	$push25=, 0
	i32.store	gvol+52($pop25), $15
	i32.const	$push24=, 0
	i32.store	gvol+56($pop24), $16
	i32.const	$push23=, 0
	i32.store	gvol+60($pop23), $17
	i32.const	$push22=, 0
	i32.store	gvol+64($pop22), $18
	i32.const	$push21=, 0
	i32.store	gvol+68($pop21), $19
	i32.const	$push20=, 0
	i32.store	gvol+72($pop20), $20
	i32.const	$push19=, 0
	i32.store	gvol+76($pop19), $21
	i32.const	$push18=, 0
	i32.store	gvol+80($pop18), $22
	i32.const	$push17=, 0
	i32.store	gvol+84($pop17), $23
	i32.const	$push16=, 0
	i32.store	gvol+88($pop16), $24
	i32.const	$push15=, 0
	i32.store	gvol+92($pop15), $25
	i32.const	$push14=, 0
	i32.store	gvol+96($pop14), $26
	i32.const	$push13=, 0
	i32.store	gvol+100($pop13), $27
	i32.const	$push12=, 0
	i32.store	gvol+104($pop12), $28
	i32.const	$push11=, 0
	i32.store	gvol+108($pop11), $29
	i32.const	$push10=, 0
	i32.store	gvol+112($pop10), $30
	i32.const	$push9=, 0
	i32.store	gvol+116($pop9), $31
	i32.const	$push8=, 0
	i32.store	gvol+120($pop8), $32
	i32.const	$push7=, -1
	i32.add 	$push6=, $0, $pop7
	tee_local	$push5=, $0=, $pop6
	br_if   	0, $pop5        # 0: up to label3
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push1=, -513
	i64.mul 	$push2=, $2, $pop1
	i64.add 	$push3=, $1, $pop2
	i64.const	$push68=, -513
	i64.add 	$1=, $pop3, $pop68
.LBB1_4:                                # %while.end
	end_block                       # label2:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end1:
	.size	t2, .Lfunc_end1-t2

	.section	.text.t3,"ax",@progbits
	.hidden	t3
	.globl	t3
	.type	t3,@function
t3:                                     # @t3
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label4
# BB#1:                                 # %while.body.preheader
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 9
	i64.shl 	$2=, $pop1, $pop2
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push68=, 0
	i32.load	$3=, gvol+4($pop68)
	i32.const	$push67=, 0
	i32.load	$4=, gvol+8($pop67)
	i32.const	$push66=, 0
	i32.load	$5=, gvol+12($pop66)
	i32.const	$push65=, 0
	i32.load	$6=, gvol+16($pop65)
	i32.const	$push64=, 0
	i32.load	$7=, gvol+20($pop64)
	i32.const	$push63=, 0
	i32.load	$8=, gvol+24($pop63)
	i32.const	$push62=, 0
	i32.load	$9=, gvol+28($pop62)
	i32.const	$push61=, 0
	i32.load	$10=, gvol+32($pop61)
	i32.const	$push60=, 0
	i32.load	$11=, gvol+36($pop60)
	i32.const	$push59=, 0
	i32.load	$12=, gvol+40($pop59)
	i32.const	$push58=, 0
	i32.load	$13=, gvol+44($pop58)
	i32.const	$push57=, 0
	i32.load	$14=, gvol+48($pop57)
	i32.const	$push56=, 0
	i32.load	$15=, gvol+52($pop56)
	i32.const	$push55=, 0
	i32.load	$16=, gvol+56($pop55)
	i32.const	$push54=, 0
	i32.load	$17=, gvol+60($pop54)
	i32.const	$push53=, 0
	i32.load	$18=, gvol+64($pop53)
	i32.const	$push52=, 0
	i32.load	$19=, gvol+68($pop52)
	i32.const	$push51=, 0
	i32.load	$20=, gvol+72($pop51)
	i32.const	$push50=, 0
	i32.load	$21=, gvol+76($pop50)
	i32.const	$push49=, 0
	i32.load	$22=, gvol+80($pop49)
	i32.const	$push48=, 0
	i32.load	$23=, gvol+84($pop48)
	i32.const	$push47=, 0
	i32.load	$24=, gvol+88($pop47)
	i32.const	$push46=, 0
	i32.load	$25=, gvol+92($pop46)
	i32.const	$push45=, 0
	i32.load	$26=, gvol+96($pop45)
	i32.const	$push44=, 0
	i32.load	$27=, gvol+100($pop44)
	i32.const	$push43=, 0
	i32.load	$28=, gvol+104($pop43)
	i32.const	$push42=, 0
	i32.load	$29=, gvol+108($pop42)
	i32.const	$push41=, 0
	i32.load	$30=, gvol+112($pop41)
	i32.const	$push40=, 0
	i32.load	$31=, gvol+116($pop40)
	i32.const	$push39=, 0
	i32.load	$32=, gvol+120($pop39)
	i32.const	$push38=, 0
	i32.store	gvol+4($pop38), $3
	i32.const	$push37=, 0
	i32.store	gvol+8($pop37), $4
	i32.const	$push36=, 0
	i32.store	gvol+12($pop36), $5
	i32.const	$push35=, 0
	i32.store	gvol+16($pop35), $6
	i32.const	$push34=, 0
	i32.store	gvol+20($pop34), $7
	i32.const	$push33=, 0
	i32.store	gvol+24($pop33), $8
	i32.const	$push32=, 0
	i32.store	gvol+28($pop32), $9
	i32.const	$push31=, 0
	i32.store	gvol+32($pop31), $10
	i32.const	$push30=, 0
	i32.store	gvol+36($pop30), $11
	i32.const	$push29=, 0
	i32.store	gvol+40($pop29), $12
	i32.const	$push28=, 0
	i32.store	gvol+44($pop28), $13
	i32.const	$push27=, 0
	i32.store	gvol+48($pop27), $14
	i32.const	$push26=, 0
	i32.store	gvol+52($pop26), $15
	i32.const	$push25=, 0
	i32.store	gvol+56($pop25), $16
	i32.const	$push24=, 0
	i32.store	gvol+60($pop24), $17
	i32.const	$push23=, 0
	i32.store	gvol+64($pop23), $18
	i32.const	$push22=, 0
	i32.store	gvol+68($pop22), $19
	i32.const	$push21=, 0
	i32.store	gvol+72($pop21), $20
	i32.const	$push20=, 0
	i32.store	gvol+76($pop20), $21
	i32.const	$push19=, 0
	i32.store	gvol+80($pop19), $22
	i32.const	$push18=, 0
	i32.store	gvol+84($pop18), $23
	i32.const	$push17=, 0
	i32.store	gvol+88($pop17), $24
	i32.const	$push16=, 0
	i32.store	gvol+92($pop16), $25
	i32.const	$push15=, 0
	i32.store	gvol+96($pop15), $26
	i32.const	$push14=, 0
	i32.store	gvol+100($pop14), $27
	i32.const	$push13=, 0
	i32.store	gvol+104($pop13), $28
	i32.const	$push12=, 0
	i32.store	gvol+108($pop12), $29
	i32.const	$push11=, 0
	i32.store	gvol+112($pop11), $30
	i32.const	$push10=, 0
	i32.store	gvol+116($pop10), $31
	i32.const	$push9=, 0
	i32.store	gvol+120($pop9), $32
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label5
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push3=, -512
	i64.add 	$push4=, $1, $pop3
	i64.sub 	$1=, $pop4, $2
.LBB2_4:                                # %while.end
	end_block                       # label4:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end2:
	.size	t3, .Lfunc_end2-t3

	.section	.text.t4,"ax",@progbits
	.hidden	t4
	.globl	t4
	.type	t4,@function
t4:                                     # @t4
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.const	$push4=, -1
	i32.add 	$push0=, $0, $pop4
	i64.extend_u/i32	$2=, $pop0
.LBB3_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.const	$push67=, 0
	i32.load	$3=, gvol+4($pop67)
	i32.const	$push66=, 0
	i32.load	$4=, gvol+8($pop66)
	i32.const	$push65=, 0
	i32.load	$5=, gvol+12($pop65)
	i32.const	$push64=, 0
	i32.load	$6=, gvol+16($pop64)
	i32.const	$push63=, 0
	i32.load	$7=, gvol+20($pop63)
	i32.const	$push62=, 0
	i32.load	$8=, gvol+24($pop62)
	i32.const	$push61=, 0
	i32.load	$9=, gvol+28($pop61)
	i32.const	$push60=, 0
	i32.load	$10=, gvol+32($pop60)
	i32.const	$push59=, 0
	i32.load	$11=, gvol+36($pop59)
	i32.const	$push58=, 0
	i32.load	$12=, gvol+40($pop58)
	i32.const	$push57=, 0
	i32.load	$13=, gvol+44($pop57)
	i32.const	$push56=, 0
	i32.load	$14=, gvol+48($pop56)
	i32.const	$push55=, 0
	i32.load	$15=, gvol+52($pop55)
	i32.const	$push54=, 0
	i32.load	$16=, gvol+56($pop54)
	i32.const	$push53=, 0
	i32.load	$17=, gvol+60($pop53)
	i32.const	$push52=, 0
	i32.load	$18=, gvol+64($pop52)
	i32.const	$push51=, 0
	i32.load	$19=, gvol+68($pop51)
	i32.const	$push50=, 0
	i32.load	$20=, gvol+72($pop50)
	i32.const	$push49=, 0
	i32.load	$21=, gvol+76($pop49)
	i32.const	$push48=, 0
	i32.load	$22=, gvol+80($pop48)
	i32.const	$push47=, 0
	i32.load	$23=, gvol+84($pop47)
	i32.const	$push46=, 0
	i32.load	$24=, gvol+88($pop46)
	i32.const	$push45=, 0
	i32.load	$25=, gvol+92($pop45)
	i32.const	$push44=, 0
	i32.load	$26=, gvol+96($pop44)
	i32.const	$push43=, 0
	i32.load	$27=, gvol+100($pop43)
	i32.const	$push42=, 0
	i32.load	$28=, gvol+104($pop42)
	i32.const	$push41=, 0
	i32.load	$29=, gvol+108($pop41)
	i32.const	$push40=, 0
	i32.load	$30=, gvol+112($pop40)
	i32.const	$push39=, 0
	i32.load	$31=, gvol+116($pop39)
	i32.const	$push38=, 0
	i32.load	$32=, gvol+120($pop38)
	i32.const	$push37=, 0
	i32.store	gvol+4($pop37), $3
	i32.const	$push36=, 0
	i32.store	gvol+8($pop36), $4
	i32.const	$push35=, 0
	i32.store	gvol+12($pop35), $5
	i32.const	$push34=, 0
	i32.store	gvol+16($pop34), $6
	i32.const	$push33=, 0
	i32.store	gvol+20($pop33), $7
	i32.const	$push32=, 0
	i32.store	gvol+24($pop32), $8
	i32.const	$push31=, 0
	i32.store	gvol+28($pop31), $9
	i32.const	$push30=, 0
	i32.store	gvol+32($pop30), $10
	i32.const	$push29=, 0
	i32.store	gvol+36($pop29), $11
	i32.const	$push28=, 0
	i32.store	gvol+40($pop28), $12
	i32.const	$push27=, 0
	i32.store	gvol+44($pop27), $13
	i32.const	$push26=, 0
	i32.store	gvol+48($pop26), $14
	i32.const	$push25=, 0
	i32.store	gvol+52($pop25), $15
	i32.const	$push24=, 0
	i32.store	gvol+56($pop24), $16
	i32.const	$push23=, 0
	i32.store	gvol+60($pop23), $17
	i32.const	$push22=, 0
	i32.store	gvol+64($pop22), $18
	i32.const	$push21=, 0
	i32.store	gvol+68($pop21), $19
	i32.const	$push20=, 0
	i32.store	gvol+72($pop20), $20
	i32.const	$push19=, 0
	i32.store	gvol+76($pop19), $21
	i32.const	$push18=, 0
	i32.store	gvol+80($pop18), $22
	i32.const	$push17=, 0
	i32.store	gvol+84($pop17), $23
	i32.const	$push16=, 0
	i32.store	gvol+88($pop16), $24
	i32.const	$push15=, 0
	i32.store	gvol+92($pop15), $25
	i32.const	$push14=, 0
	i32.store	gvol+96($pop14), $26
	i32.const	$push13=, 0
	i32.store	gvol+100($pop13), $27
	i32.const	$push12=, 0
	i32.store	gvol+104($pop12), $28
	i32.const	$push11=, 0
	i32.store	gvol+108($pop11), $29
	i32.const	$push10=, 0
	i32.store	gvol+112($pop10), $30
	i32.const	$push9=, 0
	i32.store	gvol+116($pop9), $31
	i32.const	$push8=, 0
	i32.store	gvol+120($pop8), $32
	i32.const	$push7=, -1
	i32.add 	$push6=, $0, $pop7
	tee_local	$push5=, $0=, $pop6
	br_if   	0, $pop5        # 0: up to label7
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push1=, -511
	i64.mul 	$push2=, $2, $pop1
	i64.add 	$push3=, $1, $pop2
	i64.const	$push68=, -511
	i64.add 	$1=, $pop3, $pop68
.LBB3_4:                                # %while.end
	end_block                       # label6:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end3:
	.size	t4, .Lfunc_end3-t4

	.section	.text.t5,"ax",@progbits
	.hidden	t5
	.globl	t5
	.type	t5,@function
t5:                                     # @t5
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push67=, $0
	br_if   	0, $pop67       # 0: down to label8
# BB#1:                                 # %while.body.preheader
	i32.const	$push3=, -1
	i32.add 	$push0=, $0, $pop3
	i64.extend_u/i32	$2=, $pop0
.LBB4_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label9:
	i32.const	$push66=, 0
	i32.load	$3=, gvol+4($pop66)
	i32.const	$push65=, 0
	i32.load	$4=, gvol+8($pop65)
	i32.const	$push64=, 0
	i32.load	$5=, gvol+12($pop64)
	i32.const	$push63=, 0
	i32.load	$6=, gvol+16($pop63)
	i32.const	$push62=, 0
	i32.load	$7=, gvol+20($pop62)
	i32.const	$push61=, 0
	i32.load	$8=, gvol+24($pop61)
	i32.const	$push60=, 0
	i32.load	$9=, gvol+28($pop60)
	i32.const	$push59=, 0
	i32.load	$10=, gvol+32($pop59)
	i32.const	$push58=, 0
	i32.load	$11=, gvol+36($pop58)
	i32.const	$push57=, 0
	i32.load	$12=, gvol+40($pop57)
	i32.const	$push56=, 0
	i32.load	$13=, gvol+44($pop56)
	i32.const	$push55=, 0
	i32.load	$14=, gvol+48($pop55)
	i32.const	$push54=, 0
	i32.load	$15=, gvol+52($pop54)
	i32.const	$push53=, 0
	i32.load	$16=, gvol+56($pop53)
	i32.const	$push52=, 0
	i32.load	$17=, gvol+60($pop52)
	i32.const	$push51=, 0
	i32.load	$18=, gvol+64($pop51)
	i32.const	$push50=, 0
	i32.load	$19=, gvol+68($pop50)
	i32.const	$push49=, 0
	i32.load	$20=, gvol+72($pop49)
	i32.const	$push48=, 0
	i32.load	$21=, gvol+76($pop48)
	i32.const	$push47=, 0
	i32.load	$22=, gvol+80($pop47)
	i32.const	$push46=, 0
	i32.load	$23=, gvol+84($pop46)
	i32.const	$push45=, 0
	i32.load	$24=, gvol+88($pop45)
	i32.const	$push44=, 0
	i32.load	$25=, gvol+92($pop44)
	i32.const	$push43=, 0
	i32.load	$26=, gvol+96($pop43)
	i32.const	$push42=, 0
	i32.load	$27=, gvol+100($pop42)
	i32.const	$push41=, 0
	i32.load	$28=, gvol+104($pop41)
	i32.const	$push40=, 0
	i32.load	$29=, gvol+108($pop40)
	i32.const	$push39=, 0
	i32.load	$30=, gvol+112($pop39)
	i32.const	$push38=, 0
	i32.load	$31=, gvol+116($pop38)
	i32.const	$push37=, 0
	i32.load	$32=, gvol+120($pop37)
	i32.const	$push36=, 0
	i32.store	gvol+4($pop36), $3
	i32.const	$push35=, 0
	i32.store	gvol+8($pop35), $4
	i32.const	$push34=, 0
	i32.store	gvol+12($pop34), $5
	i32.const	$push33=, 0
	i32.store	gvol+16($pop33), $6
	i32.const	$push32=, 0
	i32.store	gvol+20($pop32), $7
	i32.const	$push31=, 0
	i32.store	gvol+24($pop31), $8
	i32.const	$push30=, 0
	i32.store	gvol+28($pop30), $9
	i32.const	$push29=, 0
	i32.store	gvol+32($pop29), $10
	i32.const	$push28=, 0
	i32.store	gvol+36($pop28), $11
	i32.const	$push27=, 0
	i32.store	gvol+40($pop27), $12
	i32.const	$push26=, 0
	i32.store	gvol+44($pop26), $13
	i32.const	$push25=, 0
	i32.store	gvol+48($pop25), $14
	i32.const	$push24=, 0
	i32.store	gvol+52($pop24), $15
	i32.const	$push23=, 0
	i32.store	gvol+56($pop23), $16
	i32.const	$push22=, 0
	i32.store	gvol+60($pop22), $17
	i32.const	$push21=, 0
	i32.store	gvol+64($pop21), $18
	i32.const	$push20=, 0
	i32.store	gvol+68($pop20), $19
	i32.const	$push19=, 0
	i32.store	gvol+72($pop19), $20
	i32.const	$push18=, 0
	i32.store	gvol+76($pop18), $21
	i32.const	$push17=, 0
	i32.store	gvol+80($pop17), $22
	i32.const	$push16=, 0
	i32.store	gvol+84($pop16), $23
	i32.const	$push15=, 0
	i32.store	gvol+88($pop15), $24
	i32.const	$push14=, 0
	i32.store	gvol+92($pop14), $25
	i32.const	$push13=, 0
	i32.store	gvol+96($pop13), $26
	i32.const	$push12=, 0
	i32.store	gvol+100($pop12), $27
	i32.const	$push11=, 0
	i32.store	gvol+104($pop11), $28
	i32.const	$push10=, 0
	i32.store	gvol+108($pop10), $29
	i32.const	$push9=, 0
	i32.store	gvol+112($pop9), $30
	i32.const	$push8=, 0
	i32.store	gvol+116($pop8), $31
	i32.const	$push7=, 0
	i32.store	gvol+120($pop7), $32
	i32.const	$push6=, -1
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label9
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push1=, -1
	i64.add 	$push2=, $1, $pop1
	i64.sub 	$1=, $pop2, $2
.LBB4_4:                                # %while.end
	end_block                       # label8:
	copy_local	$push68=, $1
                                        # fallthrough-return: $pop68
	.endfunc
.Lfunc_end4:
	.size	t5, .Lfunc_end4-t5

	.section	.text.t6,"ax",@progbits
	.hidden	t6
	.globl	t6
	.type	t6,@function
t6:                                     # @t6
	.param  	i32, i64
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push67=, $0
	br_if   	0, $pop67       # 0: down to label10
# BB#1:                                 # %while.body.preheader
	i32.const	$push3=, -1
	i32.add 	$push0=, $0, $pop3
	i64.extend_u/i32	$push1=, $pop0
	i64.add 	$1=, $pop1, $1
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label11:
	i32.const	$push66=, 0
	i32.load	$2=, gvol+4($pop66)
	i32.const	$push65=, 0
	i32.load	$3=, gvol+8($pop65)
	i32.const	$push64=, 0
	i32.load	$4=, gvol+12($pop64)
	i32.const	$push63=, 0
	i32.load	$5=, gvol+16($pop63)
	i32.const	$push62=, 0
	i32.load	$6=, gvol+20($pop62)
	i32.const	$push61=, 0
	i32.load	$7=, gvol+24($pop61)
	i32.const	$push60=, 0
	i32.load	$8=, gvol+28($pop60)
	i32.const	$push59=, 0
	i32.load	$9=, gvol+32($pop59)
	i32.const	$push58=, 0
	i32.load	$10=, gvol+36($pop58)
	i32.const	$push57=, 0
	i32.load	$11=, gvol+40($pop57)
	i32.const	$push56=, 0
	i32.load	$12=, gvol+44($pop56)
	i32.const	$push55=, 0
	i32.load	$13=, gvol+48($pop55)
	i32.const	$push54=, 0
	i32.load	$14=, gvol+52($pop54)
	i32.const	$push53=, 0
	i32.load	$15=, gvol+56($pop53)
	i32.const	$push52=, 0
	i32.load	$16=, gvol+60($pop52)
	i32.const	$push51=, 0
	i32.load	$17=, gvol+64($pop51)
	i32.const	$push50=, 0
	i32.load	$18=, gvol+68($pop50)
	i32.const	$push49=, 0
	i32.load	$19=, gvol+72($pop49)
	i32.const	$push48=, 0
	i32.load	$20=, gvol+76($pop48)
	i32.const	$push47=, 0
	i32.load	$21=, gvol+80($pop47)
	i32.const	$push46=, 0
	i32.load	$22=, gvol+84($pop46)
	i32.const	$push45=, 0
	i32.load	$23=, gvol+88($pop45)
	i32.const	$push44=, 0
	i32.load	$24=, gvol+92($pop44)
	i32.const	$push43=, 0
	i32.load	$25=, gvol+96($pop43)
	i32.const	$push42=, 0
	i32.load	$26=, gvol+100($pop42)
	i32.const	$push41=, 0
	i32.load	$27=, gvol+104($pop41)
	i32.const	$push40=, 0
	i32.load	$28=, gvol+108($pop40)
	i32.const	$push39=, 0
	i32.load	$29=, gvol+112($pop39)
	i32.const	$push38=, 0
	i32.load	$30=, gvol+116($pop38)
	i32.const	$push37=, 0
	i32.load	$31=, gvol+120($pop37)
	i32.const	$push36=, 0
	i32.store	gvol+4($pop36), $2
	i32.const	$push35=, 0
	i32.store	gvol+8($pop35), $3
	i32.const	$push34=, 0
	i32.store	gvol+12($pop34), $4
	i32.const	$push33=, 0
	i32.store	gvol+16($pop33), $5
	i32.const	$push32=, 0
	i32.store	gvol+20($pop32), $6
	i32.const	$push31=, 0
	i32.store	gvol+24($pop31), $7
	i32.const	$push30=, 0
	i32.store	gvol+28($pop30), $8
	i32.const	$push29=, 0
	i32.store	gvol+32($pop29), $9
	i32.const	$push28=, 0
	i32.store	gvol+36($pop28), $10
	i32.const	$push27=, 0
	i32.store	gvol+40($pop27), $11
	i32.const	$push26=, 0
	i32.store	gvol+44($pop26), $12
	i32.const	$push25=, 0
	i32.store	gvol+48($pop25), $13
	i32.const	$push24=, 0
	i32.store	gvol+52($pop24), $14
	i32.const	$push23=, 0
	i32.store	gvol+56($pop23), $15
	i32.const	$push22=, 0
	i32.store	gvol+60($pop22), $16
	i32.const	$push21=, 0
	i32.store	gvol+64($pop21), $17
	i32.const	$push20=, 0
	i32.store	gvol+68($pop20), $18
	i32.const	$push19=, 0
	i32.store	gvol+72($pop19), $19
	i32.const	$push18=, 0
	i32.store	gvol+76($pop18), $20
	i32.const	$push17=, 0
	i32.store	gvol+80($pop17), $21
	i32.const	$push16=, 0
	i32.store	gvol+84($pop16), $22
	i32.const	$push15=, 0
	i32.store	gvol+88($pop15), $23
	i32.const	$push14=, 0
	i32.store	gvol+92($pop14), $24
	i32.const	$push13=, 0
	i32.store	gvol+96($pop13), $25
	i32.const	$push12=, 0
	i32.store	gvol+100($pop12), $26
	i32.const	$push11=, 0
	i32.store	gvol+104($pop11), $27
	i32.const	$push10=, 0
	i32.store	gvol+108($pop10), $28
	i32.const	$push9=, 0
	i32.store	gvol+112($pop9), $29
	i32.const	$push8=, 0
	i32.store	gvol+116($pop8), $30
	i32.const	$push7=, 0
	i32.store	gvol+120($pop7), $31
	i32.const	$push6=, -1
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label11
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push2=, 1
	i64.add 	$1=, $1, $pop2
.LBB5_4:                                # %while.end
	end_block                       # label10:
	copy_local	$push68=, $1
                                        # fallthrough-return: $pop68
	.endfunc
.Lfunc_end5:
	.size	t6, .Lfunc_end5-t6

	.section	.text.t7,"ax",@progbits
	.hidden	t7
	.globl	t7
	.type	t7,@function
t7:                                     # @t7
	.param  	i32, i64
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label12
# BB#1:                                 # %while.body.preheader
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 511
	i64.mul 	$push3=, $pop1, $pop2
	i64.add 	$1=, $pop3, $1
.LBB6_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push68=, 0
	i32.load	$2=, gvol+4($pop68)
	i32.const	$push67=, 0
	i32.load	$3=, gvol+8($pop67)
	i32.const	$push66=, 0
	i32.load	$4=, gvol+12($pop66)
	i32.const	$push65=, 0
	i32.load	$5=, gvol+16($pop65)
	i32.const	$push64=, 0
	i32.load	$6=, gvol+20($pop64)
	i32.const	$push63=, 0
	i32.load	$7=, gvol+24($pop63)
	i32.const	$push62=, 0
	i32.load	$8=, gvol+28($pop62)
	i32.const	$push61=, 0
	i32.load	$9=, gvol+32($pop61)
	i32.const	$push60=, 0
	i32.load	$10=, gvol+36($pop60)
	i32.const	$push59=, 0
	i32.load	$11=, gvol+40($pop59)
	i32.const	$push58=, 0
	i32.load	$12=, gvol+44($pop58)
	i32.const	$push57=, 0
	i32.load	$13=, gvol+48($pop57)
	i32.const	$push56=, 0
	i32.load	$14=, gvol+52($pop56)
	i32.const	$push55=, 0
	i32.load	$15=, gvol+56($pop55)
	i32.const	$push54=, 0
	i32.load	$16=, gvol+60($pop54)
	i32.const	$push53=, 0
	i32.load	$17=, gvol+64($pop53)
	i32.const	$push52=, 0
	i32.load	$18=, gvol+68($pop52)
	i32.const	$push51=, 0
	i32.load	$19=, gvol+72($pop51)
	i32.const	$push50=, 0
	i32.load	$20=, gvol+76($pop50)
	i32.const	$push49=, 0
	i32.load	$21=, gvol+80($pop49)
	i32.const	$push48=, 0
	i32.load	$22=, gvol+84($pop48)
	i32.const	$push47=, 0
	i32.load	$23=, gvol+88($pop47)
	i32.const	$push46=, 0
	i32.load	$24=, gvol+92($pop46)
	i32.const	$push45=, 0
	i32.load	$25=, gvol+96($pop45)
	i32.const	$push44=, 0
	i32.load	$26=, gvol+100($pop44)
	i32.const	$push43=, 0
	i32.load	$27=, gvol+104($pop43)
	i32.const	$push42=, 0
	i32.load	$28=, gvol+108($pop42)
	i32.const	$push41=, 0
	i32.load	$29=, gvol+112($pop41)
	i32.const	$push40=, 0
	i32.load	$30=, gvol+116($pop40)
	i32.const	$push39=, 0
	i32.load	$31=, gvol+120($pop39)
	i32.const	$push38=, 0
	i32.store	gvol+4($pop38), $2
	i32.const	$push37=, 0
	i32.store	gvol+8($pop37), $3
	i32.const	$push36=, 0
	i32.store	gvol+12($pop36), $4
	i32.const	$push35=, 0
	i32.store	gvol+16($pop35), $5
	i32.const	$push34=, 0
	i32.store	gvol+20($pop34), $6
	i32.const	$push33=, 0
	i32.store	gvol+24($pop33), $7
	i32.const	$push32=, 0
	i32.store	gvol+28($pop32), $8
	i32.const	$push31=, 0
	i32.store	gvol+32($pop31), $9
	i32.const	$push30=, 0
	i32.store	gvol+36($pop30), $10
	i32.const	$push29=, 0
	i32.store	gvol+40($pop29), $11
	i32.const	$push28=, 0
	i32.store	gvol+44($pop28), $12
	i32.const	$push27=, 0
	i32.store	gvol+48($pop27), $13
	i32.const	$push26=, 0
	i32.store	gvol+52($pop26), $14
	i32.const	$push25=, 0
	i32.store	gvol+56($pop25), $15
	i32.const	$push24=, 0
	i32.store	gvol+60($pop24), $16
	i32.const	$push23=, 0
	i32.store	gvol+64($pop23), $17
	i32.const	$push22=, 0
	i32.store	gvol+68($pop22), $18
	i32.const	$push21=, 0
	i32.store	gvol+72($pop21), $19
	i32.const	$push20=, 0
	i32.store	gvol+76($pop20), $20
	i32.const	$push19=, 0
	i32.store	gvol+80($pop19), $21
	i32.const	$push18=, 0
	i32.store	gvol+84($pop18), $22
	i32.const	$push17=, 0
	i32.store	gvol+88($pop17), $23
	i32.const	$push16=, 0
	i32.store	gvol+92($pop16), $24
	i32.const	$push15=, 0
	i32.store	gvol+96($pop15), $25
	i32.const	$push14=, 0
	i32.store	gvol+100($pop14), $26
	i32.const	$push13=, 0
	i32.store	gvol+104($pop13), $27
	i32.const	$push12=, 0
	i32.store	gvol+108($pop12), $28
	i32.const	$push11=, 0
	i32.store	gvol+112($pop11), $29
	i32.const	$push10=, 0
	i32.store	gvol+116($pop10), $30
	i32.const	$push9=, 0
	i32.store	gvol+120($pop9), $31
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label13
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push4=, 511
	i64.add 	$1=, $1, $pop4
.LBB6_4:                                # %while.end
	end_block                       # label12:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end6:
	.size	t7, .Lfunc_end6-t7

	.section	.text.t8,"ax",@progbits
	.hidden	t8
	.globl	t8
	.type	t8,@function
t8:                                     # @t8
	.param  	i32, i64
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label14
# BB#1:                                 # %while.body.preheader
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 9
	i64.shl 	$push3=, $pop1, $pop2
	i64.add 	$1=, $pop3, $1
.LBB7_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push68=, 0
	i32.load	$2=, gvol+4($pop68)
	i32.const	$push67=, 0
	i32.load	$3=, gvol+8($pop67)
	i32.const	$push66=, 0
	i32.load	$4=, gvol+12($pop66)
	i32.const	$push65=, 0
	i32.load	$5=, gvol+16($pop65)
	i32.const	$push64=, 0
	i32.load	$6=, gvol+20($pop64)
	i32.const	$push63=, 0
	i32.load	$7=, gvol+24($pop63)
	i32.const	$push62=, 0
	i32.load	$8=, gvol+28($pop62)
	i32.const	$push61=, 0
	i32.load	$9=, gvol+32($pop61)
	i32.const	$push60=, 0
	i32.load	$10=, gvol+36($pop60)
	i32.const	$push59=, 0
	i32.load	$11=, gvol+40($pop59)
	i32.const	$push58=, 0
	i32.load	$12=, gvol+44($pop58)
	i32.const	$push57=, 0
	i32.load	$13=, gvol+48($pop57)
	i32.const	$push56=, 0
	i32.load	$14=, gvol+52($pop56)
	i32.const	$push55=, 0
	i32.load	$15=, gvol+56($pop55)
	i32.const	$push54=, 0
	i32.load	$16=, gvol+60($pop54)
	i32.const	$push53=, 0
	i32.load	$17=, gvol+64($pop53)
	i32.const	$push52=, 0
	i32.load	$18=, gvol+68($pop52)
	i32.const	$push51=, 0
	i32.load	$19=, gvol+72($pop51)
	i32.const	$push50=, 0
	i32.load	$20=, gvol+76($pop50)
	i32.const	$push49=, 0
	i32.load	$21=, gvol+80($pop49)
	i32.const	$push48=, 0
	i32.load	$22=, gvol+84($pop48)
	i32.const	$push47=, 0
	i32.load	$23=, gvol+88($pop47)
	i32.const	$push46=, 0
	i32.load	$24=, gvol+92($pop46)
	i32.const	$push45=, 0
	i32.load	$25=, gvol+96($pop45)
	i32.const	$push44=, 0
	i32.load	$26=, gvol+100($pop44)
	i32.const	$push43=, 0
	i32.load	$27=, gvol+104($pop43)
	i32.const	$push42=, 0
	i32.load	$28=, gvol+108($pop42)
	i32.const	$push41=, 0
	i32.load	$29=, gvol+112($pop41)
	i32.const	$push40=, 0
	i32.load	$30=, gvol+116($pop40)
	i32.const	$push39=, 0
	i32.load	$31=, gvol+120($pop39)
	i32.const	$push38=, 0
	i32.store	gvol+4($pop38), $2
	i32.const	$push37=, 0
	i32.store	gvol+8($pop37), $3
	i32.const	$push36=, 0
	i32.store	gvol+12($pop36), $4
	i32.const	$push35=, 0
	i32.store	gvol+16($pop35), $5
	i32.const	$push34=, 0
	i32.store	gvol+20($pop34), $6
	i32.const	$push33=, 0
	i32.store	gvol+24($pop33), $7
	i32.const	$push32=, 0
	i32.store	gvol+28($pop32), $8
	i32.const	$push31=, 0
	i32.store	gvol+32($pop31), $9
	i32.const	$push30=, 0
	i32.store	gvol+36($pop30), $10
	i32.const	$push29=, 0
	i32.store	gvol+40($pop29), $11
	i32.const	$push28=, 0
	i32.store	gvol+44($pop28), $12
	i32.const	$push27=, 0
	i32.store	gvol+48($pop27), $13
	i32.const	$push26=, 0
	i32.store	gvol+52($pop26), $14
	i32.const	$push25=, 0
	i32.store	gvol+56($pop25), $15
	i32.const	$push24=, 0
	i32.store	gvol+60($pop24), $16
	i32.const	$push23=, 0
	i32.store	gvol+64($pop23), $17
	i32.const	$push22=, 0
	i32.store	gvol+68($pop22), $18
	i32.const	$push21=, 0
	i32.store	gvol+72($pop21), $19
	i32.const	$push20=, 0
	i32.store	gvol+76($pop20), $20
	i32.const	$push19=, 0
	i32.store	gvol+80($pop19), $21
	i32.const	$push18=, 0
	i32.store	gvol+84($pop18), $22
	i32.const	$push17=, 0
	i32.store	gvol+88($pop17), $23
	i32.const	$push16=, 0
	i32.store	gvol+92($pop16), $24
	i32.const	$push15=, 0
	i32.store	gvol+96($pop15), $25
	i32.const	$push14=, 0
	i32.store	gvol+100($pop14), $26
	i32.const	$push13=, 0
	i32.store	gvol+104($pop13), $27
	i32.const	$push12=, 0
	i32.store	gvol+108($pop12), $28
	i32.const	$push11=, 0
	i32.store	gvol+112($pop11), $29
	i32.const	$push10=, 0
	i32.store	gvol+116($pop10), $30
	i32.const	$push9=, 0
	i32.store	gvol+120($pop9), $31
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label15
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push4=, 512
	i64.add 	$1=, $1, $pop4
.LBB7_4:                                # %while.end
	end_block                       # label14:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end7:
	.size	t8, .Lfunc_end7-t8

	.section	.text.t9,"ax",@progbits
	.hidden	t9
	.globl	t9
	.type	t9,@function
t9:                                     # @t9
	.param  	i32, i64
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push69=, $0
	br_if   	0, $pop69       # 0: down to label16
# BB#1:                                 # %while.body.preheader
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 513
	i64.mul 	$push3=, $pop1, $pop2
	i64.add 	$1=, $pop3, $1
.LBB8_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push68=, 0
	i32.load	$2=, gvol+4($pop68)
	i32.const	$push67=, 0
	i32.load	$3=, gvol+8($pop67)
	i32.const	$push66=, 0
	i32.load	$4=, gvol+12($pop66)
	i32.const	$push65=, 0
	i32.load	$5=, gvol+16($pop65)
	i32.const	$push64=, 0
	i32.load	$6=, gvol+20($pop64)
	i32.const	$push63=, 0
	i32.load	$7=, gvol+24($pop63)
	i32.const	$push62=, 0
	i32.load	$8=, gvol+28($pop62)
	i32.const	$push61=, 0
	i32.load	$9=, gvol+32($pop61)
	i32.const	$push60=, 0
	i32.load	$10=, gvol+36($pop60)
	i32.const	$push59=, 0
	i32.load	$11=, gvol+40($pop59)
	i32.const	$push58=, 0
	i32.load	$12=, gvol+44($pop58)
	i32.const	$push57=, 0
	i32.load	$13=, gvol+48($pop57)
	i32.const	$push56=, 0
	i32.load	$14=, gvol+52($pop56)
	i32.const	$push55=, 0
	i32.load	$15=, gvol+56($pop55)
	i32.const	$push54=, 0
	i32.load	$16=, gvol+60($pop54)
	i32.const	$push53=, 0
	i32.load	$17=, gvol+64($pop53)
	i32.const	$push52=, 0
	i32.load	$18=, gvol+68($pop52)
	i32.const	$push51=, 0
	i32.load	$19=, gvol+72($pop51)
	i32.const	$push50=, 0
	i32.load	$20=, gvol+76($pop50)
	i32.const	$push49=, 0
	i32.load	$21=, gvol+80($pop49)
	i32.const	$push48=, 0
	i32.load	$22=, gvol+84($pop48)
	i32.const	$push47=, 0
	i32.load	$23=, gvol+88($pop47)
	i32.const	$push46=, 0
	i32.load	$24=, gvol+92($pop46)
	i32.const	$push45=, 0
	i32.load	$25=, gvol+96($pop45)
	i32.const	$push44=, 0
	i32.load	$26=, gvol+100($pop44)
	i32.const	$push43=, 0
	i32.load	$27=, gvol+104($pop43)
	i32.const	$push42=, 0
	i32.load	$28=, gvol+108($pop42)
	i32.const	$push41=, 0
	i32.load	$29=, gvol+112($pop41)
	i32.const	$push40=, 0
	i32.load	$30=, gvol+116($pop40)
	i32.const	$push39=, 0
	i32.load	$31=, gvol+120($pop39)
	i32.const	$push38=, 0
	i32.store	gvol+4($pop38), $2
	i32.const	$push37=, 0
	i32.store	gvol+8($pop37), $3
	i32.const	$push36=, 0
	i32.store	gvol+12($pop36), $4
	i32.const	$push35=, 0
	i32.store	gvol+16($pop35), $5
	i32.const	$push34=, 0
	i32.store	gvol+20($pop34), $6
	i32.const	$push33=, 0
	i32.store	gvol+24($pop33), $7
	i32.const	$push32=, 0
	i32.store	gvol+28($pop32), $8
	i32.const	$push31=, 0
	i32.store	gvol+32($pop31), $9
	i32.const	$push30=, 0
	i32.store	gvol+36($pop30), $10
	i32.const	$push29=, 0
	i32.store	gvol+40($pop29), $11
	i32.const	$push28=, 0
	i32.store	gvol+44($pop28), $12
	i32.const	$push27=, 0
	i32.store	gvol+48($pop27), $13
	i32.const	$push26=, 0
	i32.store	gvol+52($pop26), $14
	i32.const	$push25=, 0
	i32.store	gvol+56($pop25), $15
	i32.const	$push24=, 0
	i32.store	gvol+60($pop24), $16
	i32.const	$push23=, 0
	i32.store	gvol+64($pop23), $17
	i32.const	$push22=, 0
	i32.store	gvol+68($pop22), $18
	i32.const	$push21=, 0
	i32.store	gvol+72($pop21), $19
	i32.const	$push20=, 0
	i32.store	gvol+76($pop20), $20
	i32.const	$push19=, 0
	i32.store	gvol+80($pop19), $21
	i32.const	$push18=, 0
	i32.store	gvol+84($pop18), $22
	i32.const	$push17=, 0
	i32.store	gvol+88($pop17), $23
	i32.const	$push16=, 0
	i32.store	gvol+92($pop16), $24
	i32.const	$push15=, 0
	i32.store	gvol+96($pop15), $25
	i32.const	$push14=, 0
	i32.store	gvol+100($pop14), $26
	i32.const	$push13=, 0
	i32.store	gvol+104($pop13), $27
	i32.const	$push12=, 0
	i32.store	gvol+108($pop12), $28
	i32.const	$push11=, 0
	i32.store	gvol+112($pop11), $29
	i32.const	$push10=, 0
	i32.store	gvol+116($pop10), $30
	i32.const	$push9=, 0
	i32.store	gvol+120($pop9), $31
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label17
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.const	$push4=, 513
	i64.add 	$1=, $1, $pop4
.LBB8_4:                                # %while.end
	end_block                       # label16:
	copy_local	$push70=, $1
                                        # fallthrough-return: $pop70
	.endfunc
.Lfunc_end8:
	.size	t9, .Lfunc_end8-t9

	.section	.text.t10,"ax",@progbits
	.hidden	t10
	.globl	t10
	.type	t10,@function
t10:                                    # @t10
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push70=, $0
	br_if   	0, $pop70       # 0: down to label18
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push6=, 0
	i64.load	$push4=, gull($pop6)
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 1
	i64.add 	$push3=, $pop1, $pop2
	i64.mul 	$2=, $pop4, $pop3
.LBB9_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push69=, 0
	i32.load	$3=, gvol+4($pop69)
	i32.const	$push68=, 0
	i32.load	$4=, gvol+8($pop68)
	i32.const	$push67=, 0
	i32.load	$5=, gvol+12($pop67)
	i32.const	$push66=, 0
	i32.load	$6=, gvol+16($pop66)
	i32.const	$push65=, 0
	i32.load	$7=, gvol+20($pop65)
	i32.const	$push64=, 0
	i32.load	$8=, gvol+24($pop64)
	i32.const	$push63=, 0
	i32.load	$9=, gvol+28($pop63)
	i32.const	$push62=, 0
	i32.load	$10=, gvol+32($pop62)
	i32.const	$push61=, 0
	i32.load	$11=, gvol+36($pop61)
	i32.const	$push60=, 0
	i32.load	$12=, gvol+40($pop60)
	i32.const	$push59=, 0
	i32.load	$13=, gvol+44($pop59)
	i32.const	$push58=, 0
	i32.load	$14=, gvol+48($pop58)
	i32.const	$push57=, 0
	i32.load	$15=, gvol+52($pop57)
	i32.const	$push56=, 0
	i32.load	$16=, gvol+56($pop56)
	i32.const	$push55=, 0
	i32.load	$17=, gvol+60($pop55)
	i32.const	$push54=, 0
	i32.load	$18=, gvol+64($pop54)
	i32.const	$push53=, 0
	i32.load	$19=, gvol+68($pop53)
	i32.const	$push52=, 0
	i32.load	$20=, gvol+72($pop52)
	i32.const	$push51=, 0
	i32.load	$21=, gvol+76($pop51)
	i32.const	$push50=, 0
	i32.load	$22=, gvol+80($pop50)
	i32.const	$push49=, 0
	i32.load	$23=, gvol+84($pop49)
	i32.const	$push48=, 0
	i32.load	$24=, gvol+88($pop48)
	i32.const	$push47=, 0
	i32.load	$25=, gvol+92($pop47)
	i32.const	$push46=, 0
	i32.load	$26=, gvol+96($pop46)
	i32.const	$push45=, 0
	i32.load	$27=, gvol+100($pop45)
	i32.const	$push44=, 0
	i32.load	$28=, gvol+104($pop44)
	i32.const	$push43=, 0
	i32.load	$29=, gvol+108($pop43)
	i32.const	$push42=, 0
	i32.load	$30=, gvol+112($pop42)
	i32.const	$push41=, 0
	i32.load	$31=, gvol+116($pop41)
	i32.const	$push40=, 0
	i32.load	$32=, gvol+120($pop40)
	i32.const	$push39=, 0
	i32.store	gvol+4($pop39), $3
	i32.const	$push38=, 0
	i32.store	gvol+8($pop38), $4
	i32.const	$push37=, 0
	i32.store	gvol+12($pop37), $5
	i32.const	$push36=, 0
	i32.store	gvol+16($pop36), $6
	i32.const	$push35=, 0
	i32.store	gvol+20($pop35), $7
	i32.const	$push34=, 0
	i32.store	gvol+24($pop34), $8
	i32.const	$push33=, 0
	i32.store	gvol+28($pop33), $9
	i32.const	$push32=, 0
	i32.store	gvol+32($pop32), $10
	i32.const	$push31=, 0
	i32.store	gvol+36($pop31), $11
	i32.const	$push30=, 0
	i32.store	gvol+40($pop30), $12
	i32.const	$push29=, 0
	i32.store	gvol+44($pop29), $13
	i32.const	$push28=, 0
	i32.store	gvol+48($pop28), $14
	i32.const	$push27=, 0
	i32.store	gvol+52($pop27), $15
	i32.const	$push26=, 0
	i32.store	gvol+56($pop26), $16
	i32.const	$push25=, 0
	i32.store	gvol+60($pop25), $17
	i32.const	$push24=, 0
	i32.store	gvol+64($pop24), $18
	i32.const	$push23=, 0
	i32.store	gvol+68($pop23), $19
	i32.const	$push22=, 0
	i32.store	gvol+72($pop22), $20
	i32.const	$push21=, 0
	i32.store	gvol+76($pop21), $21
	i32.const	$push20=, 0
	i32.store	gvol+80($pop20), $22
	i32.const	$push19=, 0
	i32.store	gvol+84($pop19), $23
	i32.const	$push18=, 0
	i32.store	gvol+88($pop18), $24
	i32.const	$push17=, 0
	i32.store	gvol+92($pop17), $25
	i32.const	$push16=, 0
	i32.store	gvol+96($pop16), $26
	i32.const	$push15=, 0
	i32.store	gvol+100($pop15), $27
	i32.const	$push14=, 0
	i32.store	gvol+104($pop14), $28
	i32.const	$push13=, 0
	i32.store	gvol+108($pop13), $29
	i32.const	$push12=, 0
	i32.store	gvol+112($pop12), $30
	i32.const	$push11=, 0
	i32.store	gvol+116($pop11), $31
	i32.const	$push10=, 0
	i32.store	gvol+120($pop10), $32
	i32.const	$push9=, -1
	i32.add 	$push8=, $0, $pop9
	tee_local	$push7=, $0=, $pop8
	br_if   	0, $pop7        # 0: up to label19
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.add 	$1=, $2, $1
.LBB9_4:                                # %while.end
	end_block                       # label18:
	copy_local	$push71=, $1
                                        # fallthrough-return: $pop71
	.endfunc
.Lfunc_end9:
	.size	t10, .Lfunc_end9-t10

	.section	.text.t11,"ax",@progbits
	.hidden	t11
	.globl	t11
	.type	t11,@function
t11:                                    # @t11
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push70=, $0
	br_if   	0, $pop70       # 0: down to label20
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push6=, 0
	i64.load	$push4=, gull($pop6)
	i32.const	$push5=, -1
	i32.add 	$push0=, $0, $pop5
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, -1
	i64.xor 	$push3=, $pop1, $pop2
	i64.mul 	$2=, $pop4, $pop3
.LBB10_2:                               # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label21:
	i32.const	$push69=, 0
	i32.load	$3=, gvol+4($pop69)
	i32.const	$push68=, 0
	i32.load	$4=, gvol+8($pop68)
	i32.const	$push67=, 0
	i32.load	$5=, gvol+12($pop67)
	i32.const	$push66=, 0
	i32.load	$6=, gvol+16($pop66)
	i32.const	$push65=, 0
	i32.load	$7=, gvol+20($pop65)
	i32.const	$push64=, 0
	i32.load	$8=, gvol+24($pop64)
	i32.const	$push63=, 0
	i32.load	$9=, gvol+28($pop63)
	i32.const	$push62=, 0
	i32.load	$10=, gvol+32($pop62)
	i32.const	$push61=, 0
	i32.load	$11=, gvol+36($pop61)
	i32.const	$push60=, 0
	i32.load	$12=, gvol+40($pop60)
	i32.const	$push59=, 0
	i32.load	$13=, gvol+44($pop59)
	i32.const	$push58=, 0
	i32.load	$14=, gvol+48($pop58)
	i32.const	$push57=, 0
	i32.load	$15=, gvol+52($pop57)
	i32.const	$push56=, 0
	i32.load	$16=, gvol+56($pop56)
	i32.const	$push55=, 0
	i32.load	$17=, gvol+60($pop55)
	i32.const	$push54=, 0
	i32.load	$18=, gvol+64($pop54)
	i32.const	$push53=, 0
	i32.load	$19=, gvol+68($pop53)
	i32.const	$push52=, 0
	i32.load	$20=, gvol+72($pop52)
	i32.const	$push51=, 0
	i32.load	$21=, gvol+76($pop51)
	i32.const	$push50=, 0
	i32.load	$22=, gvol+80($pop50)
	i32.const	$push49=, 0
	i32.load	$23=, gvol+84($pop49)
	i32.const	$push48=, 0
	i32.load	$24=, gvol+88($pop48)
	i32.const	$push47=, 0
	i32.load	$25=, gvol+92($pop47)
	i32.const	$push46=, 0
	i32.load	$26=, gvol+96($pop46)
	i32.const	$push45=, 0
	i32.load	$27=, gvol+100($pop45)
	i32.const	$push44=, 0
	i32.load	$28=, gvol+104($pop44)
	i32.const	$push43=, 0
	i32.load	$29=, gvol+108($pop43)
	i32.const	$push42=, 0
	i32.load	$30=, gvol+112($pop42)
	i32.const	$push41=, 0
	i32.load	$31=, gvol+116($pop41)
	i32.const	$push40=, 0
	i32.load	$32=, gvol+120($pop40)
	i32.const	$push39=, 0
	i32.store	gvol+4($pop39), $3
	i32.const	$push38=, 0
	i32.store	gvol+8($pop38), $4
	i32.const	$push37=, 0
	i32.store	gvol+12($pop37), $5
	i32.const	$push36=, 0
	i32.store	gvol+16($pop36), $6
	i32.const	$push35=, 0
	i32.store	gvol+20($pop35), $7
	i32.const	$push34=, 0
	i32.store	gvol+24($pop34), $8
	i32.const	$push33=, 0
	i32.store	gvol+28($pop33), $9
	i32.const	$push32=, 0
	i32.store	gvol+32($pop32), $10
	i32.const	$push31=, 0
	i32.store	gvol+36($pop31), $11
	i32.const	$push30=, 0
	i32.store	gvol+40($pop30), $12
	i32.const	$push29=, 0
	i32.store	gvol+44($pop29), $13
	i32.const	$push28=, 0
	i32.store	gvol+48($pop28), $14
	i32.const	$push27=, 0
	i32.store	gvol+52($pop27), $15
	i32.const	$push26=, 0
	i32.store	gvol+56($pop26), $16
	i32.const	$push25=, 0
	i32.store	gvol+60($pop25), $17
	i32.const	$push24=, 0
	i32.store	gvol+64($pop24), $18
	i32.const	$push23=, 0
	i32.store	gvol+68($pop23), $19
	i32.const	$push22=, 0
	i32.store	gvol+72($pop22), $20
	i32.const	$push21=, 0
	i32.store	gvol+76($pop21), $21
	i32.const	$push20=, 0
	i32.store	gvol+80($pop20), $22
	i32.const	$push19=, 0
	i32.store	gvol+84($pop19), $23
	i32.const	$push18=, 0
	i32.store	gvol+88($pop18), $24
	i32.const	$push17=, 0
	i32.store	gvol+92($pop17), $25
	i32.const	$push16=, 0
	i32.store	gvol+96($pop16), $26
	i32.const	$push15=, 0
	i32.store	gvol+100($pop15), $27
	i32.const	$push14=, 0
	i32.store	gvol+104($pop14), $28
	i32.const	$push13=, 0
	i32.store	gvol+108($pop13), $29
	i32.const	$push12=, 0
	i32.store	gvol+112($pop12), $30
	i32.const	$push11=, 0
	i32.store	gvol+116($pop11), $31
	i32.const	$push10=, 0
	i32.store	gvol+120($pop10), $32
	i32.const	$push9=, -1
	i32.add 	$push8=, $0, $pop9
	tee_local	$push7=, $0=, $pop8
	br_if   	0, $pop7        # 0: up to label21
# BB#3:                                 # %while.end.loopexit
	end_loop
	i64.add 	$1=, $2, $1
.LBB10_4:                               # %while.end
	end_block                       # label20:
	copy_local	$push71=, $1
                                        # fallthrough-return: $pop71
	.endfunc
.Lfunc_end10:
	.size	t11, .Lfunc_end10-t11

	.section	.text.neg,"ax",@progbits
	.hidden	neg
	.globl	neg
	.type	neg,@function
neg:                                    # @neg
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.sub 	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end11:
	.size	neg, .Lfunc_end11-neg

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 100
	i64.store	gull($pop1), $pop0
	block   	
	i32.const	$push100=, 3
	i64.const	$push2=, -1
	i64.call	$push3=, t1@FUNCTION, $pop100, $pop2
	i64.const	$push4=, -6145
	i64.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label22
# BB#1:                                 # %if.end
	i32.const	$push101=, 3
	i64.const	$push6=, 4294967295
	i64.call	$push7=, t1@FUNCTION, $pop101, $pop6
	i64.const	$push8=, 4294961151
	i64.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label22
# BB#2:                                 # %if.end4
	i32.const	$push102=, 3
	i64.const	$push10=, -1
	i64.call	$push11=, t2@FUNCTION, $pop102, $pop10
	i64.const	$push12=, -1540
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label22
# BB#3:                                 # %if.end8
	i32.const	$push103=, 3
	i64.const	$push14=, 4294967295
	i64.call	$push15=, t2@FUNCTION, $pop103, $pop14
	i64.const	$push16=, 4294965756
	i64.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label22
# BB#4:                                 # %if.end12
	i32.const	$push104=, 3
	i64.const	$push18=, -1
	i64.call	$push19=, t3@FUNCTION, $pop104, $pop18
	i64.const	$push20=, -1537
	i64.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label22
# BB#5:                                 # %if.end16
	i32.const	$push105=, 3
	i64.const	$push22=, 4294967295
	i64.call	$push23=, t3@FUNCTION, $pop105, $pop22
	i64.const	$push24=, 4294965759
	i64.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label22
# BB#6:                                 # %if.end20
	i32.const	$push106=, 3
	i64.const	$push26=, -1
	i64.call	$push27=, t4@FUNCTION, $pop106, $pop26
	i64.const	$push28=, -1534
	i64.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label22
# BB#7:                                 # %if.end24
	i32.const	$push107=, 3
	i64.const	$push30=, 4294967295
	i64.call	$push31=, t4@FUNCTION, $pop107, $pop30
	i64.const	$push32=, 4294965762
	i64.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label22
# BB#8:                                 # %if.end28
	i32.const	$push108=, 3
	i64.const	$push34=, -1
	i64.call	$push35=, t5@FUNCTION, $pop108, $pop34
	i64.const	$push36=, -4
	i64.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label22
# BB#9:                                 # %if.end32
	i32.const	$push109=, 3
	i64.const	$push38=, 4294967295
	i64.call	$push39=, t5@FUNCTION, $pop109, $pop38
	i64.const	$push40=, 4294967292
	i64.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label22
# BB#10:                                # %if.end36
	i32.const	$push110=, 3
	i64.const	$push42=, -1
	i64.call	$push43=, t6@FUNCTION, $pop110, $pop42
	i64.const	$push44=, 2
	i64.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label22
# BB#11:                                # %if.end40
	i32.const	$push111=, 3
	i64.const	$push46=, 4294967295
	i64.call	$push47=, t6@FUNCTION, $pop111, $pop46
	i64.const	$push48=, 4294967298
	i64.ne  	$push49=, $pop47, $pop48
	br_if   	0, $pop49       # 0: down to label22
# BB#12:                                # %if.end44
	i32.const	$push112=, 3
	i64.const	$push50=, -1
	i64.call	$push51=, t7@FUNCTION, $pop112, $pop50
	i64.const	$push52=, 1532
	i64.ne  	$push53=, $pop51, $pop52
	br_if   	0, $pop53       # 0: down to label22
# BB#13:                                # %if.end48
	i32.const	$push113=, 3
	i64.const	$push54=, 4294967295
	i64.call	$push55=, t7@FUNCTION, $pop113, $pop54
	i64.const	$push56=, 4294968828
	i64.ne  	$push57=, $pop55, $pop56
	br_if   	0, $pop57       # 0: down to label22
# BB#14:                                # %if.end52
	i32.const	$push114=, 3
	i64.const	$push58=, -1
	i64.call	$push59=, t8@FUNCTION, $pop114, $pop58
	i64.const	$push60=, 1535
	i64.ne  	$push61=, $pop59, $pop60
	br_if   	0, $pop61       # 0: down to label22
# BB#15:                                # %if.end56
	i32.const	$push115=, 3
	i64.const	$push62=, 4294967295
	i64.call	$push63=, t8@FUNCTION, $pop115, $pop62
	i64.const	$push64=, 4294968831
	i64.ne  	$push65=, $pop63, $pop64
	br_if   	0, $pop65       # 0: down to label22
# BB#16:                                # %if.end60
	i32.const	$push116=, 3
	i64.const	$push66=, -1
	i64.call	$push67=, t9@FUNCTION, $pop116, $pop66
	i64.const	$push68=, 1538
	i64.ne  	$push69=, $pop67, $pop68
	br_if   	0, $pop69       # 0: down to label22
# BB#17:                                # %if.end64
	i32.const	$push117=, 3
	i64.const	$push70=, 4294967295
	i64.call	$push71=, t9@FUNCTION, $pop117, $pop70
	i64.const	$push72=, 4294968834
	i64.ne  	$push73=, $pop71, $pop72
	br_if   	0, $pop73       # 0: down to label22
# BB#18:                                # %if.end68
	i32.const	$push121=, 3
	i64.const	$push74=, -1
	i64.call	$push75=, t10@FUNCTION, $pop121, $pop74
	i32.const	$push120=, 0
	i64.load	$push76=, gull($pop120)
	i64.const	$push119=, 3
	i64.mul 	$push77=, $pop76, $pop119
	i64.const	$push118=, -1
	i64.add 	$push78=, $pop77, $pop118
	i64.ne  	$push79=, $pop75, $pop78
	br_if   	0, $pop79       # 0: down to label22
# BB#19:                                # %if.end72
	i32.const	$push125=, 3
	i64.const	$push80=, 4294967295
	i64.call	$push81=, t10@FUNCTION, $pop125, $pop80
	i32.const	$push124=, 0
	i64.load	$push82=, gull($pop124)
	i64.const	$push123=, 3
	i64.mul 	$push83=, $pop82, $pop123
	i64.const	$push122=, 4294967295
	i64.add 	$push84=, $pop83, $pop122
	i64.ne  	$push85=, $pop81, $pop84
	br_if   	0, $pop85       # 0: down to label22
# BB#20:                                # %if.end77
	i32.const	$push129=, 3
	i64.const	$push86=, -1
	i64.call	$push87=, t11@FUNCTION, $pop129, $pop86
	i32.const	$push128=, 0
	i64.load	$push88=, gull($pop128)
	i64.const	$push127=, -3
	i64.mul 	$push89=, $pop88, $pop127
	i64.const	$push126=, -1
	i64.add 	$push90=, $pop89, $pop126
	i64.ne  	$push91=, $pop87, $pop90
	br_if   	0, $pop91       # 0: down to label22
# BB#21:                                # %if.end84
	i32.const	$push135=, 3
	i64.const	$push92=, 4294967295
	i64.call	$push93=, t11@FUNCTION, $pop135, $pop92
	i32.const	$push134=, 0
	i64.load	$push133=, gull($pop134)
	tee_local	$push132=, $0=, $pop133
	i64.const	$push131=, -3
	i64.mul 	$push94=, $pop132, $pop131
	i64.const	$push130=, 4294967295
	i64.add 	$push95=, $pop94, $pop130
	i64.ne  	$push96=, $pop93, $pop95
	br_if   	0, $pop96       # 0: down to label22
# BB#22:                                # %if.end91
	i64.const	$push97=, 100
	i64.ne  	$push98=, $0, $pop97
	br_if   	0, $pop98       # 0: down to label22
# BB#23:                                # %if.end95
	i32.const	$push99=, 0
	call    	exit@FUNCTION, $pop99
	unreachable
.LBB12_24:                              # %if.then94
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

	.hidden	gvol                    # @gvol
	.type	gvol,@object
	.section	.bss.gvol,"aw",@nobits
	.globl	gvol
	.p2align	4
gvol:
	.skip	128
	.size	gvol, 128

	.hidden	gull                    # @gull
	.type	gull,@object
	.section	.bss.gull,"aw",@nobits
	.globl	gull
	.p2align	3
gull:
	.int64	0                       # 0x0
	.size	gull, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
