	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-2.c"
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
	i32.const	$push2=, .L.str
	i32.add 	$push3=, $0, $pop2
	i32.load8_s	$push4=, 0($pop3)
	return  	$pop4
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push16=, $pop8, $pop9
	tee_local	$push15=, $3=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.store	12($3), $1
	block   	
	i32.call	$push0=, strlen@FUNCTION, $0
	i32.const	$push14=, 16
	i32.ne  	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label1
# BB#1:
.LBB1_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.load8_u	$push18=, 0($0)
	tee_local	$push17=, $1=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load	$push24=, 12($3)
	tee_local	$push23=, $2=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	12($3), $pop2
	i32.load	$push21=, 0($2)
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push3=, $pop20, $pop19
	br_if   	2, $pop3        # 2: down to label1
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$0=, $0, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push4=, $2, $pop25
	i32.load8_u	$push5=, 0($pop4)
	i32.eq  	$push6=, $1, $pop5
	br_if   	0, $pop6        # 0: up to label3
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %while.end
	end_block                       # label2:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $3, $pop11
	i32.store	__stack_pointer($pop13), $pop12
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $4=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($4), $2
	block   	
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.const	$push1=, 15
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label4
# BB#1:
.LBB2_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label6:
	i32.load8_u	$push18=, 0($1)
	tee_local	$push17=, $2=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label5
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.load	$push24=, 12($4)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($4), $pop3
	i32.load	$push21=, 0($3)
	tee_local	$push20=, $3=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label4
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$1=, $1, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $3, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $2, $pop6
	br_if   	0, $pop7        # 0: up to label6
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %while.end
	end_block                       # label5:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $4, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB2_7:                                # %if.then.i
	end_block                       # label4:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $5=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($5), $3
	block   	
	i32.call	$push0=, strlen@FUNCTION, $2
	i32.const	$push1=, 14
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label7
# BB#1:
.LBB3_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label9:
	i32.load8_u	$push18=, 0($2)
	tee_local	$push17=, $3=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label8
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.load	$push24=, 12($5)
	tee_local	$push23=, $4=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($5), $pop3
	i32.load	$push21=, 0($4)
	tee_local	$push20=, $4=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label7
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$2=, $2, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $4, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: up to label9
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %while.end
	end_block                       # label8:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $5, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB3_7:                                # %if.then.i
	end_block                       # label7:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $6=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($6), $4
	block   	
	i32.call	$push0=, strlen@FUNCTION, $3
	i32.const	$push1=, 13
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label10
# BB#1:
.LBB4_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label12:
	i32.load8_u	$push18=, 0($3)
	tee_local	$push17=, $4=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label11
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB4_2 Depth=1
	i32.load	$push24=, 12($6)
	tee_local	$push23=, $5=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($6), $pop3
	i32.load	$push21=, 0($5)
	tee_local	$push20=, $5=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label10
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB4_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$3=, $3, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $5, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $4, $pop6
	br_if   	0, $pop7        # 0: up to label12
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB4_6:                                # %while.end
	end_block                       # label11:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $6, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB4_7:                                # %if.then.i
	end_block                       # label10:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $7=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($7), $5
	block   	
	i32.call	$push0=, strlen@FUNCTION, $4
	i32.const	$push1=, 12
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label13
# BB#1:
.LBB5_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label15:
	i32.load8_u	$push18=, 0($4)
	tee_local	$push17=, $5=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label14
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB5_2 Depth=1
	i32.load	$push24=, 12($7)
	tee_local	$push23=, $6=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($7), $pop3
	i32.load	$push21=, 0($6)
	tee_local	$push20=, $6=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label13
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB5_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$4=, $4, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $6, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $5, $pop6
	br_if   	0, $pop7        # 0: up to label15
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB5_6:                                # %while.end
	end_block                       # label14:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $7, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB5_7:                                # %if.then.i
	end_block                       # label13:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $8=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($8), $6
	block   	
	i32.call	$push0=, strlen@FUNCTION, $5
	i32.const	$push1=, 11
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label16
# BB#1:
.LBB6_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label18:
	i32.load8_u	$push18=, 0($5)
	tee_local	$push17=, $6=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label17
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.load	$push24=, 12($8)
	tee_local	$push23=, $7=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($8), $pop3
	i32.load	$push21=, 0($7)
	tee_local	$push20=, $7=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label16
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB6_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$5=, $5, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $7, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $6, $pop6
	br_if   	0, $pop7        # 0: up to label18
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB6_6:                                # %while.end
	end_block                       # label17:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $8, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB6_7:                                # %if.then.i
	end_block                       # label16:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $9=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($9), $7
	block   	
	i32.call	$push0=, strlen@FUNCTION, $6
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label19
# BB#1:
.LBB7_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label21:
	i32.load8_u	$push18=, 0($6)
	tee_local	$push17=, $7=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label20
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB7_2 Depth=1
	i32.load	$push24=, 12($9)
	tee_local	$push23=, $8=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($9), $pop3
	i32.load	$push21=, 0($8)
	tee_local	$push20=, $8=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label19
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB7_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$6=, $6, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $8, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $7, $pop6
	br_if   	0, $pop7        # 0: up to label21
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB7_6:                                # %while.end
	end_block                       # label20:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $9, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB7_7:                                # %if.then.i
	end_block                       # label19:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $10=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($10), $8
	block   	
	i32.call	$push0=, strlen@FUNCTION, $7
	i32.const	$push1=, 9
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label22
# BB#1:
.LBB8_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label24:
	i32.load8_u	$push18=, 0($7)
	tee_local	$push17=, $8=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label23
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB8_2 Depth=1
	i32.load	$push24=, 12($10)
	tee_local	$push23=, $9=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($10), $pop3
	i32.load	$push21=, 0($9)
	tee_local	$push20=, $9=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label22
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB8_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$7=, $7, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $9, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $8, $pop6
	br_if   	0, $pop7        # 0: up to label24
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %while.end
	end_block                       # label23:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $10, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB8_7:                                # %if.then.i
	end_block                       # label22:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $11=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($11), $9
	block   	
	i32.call	$push0=, strlen@FUNCTION, $8
	i32.const	$push1=, 8
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label25
# BB#1:
.LBB9_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label27:
	i32.load8_u	$push18=, 0($8)
	tee_local	$push17=, $9=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label26
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB9_2 Depth=1
	i32.load	$push24=, 12($11)
	tee_local	$push23=, $10=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($11), $pop3
	i32.load	$push21=, 0($10)
	tee_local	$push20=, $10=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label25
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB9_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$8=, $8, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $10, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $9, $pop6
	br_if   	0, $pop7        # 0: up to label27
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB9_6:                                # %while.end
	end_block                       # label26:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $11, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB9_7:                                # %if.then.i
	end_block                       # label25:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $12=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($12), $10
	block   	
	i32.call	$push0=, strlen@FUNCTION, $9
	i32.const	$push1=, 7
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label28
# BB#1:
.LBB10_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label30:
	i32.load8_u	$push18=, 0($9)
	tee_local	$push17=, $10=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label29
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB10_2 Depth=1
	i32.load	$push24=, 12($12)
	tee_local	$push23=, $11=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($12), $pop3
	i32.load	$push21=, 0($11)
	tee_local	$push20=, $11=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label28
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB10_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$9=, $9, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $11, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $10, $pop6
	br_if   	0, $pop7        # 0: up to label30
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB10_6:                               # %while.end
	end_block                       # label29:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $12, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB10_7:                               # %if.then.i
	end_block                       # label28:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $13=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($13), $11
	block   	
	i32.call	$push0=, strlen@FUNCTION, $10
	i32.const	$push1=, 6
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label31
# BB#1:
.LBB11_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label33:
	i32.load8_u	$push18=, 0($10)
	tee_local	$push17=, $11=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label32
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB11_2 Depth=1
	i32.load	$push24=, 12($13)
	tee_local	$push23=, $12=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($13), $pop3
	i32.load	$push21=, 0($12)
	tee_local	$push20=, $12=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label31
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB11_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$10=, $10, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $12, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $11, $pop6
	br_if   	0, $pop7        # 0: up to label33
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB11_6:                               # %while.end
	end_block                       # label32:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $13, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB11_7:                               # %if.then.i
	end_block                       # label31:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $14=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($14), $12
	block   	
	i32.call	$push0=, strlen@FUNCTION, $11
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label34
# BB#1:
.LBB12_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label36:
	i32.load8_u	$push18=, 0($11)
	tee_local	$push17=, $12=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label35
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.load	$push24=, 12($14)
	tee_local	$push23=, $13=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($14), $pop3
	i32.load	$push21=, 0($13)
	tee_local	$push20=, $13=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label34
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB12_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$11=, $11, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $13, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $12, $pop6
	br_if   	0, $pop7        # 0: up to label36
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB12_6:                               # %while.end
	end_block                       # label35:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $14, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB12_7:                               # %if.then.i
	end_block                       # label34:
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push16=, $pop8, $pop9
	tee_local	$push15=, $15=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.store	12($15), $13
	block   	
	i32.call	$push0=, strlen@FUNCTION, $12
	i32.const	$push14=, 4
	i32.ne  	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label37
