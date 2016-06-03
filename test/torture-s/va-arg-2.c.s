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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, __stack_pointer($pop9), $pop13
	tee_local	$push15=, $2=, $pop16
	i32.store	$drop=, 12($pop15), $1
	block
	i32.call	$push0=, strlen@FUNCTION, $0
	i32.const	$push14=, 16
	i32.ne  	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label1
# BB#1:
.LBB1_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load8_u	$push18=, 0($0)
	tee_local	$push17=, $1=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load	$push24=, 12($2)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	$drop=, 12($2), $pop2
	i32.load	$push21=, 0($3)
	tee_local	$push20=, $3=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push3=, $pop20, $pop19
	br_if   	3, $pop3        # 3: down to label1
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$0=, $0, $pop25
	i32.load8_u	$push4=, .L.str($3)
	i32.eq  	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: up to label3
# BB#5:                                 # %if.then5
	end_loop                        # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %while.end
	end_block                       # label2:
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $2, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	return
.LBB1_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $3=, $pop16
	i32.store	$drop=, 12($pop15), $2
	block
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.const	$push1=, 15
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label5
# BB#1:
.LBB2_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.load8_u	$push18=, 0($1)
	tee_local	$push17=, $2=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label6
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.load	$push24=, 12($3)
	tee_local	$push23=, $4=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($3), $pop3
	i32.load	$push21=, 0($4)
	tee_local	$push20=, $4=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label5
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$1=, $1, $pop25
	i32.load8_u	$push5=, .L.str($4)
	i32.eq  	$push6=, $2, $pop5
	br_if   	0, $pop6        # 0: up to label7
# BB#5:                                 # %if.then5
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %while.end
	end_block                       # label6:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $3, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB2_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $4=, $pop16
	i32.store	$drop=, 12($pop15), $3
	block
	i32.call	$push0=, strlen@FUNCTION, $2
	i32.const	$push1=, 14
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label9
# BB#1:
.LBB3_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label11:
	i32.load8_u	$push18=, 0($2)
	tee_local	$push17=, $3=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label10
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.load	$push24=, 12($4)
	tee_local	$push23=, $5=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($4), $pop3
	i32.load	$push21=, 0($5)
	tee_local	$push20=, $5=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label9
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$2=, $2, $pop25
	i32.load8_u	$push5=, .L.str($5)
	i32.eq  	$push6=, $3, $pop5
	br_if   	0, $pop6        # 0: up to label11
# BB#5:                                 # %if.then5
	end_loop                        # label12:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %while.end
	end_block                       # label10:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $4, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB3_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $5=, $pop16
	i32.store	$drop=, 12($pop15), $4
	block
	i32.call	$push0=, strlen@FUNCTION, $3
	i32.const	$push1=, 13
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label13
# BB#1:
.LBB4_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label15:
	i32.load8_u	$push18=, 0($3)
	tee_local	$push17=, $4=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label14
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB4_2 Depth=1
	i32.load	$push24=, 12($5)
	tee_local	$push23=, $6=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($5), $pop3
	i32.load	$push21=, 0($6)
	tee_local	$push20=, $6=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label13
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB4_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$3=, $3, $pop25
	i32.load8_u	$push5=, .L.str($6)
	i32.eq  	$push6=, $4, $pop5
	br_if   	0, $pop6        # 0: up to label15
# BB#5:                                 # %if.then5
	end_loop                        # label16:
	call    	abort@FUNCTION
	unreachable
.LBB4_6:                                # %while.end
	end_block                       # label14:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $5, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB4_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $6=, $pop16
	i32.store	$drop=, 12($pop15), $5
	block
	i32.call	$push0=, strlen@FUNCTION, $4
	i32.const	$push1=, 12
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label17
# BB#1:
.LBB5_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label19:
	i32.load8_u	$push18=, 0($4)
	tee_local	$push17=, $5=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label18
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB5_2 Depth=1
	i32.load	$push24=, 12($6)
	tee_local	$push23=, $7=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($6), $pop3
	i32.load	$push21=, 0($7)
	tee_local	$push20=, $7=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label17
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB5_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$4=, $4, $pop25
	i32.load8_u	$push5=, .L.str($7)
	i32.eq  	$push6=, $5, $pop5
	br_if   	0, $pop6        # 0: up to label19
