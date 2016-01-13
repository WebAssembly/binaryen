	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041011-1.c"
	.section	.text.t1,"ax",@progbits
	.hidden	t1
	.globl	t1
	.type	t1,@function
t1:                                     # @t1
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, -1
	i32.add 	$push0=, $0, $3
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 11
	i64.shl 	$2=, $pop1, $pop2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $3
	br_if   	$0, 0           # 0: up to label1
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label2:
	i64.const	$push3=, -2048
	i64.add 	$push4=, $1, $pop3
	i64.sub 	$1=, $pop4, $2
.LBB0_4:                                # %while.end
	end_block                       # label0:
	return  	$1
.Lfunc_end0:
	.size	t1, .Lfunc_end0-t1

	.section	.text.t2,"ax",@progbits
	.hidden	t2
	.globl	t2
	.type	t2,@function
t2:                                     # @t2
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label3
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, -1
	i32.add 	$push0=, $0, $3
	i64.extend_u/i32	$2=, $pop0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $3
	br_if   	$0, 0           # 0: up to label4
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label5:
	i64.const	$35=, -513
	i64.mul 	$push1=, $2, $35
	i64.add 	$push2=, $1, $pop1
	i64.add 	$1=, $pop2, $35
.LBB1_4:                                # %while.end
	end_block                       # label3:
	return  	$1
.Lfunc_end1:
	.size	t2, .Lfunc_end1-t2

	.section	.text.t3,"ax",@progbits
	.hidden	t3
	.globl	t3
	.type	t3,@function
t3:                                     # @t3
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label6
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, -1
	i32.add 	$push0=, $0, $3
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 9
	i64.shl 	$2=, $pop1, $pop2
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $3
	br_if   	$0, 0           # 0: up to label7
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label8:
	i64.const	$push3=, -512
	i64.add 	$push4=, $1, $pop3
	i64.sub 	$1=, $pop4, $2
.LBB2_4:                                # %while.end
	end_block                       # label6:
	return  	$1
.Lfunc_end2:
	.size	t3, .Lfunc_end2-t3

	.section	.text.t4,"ax",@progbits
	.hidden	t4
	.globl	t4
	.type	t4,@function
t4:                                     # @t4
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label9
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, -1
	i32.add 	$push0=, $0, $3
	i64.extend_u/i32	$2=, $pop0
.LBB3_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label10:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $3
	br_if   	$0, 0           # 0: up to label10
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label11:
	i64.const	$35=, -511
	i64.mul 	$push1=, $2, $35
	i64.add 	$push2=, $1, $pop1
	i64.add 	$1=, $pop2, $35
.LBB3_4:                                # %while.end
	end_block                       # label9:
	return  	$1
.Lfunc_end3:
	.size	t4, .Lfunc_end3-t4

	.section	.text.t5,"ax",@progbits
	.hidden	t5
	.globl	t5
	.type	t5,@function
t5:                                     # @t5
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label12
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, -1
	i32.add 	$push0=, $0, $3
	i64.extend_u/i32	$2=, $pop0
.LBB4_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label13:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $3
	br_if   	$0, 0           # 0: up to label13
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label14:
	i64.const	$push1=, -1
	i64.add 	$push2=, $1, $pop1
	i64.sub 	$1=, $pop2, $2
.LBB4_4:                                # %while.end
	end_block                       # label12:
	return  	$1
.Lfunc_end4:
	.size	t5, .Lfunc_end4-t5

	.section	.text.t6,"ax",@progbits
	.hidden	t6
	.globl	t6
	.type	t6,@function
