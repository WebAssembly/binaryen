	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-9.c"
	.section	.text.to_hex,"ax",@progbits
	.hidden	to_hex
	.globl	to_hex
	.type	to_hex,@function
to_hex:                                 # @to_hex
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 16
	i32.ge_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_s	$push2=, .L.str($0)
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	to_hex, .Lfunc_end0-to_hex

	.section	.text.fap,"ax",@progbits
	.hidden	fap
	.globl	fap
	.type	fap,@function
fap:                                    # @fap
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.const	$push6=, 16
	i32.sub 	$push1=, $pop6, $0
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load8_u	$push8=, 0($1)
	tee_local	$push7=, $0=, $pop8
	i32.const	$push14=, 0
	i32.eq  	$push15=, $pop7, $pop14
	br_if   	2, $pop15       # 2: down to label2
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push11=, 0($2)
	tee_local	$push10=, $3=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push3=, $pop10, $pop9
	br_if   	3, $pop3        # 3: down to label1
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push13=, 4
	i32.add 	$2=, $2, $pop13
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	i32.load8_u	$push4=, .L.str($3)
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: up to label3
# BB#4:                                 # %if.then4
	end_loop                        # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %while.end
	end_block                       # label2:
	return
.LBB1_6:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	fap, .Lfunc_end1-fap

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$4=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $4
	i32.store	$discard=, 12($4), $1
	block
	i32.call	$push0=, strlen@FUNCTION, $0
	i32.const	$push5=, 16
	i32.ne  	$push1=, $pop0, $pop5
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$1=, 12($4)
.LBB2_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.load8_u	$push7=, 0($0)
	tee_local	$push6=, $2=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label6
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.load	$push10=, 0($1)
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push2=, $pop9, $pop8
	br_if   	3, $pop2        # 3: down to label5
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$1=, $1, $pop12
	i32.const	$push11=, 1
	i32.add 	$0=, $0, $pop11
	i32.load8_u	$push3=, .L.str($3)
	i32.eq  	$push4=, $2, $pop3
	br_if   	0, $pop4        # 0: up to label7
# BB#5:                                 # %if.then4.i
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %fap.exit
	end_block                       # label6:
	i32.const	$push17=, 16
	i32.add 	$4=, $4, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $4
	return
.LBB2_7:                                # %if.then.i.i
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$5=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $5
	i32.store	$discard=, 12($5), $2
	block
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.const	$push1=, 15
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label9
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$2=, 12($5)
.LBB3_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label11:
	i32.load8_u	$push7=, 0($1)
	tee_local	$push6=, $3=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label10
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.load	$push10=, 0($2)
	tee_local	$push9=, $4=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label9
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$2=, $2, $pop12
	i32.const	$push11=, 1
	i32.add 	$1=, $1, $pop11
	i32.load8_u	$push4=, .L.str($4)
	i32.eq  	$push5=, $3, $pop4
	br_if   	0, $pop5        # 0: up to label11
# BB#5:                                 # %if.then4.i
	end_loop                        # label12:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %fap.exit
	end_block                       # label10:
	i32.const	$push17=, 16
	i32.add 	$5=, $5, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $5
	return
.LBB3_7:                                # %if.then.i.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$6=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $6
	i32.store	$discard=, 12($6), $3
	block
	i32.call	$push0=, strlen@FUNCTION, $2
	i32.const	$push1=, 14
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label13
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$3=, 12($6)
.LBB4_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label15:
	i32.load8_u	$push7=, 0($2)
	tee_local	$push6=, $4=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label14
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB4_2 Depth=1
	i32.load	$push10=, 0($3)
	tee_local	$push9=, $5=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label13
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB4_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$3=, $3, $pop12
	i32.const	$push11=, 1
	i32.add 	$2=, $2, $pop11
	i32.load8_u	$push4=, .L.str($5)
	i32.eq  	$push5=, $4, $pop4
	br_if   	0, $pop5        # 0: up to label15
# BB#5:                                 # %if.then4.i
	end_loop                        # label16:
	call    	abort@FUNCTION
	unreachable
.LBB4_6:                                # %fap.exit
	end_block                       # label14:
	i32.const	$push17=, 16
	i32.add 	$6=, $6, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $6
	return