# BB#5:                                 # %if.then5
	end_loop                        # label20:
	call    	abort@FUNCTION
	unreachable
.LBB5_6:                                # %while.end
	end_block                       # label18:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $6, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB5_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $7=, $pop16
	i32.store	$drop=, 12($pop15), $6
	block
	i32.call	$push0=, strlen@FUNCTION, $5
	i32.const	$push1=, 11
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label21
# BB#1:
.LBB6_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label23:
	i32.load8_u	$push18=, 0($5)
	tee_local	$push17=, $6=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label22
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.load	$push24=, 12($7)
	tee_local	$push23=, $8=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($7), $pop3
	i32.load	$push21=, 0($8)
	tee_local	$push20=, $8=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label21
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$5=, $5, $pop25
	i32.load8_u	$push5=, .L.str($8)
	i32.eq  	$push6=, $6, $pop5
	br_if   	0, $pop6        # 0: up to label23
# BB#5:                                 # %if.then5
	end_loop                        # label24:
	call    	abort@FUNCTION
	unreachable
.LBB6_6:                                # %while.end
	end_block                       # label22:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $7, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB6_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $8=, $pop16
	i32.store	$drop=, 12($pop15), $7
	block
	i32.call	$push0=, strlen@FUNCTION, $6
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label25
# BB#1:
.LBB7_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label27:
	i32.load8_u	$push18=, 0($6)
	tee_local	$push17=, $7=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label26
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB7_2 Depth=1
	i32.load	$push24=, 12($8)
	tee_local	$push23=, $9=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($8), $pop3
	i32.load	$push21=, 0($9)
	tee_local	$push20=, $9=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label25
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB7_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$6=, $6, $pop25
	i32.load8_u	$push5=, .L.str($9)
	i32.eq  	$push6=, $7, $pop5
	br_if   	0, $pop6        # 0: up to label27
# BB#5:                                 # %if.then5
	end_loop                        # label28:
	call    	abort@FUNCTION
	unreachable
.LBB7_6:                                # %while.end
	end_block                       # label26:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $8, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB7_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $9=, $pop16
	i32.store	$drop=, 12($pop15), $8
	block
	i32.call	$push0=, strlen@FUNCTION, $7
	i32.const	$push1=, 9
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label29
# BB#1:
.LBB8_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label31:
	i32.load8_u	$push18=, 0($7)
	tee_local	$push17=, $8=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label30
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB8_2 Depth=1
	i32.load	$push24=, 12($9)
	tee_local	$push23=, $10=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($9), $pop3
	i32.load	$push21=, 0($10)
	tee_local	$push20=, $10=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label29
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB8_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$7=, $7, $pop25
	i32.load8_u	$push5=, .L.str($10)
	i32.eq  	$push6=, $8, $pop5
	br_if   	0, $pop6        # 0: up to label31
# BB#5:                                 # %if.then5
	end_loop                        # label32:
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %while.end
	end_block                       # label30:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $9, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB8_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $10=, $pop16
	i32.store	$drop=, 12($pop15), $9
	block
	i32.call	$push0=, strlen@FUNCTION, $8
	i32.const	$push1=, 8
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label33
# BB#1:
.LBB9_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label35:
	i32.load8_u	$push18=, 0($8)
	tee_local	$push17=, $9=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label34
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB9_2 Depth=1
	i32.load	$push24=, 12($10)
	tee_local	$push23=, $11=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($10), $pop3
	i32.load	$push21=, 0($11)
	tee_local	$push20=, $11=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label33
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB9_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$8=, $8, $pop25
	i32.load8_u	$push5=, .L.str($11)
	i32.eq  	$push6=, $9, $pop5
	br_if   	0, $pop6        # 0: up to label35