# BB#1:
.LBB13_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label39:
	i32.load8_u	$push18=, 0($12)
	tee_local	$push17=, $13=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label38
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB13_2 Depth=1
	i32.load	$push24=, 12($15)
	tee_local	$push23=, $14=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	12($15), $pop2
	i32.load	$push21=, 0($14)
	tee_local	$push20=, $14=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push3=, $pop20, $pop19
	br_if   	2, $pop3        # 2: down to label37
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB13_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$12=, $12, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push4=, $14, $pop25
	i32.load8_u	$push5=, 0($pop4)
	i32.eq  	$push6=, $13, $pop5
	br_if   	0, $pop6        # 0: up to label39
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB13_6:                               # %while.end
	end_block                       # label38:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $15, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB13_7:                               # %if.then.i
	end_block                       # label37:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $16=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($16), $14
	block   	
	i32.call	$push0=, strlen@FUNCTION, $13
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label40
# BB#1:
.LBB14_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label42:
	i32.load8_u	$push18=, 0($13)
	tee_local	$push17=, $14=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label41
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB14_2 Depth=1
	i32.load	$push24=, 12($16)
	tee_local	$push23=, $15=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($16), $pop3
	i32.load	$push21=, 0($15)
	tee_local	$push20=, $15=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label40
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB14_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$13=, $13, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $15, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $14, $pop6
	br_if   	0, $pop7        # 0: up to label42
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB14_6:                               # %while.end
	end_block                       # label41:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $16, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB14_7:                               # %if.then.i
	end_block                       # label40:
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $17=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i32.store	12($17), $15
	block   	
	i32.call	$push0=, strlen@FUNCTION, $14
	i32.const	$push1=, 2
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label43
# BB#1:
.LBB15_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label45:
	i32.load8_u	$push18=, 0($14)
	tee_local	$push17=, $15=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label44
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB15_2 Depth=1
	i32.load	$push24=, 12($17)
	tee_local	$push23=, $16=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push3=, $pop23, $pop22
	i32.store	12($17), $pop3
	i32.load	$push21=, 0($16)
	tee_local	$push20=, $16=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push4=, $pop20, $pop19
	br_if   	2, $pop4        # 2: down to label43
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB15_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$14=, $14, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push5=, $16, $pop25
	i32.load8_u	$push6=, 0($pop5)
	i32.eq  	$push7=, $15, $pop6
	br_if   	0, $pop7        # 0: up to label45
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB15_6:                               # %while.end
	end_block                       # label44:
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $17, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB15_7:                               # %if.then.i
	end_block                       # label43:
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push16=, $pop8, $pop9
	tee_local	$push15=, $18=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.store	12($18), $16
	block   	
	i32.call	$push0=, strlen@FUNCTION, $15
	i32.const	$push14=, 1
	i32.ne  	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label46
