	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-2.c"
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

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $7
	block
	i32.call	$push2=, strlen@FUNCTION, $0
	i32.const	$push3=, 16
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label4:
	i32.load8_u	$push0=, 0($0)
	tee_local	$push17=, $1=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label2
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push5=, 12($6)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $2=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($6), $pop11
	i32.load	$push1=, 0($2)
	tee_local	$push18=, $2=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label3
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$0=, $0, $pop14
	i32.load8_u	$push15=, .L.str($2)
	i32.eq  	$push16=, $1, $pop15
	br_if   	0, $pop16       # 0: up to label4
# BB#4:                                 # %if.then5
	end_loop                        # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %while.end
	end_block                       # label2:
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB1_7:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f0, .Lfunc_end1-f0

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	copy_local	$8=, $7
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$discard=, 12($7), $8
	block
	i32.call	$push2=, strlen@FUNCTION, $1
	i32.const	$push3=, 15
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label6
.LBB2_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label9:
	i32.load8_u	$push0=, 0($1)
	tee_local	$push17=, $2=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label7
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push5=, 12($7)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $3=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($7), $pop11
	i32.load	$push1=, 0($3)
	tee_local	$push18=, $3=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label8
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	i32.load8_u	$push15=, .L.str($3)
	i32.eq  	$push16=, $2, $pop15
	br_if   	0, $pop16       # 0: up to label9
# BB#4:                                 # %if.then5
	end_loop                        # label10:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %if.then.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %while.end
	end_block                       # label7:
	i32.const	$6=, 16
	i32.add 	$7=, $8, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return
.LBB2_7:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	copy_local	$9=, $8
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.store	$discard=, 12($8), $9
	block
	i32.call	$push2=, strlen@FUNCTION, $2
	i32.const	$push3=, 14
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label11
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label14:
	i32.load8_u	$push0=, 0($2)
	tee_local	$push17=, $3=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label12
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push5=, 12($8)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $4=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($8), $pop11
	i32.load	$push1=, 0($4)
	tee_local	$push18=, $4=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label13
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$2=, $2, $pop14
	i32.load8_u	$push15=, .L.str($4)
	i32.eq  	$push16=, $3, $pop15
	br_if   	0, $pop16       # 0: up to label14
# BB#4:                                 # %if.then5
	end_loop                        # label15:
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %if.then.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %while.end
	end_block                       # label12:
	i32.const	$7=, 16
	i32.add 	$8=, $9, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return
.LBB3_7:                                # %if.then
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$9=, $6, $7
	copy_local	$10=, $9
	i32.const	$7=, __stack_pointer
	i32.store	$9=, 0($7), $9
	i32.store	$discard=, 12($9), $10
	block
	i32.call	$push2=, strlen@FUNCTION, $3
	i32.const	$push3=, 13
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label16
.LBB4_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label19:
	i32.load8_u	$push0=, 0($3)
	tee_local	$push17=, $4=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label17
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.load	$push5=, 12($9)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $5=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($9), $pop11
	i32.load	$push1=, 0($5)
	tee_local	$push18=, $5=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label18
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$3=, $3, $pop14
	i32.load8_u	$push15=, .L.str($5)
	i32.eq  	$push16=, $4, $pop15
	br_if   	0, $pop16       # 0: up to label19
# BB#4:                                 # %if.then5
	end_loop                        # label20:
	call    	abort@FUNCTION
	unreachable
.LBB4_5:                                # %if.then.i
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB4_6:                                # %while.end
	end_block                       # label17:
	i32.const	$8=, 16
	i32.add 	$9=, $10, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
	return
.LBB4_7:                                # %if.then
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f3, .Lfunc_end4-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$10=, $7, $8
	copy_local	$11=, $10
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.store	$discard=, 12($10), $11
	block
	i32.call	$push2=, strlen@FUNCTION, $4
	i32.const	$push3=, 12
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label21
.LBB5_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label24:
	i32.load8_u	$push0=, 0($4)
	tee_local	$push17=, $5=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label22
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.load	$push5=, 12($10)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $6=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($10), $pop11
	i32.load	$push1=, 0($6)
	tee_local	$push18=, $6=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label23
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$4=, $4, $pop14
	i32.load8_u	$push15=, .L.str($6)
	i32.eq  	$push16=, $5, $pop15
	br_if   	0, $pop16       # 0: up to label24
# BB#4:                                 # %if.then5
	end_loop                        # label25:
	call    	abort@FUNCTION
	unreachable
.LBB5_5:                                # %if.then.i
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB5_6:                                # %while.end
	end_block                       # label22:
	i32.const	$9=, 16
	i32.add 	$10=, $11, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return