t6:                                     # @t6
	.param  	i32, i64
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label15
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, -1
	i32.add 	$push0=, $0, $2
	i64.extend_u/i32	$push1=, $pop0
	i64.add 	$1=, $pop1, $1
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label16:
	i32.const	$3=, 0
	i32.load	$4=, gvol+4($3)
	i32.load	$5=, gvol+8($3)
	i32.load	$6=, gvol+12($3)
	i32.load	$7=, gvol+16($3)
	i32.load	$8=, gvol+20($3)
	i32.load	$9=, gvol+24($3)
	i32.load	$10=, gvol+28($3)
	i32.load	$11=, gvol+32($3)
	i32.load	$12=, gvol+36($3)
	i32.load	$13=, gvol+40($3)
	i32.load	$14=, gvol+44($3)
	i32.load	$15=, gvol+48($3)
	i32.load	$16=, gvol+52($3)
	i32.load	$17=, gvol+56($3)
	i32.load	$18=, gvol+60($3)
	i32.load	$19=, gvol+64($3)
	i32.load	$20=, gvol+68($3)
	i32.load	$21=, gvol+72($3)
	i32.load	$22=, gvol+76($3)
	i32.load	$23=, gvol+80($3)
	i32.load	$24=, gvol+84($3)
	i32.load	$25=, gvol+88($3)
	i32.load	$26=, gvol+92($3)
	i32.load	$27=, gvol+96($3)
	i32.load	$28=, gvol+100($3)
	i32.load	$29=, gvol+104($3)
	i32.load	$30=, gvol+108($3)
	i32.load	$31=, gvol+112($3)
	i32.load	$32=, gvol+116($3)
	i32.load	$33=, gvol+120($3)
	i32.store	$discard=, gvol+4($3), $4
	i32.store	$discard=, gvol+8($3), $5
	i32.store	$discard=, gvol+12($3), $6
	i32.store	$discard=, gvol+16($3), $7
	i32.store	$discard=, gvol+20($3), $8
	i32.store	$discard=, gvol+24($3), $9
	i32.store	$discard=, gvol+28($3), $10
	i32.store	$discard=, gvol+32($3), $11
	i32.store	$discard=, gvol+36($3), $12
	i32.store	$discard=, gvol+40($3), $13
	i32.store	$discard=, gvol+44($3), $14
	i32.store	$discard=, gvol+48($3), $15
	i32.store	$discard=, gvol+52($3), $16
	i32.store	$discard=, gvol+56($3), $17
	i32.store	$discard=, gvol+60($3), $18
	i32.store	$discard=, gvol+64($3), $19
	i32.store	$discard=, gvol+68($3), $20
	i32.store	$discard=, gvol+72($3), $21
	i32.store	$discard=, gvol+76($3), $22
	i32.store	$discard=, gvol+80($3), $23
	i32.store	$discard=, gvol+84($3), $24
	i32.store	$discard=, gvol+88($3), $25
	i32.store	$discard=, gvol+92($3), $26
	i32.store	$discard=, gvol+96($3), $27
	i32.store	$discard=, gvol+100($3), $28
	i32.store	$discard=, gvol+104($3), $29
	i32.store	$discard=, gvol+108($3), $30
	i32.store	$discard=, gvol+112($3), $31
	i32.store	$discard=, gvol+116($3), $32
	i32.store	$discard=, gvol+120($3), $33
	i32.add 	$0=, $0, $2
	br_if   	$0, 0           # 0: up to label16
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label17:
	i64.const	$push2=, 1
	i64.add 	$1=, $1, $pop2
.LBB5_4:                                # %while.end
	end_block                       # label15:
	return  	$1
.Lfunc_end5:
	.size	t6, .Lfunc_end5-t6

	.section	.text.t7,"ax",@progbits
	.hidden	t7
	.globl	t7
	.type	t7,@function
t7:                                     # @t7
	.param  	i32, i64
	.result 	i64
	.local  	i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label18
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, -1
	i64.const	$3=, 511
	i32.add 	$push0=, $0, $2
	i64.extend_u/i32	$push1=, $pop0
	i64.mul 	$push2=, $pop1, $3
	i64.add 	$1=, $pop2, $1
.LBB6_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $2
	br_if   	$0, 0           # 0: up to label19
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label20:
	i64.add 	$1=, $1, $3
.LBB6_4:                                # %while.end
	end_block                       # label18:
	return  	$1
.Lfunc_end6:
	.size	t7, .Lfunc_end6-t7

	.section	.text.t8,"ax",@progbits
	.hidden	t8
	.globl	t8
	.type	t8,@function