# BB#5:                                 # %if.then5
	end_loop                        # label36:
	call    	abort@FUNCTION
	unreachable
.LBB9_6:                                # %while.end
	end_block                       # label34:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $10, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB9_7:                                # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $11=, $pop16
	i32.store	$drop=, 12($pop15), $10
	block
	i32.call	$push0=, strlen@FUNCTION, $9
	i32.const	$push1=, 7
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label37
# BB#1:
.LBB10_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label39:
	i32.load8_u	$push18=, 0($9)
	tee_local	$push17=, $10=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label38
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB10_2 Depth=1
	i32.load	$push24=, 12($11)
	tee_local	$push23=, $12=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($11), $pop3
	i32.load	$push21=, 0($12)
	tee_local	$push20=, $12=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label37
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB10_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$9=, $9, $pop25
	i32.load8_u	$push5=, .L.str($12)
	i32.eq  	$push6=, $10, $pop5
	br_if   	0, $pop6        # 0: up to label39
# BB#5:                                 # %if.then5
	end_loop                        # label40:
	call    	abort@FUNCTION
	unreachable
.LBB10_6:                               # %while.end
	end_block                       # label38:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $11, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB10_7:                               # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $12=, $pop16
	i32.store	$drop=, 12($pop15), $11
	block
	i32.call	$push0=, strlen@FUNCTION, $10
	i32.const	$push1=, 6
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label41
# BB#1:
.LBB11_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label43:
	i32.load8_u	$push18=, 0($10)
	tee_local	$push17=, $11=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label42
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB11_2 Depth=1
	i32.load	$push24=, 12($12)
	tee_local	$push23=, $13=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($12), $pop3
	i32.load	$push21=, 0($13)
	tee_local	$push20=, $13=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label41
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB11_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$10=, $10, $pop25
	i32.load8_u	$push5=, .L.str($13)
	i32.eq  	$push6=, $11, $pop5
	br_if   	0, $pop6        # 0: up to label43
# BB#5:                                 # %if.then5
	end_loop                        # label44:
	call    	abort@FUNCTION
	unreachable
.LBB11_6:                               # %while.end
	end_block                       # label42:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $12, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB11_7:                               # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $13=, $pop16
	i32.store	$drop=, 12($pop15), $12
	block
	i32.call	$push0=, strlen@FUNCTION, $11
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label45
# BB#1:
.LBB12_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label47:
	i32.load8_u	$push18=, 0($11)
	tee_local	$push17=, $12=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label46
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.load	$push24=, 12($13)
	tee_local	$push23=, $14=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($13), $pop3
	i32.load	$push21=, 0($14)
	tee_local	$push20=, $14=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label45
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$11=, $11, $pop25
	i32.load8_u	$push5=, .L.str($14)
	i32.eq  	$push6=, $12, $pop5
	br_if   	0, $pop6        # 0: up to label47
# BB#5:                                 # %if.then5
	end_loop                        # label48:
	call    	abort@FUNCTION
	unreachable
.LBB12_6:                               # %while.end
	end_block                       # label46:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $13, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB12_7:                               # %if.then.i
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, __stack_pointer($pop9), $pop13
	tee_local	$push15=, $14=, $pop16
	i32.store	$drop=, 12($pop15), $13
	block
	i32.call	$push0=, strlen@FUNCTION, $12
	i32.const	$push14=, 4
	i32.ne  	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label49
