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
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$3=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $3
	i32.store	$discard=, 12($3), $1
	block
	i32.call	$push0=, strlen@FUNCTION, $0
	i32.const	$push6=, 16
	i32.ne  	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label1
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load8_u	$push8=, 0($0)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label2
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push14=, 12($3)
	tee_local	$push13=, $2=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push2=, $pop13, $pop12
	i32.store	$discard=, 12($3), $pop2
	i32.load	$push11=, 0($2)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push3=, $pop10, $pop9
	br_if   	3, $pop3        # 3: down to label1
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$0=, $0, $pop15
	i32.load8_u	$push4=, .L.str($2)
	i32.eq  	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: up to label3
# BB#4:                                 # %if.then5
	end_loop                        # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %while.end
	end_block                       # label2:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $3, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB1_6:                                # %if.then.i
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
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$4=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $4
	i32.store	$discard=, 12($4), $2
	block
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.const	$push1=, 15
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label5
.LBB2_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.load8_u	$push8=, 0($1)
	tee_local	$push7=, $2=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label6
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push14=, 12($4)
	tee_local	$push13=, $3=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($4), $pop3
	i32.load	$push11=, 0($3)
	tee_local	$push10=, $3=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label5
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$1=, $1, $pop15
	i32.load8_u	$push5=, .L.str($3)
	i32.eq  	$push6=, $2, $pop5
	br_if   	0, $pop6        # 0: up to label7
# BB#4:                                 # %if.then5
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %while.end
	end_block                       # label6:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $4, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB2_6:                                # %if.then.i
	end_block                       # label5:
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
	.param  	i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$5=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $5
	i32.store	$discard=, 12($5), $3
	block
	i32.call	$push0=, strlen@FUNCTION, $2
	i32.const	$push1=, 14
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label9
.LBB3_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label11:
	i32.load8_u	$push8=, 0($2)
	tee_local	$push7=, $3=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label10
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.load	$push14=, 12($5)
	tee_local	$push13=, $4=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($5), $pop3
	i32.load	$push11=, 0($4)
	tee_local	$push10=, $4=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label9
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$2=, $2, $pop15
	i32.load8_u	$push5=, .L.str($4)
	i32.eq  	$push6=, $3, $pop5
	br_if   	0, $pop6        # 0: up to label11
# BB#4:                                 # %if.then5
	end_loop                        # label12:
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %while.end
	end_block                       # label10:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $5, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB3_6:                                # %if.then.i
	end_block                       # label9:
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
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$6=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $6
	i32.store	$discard=, 12($6), $4
	block
	i32.call	$push0=, strlen@FUNCTION, $3
	i32.const	$push1=, 13
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label13
.LBB4_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label15:
	i32.load8_u	$push8=, 0($3)
	tee_local	$push7=, $4=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label14
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.load	$push14=, 12($6)
	tee_local	$push13=, $5=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($6), $pop3
	i32.load	$push11=, 0($5)
	tee_local	$push10=, $5=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label13
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB4_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$3=, $3, $pop15
	i32.load8_u	$push5=, .L.str($5)
	i32.eq  	$push6=, $4, $pop5
	br_if   	0, $pop6        # 0: up to label15
# BB#4:                                 # %if.then5
	end_loop                        # label16:
	call    	abort@FUNCTION
	unreachable
.LBB4_5:                                # %while.end
	end_block                       # label14:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $6, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB4_6:                                # %if.then.i
	end_block                       # label13:
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
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$7=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $7
	i32.store	$discard=, 12($7), $5
	block
	i32.call	$push0=, strlen@FUNCTION, $4
	i32.const	$push1=, 12
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label17
.LBB5_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label19:
	i32.load8_u	$push8=, 0($4)
	tee_local	$push7=, $5=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label18
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.load	$push14=, 12($7)
	tee_local	$push13=, $6=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($7), $pop3
	i32.load	$push11=, 0($6)
	tee_local	$push10=, $6=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label17
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB5_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$4=, $4, $pop15
	i32.load8_u	$push5=, .L.str($6)
	i32.eq  	$push6=, $5, $pop5
	br_if   	0, $pop6        # 0: up to label19