t8:                                     # @t8
	.param  	i32, i64
	.result 	i64
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label21
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, -1
	i32.add 	$push0=, $0, $2
	i64.extend_u/i32	$push1=, $pop0
	i64.const	$push2=, 9
	i64.shl 	$push3=, $pop1, $pop2
	i64.add 	$1=, $pop3, $1
.LBB7_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label22:
	i32.const	$3=, 0
	i32.load	$4=, gvol+4($3)
	i32.load	$5=, gvol+8($3)
	i32.load	$6=, gvol+12($3)
	i32.load	$7=, gvol+16($3)
	i32.load	$8=, gvol+20($3)
	i32.load	$9=, gvol+24($3)
	i32.load	$10=, gvol+28($3)
	i32.load	$11=, gvol+32($3)
	i32.load	$12=, gvol+36($3)
	i32.load	$13=, gvol+40($3)
	i32.load	$14=, gvol+44($3)
	i32.load	$15=, gvol+48($3)
	i32.load	$16=, gvol+52($3)
	i32.load	$17=, gvol+56($3)
	i32.load	$18=, gvol+60($3)
	i32.load	$19=, gvol+64($3)
	i32.load	$20=, gvol+68($3)
	i32.load	$21=, gvol+72($3)
	i32.load	$22=, gvol+76($3)
	i32.load	$23=, gvol+80($3)
	i32.load	$24=, gvol+84($3)
	i32.load	$25=, gvol+88($3)
	i32.load	$26=, gvol+92($3)
	i32.load	$27=, gvol+96($3)
	i32.load	$28=, gvol+100($3)
	i32.load	$29=, gvol+104($3)
	i32.load	$30=, gvol+108($3)
	i32.load	$31=, gvol+112($3)
	i32.load	$32=, gvol+116($3)
	i32.load	$33=, gvol+120($3)
	i32.store	$discard=, gvol+4($3), $4
	i32.store	$discard=, gvol+8($3), $5
	i32.store	$discard=, gvol+12($3), $6
	i32.store	$discard=, gvol+16($3), $7
	i32.store	$discard=, gvol+20($3), $8
	i32.store	$discard=, gvol+24($3), $9
	i32.store	$discard=, gvol+28($3), $10
	i32.store	$discard=, gvol+32($3), $11
	i32.store	$discard=, gvol+36($3), $12
	i32.store	$discard=, gvol+40($3), $13
	i32.store	$discard=, gvol+44($3), $14
	i32.store	$discard=, gvol+48($3), $15
	i32.store	$discard=, gvol+52($3), $16
	i32.store	$discard=, gvol+56($3), $17
	i32.store	$discard=, gvol+60($3), $18
	i32.store	$discard=, gvol+64($3), $19
	i32.store	$discard=, gvol+68($3), $20
	i32.store	$discard=, gvol+72($3), $21
	i32.store	$discard=, gvol+76($3), $22
	i32.store	$discard=, gvol+80($3), $23
	i32.store	$discard=, gvol+84($3), $24
	i32.store	$discard=, gvol+88($3), $25
	i32.store	$discard=, gvol+92($3), $26
	i32.store	$discard=, gvol+96($3), $27
	i32.store	$discard=, gvol+100($3), $28
	i32.store	$discard=, gvol+104($3), $29
	i32.store	$discard=, gvol+108($3), $30
	i32.store	$discard=, gvol+112($3), $31
	i32.store	$discard=, gvol+116($3), $32
	i32.store	$discard=, gvol+120($3), $33
	i32.add 	$0=, $0, $2
	br_if   	$0, 0           # 0: up to label22
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label23:
	i64.const	$push4=, 512
	i64.add 	$1=, $1, $pop4
.LBB7_4:                                # %while.end
	end_block                       # label21:
	return  	$1
.Lfunc_end7:
	.size	t8, .Lfunc_end7-t8

	.section	.text.t9,"ax",@progbits
	.hidden	t9
	.globl	t9
	.type	t9,@function
t9:                                     # @t9
	.param  	i32, i64
	.result 	i64
	.local  	i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label24
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, -1
	i64.const	$3=, 513
	i32.add 	$push0=, $0, $2
	i64.extend_u/i32	$push1=, $pop0
	i64.mul 	$push2=, $pop1, $3
	i64.add 	$1=, $pop2, $1