.LBB5_7:                                # %if.then
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f4, .Lfunc_end5-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$11=, $8, $9
	copy_local	$12=, $11
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	i32.store	$discard=, 12($11), $12
	block
	i32.call	$push2=, strlen@FUNCTION, $5
	i32.const	$push3=, 11
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label26
.LBB6_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label29:
	i32.load8_u	$push0=, 0($5)
	tee_local	$push17=, $6=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label27
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.load	$push5=, 12($11)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $7=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($11), $pop11
	i32.load	$push1=, 0($7)
	tee_local	$push18=, $7=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label28
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$5=, $5, $pop14
	i32.load8_u	$push15=, .L.str($7)
	i32.eq  	$push16=, $6, $pop15
	br_if   	0, $pop16       # 0: up to label29
# BB#4:                                 # %if.then5
	end_loop                        # label30:
	call    	abort@FUNCTION
	unreachable
.LBB6_5:                                # %if.then.i
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB6_6:                                # %while.end
	end_block                       # label27:
	i32.const	$10=, 16
	i32.add 	$11=, $12, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	return
.LBB6_7:                                # %if.then
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f5, .Lfunc_end6-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$12=, $9, $10
	copy_local	$13=, $12
	i32.const	$10=, __stack_pointer
	i32.store	$12=, 0($10), $12
	i32.store	$discard=, 12($12), $13
	block
	i32.call	$push2=, strlen@FUNCTION, $6
	i32.const	$push3=, 10
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label31
.LBB7_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label34:
	i32.load8_u	$push0=, 0($6)
	tee_local	$push17=, $7=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label32
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.load	$push5=, 12($12)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $8=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($12), $pop11
	i32.load	$push1=, 0($8)
	tee_local	$push18=, $8=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label33
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$6=, $6, $pop14
	i32.load8_u	$push15=, .L.str($8)
	i32.eq  	$push16=, $7, $pop15
	br_if   	0, $pop16       # 0: up to label34
# BB#4:                                 # %if.then5
	end_loop                        # label35:
	call    	abort@FUNCTION
	unreachable
.LBB7_5:                                # %if.then.i
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB7_6:                                # %while.end
	end_block                       # label32:
	i32.const	$11=, 16
	i32.add 	$12=, $13, $11
	i32.const	$11=, __stack_pointer
	i32.store	$12=, 0($11), $12
	return
.LBB7_7:                                # %if.then
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	f6, .Lfunc_end7-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	copy_local	$14=, $13
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$discard=, 12($13), $14
	block
	i32.call	$push2=, strlen@FUNCTION, $7
	i32.const	$push3=, 9
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label36
.LBB8_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label39:
	i32.load8_u	$push0=, 0($7)
	tee_local	$push17=, $8=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label37
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.load	$push5=, 12($13)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $9=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($13), $pop11
	i32.load	$push1=, 0($9)
	tee_local	$push18=, $9=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label38
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$7=, $7, $pop14
	i32.load8_u	$push15=, .L.str($9)
	i32.eq  	$push16=, $8, $pop15
	br_if   	0, $pop16       # 0: up to label39
# BB#4:                                 # %if.then5
	end_loop                        # label40:
	call    	abort@FUNCTION
	unreachable
.LBB8_5:                                # %if.then.i
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %while.end
	end_block                       # label37:
	i32.const	$12=, 16
	i32.add 	$13=, $14, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
	return
.LBB8_7:                                # %if.then
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f7, .Lfunc_end8-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 16
	i32.sub 	$14=, $11, $12
	copy_local	$15=, $14
	i32.const	$12=, __stack_pointer
	i32.store	$14=, 0($12), $14
	i32.store	$discard=, 12($14), $15
	block
	i32.call	$push2=, strlen@FUNCTION, $8
	i32.const	$push3=, 8
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label41
.LBB9_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label44:
	i32.load8_u	$push0=, 0($8)
	tee_local	$push17=, $9=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label42
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.load	$push5=, 12($14)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $10=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($14), $pop11
	i32.load	$push1=, 0($10)
	tee_local	$push18=, $10=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label43
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$8=, $8, $pop14
	i32.load8_u	$push15=, .L.str($10)
	i32.eq  	$push16=, $9, $pop15
	br_if   	0, $pop16       # 0: up to label44
# BB#4:                                 # %if.then5
	end_loop                        # label45:
	call    	abort@FUNCTION
	unreachable
.LBB9_5:                                # %if.then.i
	end_block                       # label43:
	call    	abort@FUNCTION
	unreachable
.LBB9_6:                                # %while.end
	end_block                       # label42:
	i32.const	$13=, 16
	i32.add 	$14=, $15, $13
	i32.const	$13=, __stack_pointer
	i32.store	$14=, 0($13), $14
	return