# BB#1:
.LBB16_2:                               # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label48:
	i32.load8_u	$push18=, 0($15)
	tee_local	$push17=, $16=, $pop18
	i32.eqz 	$push27=, $pop17
	br_if   	1, $pop27       # 1: down to label47
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB16_2 Depth=1
	i32.load	$push24=, 12($18)
	tee_local	$push23=, $17=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push2=, $pop23, $pop22
	i32.store	12($18), $pop2
	i32.load	$push21=, 0($17)
	tee_local	$push20=, $17=, $pop21
	i32.const	$push19=, 16
	i32.ge_u	$push3=, $pop20, $pop19
	br_if   	2, $pop3        # 2: down to label46
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB16_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$15=, $15, $pop26
	i32.const	$push25=, .L.str
	i32.add 	$push4=, $17, $pop25
	i32.load8_u	$push5=, 0($pop4)
	i32.eq  	$push6=, $16, $pop5
	br_if   	0, $pop6        # 0: up to label48
# BB#5:                                 # %if.then5
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB16_6:                               # %while.end
	end_block                       # label47:
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $18, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB16_7:                               # %if.then.i
	end_block                       # label46:
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push84=, 0
	i32.const	$push81=, 0
	i32.load	$push82=, __stack_pointer($pop81)
	i32.const	$push83=, 640
	i32.sub 	$push292=, $pop82, $pop83
	tee_local	$push291=, $0=, $pop292
	i32.store	__stack_pointer($pop84), $pop291
	i32.const	$push85=, 576
	i32.add 	$push86=, $0, $pop85
	i32.const	$push0=, 56
	i32.add 	$push1=, $pop86, $pop0
	i64.const	$push2=, 64424509454
	i64.store	0($pop1), $pop2
	i32.const	$push87=, 576
	i32.add 	$push88=, $0, $pop87
	i32.const	$push3=, 48
	i32.add 	$push4=, $pop88, $pop3
	i64.const	$push5=, 55834574860
	i64.store	0($pop4), $pop5
	i32.const	$push89=, 576
	i32.add 	$push90=, $0, $pop89
	i32.const	$push6=, 40
	i32.add 	$push7=, $pop90, $pop6
	i64.const	$push8=, 47244640266
	i64.store	0($pop7), $pop8
	i32.const	$push91=, 576
	i32.add 	$push92=, $0, $pop91
	i32.const	$push9=, 32
	i32.add 	$push10=, $pop92, $pop9
	i64.const	$push11=, 38654705672
	i64.store	0($pop10), $pop11
	i32.const	$push93=, 576
	i32.add 	$push94=, $0, $pop93
	i32.const	$push12=, 24
	i32.add 	$push13=, $pop94, $pop12
	i64.const	$push14=, 30064771078
	i64.store	0($pop13), $pop14
	i32.const	$push95=, 576
	i32.add 	$push96=, $0, $pop95
	i32.const	$push15=, 16
	i32.add 	$push16=, $pop96, $pop15
	i64.const	$push17=, 21474836484
	i64.store	0($pop16), $pop17
	i64.const	$push18=, 12884901890
	i64.store	584($0), $pop18
	i64.const	$push19=, 4294967296
	i64.store	576($0), $pop19
	i32.const	$push20=, .L.str
	i32.const	$push97=, 576
	i32.add 	$push98=, $0, $pop97
	call    	f0@FUNCTION, $pop20, $pop98
	i32.const	$push99=, 512
	i32.add 	$push100=, $0, $pop99
	i32.const	$push290=, 56
	i32.add 	$push21=, $pop100, $pop290
	i32.const	$push22=, 15
	i32.store	0($pop21), $pop22
	i32.const	$push101=, 512
	i32.add 	$push102=, $0, $pop101
	i32.const	$push289=, 48
	i32.add 	$push23=, $pop102, $pop289
	i64.const	$push24=, 60129542157
	i64.store	0($pop23), $pop24
	i32.const	$push103=, 512
	i32.add 	$push104=, $0, $pop103
	i32.const	$push288=, 40
	i32.add 	$push25=, $pop104, $pop288
	i64.const	$push26=, 51539607563
	i64.store	0($pop25), $pop26
	i32.const	$push105=, 512
	i32.add 	$push106=, $0, $pop105
	i32.const	$push287=, 32
	i32.add 	$push27=, $pop106, $pop287
	i64.const	$push28=, 42949672969
	i64.store	0($pop27), $pop28
	i32.const	$push107=, 512
	i32.add 	$push108=, $0, $pop107
	i32.const	$push286=, 24
	i32.add 	$push29=, $pop108, $pop286
	i64.const	$push30=, 34359738375
	i64.store	0($pop29), $pop30
	i32.const	$push109=, 512
	i32.add 	$push110=, $0, $pop109
	i32.const	$push285=, 16
	i32.add 	$push31=, $pop110, $pop285
	i64.const	$push32=, 25769803781
	i64.store	0($pop31), $pop32
	i64.const	$push33=, 17179869187
	i64.store	520($0), $pop33
	i64.const	$push34=, 8589934593
	i64.store	512($0), $pop34
	i32.const	$push35=, .L.str+1
	i32.const	$push111=, 512
	i32.add 	$push112=, $0, $pop111
	call    	f1@FUNCTION, $0, $pop35, $pop112
	i32.const	$push113=, 448
	i32.add 	$push114=, $0, $pop113
	i32.const	$push284=, 48
	i32.add 	$push36=, $pop114, $pop284
	i64.const	$push283=, 64424509454
	i64.store	0($pop36), $pop283
	i32.const	$push115=, 448
	i32.add 	$push116=, $0, $pop115
	i32.const	$push282=, 40
	i32.add 	$push37=, $pop116, $pop282
	i64.const	$push281=, 55834574860
	i64.store	0($pop37), $pop281
	i32.const	$push117=, 448
	i32.add 	$push118=, $0, $pop117
	i32.const	$push280=, 32
	i32.add 	$push38=, $pop118, $pop280
	i64.const	$push279=, 47244640266
	i64.store	0($pop38), $pop279
	i32.const	$push119=, 448
	i32.add 	$push120=, $0, $pop119
	i32.const	$push278=, 24
	i32.add 	$push39=, $pop120, $pop278
	i64.const	$push277=, 38654705672
	i64.store	0($pop39), $pop277
	i32.const	$push121=, 448
	i32.add 	$push122=, $0, $pop121
	i32.const	$push276=, 16
	i32.add 	$push40=, $pop122, $pop276
	i64.const	$push275=, 30064771078
	i64.store	0($pop40), $pop275
	i64.const	$push274=, 21474836484
	i64.store	456($0), $pop274
	i64.const	$push273=, 12884901890
	i64.store	448($0), $pop273
	i32.const	$push41=, .L.str+2
	i32.const	$push123=, 448
	i32.add 	$push124=, $0, $pop123
	call    	f2@FUNCTION, $0, $0, $pop41, $pop124
	i32.const	$push125=, 384
	i32.add 	$push126=, $0, $pop125
	i32.const	$push272=, 48
	i32.add 	$push42=, $pop126, $pop272
	i32.const	$push271=, 15
	i32.store	0($pop42), $pop271
	i32.const	$push127=, 384
	i32.add 	$push128=, $0, $pop127
	i32.const	$push270=, 40
	i32.add 	$push43=, $pop128, $pop270
	i64.const	$push269=, 60129542157
	i64.store	0($pop43), $pop269
	i32.const	$push129=, 384
	i32.add 	$push130=, $0, $pop129
	i32.const	$push268=, 32
	i32.add 	$push44=, $pop130, $pop268
	i64.const	$push267=, 51539607563
	i64.store	0($pop44), $pop267
	i32.const	$push131=, 384
	i32.add 	$push132=, $0, $pop131
	i32.const	$push266=, 24
	i32.add 	$push45=, $pop132, $pop266
	i64.const	$push265=, 42949672969
	i64.store	0($pop45), $pop265
	i32.const	$push133=, 384
	i32.add 	$push134=, $0, $pop133
	i32.const	$push264=, 16
	i32.add 	$push46=, $pop134, $pop264
	i64.const	$push263=, 34359738375
	i64.store	0($pop46), $pop263
	i64.const	$push262=, 25769803781
	i64.store	392($0), $pop262
	i64.const	$push261=, 17179869187
	i64.store	384($0), $pop261
	i32.const	$push47=, .L.str+3
	i32.const	$push135=, 384
	i32.add 	$push136=, $0, $pop135
	call    	f3@FUNCTION, $0, $0, $0, $pop47, $pop136
	i32.const	$push137=, 336
	i32.add 	$push138=, $0, $pop137
	i32.const	$push260=, 40
	i32.add 	$push48=, $pop138, $pop260
	i64.const	$push259=, 64424509454
	i64.store	0($pop48), $pop259
	i32.const	$push139=, 336
	i32.add 	$push140=, $0, $pop139
	i32.const	$push258=, 32
	i32.add 	$push49=, $pop140, $pop258
	i64.const	$push257=, 55834574860
	i64.store	0($pop49), $pop257
	i32.const	$push141=, 336
	i32.add 	$push142=, $0, $pop141
	i32.const	$push256=, 24
	i32.add 	$push50=, $pop142, $pop256
	i64.const	$push255=, 47244640266
	i64.store	0($pop50), $pop255
	i32.const	$push143=, 336
	i32.add 	$push144=, $0, $pop143
	i32.const	$push254=, 16
	i32.add 	$push51=, $pop144, $pop254
	i64.const	$push253=, 38654705672
	i64.store	0($pop51), $pop253
	i64.const	$push252=, 30064771078
	i64.store	344($0), $pop252
	i64.const	$push251=, 21474836484
	i64.store	336($0), $pop251
	i32.const	$push52=, .L.str+4
	i32.const	$push145=, 336
	i32.add 	$push146=, $0, $pop145
	call    	f4@FUNCTION, $0, $0, $0, $0, $pop52, $pop146
	i32.const	$push147=, 288
	i32.add 	$push148=, $0, $pop147
	i32.const	$push250=, 40
	i32.add 	$push53=, $pop148, $pop250
	i32.const	$push249=, 15
	i32.store	0($pop53), $pop249
	i32.const	$push149=, 288
	i32.add 	$push150=, $0, $pop149
	i32.const	$push248=, 32
	i32.add 	$push54=, $pop150, $pop248
	i64.const	$push247=, 60129542157
	i64.store	0($pop54), $pop247
	i32.const	$push151=, 288
	i32.add 	$push152=, $0, $pop151
	i32.const	$push246=, 24
	i32.add 	$push55=, $pop152, $pop246
	i64.const	$push245=, 51539607563
	i64.store	0($pop55), $pop245
	i32.const	$push153=, 288
	i32.add 	$push154=, $0, $pop153
	i32.const	$push244=, 16
	i32.add 	$push56=, $pop154, $pop244
	i64.const	$push243=, 42949672969
	i64.store	0($pop56), $pop243
	i64.const	$push242=, 34359738375
	i64.store	296($0), $pop242
	i64.const	$push241=, 25769803781
	i64.store	288($0), $pop241
	i32.const	$push57=, .L.str+5
	i32.const	$push155=, 288
	i32.add 	$push156=, $0, $pop155
	call    	f5@FUNCTION, $0, $0, $0, $0, $0, $pop57, $pop156
	i32.const	$push157=, 240
	i32.add 	$push158=, $0, $pop157
	i32.const	$push240=, 32
	i32.add 	$push58=, $pop158, $pop240
	i64.const	$push239=, 64424509454
	i64.store	0($pop58), $pop239
	i32.const	$push159=, 240
	i32.add 	$push160=, $0, $pop159
	i32.const	$push238=, 24
	i32.add 	$push59=, $pop160, $pop238
	i64.const	$push237=, 55834574860
	i64.store	0($pop59), $pop237
	i32.const	$push161=, 240
	i32.add 	$push162=, $0, $pop161
	i32.const	$push236=, 16
	i32.add 	$push60=, $pop162, $pop236
	i64.const	$push235=, 47244640266
	i64.store	0($pop60), $pop235
	i64.const	$push234=, 38654705672
	i64.store	248($0), $pop234
	i64.const	$push233=, 30064771078
	i64.store	240($0), $pop233
	i32.const	$push61=, .L.str+6
	i32.const	$push163=, 240
	i32.add 	$push164=, $0, $pop163
	call    	f6@FUNCTION, $0, $0, $0, $0, $0, $0, $pop61, $pop164
	i32.const	$push165=, 192
	i32.add 	$push166=, $0, $pop165
	i32.const	$push232=, 32
	i32.add 	$push62=, $pop166, $pop232
	i32.const	$push231=, 15
	i32.store	0($pop62), $pop231
	i32.const	$push167=, 192
	i32.add 	$push168=, $0, $pop167
	i32.const	$push230=, 24
	i32.add 	$push63=, $pop168, $pop230
	i64.const	$push229=, 60129542157
	i64.store	0($pop63), $pop229
	i32.const	$push169=, 192
	i32.add 	$push170=, $0, $pop169
	i32.const	$push228=, 16
	i32.add 	$push64=, $pop170, $pop228
	i64.const	$push227=, 51539607563
	i64.store	0($pop64), $pop227
	i64.const	$push226=, 42949672969
	i64.store	200($0), $pop226
	i64.const	$push225=, 34359738375
	i64.store	192($0), $pop225
	i32.const	$push65=, .L.str+7
	i32.const	$push171=, 192
	i32.add 	$push172=, $0, $pop171
	call    	f7@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $pop65, $pop172
	i32.const	$push173=, 160
	i32.add 	$push174=, $0, $pop173
	i32.const	$push224=, 24
	i32.add 	$push66=, $pop174, $pop224
	i64.const	$push223=, 64424509454
	i64.store	0($pop66), $pop223
	i32.const	$push175=, 160
	i32.add 	$push176=, $0, $pop175
	i32.const	$push222=, 16
	i32.add 	$push67=, $pop176, $pop222
	i64.const	$push221=, 55834574860
	i64.store	0($pop67), $pop221
	i64.const	$push220=, 47244640266
	i64.store	168($0), $pop220
	i64.const	$push219=, 38654705672
	i64.store	160($0), $pop219
	i32.const	$push68=, .L.str+8
	i32.const	$push177=, 160
	i32.add 	$push178=, $0, $pop177
	call    	f8@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $pop68, $pop178
	i32.const	$push179=, 128
	i32.add 	$push180=, $0, $pop179
	i32.const	$push218=, 24
	i32.add 	$push69=, $pop180, $pop218
	i32.const	$push217=, 15
	i32.store	0($pop69), $pop217
	i32.const	$push181=, 128
	i32.add 	$push182=, $0, $pop181
	i32.const	$push216=, 16
	i32.add 	$push70=, $pop182, $pop216
	i64.const	$push215=, 60129542157
	i64.store	0($pop70), $pop215
	i64.const	$push214=, 51539607563
	i64.store	136($0), $pop214
	i64.const	$push213=, 42949672969
	i64.store	128($0), $pop213
	i32.const	$push71=, .L.str+9
	i32.const	$push183=, 128
	i32.add 	$push184=, $0, $pop183
	call    	f9@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop71, $pop184
	i32.const	$push185=, 96
	i32.add 	$push186=, $0, $pop185
	i32.const	$push212=, 16
	i32.add 	$push72=, $pop186, $pop212
	i64.const	$push211=, 64424509454
	i64.store	0($pop72), $pop211
	i64.const	$push210=, 55834574860
	i64.store	104($0), $pop210
	i64.const	$push209=, 47244640266
	i64.store	96($0), $pop209
	i32.const	$push73=, .L.str+10
	i32.const	$push187=, 96
	i32.add 	$push188=, $0, $pop187
	call    	f10@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop73, $pop188
	i32.const	$push189=, 64
	i32.add 	$push190=, $0, $pop189
	i32.const	$push208=, 16
	i32.add 	$push74=, $pop190, $pop208
	i32.const	$push207=, 15
	i32.store	0($pop74), $pop207
	i64.const	$push206=, 60129542157
	i64.store	72($0), $pop206
	i64.const	$push205=, 51539607563
	i64.store	64($0), $pop205
	i32.const	$push75=, .L.str+11
	i32.const	$push191=, 64
	i32.add 	$push192=, $0, $pop191
	call    	f11@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop75, $pop192
	i64.const	$push204=, 64424509454
	i64.store	56($0), $pop204
	i64.const	$push203=, 55834574860
	i64.store	48($0), $pop203
	i32.const	$push76=, .L.str+12
	i32.const	$push193=, 48
	i32.add 	$push194=, $0, $pop193
	call    	f12@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop76, $pop194
	i32.const	$push202=, 15
	i32.store	40($0), $pop202
	i64.const	$push201=, 60129542157
	i64.store	32($0), $pop201
	i32.const	$push77=, .L.str+13
	i32.const	$push195=, 32
	i32.add 	$push196=, $0, $pop195
	call    	f13@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop77, $pop196
	i64.const	$push200=, 64424509454
	i64.store	16($0), $pop200
	i32.const	$push78=, .L.str+14
	i32.const	$push197=, 16
	i32.add 	$push198=, $0, $pop197
	call    	f14@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop78, $pop198
	i32.const	$push199=, 15
	i32.store	0($0), $pop199
	i32.const	$push79=, .L.str+15
	call    	f15@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $pop79, $0
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	strlen, i32, i32
	.functype	exit, void, i32