.LBB8_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label25:
	i32.const	$4=, 0
	i32.load	$5=, gvol+4($4)
	i32.load	$6=, gvol+8($4)
	i32.load	$7=, gvol+12($4)
	i32.load	$8=, gvol+16($4)
	i32.load	$9=, gvol+20($4)
	i32.load	$10=, gvol+24($4)
	i32.load	$11=, gvol+28($4)
	i32.load	$12=, gvol+32($4)
	i32.load	$13=, gvol+36($4)
	i32.load	$14=, gvol+40($4)
	i32.load	$15=, gvol+44($4)
	i32.load	$16=, gvol+48($4)
	i32.load	$17=, gvol+52($4)
	i32.load	$18=, gvol+56($4)
	i32.load	$19=, gvol+60($4)
	i32.load	$20=, gvol+64($4)
	i32.load	$21=, gvol+68($4)
	i32.load	$22=, gvol+72($4)
	i32.load	$23=, gvol+76($4)
	i32.load	$24=, gvol+80($4)
	i32.load	$25=, gvol+84($4)
	i32.load	$26=, gvol+88($4)
	i32.load	$27=, gvol+92($4)
	i32.load	$28=, gvol+96($4)
	i32.load	$29=, gvol+100($4)
	i32.load	$30=, gvol+104($4)
	i32.load	$31=, gvol+108($4)
	i32.load	$32=, gvol+112($4)
	i32.load	$33=, gvol+116($4)
	i32.load	$34=, gvol+120($4)
	i32.store	$discard=, gvol+4($4), $5
	i32.store	$discard=, gvol+8($4), $6
	i32.store	$discard=, gvol+12($4), $7
	i32.store	$discard=, gvol+16($4), $8
	i32.store	$discard=, gvol+20($4), $9
	i32.store	$discard=, gvol+24($4), $10
	i32.store	$discard=, gvol+28($4), $11
	i32.store	$discard=, gvol+32($4), $12
	i32.store	$discard=, gvol+36($4), $13
	i32.store	$discard=, gvol+40($4), $14
	i32.store	$discard=, gvol+44($4), $15
	i32.store	$discard=, gvol+48($4), $16
	i32.store	$discard=, gvol+52($4), $17
	i32.store	$discard=, gvol+56($4), $18
	i32.store	$discard=, gvol+60($4), $19
	i32.store	$discard=, gvol+64($4), $20
	i32.store	$discard=, gvol+68($4), $21
	i32.store	$discard=, gvol+72($4), $22
	i32.store	$discard=, gvol+76($4), $23
	i32.store	$discard=, gvol+80($4), $24
	i32.store	$discard=, gvol+84($4), $25
	i32.store	$discard=, gvol+88($4), $26
	i32.store	$discard=, gvol+92($4), $27
	i32.store	$discard=, gvol+96($4), $28
	i32.store	$discard=, gvol+100($4), $29
	i32.store	$discard=, gvol+104($4), $30
	i32.store	$discard=, gvol+108($4), $31
	i32.store	$discard=, gvol+112($4), $32
	i32.store	$discard=, gvol+116($4), $33
	i32.store	$discard=, gvol+120($4), $34
	i32.add 	$0=, $0, $2
	br_if   	$0, 0           # 0: up to label25
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label26:
	i64.add 	$1=, $1, $3
.LBB8_4:                                # %while.end
	end_block                       # label24:
	return  	$1
.Lfunc_end8:
	.size	t9, .Lfunc_end8-t9

	.section	.text.t10,"ax",@progbits
	.hidden	t10
	.globl	t10
	.type	t10,@function
t10:                                    # @t10
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label27
# BB#1:                                 # %while.body.lr.ph
	i32.const	$3=, 0
	i32.const	$4=, -1
	i64.load	$push0=, gull($3)
	i32.add 	$push1=, $0, $4
	i64.extend_u/i32	$push2=, $pop1
	i64.const	$push3=, 1
	i64.add 	$push4=, $pop2, $pop3
	i64.mul 	$2=, $pop0, $pop4