# BB#4:                                 # %if.then5
	end_loop                        # label20:
	call    	abort@FUNCTION
	unreachable
.LBB5_5:                                # %while.end
	end_block                       # label18:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $7, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB5_6:                                # %if.then.i
	end_block                       # label17:
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
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$8=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $8
	i32.store	$discard=, 12($8), $6
	block
	i32.call	$push0=, strlen@FUNCTION, $5
	i32.const	$push1=, 11
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label21
.LBB6_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label23:
	i32.load8_u	$push8=, 0($5)
	tee_local	$push7=, $6=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label22
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.load	$push14=, 12($8)
	tee_local	$push13=, $7=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($8), $pop3
	i32.load	$push11=, 0($7)
	tee_local	$push10=, $7=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label21
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB6_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$5=, $5, $pop15
	i32.load8_u	$push5=, .L.str($7)
	i32.eq  	$push6=, $6, $pop5
	br_if   	0, $pop6        # 0: up to label23
# BB#4:                                 # %if.then5
	end_loop                        # label24:
	call    	abort@FUNCTION
	unreachable
.LBB6_5:                                # %while.end
	end_block                       # label22:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $8, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB6_6:                                # %if.then.i
	end_block                       # label21:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$9=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $9
	i32.store	$discard=, 12($9), $7
	block
	i32.call	$push0=, strlen@FUNCTION, $6
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label25
.LBB7_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label27:
	i32.load8_u	$push8=, 0($6)
	tee_local	$push7=, $7=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label26
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.load	$push14=, 12($9)
	tee_local	$push13=, $8=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($9), $pop3
	i32.load	$push11=, 0($8)
	tee_local	$push10=, $8=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label25
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB7_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$6=, $6, $pop15
	i32.load8_u	$push5=, .L.str($8)
	i32.eq  	$push6=, $7, $pop5
	br_if   	0, $pop6        # 0: up to label27
# BB#4:                                 # %if.then5
	end_loop                        # label28:
	call    	abort@FUNCTION
	unreachable
.LBB7_5:                                # %while.end
	end_block                       # label26:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $9, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB7_6:                                # %if.then.i
	end_block                       # label25:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$10=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $10
	i32.store	$discard=, 12($10), $8
	block
	i32.call	$push0=, strlen@FUNCTION, $7
	i32.const	$push1=, 9
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label29
.LBB8_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label31:
	i32.load8_u	$push8=, 0($7)
	tee_local	$push7=, $8=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label30
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.load	$push14=, 12($10)
	tee_local	$push13=, $9=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($10), $pop3
	i32.load	$push11=, 0($9)
	tee_local	$push10=, $9=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label29
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB8_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$7=, $7, $pop15
	i32.load8_u	$push5=, .L.str($9)
	i32.eq  	$push6=, $8, $pop5
	br_if   	0, $pop6        # 0: up to label31
# BB#4:                                 # %if.then5
	end_loop                        # label32:
	call    	abort@FUNCTION
	unreachable
.LBB8_5:                                # %while.end
	end_block                       # label30:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $10, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB8_6:                                # %if.then.i
	end_block                       # label29:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$11=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $11
	i32.store	$discard=, 12($11), $9
	block
	i32.call	$push0=, strlen@FUNCTION, $8
	i32.const	$push1=, 8
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label33
.LBB9_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label35:
	i32.load8_u	$push8=, 0($8)
	tee_local	$push7=, $9=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label34
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.load	$push14=, 12($11)
	tee_local	$push13=, $10=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($11), $pop3
	i32.load	$push11=, 0($10)
	tee_local	$push10=, $10=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label33
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB9_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$8=, $8, $pop15
	i32.load8_u	$push5=, .L.str($10)
	i32.eq  	$push6=, $9, $pop5
	br_if   	0, $pop6        # 0: up to label35