.LBB4_7:                                # %if.then.i.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$7=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $7
	i32.store	$discard=, 12($7), $4
	block
	i32.call	$push0=, strlen@FUNCTION, $3
	i32.const	$push1=, 13
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label17
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$4=, 12($7)
.LBB5_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label19:
	i32.load8_u	$push7=, 0($3)
	tee_local	$push6=, $5=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label18
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB5_2 Depth=1
	i32.load	$push10=, 0($4)
	tee_local	$push9=, $6=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label17
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB5_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$4=, $4, $pop12
	i32.const	$push11=, 1
	i32.add 	$3=, $3, $pop11
	i32.load8_u	$push4=, .L.str($6)
	i32.eq  	$push5=, $5, $pop4
	br_if   	0, $pop5        # 0: up to label19
# BB#5:                                 # %if.then4.i
	end_loop                        # label20:
	call    	abort@FUNCTION
	unreachable
.LBB5_6:                                # %fap.exit
	end_block                       # label18:
	i32.const	$push17=, 16
	i32.add 	$7=, $7, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $7
	return
.LBB5_7:                                # %if.then.i.i
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$8=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $8
	i32.store	$discard=, 12($8), $5
	block
	i32.call	$push0=, strlen@FUNCTION, $4
	i32.const	$push1=, 12
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label21
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$5=, 12($8)
.LBB6_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label23:
	i32.load8_u	$push7=, 0($4)
	tee_local	$push6=, $6=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label22
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.load	$push10=, 0($5)
	tee_local	$push9=, $7=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label21
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$5=, $5, $pop12
	i32.const	$push11=, 1
	i32.add 	$4=, $4, $pop11
	i32.load8_u	$push4=, .L.str($7)
	i32.eq  	$push5=, $6, $pop4
	br_if   	0, $pop5        # 0: up to label23
# BB#5:                                 # %if.then4.i
	end_loop                        # label24:
	call    	abort@FUNCTION
	unreachable
.LBB6_6:                                # %fap.exit
	end_block                       # label22:
	i32.const	$push17=, 16
	i32.add 	$8=, $8, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $8
	return
.LBB6_7:                                # %if.then.i.i
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$9=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $9
	i32.store	$discard=, 12($9), $6
	block
	i32.call	$push0=, strlen@FUNCTION, $5
	i32.const	$push1=, 11
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label25
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$6=, 12($9)
.LBB7_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label27:
	i32.load8_u	$push7=, 0($5)
	tee_local	$push6=, $7=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label26
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB7_2 Depth=1
	i32.load	$push10=, 0($6)
	tee_local	$push9=, $8=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label25
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB7_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$6=, $6, $pop12
	i32.const	$push11=, 1
	i32.add 	$5=, $5, $pop11
	i32.load8_u	$push4=, .L.str($8)
	i32.eq  	$push5=, $7, $pop4
	br_if   	0, $pop5        # 0: up to label27
# BB#5:                                 # %if.then4.i
	end_loop                        # label28:
	call    	abort@FUNCTION
	unreachable
.LBB7_6:                                # %fap.exit
	end_block                       # label26:
	i32.const	$push17=, 16
	i32.add 	$9=, $9, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $9
	return
.LBB7_7:                                # %if.then.i.i
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$10=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $10
	i32.store	$discard=, 12($10), $7
	block
	i32.call	$push0=, strlen@FUNCTION, $6
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label29
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$7=, 12($10)
.LBB8_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label31:
	i32.load8_u	$push7=, 0($6)
	tee_local	$push6=, $8=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label30
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB8_2 Depth=1
	i32.load	$push10=, 0($7)
	tee_local	$push9=, $9=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label29
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB8_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$7=, $7, $pop12
	i32.const	$push11=, 1
	i32.add 	$6=, $6, $pop11
	i32.load8_u	$push4=, .L.str($9)
	i32.eq  	$push5=, $8, $pop4
	br_if   	0, $pop5        # 0: up to label31
# BB#5:                                 # %if.then4.i
	end_loop                        # label32:
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %fap.exit
	end_block                       # label30:
	i32.const	$push17=, 16
	i32.add 	$10=, $10, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $10
	return