.LBB9_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label28:
	i32.load	$5=, gvol+4($3)
	i32.load	$6=, gvol+8($3)
	i32.load	$7=, gvol+12($3)
	i32.load	$8=, gvol+16($3)
	i32.load	$9=, gvol+20($3)
	i32.load	$10=, gvol+24($3)
	i32.load	$11=, gvol+28($3)
	i32.load	$12=, gvol+32($3)
	i32.load	$13=, gvol+36($3)
	i32.load	$14=, gvol+40($3)
	i32.load	$15=, gvol+44($3)
	i32.load	$16=, gvol+48($3)
	i32.load	$17=, gvol+52($3)
	i32.load	$18=, gvol+56($3)
	i32.load	$19=, gvol+60($3)
	i32.load	$20=, gvol+64($3)
	i32.load	$21=, gvol+68($3)
	i32.load	$22=, gvol+72($3)
	i32.load	$23=, gvol+76($3)
	i32.load	$24=, gvol+80($3)
	i32.load	$25=, gvol+84($3)
	i32.load	$26=, gvol+88($3)
	i32.load	$27=, gvol+92($3)
	i32.load	$28=, gvol+96($3)
	i32.load	$29=, gvol+100($3)
	i32.load	$30=, gvol+104($3)
	i32.load	$31=, gvol+108($3)
	i32.load	$32=, gvol+112($3)
	i32.load	$33=, gvol+116($3)
	i32.load	$34=, gvol+120($3)
	i32.store	$discard=, gvol+4($3), $5
	i32.store	$discard=, gvol+8($3), $6
	i32.store	$discard=, gvol+12($3), $7
	i32.store	$discard=, gvol+16($3), $8
	i32.store	$discard=, gvol+20($3), $9
	i32.store	$discard=, gvol+24($3), $10
	i32.store	$discard=, gvol+28($3), $11
	i32.store	$discard=, gvol+32($3), $12
	i32.store	$discard=, gvol+36($3), $13
	i32.store	$discard=, gvol+40($3), $14
	i32.store	$discard=, gvol+44($3), $15
	i32.store	$discard=, gvol+48($3), $16
	i32.store	$discard=, gvol+52($3), $17
	i32.store	$discard=, gvol+56($3), $18
	i32.store	$discard=, gvol+60($3), $19
	i32.store	$discard=, gvol+64($3), $20
	i32.store	$discard=, gvol+68($3), $21
	i32.store	$discard=, gvol+72($3), $22
	i32.store	$discard=, gvol+76($3), $23
	i32.store	$discard=, gvol+80($3), $24
	i32.store	$discard=, gvol+84($3), $25
	i32.store	$discard=, gvol+88($3), $26
	i32.store	$discard=, gvol+92($3), $27
	i32.store	$discard=, gvol+96($3), $28
	i32.store	$discard=, gvol+100($3), $29
	i32.store	$discard=, gvol+104($3), $30
	i32.store	$discard=, gvol+108($3), $31
	i32.store	$discard=, gvol+112($3), $32
	i32.store	$discard=, gvol+116($3), $33
	i32.store	$discard=, gvol+120($3), $34
	i32.add 	$0=, $0, $4
	br_if   	$0, 0           # 0: up to label28
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label29:
	i64.add 	$1=, $2, $1
.LBB9_4:                                # %while.end
	end_block                       # label27:
	return  	$1
.Lfunc_end9:
	.size	t10, .Lfunc_end9-t10

	.section	.text.t11,"ax",@progbits
	.hidden	t11
	.globl	t11
	.type	t11,@function
t11:                                    # @t11
	.param  	i32, i64
	.result 	i64
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label30
# BB#1:                                 # %while.body.lr.ph
	i32.const	$3=, 0
	i32.const	$4=, -1
	i64.load	$push0=, gull($3)
	i32.add 	$push1=, $0, $4
	i64.extend_u/i32	$push2=, $pop1
	i64.const	$push3=, -1
	i64.xor 	$push4=, $pop2, $pop3
	i64.mul 	$2=, $pop0, $pop4