# BB#4:                                 # %if.then5
	end_loop                        # label36:
	call    	abort@FUNCTION
	unreachable
.LBB9_5:                                # %while.end
	end_block                       # label34:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $11, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB9_6:                                # %if.then.i
	end_block                       # label33:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$12=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $12
	i32.store	$discard=, 12($12), $10
	block
	i32.call	$push0=, strlen@FUNCTION, $9
	i32.const	$push1=, 7
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label37
.LBB10_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label39:
	i32.load8_u	$push8=, 0($9)
	tee_local	$push7=, $10=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label38
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.load	$push14=, 12($12)
	tee_local	$push13=, $11=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($12), $pop3
	i32.load	$push11=, 0($11)
	tee_local	$push10=, $11=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label37
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB10_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$9=, $9, $pop15
	i32.load8_u	$push5=, .L.str($11)
	i32.eq  	$push6=, $10, $pop5
	br_if   	0, $pop6        # 0: up to label39
# BB#4:                                 # %if.then5
	end_loop                        # label40:
	call    	abort@FUNCTION
	unreachable
.LBB10_5:                               # %while.end
	end_block                       # label38:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $12, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB10_6:                               # %if.then.i
	end_block                       # label37:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$13=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $13
	i32.store	$discard=, 12($13), $11
	block
	i32.call	$push0=, strlen@FUNCTION, $10
	i32.const	$push1=, 6
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label41
.LBB11_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label43:
	i32.load8_u	$push8=, 0($10)
	tee_local	$push7=, $11=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label42
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB11_1 Depth=1
	i32.load	$push14=, 12($13)
	tee_local	$push13=, $12=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($13), $pop3
	i32.load	$push11=, 0($12)
	tee_local	$push10=, $12=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label41
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB11_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$10=, $10, $pop15
	i32.load8_u	$push5=, .L.str($12)
	i32.eq  	$push6=, $11, $pop5
	br_if   	0, $pop6        # 0: up to label43
# BB#4:                                 # %if.then5
	end_loop                        # label44:
	call    	abort@FUNCTION
	unreachable
.LBB11_5:                               # %while.end
	end_block                       # label42:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $13, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB11_6:                               # %if.then.i
	end_block                       # label41:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$14=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $14
	i32.store	$discard=, 12($14), $12
	block
	i32.call	$push0=, strlen@FUNCTION, $11
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label45
.LBB12_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label47:
	i32.load8_u	$push8=, 0($11)
	tee_local	$push7=, $12=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label46
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.load	$push14=, 12($14)
	tee_local	$push13=, $13=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($14), $pop3
	i32.load	$push11=, 0($13)
	tee_local	$push10=, $13=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label45
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$11=, $11, $pop15
	i32.load8_u	$push5=, .L.str($13)
	i32.eq  	$push6=, $12, $pop5
	br_if   	0, $pop6        # 0: up to label47
# BB#4:                                 # %if.then5
	end_loop                        # label48:
	call    	abort@FUNCTION
	unreachable
.LBB12_5:                               # %while.end
	end_block                       # label46:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $14, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB12_6:                               # %if.then.i
	end_block                       # label45:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$15=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $15
	i32.store	$discard=, 12($15), $13
	block
	i32.call	$push0=, strlen@FUNCTION, $12
	i32.const	$push6=, 4
	i32.ne  	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label49
.LBB13_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label51:
	i32.load8_u	$push8=, 0($12)
	tee_local	$push7=, $13=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label50
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.load	$push14=, 12($15)
	tee_local	$push13=, $14=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push2=, $pop13, $pop12
	i32.store	$discard=, 12($15), $pop2
	i32.load	$push11=, 0($14)
	tee_local	$push10=, $14=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push3=, $pop10, $pop9
	br_if   	3, $pop3        # 3: down to label49
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB13_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$12=, $12, $pop15
	i32.load8_u	$push4=, .L.str($14)
	i32.eq  	$push5=, $13, $pop4
	br_if   	0, $pop5        # 0: up to label51