.LBB9_7:                                # %if.then
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f8, .Lfunc_end9-f8

	.section	.text.f9,"ax",@progbits
	.hidden	f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 16
	i32.sub 	$15=, $12, $13
	copy_local	$16=, $15
	i32.const	$13=, __stack_pointer
	i32.store	$15=, 0($13), $15
	i32.store	$discard=, 12($15), $16
	block
	i32.call	$push2=, strlen@FUNCTION, $9
	i32.const	$push3=, 7
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label46
.LBB10_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label49:
	i32.load8_u	$push0=, 0($9)
	tee_local	$push17=, $10=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label47
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.load	$push5=, 12($15)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $11=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($15), $pop11
	i32.load	$push1=, 0($11)
	tee_local	$push18=, $11=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label48
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$9=, $9, $pop14
	i32.load8_u	$push15=, .L.str($11)
	i32.eq  	$push16=, $10, $pop15
	br_if   	0, $pop16       # 0: up to label49
# BB#4:                                 # %if.then5
	end_loop                        # label50:
	call    	abort@FUNCTION
	unreachable
.LBB10_5:                               # %if.then.i
	end_block                       # label48:
	call    	abort@FUNCTION
	unreachable
.LBB10_6:                               # %while.end
	end_block                       # label47:
	i32.const	$14=, 16
	i32.add 	$15=, $16, $14
	i32.const	$14=, __stack_pointer
	i32.store	$15=, 0($14), $15
	return
.LBB10_7:                               # %if.then
	end_block                       # label46:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	f9, .Lfunc_end10-f9

	.section	.text.f10,"ax",@progbits
	.hidden	f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 16
	i32.sub 	$16=, $13, $14
	copy_local	$17=, $16
	i32.const	$14=, __stack_pointer
	i32.store	$16=, 0($14), $16
	i32.store	$discard=, 12($16), $17
	block
	i32.call	$push2=, strlen@FUNCTION, $10
	i32.const	$push3=, 6
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label51
.LBB11_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label54:
	i32.load8_u	$push0=, 0($10)
	tee_local	$push17=, $11=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label52
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB11_1 Depth=1
	i32.load	$push5=, 12($16)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $12=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($16), $pop11
	i32.load	$push1=, 0($12)
	tee_local	$push18=, $12=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label53
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB11_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$10=, $10, $pop14
	i32.load8_u	$push15=, .L.str($12)
	i32.eq  	$push16=, $11, $pop15
	br_if   	0, $pop16       # 0: up to label54
# BB#4:                                 # %if.then5
	end_loop                        # label55:
	call    	abort@FUNCTION
	unreachable
.LBB11_5:                               # %if.then.i
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
.LBB11_6:                               # %while.end
	end_block                       # label52:
	i32.const	$15=, 16
	i32.add 	$16=, $17, $15
	i32.const	$15=, __stack_pointer
	i32.store	$16=, 0($15), $16
	return
.LBB11_7:                               # %if.then
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	f10, .Lfunc_end11-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 16
	i32.sub 	$17=, $14, $15
	copy_local	$18=, $17
	i32.const	$15=, __stack_pointer
	i32.store	$17=, 0($15), $17
	i32.store	$discard=, 12($17), $18
	block
	i32.call	$push2=, strlen@FUNCTION, $11
	i32.const	$push3=, 5
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label56
.LBB12_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label59:
	i32.load8_u	$push0=, 0($11)
	tee_local	$push17=, $12=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label57
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.load	$push5=, 12($17)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $13=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($17), $pop11
	i32.load	$push1=, 0($13)
	tee_local	$push18=, $13=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label58
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$11=, $11, $pop14
	i32.load8_u	$push15=, .L.str($13)
	i32.eq  	$push16=, $12, $pop15
	br_if   	0, $pop16       # 0: up to label59
# BB#4:                                 # %if.then5
	end_loop                        # label60:
	call    	abort@FUNCTION
	unreachable
.LBB12_5:                               # %if.then.i
	end_block                       # label58:
	call    	abort@FUNCTION
	unreachable
.LBB12_6:                               # %while.end
	end_block                       # label57:
	i32.const	$16=, 16
	i32.add 	$17=, $18, $16
	i32.const	$16=, __stack_pointer
	i32.store	$17=, 0($16), $17
	return
.LBB12_7:                               # %if.then
	end_block                       # label56:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	f11, .Lfunc_end12-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 16
	i32.sub 	$18=, $15, $16
	copy_local	$19=, $18
	i32.const	$16=, __stack_pointer
	i32.store	$18=, 0($16), $18
	i32.store	$discard=, 12($18), $19
	block
	i32.call	$push2=, strlen@FUNCTION, $12
	i32.const	$push3=, 4
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label61
.LBB13_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label64:
	i32.load8_u	$push0=, 0($12)
	tee_local	$push17=, $13=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label62
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.load	$push5=, 12($18)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $14=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($18), $pop11
	i32.load	$push1=, 0($14)
	tee_local	$push18=, $14=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label63
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$12=, $12, $pop14
	i32.load8_u	$push15=, .L.str($14)
	i32.eq  	$push16=, $13, $pop15
	br_if   	0, $pop16       # 0: up to label64