.LBB8_7:                                # %if.then.i.i
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f6, .Lfunc_end8-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$11=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $11
	i32.store	$discard=, 12($11), $8
	block
	i32.call	$push0=, strlen@FUNCTION, $7
	i32.const	$push1=, 9
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label33
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$8=, 12($11)
.LBB9_2:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label35:
	i32.load8_u	$push7=, 0($7)
	tee_local	$push6=, $9=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label34
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB9_2 Depth=1
	i32.load	$push10=, 0($8)
	tee_local	$push9=, $10=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label33
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB9_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$8=, $8, $pop12
	i32.const	$push11=, 1
	i32.add 	$7=, $7, $pop11
	i32.load8_u	$push4=, .L.str($10)
	i32.eq  	$push5=, $9, $pop4
	br_if   	0, $pop5        # 0: up to label35
# BB#5:                                 # %if.then4.i
	end_loop                        # label36:
	call    	abort@FUNCTION
	unreachable
.LBB9_6:                                # %fap.exit
	end_block                       # label34:
	i32.const	$push17=, 16
	i32.add 	$11=, $11, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $11
	return
.LBB9_7:                                # %if.then.i.i
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$12=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $12
	i32.store	$discard=, 12($12), $9
	block
	i32.call	$push0=, strlen@FUNCTION, $8
	i32.const	$push1=, 8
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label37
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$9=, 12($12)
.LBB10_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label39:
	i32.load8_u	$push7=, 0($8)
	tee_local	$push6=, $10=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label38
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB10_2 Depth=1
	i32.load	$push10=, 0($9)
	tee_local	$push9=, $11=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label37
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB10_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$9=, $9, $pop12
	i32.const	$push11=, 1
	i32.add 	$8=, $8, $pop11
	i32.load8_u	$push4=, .L.str($11)
	i32.eq  	$push5=, $10, $pop4
	br_if   	0, $pop5        # 0: up to label39
# BB#5:                                 # %if.then4.i
	end_loop                        # label40:
	call    	abort@FUNCTION
	unreachable
.LBB10_6:                               # %fap.exit
	end_block                       # label38:
	i32.const	$push17=, 16
	i32.add 	$12=, $12, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $12
	return
.LBB10_7:                               # %if.then.i.i
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8

	.section	.text.f9,"ax",@progbits
	.hidden	f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$13=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $13
	i32.store	$discard=, 12($13), $10
	block
	i32.call	$push0=, strlen@FUNCTION, $9
	i32.const	$push1=, 7
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label41
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$10=, 12($13)
.LBB11_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label43:
	i32.load8_u	$push7=, 0($9)
	tee_local	$push6=, $11=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label42
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB11_2 Depth=1
	i32.load	$push10=, 0($10)
	tee_local	$push9=, $12=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label41
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB11_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$10=, $10, $pop12
	i32.const	$push11=, 1
	i32.add 	$9=, $9, $pop11
	i32.load8_u	$push4=, .L.str($12)
	i32.eq  	$push5=, $11, $pop4
	br_if   	0, $pop5        # 0: up to label43
# BB#5:                                 # %if.then4.i
	end_loop                        # label44:
	call    	abort@FUNCTION
	unreachable
.LBB11_6:                               # %fap.exit
	end_block                       # label42:
	i32.const	$push17=, 16
	i32.add 	$13=, $13, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $13
	return
.LBB11_7:                               # %if.then.i.i
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	f9, .Lfunc_end11-f9

	.section	.text.f10,"ax",@progbits
	.hidden	f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$14=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $14
	i32.store	$discard=, 12($14), $11
	block
	i32.call	$push0=, strlen@FUNCTION, $10
	i32.const	$push1=, 6
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label45
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$11=, 12($14)
.LBB12_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label47:
	i32.load8_u	$push7=, 0($10)
	tee_local	$push6=, $12=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label46
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.load	$push10=, 0($11)
	tee_local	$push9=, $13=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label45
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$11=, $11, $pop12
	i32.const	$push11=, 1
	i32.add 	$10=, $10, $pop11
	i32.load8_u	$push4=, .L.str($13)
	i32.eq  	$push5=, $12, $pop4
	br_if   	0, $pop5        # 0: up to label47
# BB#5:                                 # %if.then4.i
	end_loop                        # label48:
	call    	abort@FUNCTION
	unreachable
.LBB12_6:                               # %fap.exit
	end_block                       # label46:
	i32.const	$push17=, 16
	i32.add 	$14=, $14, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $14
	return