# BB#1:
.LBB13_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label51:
	i32.load8_u	$push18=, 0($12)
	tee_local	$push17=, $13=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label50
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB13_2 Depth=1
	i32.load	$push24=, 12($14)
	tee_local	$push23=, $15=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	$drop=, 12($14), $pop2
	i32.load	$push21=, 0($15)
	tee_local	$push20=, $15=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push3=, $pop20, $pop19
	br_if   	3, $pop3        # 3: down to label49
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB13_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$12=, $12, $pop25
	i32.load8_u	$push4=, .L.str($15)
	i32.eq  	$push5=, $13, $pop4
	br_if   	0, $pop5        # 0: up to label51
# BB#5:                                 # %if.then5
	end_loop                        # label52:
	call    	abort@FUNCTION
	unreachable
.LBB13_6:                               # %while.end
	end_block                       # label50:
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $14, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	return
.LBB13_7:                               # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $15=, $pop16
	i32.store	$drop=, 12($pop15), $14
	block
	i32.call	$push0=, strlen@FUNCTION, $13
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label53
# BB#1:
.LBB14_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label55:
	i32.load8_u	$push18=, 0($13)
	tee_local	$push17=, $14=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label54
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB14_2 Depth=1
	i32.load	$push24=, 12($15)
	tee_local	$push23=, $16=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($15), $pop3
	i32.load	$push21=, 0($16)
	tee_local	$push20=, $16=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label53
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB14_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$13=, $13, $pop25
	i32.load8_u	$push5=, .L.str($16)
	i32.eq  	$push6=, $14, $pop5
	br_if   	0, $pop6        # 0: up to label55
# BB#5:                                 # %if.then5
	end_loop                        # label56:
	call    	abort@FUNCTION
	unreachable
.LBB14_6:                               # %while.end
	end_block                       # label54:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $15, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB14_7:                               # %if.then.i
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push16=, __stack_pointer($pop10), $pop14
	tee_local	$push15=, $16=, $pop16
	i32.store	$drop=, 12($pop15), $15
	block
	i32.call	$push0=, strlen@FUNCTION, $14
	i32.const	$push1=, 2
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label57
# BB#1:
.LBB15_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label59:
	i32.load8_u	$push18=, 0($14)
	tee_local	$push17=, $15=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label58
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB15_2 Depth=1
	i32.load	$push24=, 12($16)
	tee_local	$push23=, $17=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	$drop=, 12($16), $pop3
	i32.load	$push21=, 0($17)
	tee_local	$push20=, $17=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	3, $pop4        # 3: down to label57
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB15_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$14=, $14, $pop25
	i32.load8_u	$push5=, .L.str($17)
	i32.eq  	$push6=, $15, $pop5
	br_if   	0, $pop6        # 0: up to label59
# BB#5:                                 # %if.then5
	end_loop                        # label60:
	call    	abort@FUNCTION
	unreachable
.LBB15_6:                               # %while.end
	end_block                       # label58:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $16, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	return
.LBB15_7:                               # %if.then.i
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push16=, __stack_pointer($pop9), $pop13
	tee_local	$push15=, $17=, $pop16
	i32.store	$drop=, 12($pop15), $16
	block
	i32.call	$push0=, strlen@FUNCTION, $15
	i32.const	$push14=, 1
	i32.ne  	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label61
# BB#1:
.LBB16_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label63:
	i32.load8_u	$push18=, 0($15)
	tee_local	$push17=, $16=, $pop18
	i32.eqz 	$push26=, $pop17
	br_if   	2, $pop26       # 2: down to label62
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB16_2 Depth=1
	i32.load	$push24=, 12($17)
	tee_local	$push23=, $18=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	$drop=, 12($17), $pop2
	i32.load	$push21=, 0($18)
	tee_local	$push20=, $18=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push3=, $pop20, $pop19
	br_if   	3, $pop3        # 3: down to label61
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB16_2 Depth=1
	i32.const	$push25=, 1
	i32.add 	$15=, $15, $pop25
	i32.load8_u	$push4=, .L.str($18)
	i32.eq  	$push5=, $16, $pop4
	br_if   	0, $pop5        # 0: up to label63