# BB#4:                                 # %if.then5
	end_loop                        # label65:
	call    	abort@FUNCTION
	unreachable
.LBB13_5:                               # %if.then.i
	end_block                       # label63:
	call    	abort@FUNCTION
	unreachable
.LBB13_6:                               # %while.end
	end_block                       # label62:
	i32.const	$17=, 16
	i32.add 	$18=, $19, $17
	i32.const	$17=, __stack_pointer
	i32.store	$18=, 0($17), $18
	return
.LBB13_7:                               # %if.then
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end13:
	.size	f12, .Lfunc_end13-f12

	.section	.text.f13,"ax",@progbits
	.hidden	f13
	.globl	f13
	.type	f13,@function
f13:                                    # @f13
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 16
	i32.sub 	$19=, $16, $17
	copy_local	$20=, $19
	i32.const	$17=, __stack_pointer
	i32.store	$19=, 0($17), $19
	i32.store	$discard=, 12($19), $20
	block
	i32.call	$push2=, strlen@FUNCTION, $13
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label66
.LBB14_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label69:
	i32.load8_u	$push0=, 0($13)
	tee_local	$push17=, $14=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label67
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB14_1 Depth=1
	i32.load	$push5=, 12($19)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $15=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($19), $pop11
	i32.load	$push1=, 0($15)
	tee_local	$push18=, $15=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label68
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB14_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$13=, $13, $pop14
	i32.load8_u	$push15=, .L.str($15)
	i32.eq  	$push16=, $14, $pop15
	br_if   	0, $pop16       # 0: up to label69
# BB#4:                                 # %if.then5
	end_loop                        # label70:
	call    	abort@FUNCTION
	unreachable
.LBB14_5:                               # %if.then.i
	end_block                       # label68:
	call    	abort@FUNCTION
	unreachable
.LBB14_6:                               # %while.end
	end_block                       # label67:
	i32.const	$18=, 16
	i32.add 	$19=, $20, $18
	i32.const	$18=, __stack_pointer
	i32.store	$19=, 0($18), $19
	return
.LBB14_7:                               # %if.then
	end_block                       # label66:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end14:
	.size	f13, .Lfunc_end14-f13

	.section	.text.f14,"ax",@progbits
	.hidden	f14
	.globl	f14
	.type	f14,@function
f14:                                    # @f14
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 16
	i32.sub 	$20=, $17, $18
	copy_local	$21=, $20
	i32.const	$18=, __stack_pointer
	i32.store	$20=, 0($18), $20
	i32.store	$discard=, 12($20), $21
	block
	i32.call	$push2=, strlen@FUNCTION, $14
	i32.const	$push3=, 2
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label71
.LBB15_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label74:
	i32.load8_u	$push0=, 0($14)
	tee_local	$push17=, $15=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label72
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB15_1 Depth=1
	i32.load	$push5=, 12($20)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $16=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($20), $pop11
	i32.load	$push1=, 0($16)
	tee_local	$push18=, $16=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label73
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB15_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$14=, $14, $pop14
	i32.load8_u	$push15=, .L.str($16)
	i32.eq  	$push16=, $15, $pop15
	br_if   	0, $pop16       # 0: up to label74
# BB#4:                                 # %if.then5
	end_loop                        # label75:
	call    	abort@FUNCTION
	unreachable
.LBB15_5:                               # %if.then.i
	end_block                       # label73:
	call    	abort@FUNCTION
	unreachable
.LBB15_6:                               # %while.end
	end_block                       # label72:
	i32.const	$19=, 16
	i32.add 	$20=, $21, $19
	i32.const	$19=, __stack_pointer
	i32.store	$20=, 0($19), $20
	return
.LBB15_7:                               # %if.then
	end_block                       # label71:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end15:
	.size	f14, .Lfunc_end15-f14

	.section	.text.f15,"ax",@progbits
	.hidden	f15
	.globl	f15
	.type	f15,@function
f15:                                    # @f15
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$18=, __stack_pointer
	i32.load	$18=, 0($18)
	i32.const	$19=, 16
	i32.sub 	$21=, $18, $19
	copy_local	$22=, $21
	i32.const	$19=, __stack_pointer
	i32.store	$21=, 0($19), $21
	i32.store	$discard=, 12($21), $22
	block
	i32.call	$push2=, strlen@FUNCTION, $15
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label76
.LBB16_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label79:
	i32.load8_u	$push0=, 0($15)
	tee_local	$push17=, $16=, $pop0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	3, $pop21       # 3: down to label77
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB16_1 Depth=1
	i32.load	$push5=, 12($21)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push19=, $17=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop19, $pop10
	i32.store	$discard=, 12($21), $pop11
	i32.load	$push1=, 0($17)
	tee_local	$push18=, $17=, $pop1
	i32.const	$push12=, 16
	i32.ge_u	$push13=, $pop18, $pop12
	br_if   	2, $pop13       # 2: down to label78
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB16_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$15=, $15, $pop14
	i32.load8_u	$push15=, .L.str($17)
	i32.eq  	$push16=, $16, $pop15
	br_if   	0, $pop16       # 0: up to label79