.LBB10_2:                               # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.load	$5=, gvol+4($3)
	i32.load	$6=, gvol+8($3)
	i32.load	$7=, gvol+12($3)
	i32.load	$8=, gvol+16($3)
	i32.load	$9=, gvol+20($3)
	i32.load	$10=, gvol+24($3)
	i32.load	$11=, gvol+28($3)
	i32.load	$12=, gvol+32($3)
	i32.load	$13=, gvol+36($3)
	i32.load	$14=, gvol+40($3)
	i32.load	$15=, gvol+44($3)
	i32.load	$16=, gvol+48($3)
	i32.load	$17=, gvol+52($3)
	i32.load	$18=, gvol+56($3)
	i32.load	$19=, gvol+60($3)
	i32.load	$20=, gvol+64($3)
	i32.load	$21=, gvol+68($3)
	i32.load	$22=, gvol+72($3)
	i32.load	$23=, gvol+76($3)
	i32.load	$24=, gvol+80($3)
	i32.load	$25=, gvol+84($3)
	i32.load	$26=, gvol+88($3)
	i32.load	$27=, gvol+92($3)
	i32.load	$28=, gvol+96($3)
	i32.load	$29=, gvol+100($3)
	i32.load	$30=, gvol+104($3)
	i32.load	$31=, gvol+108($3)
	i32.load	$32=, gvol+112($3)
	i32.load	$33=, gvol+116($3)
	i32.load	$34=, gvol+120($3)
	i32.store	$discard=, gvol+4($3), $5
	i32.store	$discard=, gvol+8($3), $6
	i32.store	$discard=, gvol+12($3), $7
	i32.store	$discard=, gvol+16($3), $8
	i32.store	$discard=, gvol+20($3), $9
	i32.store	$discard=, gvol+24($3), $10
	i32.store	$discard=, gvol+28($3), $11
	i32.store	$discard=, gvol+32($3), $12
	i32.store	$discard=, gvol+36($3), $13
	i32.store	$discard=, gvol+40($3), $14
	i32.store	$discard=, gvol+44($3), $15
	i32.store	$discard=, gvol+48($3), $16
	i32.store	$discard=, gvol+52($3), $17
	i32.store	$discard=, gvol+56($3), $18
	i32.store	$discard=, gvol+60($3), $19
	i32.store	$discard=, gvol+64($3), $20
	i32.store	$discard=, gvol+68($3), $21
	i32.store	$discard=, gvol+72($3), $22
	i32.store	$discard=, gvol+76($3), $23
	i32.store	$discard=, gvol+80($3), $24
	i32.store	$discard=, gvol+84($3), $25
	i32.store	$discard=, gvol+88($3), $26
	i32.store	$discard=, gvol+92($3), $27
	i32.store	$discard=, gvol+96($3), $28
	i32.store	$discard=, gvol+100($3), $29
	i32.store	$discard=, gvol+104($3), $30
	i32.store	$discard=, gvol+108($3), $31
	i32.store	$discard=, gvol+112($3), $32
	i32.store	$discard=, gvol+116($3), $33
	i32.store	$discard=, gvol+120($3), $34
	i32.add 	$0=, $0, $4
	br_if   	$0, 0           # 0: up to label31
# BB#3:                                 # %while.end.loopexit
	end_loop                        # label32:
	i64.add 	$1=, $2, $1
.LBB10_4:                               # %while.end
	end_block                       # label30:
	return  	$1
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
	return  	$pop1
.Lfunc_end11:
	.size	neg, .Lfunc_end11-neg

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i32, i64, i64, i64
# BB#0:                                 # %entry
	i64.const	$2=, -1
	i32.const	$0=, 0
	i32.const	$3=, 3
	block
	i64.const	$push0=, 100
	i64.store	$1=, gull($0), $pop0
	i64.call	$push1=, t1@FUNCTION, $3, $2
	i64.const	$push2=, -6145
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label33
# BB#1:                                 # %if.end
	i64.const	$4=, 4294967295
	block
	i64.call	$push4=, t1@FUNCTION, $3, $4
	i64.const	$push5=, 4294961151
	i64.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label34