# BB#5:                                 # %if.then5
	end_loop                        # label64:
	call    	abort@FUNCTION
	unreachable
.LBB16_6:                               # %while.end
	end_block                       # label62:
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $17, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	return
.LBB16_7:                               # %if.then.i
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
	i32.const	$push84=, 0
	i32.const	$push81=, 0
	i32.load	$push82=, __stack_pointer($pop81)
	i32.const	$push83=, 640
	i32.sub 	$push199=, $pop82, $pop83
	i32.store	$push237=, __stack_pointer($pop84), $pop199
	tee_local	$push236=, $14=, $pop237
	i32.const	$push85=, 576
	i32.add 	$push86=, $pop236, $pop85
	i32.const	$push0=, 56
	i32.add 	$push1=, $pop86, $pop0
	i64.const	$push2=, 64424509454
	i64.store	$0=, 0($pop1), $pop2
	i32.const	$push87=, 576
	i32.add 	$push88=, $14, $pop87
	i32.const	$push3=, 48
	i32.add 	$push4=, $pop88, $pop3
	i64.const	$push5=, 55834574860
	i64.store	$1=, 0($pop4), $pop5
	i32.const	$push89=, 576
	i32.add 	$push90=, $14, $pop89
	i32.const	$push6=, 40
	i32.add 	$push7=, $pop90, $pop6
	i64.const	$push8=, 47244640266
	i64.store	$2=, 0($pop7), $pop8
	i32.const	$push91=, 576
	i32.add 	$push92=, $14, $pop91
	i32.const	$push9=, 32
	i32.add 	$push10=, $pop92, $pop9
	i64.const	$push11=, 38654705672
	i64.store	$3=, 0($pop10), $pop11
	i32.const	$push93=, 576
	i32.add 	$push94=, $14, $pop93
	i32.const	$push12=, 24
	i32.add 	$push13=, $pop94, $pop12
	i64.const	$push14=, 30064771078
	i64.store	$4=, 0($pop13), $pop14
	i32.const	$push95=, 576
	i32.add 	$push96=, $14, $pop95
	i32.const	$push15=, 16
	i32.add 	$push16=, $pop96, $pop15
	i64.const	$push17=, 21474836484
	i64.store	$5=, 0($pop16), $pop17
	i64.const	$push18=, 12884901890
	i64.store	$6=, 584($14), $pop18
	i64.const	$push19=, 4294967296
	i64.store	$drop=, 576($14), $pop19
	i32.const	$push20=, .L.str
	i32.const	$push97=, 576
	i32.add 	$push98=, $14, $pop97
	call    	f0@FUNCTION, $pop20, $pop98
	i32.const	$push99=, 512
	i32.add 	$push100=, $14, $pop99
	i32.const	$push235=, 56
	i32.add 	$push21=, $pop100, $pop235
	i32.const	$push22=, 15
	i32.store	$7=, 0($pop21), $pop22
	i32.const	$push101=, 512
	i32.add 	$push102=, $14, $pop101
	i32.const	$push234=, 48
	i32.add 	$push23=, $pop102, $pop234
	i64.const	$push24=, 60129542157
	i64.store	$8=, 0($pop23), $pop24
	i32.const	$push103=, 512
	i32.add 	$push104=, $14, $pop103
	i32.const	$push233=, 40
	i32.add 	$push25=, $pop104, $pop233
	i64.const	$push26=, 51539607563
	i64.store	$9=, 0($pop25), $pop26
	i32.const	$push105=, 512
	i32.add 	$push106=, $14, $pop105
	i32.const	$push232=, 32
	i32.add 	$push27=, $pop106, $pop232
	i64.const	$push28=, 42949672969
	i64.store	$10=, 0($pop27), $pop28
	i32.const	$push107=, 512
	i32.add 	$push108=, $14, $pop107
	i32.const	$push231=, 24
	i32.add 	$push29=, $pop108, $pop231
	i64.const	$push30=, 34359738375
	i64.store	$11=, 0($pop29), $pop30
	i32.const	$push109=, 512
	i32.add 	$push110=, $14, $pop109
	i32.const	$push230=, 16
	i32.add 	$push31=, $pop110, $pop230
	i64.const	$push32=, 25769803781
	i64.store	$12=, 0($pop31), $pop32
	i64.const	$push33=, 17179869187
	i64.store	$13=, 520($14), $pop33
	i64.const	$push34=, 8589934593
	i64.store	$drop=, 512($14), $pop34
	i32.const	$push35=, .L.str+1
	i32.const	$push111=, 512
	i32.add 	$push112=, $14, $pop111
	call    	f1@FUNCTION, $14, $pop35, $pop112
	i32.const	$push113=, 448
	i32.add 	$push114=, $14, $pop113
	i32.const	$push229=, 48
	i32.add 	$push36=, $pop114, $pop229
	i64.store	$drop=, 0($pop36), $0
	i32.const	$push115=, 448
	i32.add 	$push116=, $14, $pop115
	i32.const	$push228=, 40
	i32.add 	$push37=, $pop116, $pop228
	i64.store	$drop=, 0($pop37), $1
	i32.const	$push117=, 448
	i32.add 	$push118=, $14, $pop117
	i32.const	$push227=, 32
	i32.add 	$push38=, $pop118, $pop227
	i64.store	$drop=, 0($pop38), $2
	i32.const	$push119=, 448
	i32.add 	$push120=, $14, $pop119
	i32.const	$push226=, 24
	i32.add 	$push39=, $pop120, $pop226
	i64.store	$drop=, 0($pop39), $3
	i32.const	$push121=, 448
	i32.add 	$push122=, $14, $pop121
	i32.const	$push225=, 16
	i32.add 	$push40=, $pop122, $pop225
	i64.store	$drop=, 0($pop40), $4
	i64.store	$drop=, 456($14), $5
	i64.store	$drop=, 448($14), $6
	i32.const	$push41=, .L.str+2
	i32.const	$push123=, 448
	i32.add 	$push124=, $14, $pop123
	call    	f2@FUNCTION, $14, $14, $pop41, $pop124
	i32.const	$push125=, 384
	i32.add 	$push126=, $14, $pop125
	i32.const	$push224=, 48
	i32.add 	$push42=, $pop126, $pop224
	i32.store	$drop=, 0($pop42), $7
	i32.const	$push127=, 384
	i32.add 	$push128=, $14, $pop127
	i32.const	$push223=, 40
	i32.add 	$push43=, $pop128, $pop223
	i64.store	$6=, 0($pop43), $8
	i32.const	$push129=, 384
	i32.add 	$push130=, $14, $pop129
	i32.const	$push222=, 32
	i32.add 	$push44=, $pop130, $pop222
	i64.store	$8=, 0($pop44), $9
	i32.const	$push131=, 384
	i32.add 	$push132=, $14, $pop131
	i32.const	$push221=, 24
	i32.add 	$push45=, $pop132, $pop221
	i64.store	$9=, 0($pop45), $10
	i32.const	$push133=, 384
	i32.add 	$push134=, $14, $pop133
	i32.const	$push220=, 16
	i32.add 	$push46=, $pop134, $pop220
	i64.store	$10=, 0($pop46), $11
	i64.store	$11=, 392($14), $12
	i64.store	$drop=, 384($14), $13
	i32.const	$push47=, .L.str+3
	i32.const	$push135=, 384
	i32.add 	$push136=, $14, $pop135
	call    	f3@FUNCTION, $14, $14, $14, $pop47, $pop136
	i32.const	$push137=, 336
	i32.add 	$push138=, $14, $pop137
	i32.const	$push219=, 40
	i32.add 	$push48=, $pop138, $pop219
	i64.store	$drop=, 0($pop48), $0
	i32.const	$push139=, 336
	i32.add 	$push140=, $14, $pop139
	i32.const	$push218=, 32
	i32.add 	$push49=, $pop140, $pop218
	i64.store	$drop=, 0($pop49), $1
	i32.const	$push141=, 336
	i32.add 	$push142=, $14, $pop141
	i32.const	$push217=, 24
	i32.add 	$push50=, $pop142, $pop217
	i64.store	$drop=, 0($pop50), $2
	i32.const	$push143=, 336
	i32.add 	$push144=, $14, $pop143
	i32.const	$push216=, 16
	i32.add 	$push51=, $pop144, $pop216
	i64.store	$drop=, 0($pop51), $3
	i64.store	$drop=, 344($14), $4
	i64.store	$drop=, 336($14), $5
	i32.const	$push52=, .L.str+4
	i32.const	$push145=, 336
	i32.add 	$push146=, $14, $pop145
	call    	f4@FUNCTION, $14, $14, $14, $14, $pop52, $pop146
	i32.const	$push147=, 288
	i32.add 	$push148=, $14, $pop147
	i32.const	$push215=, 40
	i32.add 	$push53=, $pop148, $pop215
	i32.store	$drop=, 0($pop53), $7
	i32.const	$push149=, 288
	i32.add 	$push150=, $14, $pop149
	i32.const	$push214=, 32
	i32.add 	$push54=, $pop150, $pop214
	i64.store	$5=, 0($pop54), $6
	i32.const	$push151=, 288
	i32.add 	$push152=, $14, $pop151
	i32.const	$push213=, 24
	i32.add 	$push55=, $pop152, $pop213
	i64.store	$6=, 0($pop55), $8
	i32.const	$push153=, 288
	i32.add 	$push154=, $14, $pop153
	i32.const	$push212=, 16
	i32.add 	$push56=, $pop154, $pop212
	i64.store	$8=, 0($pop56), $9
	i64.store	$9=, 296($14), $10
	i64.store	$drop=, 288($14), $11
	i32.const	$push57=, .L.str+5
	i32.const	$push155=, 288
	i32.add 	$push156=, $14, $pop155
	call    	f5@FUNCTION, $14, $14, $14, $14, $14, $pop57, $pop156
	i32.const	$push157=, 240
	i32.add 	$push158=, $14, $pop157
	i32.const	$push211=, 32
	i32.add 	$push58=, $pop158, $pop211
	i64.store	$drop=, 0($pop58), $0
	i32.const	$push159=, 240
	i32.add 	$push160=, $14, $pop159
	i32.const	$push210=, 24
	i32.add 	$push59=, $pop160, $pop210
	i64.store	$drop=, 0($pop59), $1
	i32.const	$push161=, 240
	i32.add 	$push162=, $14, $pop161
	i32.const	$push209=, 16
	i32.add 	$push60=, $pop162, $pop209
	i64.store	$drop=, 0($pop60), $2
	i64.store	$drop=, 248($14), $3
	i64.store	$drop=, 240($14), $4
	i32.const	$push61=, .L.str+6
	i32.const	$push163=, 240
	i32.add 	$push164=, $14, $pop163
	call    	f6@FUNCTION, $14, $14, $14, $14, $14, $14, $pop61, $pop164
	i32.const	$push165=, 192
	i32.add 	$push166=, $14, $pop165
	i32.const	$push208=, 32
	i32.add 	$push62=, $pop166, $pop208
	i32.store	$drop=, 0($pop62), $7
	i32.const	$push167=, 192
	i32.add 	$push168=, $14, $pop167
	i32.const	$push207=, 24
	i32.add 	$push63=, $pop168, $pop207
	i64.store	$4=, 0($pop63), $5
	i32.const	$push169=, 192
	i32.add 	$push170=, $14, $pop169
	i32.const	$push206=, 16
	i32.add 	$push64=, $pop170, $pop206
	i64.store	$5=, 0($pop64), $6
	i64.store	$6=, 200($14), $8
	i64.store	$drop=, 192($14), $9
	i32.const	$push65=, .L.str+7
	i32.const	$push171=, 192
	i32.add 	$push172=, $14, $pop171
	call    	f7@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $pop65, $pop172
	i32.const	$push173=, 160
	i32.add 	$push174=, $14, $pop173
	i32.const	$push205=, 24
	i32.add 	$push66=, $pop174, $pop205
	i64.store	$drop=, 0($pop66), $0
	i32.const	$push175=, 160
	i32.add 	$push176=, $14, $pop175
	i32.const	$push204=, 16
	i32.add 	$push67=, $pop176, $pop204
	i64.store	$drop=, 0($pop67), $1
	i64.store	$drop=, 168($14), $2
	i64.store	$drop=, 160($14), $3
	i32.const	$push68=, .L.str+8
	i32.const	$push177=, 160
	i32.add 	$push178=, $14, $pop177
	call    	f8@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $pop68, $pop178
	i32.const	$push179=, 128
	i32.add 	$push180=, $14, $pop179
	i32.const	$push203=, 24
	i32.add 	$push69=, $pop180, $pop203
	i32.store	$drop=, 0($pop69), $7
	i32.const	$push181=, 128
	i32.add 	$push182=, $14, $pop181
	i32.const	$push202=, 16
	i32.add 	$push70=, $pop182, $pop202
	i64.store	$3=, 0($pop70), $4
	i64.store	$4=, 136($14), $5
	i64.store	$drop=, 128($14), $6
	i32.const	$push71=, .L.str+9
	i32.const	$push183=, 128
	i32.add 	$push184=, $14, $pop183
	call    	f9@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop71, $pop184
	i32.const	$push185=, 96
	i32.add 	$push186=, $14, $pop185
	i32.const	$push201=, 16
	i32.add 	$push72=, $pop186, $pop201
	i64.store	$drop=, 0($pop72), $0
	i64.store	$drop=, 104($14), $1
	i64.store	$drop=, 96($14), $2
	i32.const	$push73=, .L.str+10
	i32.const	$push187=, 96
	i32.add 	$push188=, $14, $pop187
	call    	f10@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop73, $pop188
	i32.const	$push189=, 64
	i32.add 	$push190=, $14, $pop189
	i32.const	$push200=, 16
	i32.add 	$push74=, $pop190, $pop200
	i32.store	$drop=, 0($pop74), $7
	i64.store	$2=, 72($14), $3
	i64.store	$drop=, 64($14), $4
	i32.const	$push75=, .L.str+11
	i32.const	$push191=, 64
	i32.add 	$push192=, $14, $pop191
	call    	f11@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop75, $pop192
	i64.store	$drop=, 56($14), $0
	i64.store	$drop=, 48($14), $1
	i32.const	$push76=, .L.str+12
	i32.const	$push193=, 48
	i32.add 	$push194=, $14, $pop193
	call    	f12@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop76, $pop194
	i32.store	$drop=, 40($14), $7
	i64.store	$drop=, 32($14), $2
	i32.const	$push77=, .L.str+13
	i32.const	$push195=, 32
	i32.add 	$push196=, $14, $pop195
	call    	f13@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop77, $pop196
	i64.store	$drop=, 16($14), $0
	i32.const	$push78=, .L.str+14
	i32.const	$push197=, 16
	i32.add 	$push198=, $14, $pop197
	call    	f14@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop78, $pop198
	i32.store	$drop=, 0($14), $7
	i32.const	$push79=, .L.str+15
	call    	f15@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop79, $14
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
	.functype	abort, void
	.functype	strlen, i32, i32
	.functype	exit, void, i32