.LBB12_7:                               # %if.then.i.i
	end_block                       # label45:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	f10, .Lfunc_end12-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$15=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $15
	i32.store	$discard=, 12($15), $12
	block
	i32.call	$push0=, strlen@FUNCTION, $11
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label49
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$12=, 12($15)
.LBB13_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label51:
	i32.load8_u	$push7=, 0($11)
	tee_local	$push6=, $13=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label50
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB13_2 Depth=1
	i32.load	$push10=, 0($12)
	tee_local	$push9=, $14=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label49
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB13_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$12=, $12, $pop12
	i32.const	$push11=, 1
	i32.add 	$11=, $11, $pop11
	i32.load8_u	$push4=, .L.str($14)
	i32.eq  	$push5=, $13, $pop4
	br_if   	0, $pop5        # 0: up to label51
# BB#5:                                 # %if.then4.i
	end_loop                        # label52:
	call    	abort@FUNCTION
	unreachable
.LBB13_6:                               # %fap.exit
	end_block                       # label50:
	i32.const	$push17=, 16
	i32.add 	$15=, $15, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $15
	return
.LBB13_7:                               # %if.then.i.i
	end_block                       # label49:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end13:
	.size	f11, .Lfunc_end13-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$16=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $16
	i32.store	$discard=, 12($16), $13
	block
	i32.call	$push0=, strlen@FUNCTION, $12
	i32.const	$push5=, 4
	i32.ne  	$push1=, $pop0, $pop5
	br_if   	0, $pop1        # 0: down to label53
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$13=, 12($16)
.LBB14_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label55:
	i32.load8_u	$push7=, 0($12)
	tee_local	$push6=, $14=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label54
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB14_2 Depth=1
	i32.load	$push10=, 0($13)
	tee_local	$push9=, $15=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push2=, $pop9, $pop8
	br_if   	3, $pop2        # 3: down to label53
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB14_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$13=, $13, $pop12
	i32.const	$push11=, 1
	i32.add 	$12=, $12, $pop11
	i32.load8_u	$push3=, .L.str($15)
	i32.eq  	$push4=, $14, $pop3
	br_if   	0, $pop4        # 0: up to label55
# BB#5:                                 # %if.then4.i
	end_loop                        # label56:
	call    	abort@FUNCTION
	unreachable
.LBB14_6:                               # %fap.exit
	end_block                       # label54:
	i32.const	$push17=, 16
	i32.add 	$16=, $16, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $16
	return
.LBB14_7:                               # %if.then.i.i
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end14:
	.size	f12, .Lfunc_end14-f12

	.section	.text.f13,"ax",@progbits
	.hidden	f13
	.globl	f13
	.type	f13,@function
f13:                                    # @f13
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$17=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $17
	i32.store	$discard=, 12($17), $14
	block
	i32.call	$push0=, strlen@FUNCTION, $13
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label57
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$14=, 12($17)
.LBB15_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label59:
	i32.load8_u	$push7=, 0($13)
	tee_local	$push6=, $15=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label58
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB15_2 Depth=1
	i32.load	$push10=, 0($14)
	tee_local	$push9=, $16=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label57
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB15_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$14=, $14, $pop12
	i32.const	$push11=, 1
	i32.add 	$13=, $13, $pop11
	i32.load8_u	$push4=, .L.str($16)
	i32.eq  	$push5=, $15, $pop4
	br_if   	0, $pop5        # 0: up to label59
# BB#5:                                 # %if.then4.i
	end_loop                        # label60:
	call    	abort@FUNCTION
	unreachable
.LBB15_6:                               # %fap.exit
	end_block                       # label58:
	i32.const	$push17=, 16
	i32.add 	$17=, $17, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $17
	return
.LBB15_7:                               # %if.then.i.i
	end_block                       # label57:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end15:
	.size	f13, .Lfunc_end15-f13

	.section	.text.f14,"ax",@progbits
	.hidden	f14
	.globl	f14
	.type	f14,@function
f14:                                    # @f14
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$18=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $18
	i32.store	$discard=, 12($18), $15
	block
	i32.call	$push0=, strlen@FUNCTION, $14
	i32.const	$push1=, 2
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label61
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$15=, 12($18)
.LBB16_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label63:
	i32.load8_u	$push7=, 0($14)
	tee_local	$push6=, $16=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label62
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB16_2 Depth=1
	i32.load	$push10=, 0($15)
	tee_local	$push9=, $17=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push3=, $pop9, $pop8
	br_if   	3, $pop3        # 3: down to label61
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB16_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$15=, $15, $pop12
	i32.const	$push11=, 1
	i32.add 	$14=, $14, $pop11
	i32.load8_u	$push4=, .L.str($17)
	i32.eq  	$push5=, $16, $pop4
	br_if   	0, $pop5        # 0: up to label63