# BB#2:                                 # %if.end4
	block
	i64.call	$push7=, t2@FUNCTION, $3, $2
	i64.const	$push8=, -1540
	i64.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label35
# BB#3:                                 # %if.end8
	block
	i64.call	$push10=, t2@FUNCTION, $3, $4
	i64.const	$push11=, 4294965756
	i64.ne  	$push12=, $pop10, $pop11
	br_if   	$pop12, 0       # 0: down to label36
# BB#4:                                 # %if.end12
	block
	i64.call	$push13=, t3@FUNCTION, $3, $2
	i64.const	$push14=, -1537
	i64.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label37
# BB#5:                                 # %if.end16
	block
	i64.call	$push16=, t3@FUNCTION, $3, $4
	i64.const	$push17=, 4294965759
	i64.ne  	$push18=, $pop16, $pop17
	br_if   	$pop18, 0       # 0: down to label38
# BB#6:                                 # %if.end20
	block
	i64.call	$push19=, t4@FUNCTION, $3, $2
	i64.const	$push20=, -1534
	i64.ne  	$push21=, $pop19, $pop20
	br_if   	$pop21, 0       # 0: down to label39
# BB#7:                                 # %if.end24
	block
	i64.call	$push22=, t4@FUNCTION, $3, $4
	i64.const	$push23=, 4294965762
	i64.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, 0       # 0: down to label40
# BB#8:                                 # %if.end28
	block
	i64.call	$push25=, t5@FUNCTION, $3, $2
	i64.const	$push26=, -4
	i64.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, 0       # 0: down to label41
# BB#9:                                 # %if.end32
	block
	i64.call	$push28=, t5@FUNCTION, $3, $4
	i64.const	$push29=, 4294967292
	i64.ne  	$push30=, $pop28, $pop29
	br_if   	$pop30, 0       # 0: down to label42
# BB#10:                                # %if.end36
	block
	i64.call	$push31=, t6@FUNCTION, $3, $2
	i64.const	$push32=, 2
	i64.ne  	$push33=, $pop31, $pop32
	br_if   	$pop33, 0       # 0: down to label43
# BB#11:                                # %if.end40
	block
	i64.call	$push34=, t6@FUNCTION, $3, $4
	i64.const	$push35=, 4294967298
	i64.ne  	$push36=, $pop34, $pop35
	br_if   	$pop36, 0       # 0: down to label44
# BB#12:                                # %if.end44
	block
	i64.call	$push37=, t7@FUNCTION, $3, $2
	i64.const	$push38=, 1532
	i64.ne  	$push39=, $pop37, $pop38
	br_if   	$pop39, 0       # 0: down to label45
# BB#13:                                # %if.end48
	block
	i64.call	$push40=, t7@FUNCTION, $3, $4
	i64.const	$push41=, 4294968828
	i64.ne  	$push42=, $pop40, $pop41
	br_if   	$pop42, 0       # 0: down to label46
# BB#14:                                # %if.end52
	block
	i64.call	$push43=, t8@FUNCTION, $3, $2
	i64.const	$push44=, 1535
	i64.ne  	$push45=, $pop43, $pop44
	br_if   	$pop45, 0       # 0: down to label47
# BB#15:                                # %if.end56
	block
	i64.call	$push46=, t8@FUNCTION, $3, $4
	i64.const	$push47=, 4294968831
	i64.ne  	$push48=, $pop46, $pop47
	br_if   	$pop48, 0       # 0: down to label48
# BB#16:                                # %if.end60
	block
	i64.call	$push49=, t9@FUNCTION, $3, $2
	i64.const	$push50=, 1538
	i64.ne  	$push51=, $pop49, $pop50
	br_if   	$pop51, 0       # 0: down to label49
# BB#17:                                # %if.end64
	block
	i64.call	$push52=, t9@FUNCTION, $3, $4
	i64.const	$push53=, 4294968834
	i64.ne  	$push54=, $pop52, $pop53
	br_if   	$pop54, 0       # 0: down to label50