# BB#4:                                 # %if.then5
	end_loop                        # label52:
	call    	abort@FUNCTION
	unreachable
.LBB13_5:                               # %while.end
	end_block                       # label50:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $15, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB13_6:                               # %if.then.i
	end_block                       # label49:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$16=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $16
	i32.store	$discard=, 12($16), $14
	block
	i32.call	$push0=, strlen@FUNCTION, $13
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label53
.LBB14_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label55:
	i32.load8_u	$push8=, 0($13)
	tee_local	$push7=, $14=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label54
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB14_1 Depth=1
	i32.load	$push14=, 12($16)
	tee_local	$push13=, $15=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($16), $pop3
	i32.load	$push11=, 0($15)
	tee_local	$push10=, $15=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label53
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB14_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$13=, $13, $pop15
	i32.load8_u	$push5=, .L.str($15)
	i32.eq  	$push6=, $14, $pop5
	br_if   	0, $pop6        # 0: up to label55
# BB#4:                                 # %if.then5
	end_loop                        # label56:
	call    	abort@FUNCTION
	unreachable
.LBB14_5:                               # %while.end
	end_block                       # label54:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $16, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB14_6:                               # %if.then.i
	end_block                       # label53:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$17=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $17
	i32.store	$discard=, 12($17), $15
	block
	i32.call	$push0=, strlen@FUNCTION, $14
	i32.const	$push1=, 2
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label57
.LBB15_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label59:
	i32.load8_u	$push8=, 0($14)
	tee_local	$push7=, $15=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label58
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB15_1 Depth=1
	i32.load	$push14=, 12($17)
	tee_local	$push13=, $16=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push3=, $pop13, $pop12
	i32.store	$discard=, 12($17), $pop3
	i32.load	$push11=, 0($16)
	tee_local	$push10=, $16=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label57
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB15_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$14=, $14, $pop15
	i32.load8_u	$push5=, .L.str($16)
	i32.eq  	$push6=, $15, $pop5
	br_if   	0, $pop6        # 0: up to label59
# BB#4:                                 # %if.then5
	end_loop                        # label60:
	call    	abort@FUNCTION
	unreachable
.LBB15_5:                               # %while.end
	end_block                       # label58:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $17, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB15_6:                               # %if.then.i
	end_block                       # label57:
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
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$18=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $18
	i32.store	$discard=, 12($18), $16
	block
	i32.call	$push0=, strlen@FUNCTION, $15
	i32.const	$push6=, 1
	i32.ne  	$push1=, $pop0, $pop6
	br_if   	0, $pop1        # 0: down to label61
.LBB16_1:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label63:
	i32.load8_u	$push8=, 0($15)
	tee_local	$push7=, $16=, $pop8
	i32.const	$push23=, 0
	i32.eq  	$push24=, $pop7, $pop23
	br_if   	2, $pop24       # 2: down to label62
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB16_1 Depth=1
	i32.load	$push14=, 12($18)
	tee_local	$push13=, $17=, $pop14
	i32.const	$push12=, 4
	i32.add 	$push2=, $pop13, $pop12
	i32.store	$discard=, 12($18), $pop2
	i32.load	$push11=, 0($17)
	tee_local	$push10=, $17=, $pop11
	i32.const	$push9=, 16
	i32.ge_u	$push3=, $pop10, $pop9
	br_if   	3, $pop3        # 3: down to label61
# BB#3:                                 # %to_hex.exit
                                        #   in Loop: Header=BB16_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$15=, $15, $pop15
	i32.load8_u	$push4=, .L.str($17)
	i32.eq  	$push5=, $16, $pop4
	br_if   	0, $pop5        # 0: up to label63