# BB#5:                                 # %if.then4.i
	end_loop                        # label64:
	call    	abort@FUNCTION
	unreachable
.LBB16_6:                               # %fap.exit
	end_block                       # label62:
	i32.const	$push17=, 16
	i32.add 	$18=, $18, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $18
	return
.LBB16_7:                               # %if.then.i.i
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end16:
	.size	f14, .Lfunc_end16-f14

	.section	.text.f15,"ax",@progbits
	.hidden	f15
	.globl	f15
	.type	f15,@function
f15:                                    # @f15
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$19=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $19
	i32.store	$discard=, 12($19), $16
	block
	i32.call	$push0=, strlen@FUNCTION, $15
	i32.const	$push5=, 1
	i32.ne  	$push1=, $pop0, $pop5
	br_if   	0, $pop1        # 0: down to label65
# BB#1:                                 # %while.cond.i.preheader
	i32.load	$16=, 12($19)
.LBB17_2:                               # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label67:
	i32.load8_u	$push7=, 0($15)
	tee_local	$push6=, $17=, $pop7
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop6, $pop19
	br_if   	2, $pop20       # 2: down to label66
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB17_2 Depth=1
	i32.load	$push10=, 0($16)
	tee_local	$push9=, $18=, $pop10
	i32.const	$push8=, 16
	i32.ge_u	$push2=, $pop9, $pop8
	br_if   	3, $pop2        # 3: down to label65
# BB#4:                                 # %to_hex.exit.i
                                        #   in Loop: Header=BB17_2 Depth=1
	i32.const	$push12=, 4
	i32.add 	$16=, $16, $pop12
	i32.const	$push11=, 1
	i32.add 	$15=, $15, $pop11
	i32.load8_u	$push3=, .L.str($18)
	i32.eq  	$push4=, $17, $pop3
	br_if   	0, $pop4        # 0: up to label67
# BB#5:                                 # %if.then4.i
	end_loop                        # label68:
	call    	abort@FUNCTION
	unreachable
.LBB17_6:                               # %fap.exit
	end_block                       # label66:
	i32.const	$push17=, 16
	i32.add 	$19=, $19, $pop17
	i32.const	$push18=, __stack_pointer
	i32.store	$discard=, 0($pop18), $19
	return