# BB#4:                                 # %if.then5
	end_loop                        # label80:
	call    	abort@FUNCTION
	unreachable
.LBB16_5:                               # %if.then.i
	end_block                       # label78:
	call    	abort@FUNCTION
	unreachable
.LBB16_6:                               # %while.end
	end_block                       # label77:
	i32.const	$20=, 16
	i32.add 	$21=, $22, $20
	i32.const	$20=, __stack_pointer
	i32.store	$21=, 0($20), $21
	return
.LBB16_7:                               # %if.then
	end_block                       # label76:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end16:
	.size	f15, .Lfunc_end16-f15

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$79=, __stack_pointer
	i32.load	$79=, 0($79)
	i32.const	$80=, 64
	i32.sub 	$81=, $79, $80
	i32.const	$80=, __stack_pointer
	i32.store	$81=, 0($80), $81
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 64
	i32.sub 	$81=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$81=, 0($16), $81
	i64.const	$push0=, 4294967296
	i64.store	$discard=, 0($81):p2align=2, $pop0
	i32.const	$push1=, 56
	i32.add 	$0=, $81, $pop1
	i64.const	$push2=, 64424509454
	i64.store	$1=, 0($0):p2align=2, $pop2
	i32.const	$push3=, 48
	i32.add 	$0=, $81, $pop3
	i64.const	$push4=, 55834574860
	i64.store	$2=, 0($0):p2align=2, $pop4
	i32.const	$push5=, 40
	i32.add 	$0=, $81, $pop5
	i64.const	$push6=, 47244640266
	i64.store	$3=, 0($0):p2align=2, $pop6
	i32.const	$push7=, 32
	i32.add 	$0=, $81, $pop7
	i64.const	$push8=, 38654705672
	i64.store	$4=, 0($0):p2align=2, $pop8
	i32.const	$push9=, 24
	i32.add 	$0=, $81, $pop9
	i64.const	$push10=, 30064771078
	i64.store	$5=, 0($0):p2align=2, $pop10
	i32.const	$push11=, 16
	i32.add 	$0=, $81, $pop11
	i64.const	$push12=, 21474836484
	i64.store	$6=, 0($0):p2align=2, $pop12
	i32.const	$push13=, 8
	i32.add 	$0=, $81, $pop13
	i64.const	$push14=, 12884901890
	i64.store	$7=, 0($0):p2align=2, $pop14
	i32.const	$push15=, .L.str
	call    	f0@FUNCTION, $pop15
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 64
	i32.add 	$81=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$81=, 0($18), $81
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 60
	i32.sub 	$81=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$81=, 0($20), $81
	i64.const	$push16=, 8589934593
	i64.store	$discard=, 0($81):p2align=2, $pop16
	i32.const	$push88=, 56
	i32.add 	$0=, $81, $pop88
	i32.const	$push17=, 15
	i32.store	$0=, 0($0), $pop17
	i32.const	$push87=, 48
	i32.add 	$8=, $81, $pop87
	i64.const	$push18=, 60129542157
	i64.store	$9=, 0($8):p2align=2, $pop18
	i32.const	$push86=, 40
	i32.add 	$8=, $81, $pop86
	i64.const	$push19=, 51539607563
	i64.store	$10=, 0($8):p2align=2, $pop19
	i32.const	$push85=, 32
	i32.add 	$8=, $81, $pop85
	i64.const	$push20=, 42949672969
	i64.store	$11=, 0($8):p2align=2, $pop20
	i32.const	$push84=, 24
	i32.add 	$8=, $81, $pop84
	i64.const	$push21=, 34359738375
	i64.store	$12=, 0($8):p2align=2, $pop21
	i32.const	$push83=, 16
	i32.add 	$8=, $81, $pop83
	i64.const	$push22=, 25769803781
	i64.store	$13=, 0($8):p2align=2, $pop22
	i32.const	$push82=, 8
	i32.add 	$8=, $81, $pop82
	i64.const	$push23=, 17179869187
	i64.store	$14=, 0($8):p2align=2, $pop23
	i32.const	$push24=, .L.str+1
	call    	f1@FUNCTION, $0, $pop24
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 60
	i32.add 	$81=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$81=, 0($22), $81
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 56
	i32.sub 	$81=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$81=, 0($24), $81
	i64.store	$discard=, 0($81):p2align=2, $7
	i32.const	$push81=, 48
	i32.add 	$8=, $81, $pop81
	i64.store	$discard=, 0($8):p2align=2, $1
	i32.const	$push80=, 40
	i32.add 	$8=, $81, $pop80
	i64.store	$discard=, 0($8):p2align=2, $2
	i32.const	$push79=, 32
	i32.add 	$8=, $81, $pop79
	i64.store	$discard=, 0($8):p2align=2, $3
	i32.const	$push78=, 24
	i32.add 	$8=, $81, $pop78
	i64.store	$discard=, 0($8):p2align=2, $4
	i32.const	$push77=, 16
	i32.add 	$8=, $81, $pop77
	i64.store	$discard=, 0($8):p2align=2, $5
	i32.const	$push76=, 8
	i32.add 	$8=, $81, $pop76
	i64.store	$discard=, 0($8):p2align=2, $6
	i32.const	$push25=, .L.str+2
	call    	f2@FUNCTION, $0, $0, $pop25
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 56
	i32.add 	$81=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$81=, 0($26), $81
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 52
	i32.sub 	$81=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$81=, 0($28), $81
	i64.store	$discard=, 0($81):p2align=2, $14
	i32.const	$push75=, 48
	i32.add 	$8=, $81, $pop75
	i32.store	$discard=, 0($8), $0
	i32.const	$push74=, 40
	i32.add 	$8=, $81, $pop74
	i64.store	$7=, 0($8):p2align=2, $9
	i32.const	$push73=, 32
	i32.add 	$8=, $81, $pop73
	i64.store	$9=, 0($8):p2align=2, $10
	i32.const	$push72=, 24
	i32.add 	$8=, $81, $pop72
	i64.store	$10=, 0($8):p2align=2, $11
	i32.const	$push71=, 16
	i32.add 	$8=, $81, $pop71
	i64.store	$11=, 0($8):p2align=2, $12
	i32.const	$push70=, 8
	i32.add 	$8=, $81, $pop70
	i64.store	$12=, 0($8):p2align=2, $13
	i32.const	$push26=, .L.str+3
	call    	f3@FUNCTION, $0, $0, $0, $pop26
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 52
	i32.add 	$81=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$81=, 0($30), $81
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 48
	i32.sub 	$81=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$81=, 0($32), $81
	i64.store	$discard=, 0($81):p2align=2, $6
	i32.const	$push69=, 40
	i32.add 	$8=, $81, $pop69
	i64.store	$discard=, 0($8):p2align=2, $1
	i32.const	$push68=, 32
	i32.add 	$8=, $81, $pop68
	i64.store	$discard=, 0($8):p2align=2, $2
	i32.const	$push67=, 24
	i32.add 	$8=, $81, $pop67
	i64.store	$discard=, 0($8):p2align=2, $3
	i32.const	$push66=, 16
	i32.add 	$8=, $81, $pop66
	i64.store	$discard=, 0($8):p2align=2, $4
	i32.const	$push65=, 8
	i32.add 	$8=, $81, $pop65
	i64.store	$discard=, 0($8):p2align=2, $5
	i32.const	$push27=, .L.str+4
	call    	f4@FUNCTION, $0, $0, $0, $0, $pop27
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 48
	i32.add 	$81=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$81=, 0($34), $81
	i32.const	$35=, __stack_pointer
	i32.load	$35=, 0($35)
	i32.const	$36=, 44
	i32.sub 	$81=, $35, $36
	i32.const	$36=, __stack_pointer
	i32.store	$81=, 0($36), $81
	i64.store	$discard=, 0($81):p2align=2, $12
	i32.const	$push64=, 40
	i32.add 	$8=, $81, $pop64
	i32.store	$discard=, 0($8), $0
	i32.const	$push63=, 32
	i32.add 	$8=, $81, $pop63
	i64.store	$6=, 0($8):p2align=2, $7
	i32.const	$push62=, 24
	i32.add 	$8=, $81, $pop62
	i64.store	$7=, 0($8):p2align=2, $9
	i32.const	$push61=, 16
	i32.add 	$8=, $81, $pop61
	i64.store	$9=, 0($8):p2align=2, $10
	i32.const	$push60=, 8
	i32.add 	$8=, $81, $pop60
	i64.store	$10=, 0($8):p2align=2, $11
	i32.const	$push28=, .L.str+5
	call    	f5@FUNCTION, $0, $0, $0, $0, $0, $pop28
	i32.const	$37=, __stack_pointer
	i32.load	$37=, 0($37)
	i32.const	$38=, 44
	i32.add 	$81=, $37, $38
	i32.const	$38=, __stack_pointer
	i32.store	$81=, 0($38), $81
	i32.const	$39=, __stack_pointer
	i32.load	$39=, 0($39)
	i32.const	$40=, 40
	i32.sub 	$81=, $39, $40
	i32.const	$40=, __stack_pointer
	i32.store	$81=, 0($40), $81
	i64.store	$discard=, 0($81):p2align=2, $5
	i32.const	$push59=, 32
	i32.add 	$8=, $81, $pop59
	i64.store	$discard=, 0($8):p2align=2, $1
	i32.const	$push58=, 24
	i32.add 	$8=, $81, $pop58
	i64.store	$discard=, 0($8):p2align=2, $2
	i32.const	$push57=, 16
	i32.add 	$8=, $81, $pop57
	i64.store	$discard=, 0($8):p2align=2, $3
	i32.const	$push56=, 8
	i32.add 	$8=, $81, $pop56
	i64.store	$discard=, 0($8):p2align=2, $4
	i32.const	$push29=, .L.str+6
	call    	f6@FUNCTION, $0, $0, $0, $0, $0, $0, $pop29
	i32.const	$41=, __stack_pointer
	i32.load	$41=, 0($41)
	i32.const	$42=, 40
	i32.add 	$81=, $41, $42
	i32.const	$42=, __stack_pointer
	i32.store	$81=, 0($42), $81
	i32.const	$43=, __stack_pointer
	i32.load	$43=, 0($43)
	i32.const	$44=, 36
	i32.sub 	$81=, $43, $44
	i32.const	$44=, __stack_pointer
	i32.store	$81=, 0($44), $81
	i64.store	$discard=, 0($81):p2align=2, $10
	i32.const	$push55=, 32
	i32.add 	$8=, $81, $pop55
	i32.store	$discard=, 0($8), $0
	i32.const	$push54=, 24
	i32.add 	$8=, $81, $pop54
	i64.store	$5=, 0($8):p2align=2, $6
	i32.const	$push53=, 16
	i32.add 	$8=, $81, $pop53
	i64.store	$6=, 0($8):p2align=2, $7
	i32.const	$push52=, 8
	i32.add 	$8=, $81, $pop52
	i64.store	$7=, 0($8):p2align=2, $9
	i32.const	$push30=, .L.str+7
	call    	f7@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $pop30
	i32.const	$45=, __stack_pointer
	i32.load	$45=, 0($45)
	i32.const	$46=, 36
	i32.add 	$81=, $45, $46
	i32.const	$46=, __stack_pointer
	i32.store	$81=, 0($46), $81
	i32.const	$47=, __stack_pointer
	i32.load	$47=, 0($47)
	i32.const	$48=, 32
	i32.sub 	$81=, $47, $48
	i32.const	$48=, __stack_pointer
	i32.store	$81=, 0($48), $81
	i64.store	$discard=, 0($81):p2align=2, $4
	i32.const	$push51=, 24
	i32.add 	$8=, $81, $pop51
	i64.store	$discard=, 0($8):p2align=2, $1
	i32.const	$push50=, 16
	i32.add 	$8=, $81, $pop50
	i64.store	$discard=, 0($8):p2align=2, $2
	i32.const	$push49=, 8
	i32.add 	$8=, $81, $pop49
	i64.store	$discard=, 0($8):p2align=2, $3
	i32.const	$push31=, .L.str+8
	call    	f8@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $pop31
	i32.const	$49=, __stack_pointer
	i32.load	$49=, 0($49)
	i32.const	$50=, 32
	i32.add 	$81=, $49, $50
	i32.const	$50=, __stack_pointer
	i32.store	$81=, 0($50), $81
	i32.const	$51=, __stack_pointer
	i32.load	$51=, 0($51)
	i32.const	$52=, 28
	i32.sub 	$81=, $51, $52
	i32.const	$52=, __stack_pointer
	i32.store	$81=, 0($52), $81
	i64.store	$discard=, 0($81):p2align=2, $7
	i32.const	$push48=, 24
	i32.add 	$8=, $81, $pop48
	i32.store	$discard=, 0($8), $0
	i32.const	$push47=, 16
	i32.add 	$8=, $81, $pop47
	i64.store	$4=, 0($8):p2align=2, $5
	i32.const	$push46=, 8
	i32.add 	$8=, $81, $pop46
	i64.store	$5=, 0($8):p2align=2, $6
	i32.const	$push32=, .L.str+9
	call    	f9@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop32
	i32.const	$53=, __stack_pointer
	i32.load	$53=, 0($53)
	i32.const	$54=, 28
	i32.add 	$81=, $53, $54
	i32.const	$54=, __stack_pointer
	i32.store	$81=, 0($54), $81
	i32.const	$55=, __stack_pointer
	i32.load	$55=, 0($55)
	i32.const	$56=, 24
	i32.sub 	$81=, $55, $56
	i32.const	$56=, __stack_pointer
	i32.store	$81=, 0($56), $81
	i64.store	$discard=, 0($81):p2align=2, $3
	i32.const	$push45=, 16
	i32.add 	$8=, $81, $pop45
	i64.store	$discard=, 0($8):p2align=2, $1
	i32.const	$push44=, 8
	i32.add 	$8=, $81, $pop44
	i64.store	$discard=, 0($8):p2align=2, $2
	i32.const	$push33=, .L.str+10
	call    	f10@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop33
	i32.const	$57=, __stack_pointer
	i32.load	$57=, 0($57)
	i32.const	$58=, 24
	i32.add 	$81=, $57, $58
	i32.const	$58=, __stack_pointer
	i32.store	$81=, 0($58), $81
	i32.const	$59=, __stack_pointer
	i32.load	$59=, 0($59)
	i32.const	$60=, 20
	i32.sub 	$81=, $59, $60
	i32.const	$60=, __stack_pointer
	i32.store	$81=, 0($60), $81
	i64.store	$discard=, 0($81):p2align=2, $5
	i32.const	$push43=, 16
	i32.add 	$8=, $81, $pop43
	i32.store	$discard=, 0($8), $0
	i32.const	$push42=, 8
	i32.add 	$8=, $81, $pop42
	i64.store	$3=, 0($8):p2align=2, $4
	i32.const	$push34=, .L.str+11
	call    	f11@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop34
	i32.const	$61=, __stack_pointer
	i32.load	$61=, 0($61)
	i32.const	$62=, 20
	i32.add 	$81=, $61, $62
	i32.const	$62=, __stack_pointer
	i32.store	$81=, 0($62), $81
	i32.const	$63=, __stack_pointer
	i32.load	$63=, 0($63)
	i32.const	$64=, 16
	i32.sub 	$81=, $63, $64
	i32.const	$64=, __stack_pointer
	i32.store	$81=, 0($64), $81
	i64.store	$discard=, 0($81):p2align=2, $2
	i32.const	$push41=, 8
	i32.add 	$8=, $81, $pop41
	i64.store	$discard=, 0($8):p2align=2, $1
	i32.const	$push35=, .L.str+12
	call    	f12@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop35
	i32.const	$65=, __stack_pointer
	i32.load	$65=, 0($65)
	i32.const	$66=, 16
	i32.add 	$81=, $65, $66
	i32.const	$66=, __stack_pointer
	i32.store	$81=, 0($66), $81
	i32.const	$67=, __stack_pointer
	i32.load	$67=, 0($67)
	i32.const	$68=, 12
	i32.sub 	$81=, $67, $68
	i32.const	$68=, __stack_pointer
	i32.store	$81=, 0($68), $81
	i64.store	$discard=, 0($81):p2align=2, $3
	i32.const	$push40=, 8
	i32.add 	$8=, $81, $pop40
	i32.store	$discard=, 0($8), $0
	i32.const	$push36=, .L.str+13
	call    	f13@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop36
	i32.const	$69=, __stack_pointer
	i32.load	$69=, 0($69)
	i32.const	$70=, 12
	i32.add 	$81=, $69, $70
	i32.const	$70=, __stack_pointer
	i32.store	$81=, 0($70), $81
	i32.const	$71=, __stack_pointer
	i32.load	$71=, 0($71)
	i32.const	$72=, 8
	i32.sub 	$81=, $71, $72
	i32.const	$72=, __stack_pointer
	i32.store	$81=, 0($72), $81
	i64.store	$discard=, 0($81):p2align=2, $1
	i32.const	$push37=, .L.str+14
	call    	f14@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop37
	i32.const	$73=, __stack_pointer
	i32.load	$73=, 0($73)
	i32.const	$74=, 8
	i32.add 	$81=, $73, $74
	i32.const	$74=, __stack_pointer
	i32.store	$81=, 0($74), $81
	i32.const	$75=, __stack_pointer
	i32.load	$75=, 0($75)
	i32.const	$76=, 4
	i32.sub 	$81=, $75, $76
	i32.const	$76=, __stack_pointer
	i32.store	$81=, 0($76), $81
	i32.store	$discard=, 0($81), $0
	i32.const	$push38=, .L.str+15
	call    	f15@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop38
	i32.const	$77=, __stack_pointer
	i32.load	$77=, 0($77)
	i32.const	$78=, 4
	i32.add 	$81=, $77, $78
	i32.const	$78=, __stack_pointer
	i32.store	$81=, 0($78), $81
	i32.const	$push39=, 0
	call    	exit@FUNCTION, $pop39
	unreachable
	.endfunc
.Lfunc_end17:
	.size	main, .Lfunc_end17-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.L.str:
	.asciz	"0123456789abcdef"
	.size	.L.str, 17


	.ident	"clang version 3.9.0 "