# BB#18:                                # %if.end68
	i64.call	$5=, t10@FUNCTION, $3, $2
	i64.const	$6=, 3
	block
	i64.load	$push55=, gull($0)
	i64.mul 	$push56=, $pop55, $6
	i64.add 	$push57=, $pop56, $2
	i64.ne  	$push58=, $5, $pop57
	br_if   	$pop58, 0       # 0: down to label51
# BB#19:                                # %if.end72
	i64.call	$5=, t10@FUNCTION, $3, $4
	block
	i64.load	$push59=, gull($0)
	i64.mul 	$push60=, $pop59, $6
	i64.add 	$push61=, $pop60, $4
	i64.ne  	$push62=, $5, $pop61
	br_if   	$pop62, 0       # 0: down to label52
# BB#20:                                # %if.end77
	i64.call	$5=, t11@FUNCTION, $3, $2
	i64.const	$6=, -3
	block
	i64.load	$push63=, gull($0)
	i64.mul 	$push64=, $pop63, $6
	i64.add 	$push65=, $pop64, $2
	i64.ne  	$push66=, $5, $pop65
	br_if   	$pop66, 0       # 0: down to label53
# BB#21:                                # %if.end84
	i64.call	$5=, t11@FUNCTION, $3, $4
	i64.load	$2=, gull($0)
	block
	i64.mul 	$push67=, $2, $6
	i64.add 	$push68=, $pop67, $4
	i64.ne  	$push69=, $5, $pop68
	br_if   	$pop69, 0       # 0: down to label54
# BB#22:                                # %if.end91
	block
	i64.ne  	$push70=, $2, $1
	br_if   	$pop70, 0       # 0: down to label55
# BB#23:                                # %if.end95
	call    	exit@FUNCTION, $0
	unreachable
.LBB12_24:                              # %if.then94
	end_block                       # label55:
	call    	abort@FUNCTION
	unreachable
.LBB12_25:                              # %if.then90
	end_block                       # label54:
	call    	abort@FUNCTION
	unreachable
.LBB12_26:                              # %if.then83
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
.LBB12_27:                              # %if.then76
	end_block                       # label52:
	call    	abort@FUNCTION
	unreachable
.LBB12_28:                              # %if.then71
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB12_29:                              # %if.then67
	end_block                       # label50:
	call    	abort@FUNCTION
	unreachable
.LBB12_30:                              # %if.then63
	end_block                       # label49:
	call    	abort@FUNCTION
	unreachable
.LBB12_31:                              # %if.then59
	end_block                       # label48:
	call    	abort@FUNCTION
	unreachable
.LBB12_32:                              # %if.then55
	end_block                       # label47:
	call    	abort@FUNCTION
	unreachable
.LBB12_33:                              # %if.then51
	end_block                       # label46:
	call    	abort@FUNCTION
	unreachable
.LBB12_34:                              # %if.then47
	end_block                       # label45:
	call    	abort@FUNCTION
	unreachable
.LBB12_35:                              # %if.then43
	end_block                       # label44:
	call    	abort@FUNCTION
	unreachable
.LBB12_36:                              # %if.then39
	end_block                       # label43:
	call    	abort@FUNCTION
	unreachable
.LBB12_37:                              # %if.then35
	end_block                       # label42:
	call    	abort@FUNCTION
	unreachable
.LBB12_38:                              # %if.then31
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB12_39:                              # %if.then27
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB12_40:                              # %if.then23
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
.LBB12_41:                              # %if.then19
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB12_42:                              # %if.then15
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
.LBB12_43:                              # %if.then11
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB12_44:                              # %if.then7
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB12_45:                              # %if.then3
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB12_46:                              # %if.then
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

	.hidden	gvol                    # @gvol
	.type	gvol,@object
	.section	.bss.gvol,"aw",@nobits
	.globl	gvol
	.align	4
gvol:
	.skip	128
	.size	gvol, 128

	.hidden	gull                    # @gull
	.type	gull,@object
	.section	.bss.gull,"aw",@nobits
	.globl	gull
	.align	3
gull:
	.int64	0                       # 0x0
	.size	gull, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