.LBB17_7:                               # %if.then.i.i
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end17:
	.size	f15, .Lfunc_end17-f15

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push117=, __stack_pointer
	i32.load	$push118=, 0($pop117)
	i32.const	$push119=, 640
	i32.sub 	$71=, $pop118, $pop119
	i32.const	$push120=, __stack_pointer
	i32.store	$discard=, 0($pop120), $71
	i32.const	$push0=, 56
	i32.const	$14=, 576
	i32.add 	$14=, $71, $14
	i32.add 	$push1=, $14, $pop0
	i64.const	$push2=, 64424509454
	i64.store	$0=, 0($pop1), $pop2
	i32.const	$push3=, 48
	i32.const	$15=, 576
	i32.add 	$15=, $71, $15
	i32.add 	$push4=, $15, $pop3
	i64.const	$push5=, 55834574860
	i64.store	$1=, 0($pop4):p2align=4, $pop5
	i32.const	$push6=, 40
	i32.const	$16=, 576
	i32.add 	$16=, $71, $16
	i32.add 	$push7=, $16, $pop6
	i64.const	$push8=, 47244640266
	i64.store	$2=, 0($pop7), $pop8
	i32.const	$push9=, 32
	i32.const	$17=, 576
	i32.add 	$17=, $71, $17
	i32.add 	$push10=, $17, $pop9
	i64.const	$push11=, 38654705672
	i64.store	$3=, 0($pop10):p2align=4, $pop11
	i32.const	$push12=, 24
	i32.const	$18=, 576
	i32.add 	$18=, $71, $18
	i32.add 	$push13=, $18, $pop12
	i64.const	$push14=, 30064771078
	i64.store	$4=, 0($pop13), $pop14
	i32.const	$push15=, 16
	i32.const	$19=, 576
	i32.add 	$19=, $71, $19
	i32.add 	$push16=, $19, $pop15
	i64.const	$push17=, 21474836484
	i64.store	$5=, 0($pop16):p2align=4, $pop17
	i64.const	$push18=, 12884901890
	i64.store	$6=, 584($71), $pop18
	i64.const	$push19=, 4294967296
	i64.store	$discard=, 576($71):p2align=4, $pop19
	i32.const	$push20=, .L.str
	i32.const	$20=, 576
	i32.add 	$20=, $71, $20
	call    	f0@FUNCTION, $pop20, $20
	i32.const	$push116=, 56
	i32.const	$21=, 512
	i32.add 	$21=, $71, $21
	i32.add 	$push21=, $21, $pop116
	i32.const	$push22=, 15
	i32.store	$7=, 0($pop21):p2align=3, $pop22
	i32.const	$push115=, 48
	i32.const	$22=, 512
	i32.add 	$22=, $71, $22
	i32.add 	$push23=, $22, $pop115
	i64.const	$push24=, 60129542157
	i64.store	$8=, 0($pop23):p2align=4, $pop24
	i32.const	$push114=, 40
	i32.const	$23=, 512
	i32.add 	$23=, $71, $23
	i32.add 	$push25=, $23, $pop114
	i64.const	$push26=, 51539607563
	i64.store	$9=, 0($pop25), $pop26
	i32.const	$push113=, 32
	i32.const	$24=, 512
	i32.add 	$24=, $71, $24
	i32.add 	$push27=, $24, $pop113
	i64.const	$push28=, 42949672969
	i64.store	$10=, 0($pop27):p2align=4, $pop28
	i32.const	$push112=, 24
	i32.const	$25=, 512
	i32.add 	$25=, $71, $25
	i32.add 	$push29=, $25, $pop112
	i64.const	$push30=, 34359738375
	i64.store	$11=, 0($pop29), $pop30
	i32.const	$push111=, 16
	i32.const	$26=, 512
	i32.add 	$26=, $71, $26
	i32.add 	$push31=, $26, $pop111
	i64.const	$push32=, 25769803781
	i64.store	$12=, 0($pop31):p2align=4, $pop32
	i64.const	$push33=, 17179869187
	i64.store	$13=, 520($71), $pop33
	i64.const	$push34=, 8589934593
	i64.store	$discard=, 512($71):p2align=4, $pop34
	i32.const	$push35=, .L.str+1
	i32.const	$27=, 512
	i32.add 	$27=, $71, $27
	call    	f1@FUNCTION, $7, $pop35, $27
	i32.const	$push110=, 48
	i32.const	$28=, 448
	i32.add 	$28=, $71, $28
	i32.add 	$push36=, $28, $pop110
	i64.store	$discard=, 0($pop36):p2align=4, $0
	i32.const	$push109=, 40
	i32.const	$29=, 448
	i32.add 	$29=, $71, $29
	i32.add 	$push37=, $29, $pop109
	i64.store	$discard=, 0($pop37), $1
	i32.const	$push108=, 32
	i32.const	$30=, 448
	i32.add 	$30=, $71, $30
	i32.add 	$push38=, $30, $pop108
	i64.store	$discard=, 0($pop38):p2align=4, $2
	i32.const	$push107=, 24
	i32.const	$31=, 448
	i32.add 	$31=, $71, $31
	i32.add 	$push39=, $31, $pop107
	i64.store	$discard=, 0($pop39), $3
	i32.const	$push106=, 16
	i32.const	$32=, 448
	i32.add 	$32=, $71, $32
	i32.add 	$push40=, $32, $pop106
	i64.store	$discard=, 0($pop40):p2align=4, $4
	i64.store	$discard=, 456($71), $5
	i64.store	$discard=, 448($71):p2align=4, $6
	i32.const	$push41=, .L.str+2
	i32.const	$33=, 448
	i32.add 	$33=, $71, $33
	call    	f2@FUNCTION, $7, $7, $pop41, $33
	i32.const	$push105=, 48
	i32.const	$34=, 384
	i32.add 	$34=, $71, $34
	i32.add 	$push42=, $34, $pop105
	i32.store	$discard=, 0($pop42):p2align=4, $7
	i32.const	$push104=, 40
	i32.const	$35=, 384
	i32.add 	$35=, $71, $35
	i32.add 	$push43=, $35, $pop104
	i64.store	$6=, 0($pop43), $8
	i32.const	$push103=, 32
	i32.const	$36=, 384
	i32.add 	$36=, $71, $36
	i32.add 	$push44=, $36, $pop103
	i64.store	$8=, 0($pop44):p2align=4, $9
	i32.const	$push102=, 24
	i32.const	$37=, 384
	i32.add 	$37=, $71, $37
	i32.add 	$push45=, $37, $pop102
	i64.store	$9=, 0($pop45), $10
	i32.const	$push101=, 16
	i32.const	$38=, 384
	i32.add 	$38=, $71, $38
	i32.add 	$push46=, $38, $pop101
	i64.store	$10=, 0($pop46):p2align=4, $11
	i64.store	$11=, 392($71), $12
	i64.store	$discard=, 384($71):p2align=4, $13
	i32.const	$push47=, .L.str+3
	i32.const	$39=, 384
	i32.add 	$39=, $71, $39
	call    	f3@FUNCTION, $7, $7, $7, $pop47, $39
	i32.const	$push100=, 40
	i32.const	$40=, 336
	i32.add 	$40=, $71, $40
	i32.add 	$push48=, $40, $pop100
	i64.store	$discard=, 0($pop48), $0
	i32.const	$push99=, 32
	i32.const	$41=, 336
	i32.add 	$41=, $71, $41
	i32.add 	$push49=, $41, $pop99
	i64.store	$discard=, 0($pop49):p2align=4, $1
	i32.const	$push98=, 24
	i32.const	$42=, 336
	i32.add 	$42=, $71, $42
	i32.add 	$push50=, $42, $pop98
	i64.store	$discard=, 0($pop50), $2
	i32.const	$push97=, 16
	i32.const	$43=, 336
	i32.add 	$43=, $71, $43
	i32.add 	$push51=, $43, $pop97
	i64.store	$discard=, 0($pop51):p2align=4, $3
	i64.store	$discard=, 344($71), $4
	i64.store	$discard=, 336($71):p2align=4, $5
	i32.const	$push52=, .L.str+4
	i32.const	$44=, 336
	i32.add 	$44=, $71, $44
	call    	f4@FUNCTION, $7, $7, $7, $7, $pop52, $44
	i32.const	$push96=, 40
	i32.const	$45=, 288
	i32.add 	$45=, $71, $45
	i32.add 	$push53=, $45, $pop96
	i32.store	$discard=, 0($pop53):p2align=3, $7
	i32.const	$push95=, 32
	i32.const	$46=, 288
	i32.add 	$46=, $71, $46
	i32.add 	$push54=, $46, $pop95
	i64.store	$5=, 0($pop54):p2align=4, $6
	i32.const	$push94=, 24
	i32.const	$47=, 288
	i32.add 	$47=, $71, $47
	i32.add 	$push55=, $47, $pop94
	i64.store	$6=, 0($pop55), $8
	i32.const	$push93=, 16
	i32.const	$48=, 288
	i32.add 	$48=, $71, $48
	i32.add 	$push56=, $48, $pop93
	i64.store	$8=, 0($pop56):p2align=4, $9
	i64.store	$9=, 296($71), $10
	i64.store	$discard=, 288($71):p2align=4, $11
	i32.const	$push57=, .L.str+5
	i32.const	$49=, 288
	i32.add 	$49=, $71, $49
	call    	f5@FUNCTION, $7, $7, $7, $7, $7, $pop57, $49
	i32.const	$push92=, 32
	i32.const	$50=, 240
	i32.add 	$50=, $71, $50
	i32.add 	$push58=, $50, $pop92
	i64.store	$discard=, 0($pop58):p2align=4, $0
	i32.const	$push91=, 24
	i32.const	$51=, 240
	i32.add 	$51=, $71, $51
	i32.add 	$push59=, $51, $pop91
	i64.store	$discard=, 0($pop59), $1
	i32.const	$push90=, 16
	i32.const	$52=, 240
	i32.add 	$52=, $71, $52
	i32.add 	$push60=, $52, $pop90
	i64.store	$discard=, 0($pop60):p2align=4, $2
	i64.store	$discard=, 248($71), $3
	i64.store	$discard=, 240($71):p2align=4, $4
	i32.const	$push61=, .L.str+6
	i32.const	$53=, 240
	i32.add 	$53=, $71, $53
	call    	f6@FUNCTION, $7, $7, $7, $7, $7, $7, $pop61, $53
	i32.const	$push89=, 32
	i32.const	$54=, 192
	i32.add 	$54=, $71, $54
	i32.add 	$push62=, $54, $pop89
	i32.store	$discard=, 0($pop62):p2align=4, $7
	i32.const	$push88=, 24
	i32.const	$55=, 192
	i32.add 	$55=, $71, $55
	i32.add 	$push63=, $55, $pop88
	i64.store	$4=, 0($pop63), $5
	i32.const	$push87=, 16
	i32.const	$56=, 192
	i32.add 	$56=, $71, $56
	i32.add 	$push64=, $56, $pop87
	i64.store	$5=, 0($pop64):p2align=4, $6
	i64.store	$6=, 200($71), $8
	i64.store	$discard=, 192($71):p2align=4, $9
	i32.const	$push65=, .L.str+7
	i32.const	$57=, 192
	i32.add 	$57=, $71, $57
	call    	f7@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $pop65, $57
	i32.const	$push86=, 24
	i32.const	$58=, 160
	i32.add 	$58=, $71, $58
	i32.add 	$push66=, $58, $pop86
	i64.store	$discard=, 0($pop66), $0
	i32.const	$push85=, 16
	i32.const	$59=, 160
	i32.add 	$59=, $71, $59
	i32.add 	$push67=, $59, $pop85
	i64.store	$discard=, 0($pop67):p2align=4, $1
	i64.store	$discard=, 168($71), $2
	i64.store	$discard=, 160($71):p2align=4, $3
	i32.const	$push68=, .L.str+8
	i32.const	$60=, 160
	i32.add 	$60=, $71, $60
	call    	f8@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $pop68, $60
	i32.const	$push84=, 24
	i32.const	$61=, 128
	i32.add 	$61=, $71, $61
	i32.add 	$push69=, $61, $pop84
	i32.store	$discard=, 0($pop69):p2align=3, $7
	i32.const	$push83=, 16
	i32.const	$62=, 128
	i32.add 	$62=, $71, $62
	i32.add 	$push70=, $62, $pop83
	i64.store	$3=, 0($pop70):p2align=4, $4
	i64.store	$4=, 136($71), $5
	i64.store	$discard=, 128($71):p2align=4, $6
	i32.const	$push71=, .L.str+9
	i32.const	$63=, 128
	i32.add 	$63=, $71, $63
	call    	f9@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop71, $63
	i32.const	$push82=, 16
	i32.const	$64=, 96
	i32.add 	$64=, $71, $64
	i32.add 	$push72=, $64, $pop82
	i64.store	$discard=, 0($pop72):p2align=4, $0
	i64.store	$discard=, 104($71), $1
	i64.store	$discard=, 96($71):p2align=4, $2
	i32.const	$push73=, .L.str+10
	i32.const	$65=, 96
	i32.add 	$65=, $71, $65
	call    	f10@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop73, $65
	i32.const	$push81=, 16
	i32.const	$66=, 64
	i32.add 	$66=, $71, $66
	i32.add 	$push74=, $66, $pop81
	i32.store	$discard=, 0($pop74):p2align=4, $7
	i64.store	$2=, 72($71), $3
	i64.store	$discard=, 64($71):p2align=4, $4
	i32.const	$push75=, .L.str+11
	i32.const	$67=, 64
	i32.add 	$67=, $71, $67
	call    	f11@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop75, $67
	i64.store	$discard=, 56($71), $0
	i64.store	$discard=, 48($71):p2align=4, $1
	i32.const	$push76=, .L.str+12
	i32.const	$68=, 48
	i32.add 	$68=, $71, $68
	call    	f12@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop76, $68
	i32.store	$discard=, 40($71):p2align=3, $7
	i64.store	$discard=, 32($71):p2align=4, $2
	i32.const	$push77=, .L.str+13
	i32.const	$69=, 32
	i32.add 	$69=, $71, $69
	call    	f13@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop77, $69
	i64.store	$discard=, 16($71):p2align=4, $0
	i32.const	$push78=, .L.str+14
	i32.const	$70=, 16
	i32.add 	$70=, $71, $70
	call    	f14@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop78, $70
	i32.store	$discard=, 0($71):p2align=4, $7
	i32.const	$push79=, .L.str+15
	call    	f15@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop79, $71
	i32.const	$push80=, 0
	call    	exit@FUNCTION, $pop80
	unreachable
	.endfunc
.Lfunc_end18:
	.size	main, .Lfunc_end18-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.L.str:
	.asciz	"0123456789abcdef"
	.size	.L.str, 17


	.ident	"clang version 3.9.0 "