# BB#4:                                 # %if.then5
	end_loop                        # label64:
	call    	abort@FUNCTION
	unreachable
.LBB16_5:                               # %while.end
	end_block                       # label62:
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 16
	i32.add 	$push21=, $18, $pop20
	i32.store	$discard=, 0($pop22), $pop21
	return
.LBB16_6:                               # %if.then.i
	end_block                       # label61:
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
	.local  	i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push117=, __stack_pointer
	i32.load	$push118=, 0($pop117)
	i32.const	$push119=, 640
	i32.sub 	$14=, $pop118, $pop119
	i32.const	$push120=, __stack_pointer
	i32.store	$discard=, 0($pop120), $14
	i32.const	$push121=, 576
	i32.add 	$push122=, $14, $pop121
	i32.const	$push0=, 56
	i32.add 	$push1=, $pop122, $pop0
	i64.const	$push2=, 64424509454
	i64.store	$0=, 0($pop1), $pop2
	i32.const	$push123=, 576
	i32.add 	$push124=, $14, $pop123
	i32.const	$push3=, 48
	i32.add 	$push4=, $pop124, $pop3
	i64.const	$push5=, 55834574860
	i64.store	$1=, 0($pop4), $pop5
	i32.const	$push125=, 576
	i32.add 	$push126=, $14, $pop125
	i32.const	$push6=, 40
	i32.add 	$push7=, $pop126, $pop6
	i64.const	$push8=, 47244640266
	i64.store	$2=, 0($pop7), $pop8
	i32.const	$push127=, 576
	i32.add 	$push128=, $14, $pop127
	i32.const	$push9=, 32
	i32.add 	$push10=, $pop128, $pop9
	i64.const	$push11=, 38654705672
	i64.store	$3=, 0($pop10), $pop11
	i32.const	$push129=, 576
	i32.add 	$push130=, $14, $pop129
	i32.const	$push12=, 24
	i32.add 	$push13=, $pop130, $pop12
	i64.const	$push14=, 30064771078
	i64.store	$4=, 0($pop13), $pop14
	i32.const	$push131=, 576
	i32.add 	$push132=, $14, $pop131
	i32.const	$push15=, 16
	i32.add 	$push16=, $pop132, $pop15
	i64.const	$push17=, 21474836484
	i64.store	$5=, 0($pop16), $pop17
	i64.const	$push18=, 12884901890
	i64.store	$6=, 584($14), $pop18
	i64.const	$push19=, 4294967296
	i64.store	$discard=, 576($14), $pop19
	i32.const	$push20=, .L.str
	i32.const	$push133=, 576
	i32.add 	$push134=, $14, $pop133
	call    	f0@FUNCTION, $pop20, $pop134
	i32.const	$push135=, 512
	i32.add 	$push136=, $14, $pop135
	i32.const	$push116=, 56
	i32.add 	$push21=, $pop136, $pop116
	i32.const	$push22=, 15
	i32.store	$7=, 0($pop21), $pop22
	i32.const	$push137=, 512
	i32.add 	$push138=, $14, $pop137
	i32.const	$push115=, 48
	i32.add 	$push23=, $pop138, $pop115
	i64.const	$push24=, 60129542157
	i64.store	$8=, 0($pop23), $pop24
	i32.const	$push139=, 512
	i32.add 	$push140=, $14, $pop139
	i32.const	$push114=, 40
	i32.add 	$push25=, $pop140, $pop114
	i64.const	$push26=, 51539607563
	i64.store	$9=, 0($pop25), $pop26
	i32.const	$push141=, 512
	i32.add 	$push142=, $14, $pop141
	i32.const	$push113=, 32
	i32.add 	$push27=, $pop142, $pop113
	i64.const	$push28=, 42949672969
	i64.store	$10=, 0($pop27), $pop28
	i32.const	$push143=, 512
	i32.add 	$push144=, $14, $pop143
	i32.const	$push112=, 24
	i32.add 	$push29=, $pop144, $pop112
	i64.const	$push30=, 34359738375
	i64.store	$11=, 0($pop29), $pop30
	i32.const	$push145=, 512
	i32.add 	$push146=, $14, $pop145
	i32.const	$push111=, 16
	i32.add 	$push31=, $pop146, $pop111
	i64.const	$push32=, 25769803781
	i64.store	$12=, 0($pop31), $pop32
	i64.const	$push33=, 17179869187
	i64.store	$13=, 520($14), $pop33
	i64.const	$push34=, 8589934593
	i64.store	$discard=, 512($14), $pop34
	i32.const	$push35=, .L.str+1
	i32.const	$push147=, 512
	i32.add 	$push148=, $14, $pop147
	call    	f1@FUNCTION, $7, $pop35, $pop148
	i32.const	$push149=, 448
	i32.add 	$push150=, $14, $pop149
	i32.const	$push110=, 48
	i32.add 	$push36=, $pop150, $pop110
	i64.store	$discard=, 0($pop36), $0
	i32.const	$push151=, 448
	i32.add 	$push152=, $14, $pop151
	i32.const	$push109=, 40
	i32.add 	$push37=, $pop152, $pop109
	i64.store	$discard=, 0($pop37), $1
	i32.const	$push153=, 448
	i32.add 	$push154=, $14, $pop153
	i32.const	$push108=, 32
	i32.add 	$push38=, $pop154, $pop108
	i64.store	$discard=, 0($pop38), $2
	i32.const	$push155=, 448
	i32.add 	$push156=, $14, $pop155
	i32.const	$push107=, 24
	i32.add 	$push39=, $pop156, $pop107
	i64.store	$discard=, 0($pop39), $3
	i32.const	$push157=, 448
	i32.add 	$push158=, $14, $pop157
	i32.const	$push106=, 16
	i32.add 	$push40=, $pop158, $pop106
	i64.store	$discard=, 0($pop40), $4
	i64.store	$discard=, 456($14), $5
	i64.store	$discard=, 448($14), $6
	i32.const	$push41=, .L.str+2
	i32.const	$push159=, 448
	i32.add 	$push160=, $14, $pop159
	call    	f2@FUNCTION, $7, $7, $pop41, $pop160
	i32.const	$push161=, 384
	i32.add 	$push162=, $14, $pop161
	i32.const	$push105=, 48
	i32.add 	$push42=, $pop162, $pop105
	i32.store	$discard=, 0($pop42), $7
	i32.const	$push163=, 384
	i32.add 	$push164=, $14, $pop163
	i32.const	$push104=, 40
	i32.add 	$push43=, $pop164, $pop104
	i64.store	$6=, 0($pop43), $8
	i32.const	$push165=, 384
	i32.add 	$push166=, $14, $pop165
	i32.const	$push103=, 32
	i32.add 	$push44=, $pop166, $pop103
	i64.store	$8=, 0($pop44), $9
	i32.const	$push167=, 384
	i32.add 	$push168=, $14, $pop167
	i32.const	$push102=, 24
	i32.add 	$push45=, $pop168, $pop102
	i64.store	$9=, 0($pop45), $10
	i32.const	$push169=, 384
	i32.add 	$push170=, $14, $pop169
	i32.const	$push101=, 16
	i32.add 	$push46=, $pop170, $pop101
	i64.store	$10=, 0($pop46), $11
	i64.store	$11=, 392($14), $12
	i64.store	$discard=, 384($14), $13
	i32.const	$push47=, .L.str+3
	i32.const	$push171=, 384
	i32.add 	$push172=, $14, $pop171
	call    	f3@FUNCTION, $7, $7, $7, $pop47, $pop172
	i32.const	$push173=, 336
	i32.add 	$push174=, $14, $pop173
	i32.const	$push100=, 40
	i32.add 	$push48=, $pop174, $pop100
	i64.store	$discard=, 0($pop48), $0
	i32.const	$push175=, 336
	i32.add 	$push176=, $14, $pop175
	i32.const	$push99=, 32
	i32.add 	$push49=, $pop176, $pop99
	i64.store	$discard=, 0($pop49), $1
	i32.const	$push177=, 336
	i32.add 	$push178=, $14, $pop177
	i32.const	$push98=, 24
	i32.add 	$push50=, $pop178, $pop98
	i64.store	$discard=, 0($pop50), $2
	i32.const	$push179=, 336
	i32.add 	$push180=, $14, $pop179
	i32.const	$push97=, 16
	i32.add 	$push51=, $pop180, $pop97
	i64.store	$discard=, 0($pop51), $3
	i64.store	$discard=, 344($14), $4
	i64.store	$discard=, 336($14), $5
	i32.const	$push52=, .L.str+4
	i32.const	$push181=, 336
	i32.add 	$push182=, $14, $pop181
	call    	f4@FUNCTION, $7, $7, $7, $7, $pop52, $pop182
	i32.const	$push183=, 288
	i32.add 	$push184=, $14, $pop183
	i32.const	$push96=, 40
	i32.add 	$push53=, $pop184, $pop96
	i32.store	$discard=, 0($pop53), $7
	i32.const	$push185=, 288
	i32.add 	$push186=, $14, $pop185
	i32.const	$push95=, 32
	i32.add 	$push54=, $pop186, $pop95
	i64.store	$5=, 0($pop54), $6
	i32.const	$push187=, 288
	i32.add 	$push188=, $14, $pop187
	i32.const	$push94=, 24
	i32.add 	$push55=, $pop188, $pop94
	i64.store	$6=, 0($pop55), $8
	i32.const	$push189=, 288
	i32.add 	$push190=, $14, $pop189
	i32.const	$push93=, 16
	i32.add 	$push56=, $pop190, $pop93
	i64.store	$8=, 0($pop56), $9
	i64.store	$9=, 296($14), $10
	i64.store	$discard=, 288($14), $11
	i32.const	$push57=, .L.str+5
	i32.const	$push191=, 288
	i32.add 	$push192=, $14, $pop191
	call    	f5@FUNCTION, $7, $7, $7, $7, $7, $pop57, $pop192
	i32.const	$push193=, 240
	i32.add 	$push194=, $14, $pop193
	i32.const	$push92=, 32
	i32.add 	$push58=, $pop194, $pop92
	i64.store	$discard=, 0($pop58), $0
	i32.const	$push195=, 240
	i32.add 	$push196=, $14, $pop195
	i32.const	$push91=, 24
	i32.add 	$push59=, $pop196, $pop91
	i64.store	$discard=, 0($pop59), $1
	i32.const	$push197=, 240
	i32.add 	$push198=, $14, $pop197
	i32.const	$push90=, 16
	i32.add 	$push60=, $pop198, $pop90
	i64.store	$discard=, 0($pop60), $2
	i64.store	$discard=, 248($14), $3
	i64.store	$discard=, 240($14), $4
	i32.const	$push61=, .L.str+6
	i32.const	$push199=, 240
	i32.add 	$push200=, $14, $pop199
	call    	f6@FUNCTION, $7, $7, $7, $7, $7, $7, $pop61, $pop200
	i32.const	$push201=, 192
	i32.add 	$push202=, $14, $pop201
	i32.const	$push89=, 32
	i32.add 	$push62=, $pop202, $pop89
	i32.store	$discard=, 0($pop62), $7
	i32.const	$push203=, 192
	i32.add 	$push204=, $14, $pop203
	i32.const	$push88=, 24
	i32.add 	$push63=, $pop204, $pop88
	i64.store	$4=, 0($pop63), $5
	i32.const	$push205=, 192
	i32.add 	$push206=, $14, $pop205
	i32.const	$push87=, 16
	i32.add 	$push64=, $pop206, $pop87
	i64.store	$5=, 0($pop64), $6
	i64.store	$6=, 200($14), $8
	i64.store	$discard=, 192($14), $9
	i32.const	$push65=, .L.str+7
	i32.const	$push207=, 192
	i32.add 	$push208=, $14, $pop207
	call    	f7@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $pop65, $pop208
	i32.const	$push209=, 160
	i32.add 	$push210=, $14, $pop209
	i32.const	$push86=, 24
	i32.add 	$push66=, $pop210, $pop86
	i64.store	$discard=, 0($pop66), $0
	i32.const	$push211=, 160
	i32.add 	$push212=, $14, $pop211
	i32.const	$push85=, 16
	i32.add 	$push67=, $pop212, $pop85
	i64.store	$discard=, 0($pop67), $1
	i64.store	$discard=, 168($14), $2
	i64.store	$discard=, 160($14), $3
	i32.const	$push68=, .L.str+8
	i32.const	$push213=, 160
	i32.add 	$push214=, $14, $pop213
	call    	f8@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $pop68, $pop214
	i32.const	$push215=, 128
	i32.add 	$push216=, $14, $pop215
	i32.const	$push84=, 24
	i32.add 	$push69=, $pop216, $pop84
	i32.store	$discard=, 0($pop69), $7
	i32.const	$push217=, 128
	i32.add 	$push218=, $14, $pop217
	i32.const	$push83=, 16
	i32.add 	$push70=, $pop218, $pop83
	i64.store	$3=, 0($pop70), $4
	i64.store	$4=, 136($14), $5
	i64.store	$discard=, 128($14), $6
	i32.const	$push71=, .L.str+9
	i32.const	$push219=, 128
	i32.add 	$push220=, $14, $pop219
	call    	f9@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop71, $pop220
	i32.const	$push221=, 96
	i32.add 	$push222=, $14, $pop221
	i32.const	$push82=, 16
	i32.add 	$push72=, $pop222, $pop82
	i64.store	$discard=, 0($pop72), $0
	i64.store	$discard=, 104($14), $1
	i64.store	$discard=, 96($14), $2
	i32.const	$push73=, .L.str+10
	i32.const	$push223=, 96
	i32.add 	$push224=, $14, $pop223
	call    	f10@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop73, $pop224
	i32.const	$push225=, 64
	i32.add 	$push226=, $14, $pop225
	i32.const	$push81=, 16
	i32.add 	$push74=, $pop226, $pop81
	i32.store	$discard=, 0($pop74), $7
	i64.store	$2=, 72($14), $3
	i64.store	$discard=, 64($14), $4
	i32.const	$push75=, .L.str+11
	i32.const	$push227=, 64
	i32.add 	$push228=, $14, $pop227
	call    	f11@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop75, $pop228
	i64.store	$discard=, 56($14), $0
	i64.store	$discard=, 48($14), $1
	i32.const	$push76=, .L.str+12
	i32.const	$push229=, 48
	i32.add 	$push230=, $14, $pop229
	call    	f12@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop76, $pop230
	i32.store	$discard=, 40($14), $7
	i64.store	$discard=, 32($14), $2
	i32.const	$push77=, .L.str+13
	i32.const	$push231=, 32
	i32.add 	$push232=, $14, $pop231
	call    	f13@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop77, $pop232
	i64.store	$discard=, 16($14), $0
	i32.const	$push78=, .L.str+14
	i32.const	$push233=, 16
	i32.add 	$push234=, $14, $pop233
	call    	f14@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop78, $pop234
	i32.store	$discard=, 0($14), $7
	i32.const	$push79=, .L.str+15
	call    	f15@FUNCTION, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $pop79, $14
	i32.const	$push80=, 0
	call    	exit@FUNCTION, $pop80
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
