	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071213-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h
	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
	block
	block
	block
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label2
# BB#1:                                 # %entry
	block
	i32.const	$push2=, 1
	i32.ne  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label3
# BB#2:                                 # %sw.bb
	i32.load	$push18=, 12($5)
	i32.const	$push34=, 3
	i32.add 	$push19=, $pop18, $pop34
	i32.const	$push33=, -4
	i32.and 	$push20=, $pop19, $pop33
	tee_local	$push32=, $0=, $pop20
	i32.const	$push31=, 4
	i32.add 	$push21=, $pop32, $pop31
	i32.store	$discard=, 12($5), $pop21
	block
	i32.load	$push22=, 0($0)
	i32.const	$push30=, 3
	i32.ne  	$push23=, $pop22, $pop30
	br_if   	$pop23, 0       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.load	$push24=, 12($5)
	i32.const	$push39=, 3
	i32.add 	$push25=, $pop24, $pop39
	i32.const	$push38=, -4
	i32.and 	$push26=, $pop25, $pop38
	tee_local	$push37=, $0=, $pop26
	i32.const	$push36=, 4
	i32.add 	$push27=, $pop37, $pop36
	i32.store	$discard=, 12($5), $pop27
	i32.load	$push28=, 0($0)
	i32.const	$push35=, 4
	i32.eq  	$push29=, $pop28, $pop35
	br_if   	$pop29, 3       # 3: down to label1
.LBB0_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb2
	end_block                       # label2:
	i32.load	$push4=, 12($5)
	i32.const	$push43=, 3
	i32.add 	$push5=, $pop4, $pop43
	i32.const	$push42=, -4
	i32.and 	$push6=, $pop5, $pop42
	tee_local	$push41=, $0=, $pop6
	i32.const	$push40=, 4
	i32.add 	$push7=, $pop41, $pop40
	i32.store	$discard=, 12($5), $pop7
	i32.load	$push8=, 0($0)
	i32.const	$push9=, 9
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, 1       # 1: down to label0
# BB#7:                                 # %lor.lhs.false4
	i32.load	$push11=, 12($5)
	i32.const	$push47=, 3
	i32.add 	$push12=, $pop11, $pop47
	i32.const	$push46=, -4
	i32.and 	$push13=, $pop12, $pop46
	tee_local	$push45=, $0=, $pop13
	i32.const	$push44=, 4
	i32.add 	$push14=, $pop45, $pop44
	i32.store	$discard=, 12($5), $pop14
	i32.load	$push15=, 0($0)
	i32.const	$push16=, 10
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, 1       # 1: down to label0
.LBB0_8:                                # %return
	end_block                       # label1:
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_9:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	h, .Lfunc_end0-h

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i64
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 8($5), $6
	i32.store	$discard=, 12($5), $pop0
	block
	block
	block
	block
	i32.const	$push1=, 1
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label8
# BB#1:                                 # %sw.bb.i
	i32.load	$push19=, 12($5)
	i32.const	$push37=, 3
	i32.add 	$push20=, $pop19, $pop37
	i32.const	$push36=, -4
	i32.and 	$push21=, $pop20, $pop36
	tee_local	$push35=, $0=, $pop21
	i32.const	$push34=, 4
	i32.add 	$push22=, $pop35, $pop34
	i32.store	$discard=, 12($5), $pop22
	block
	i32.load	$push23=, 0($0)
	i32.const	$push33=, 3
	i32.ne  	$push24=, $pop23, $pop33
	br_if   	$pop24, 0       # 0: down to label9
# BB#2:                                 # %lor.lhs.false.i
	i32.load	$push25=, 12($5)
	i32.const	$push42=, 3
	i32.add 	$push26=, $pop25, $pop42
	i32.const	$push41=, -4
	i32.and 	$push27=, $pop26, $pop41
	tee_local	$push40=, $0=, $pop27
	i32.const	$push39=, 4
	i32.add 	$push28=, $pop40, $pop39
	i32.store	$discard=, 12($5), $pop28
	i32.load	$push29=, 0($0)
	i32.const	$push38=, 4
	i32.ne  	$push30=, $pop29, $pop38
	br_if   	$pop30, 0       # 0: down to label9
# BB#3:                                 # %h.exit
	i64.const	$push31=, 2
	i64.ne  	$push32=, $1, $pop31
	br_if   	$pop32, 2       # 2: down to label7
# BB#4:                                 # %if.end
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB1_5:                                # %if.then.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %entry
	end_block                       # label8:
	i32.const	$push3=, 5
	i32.ne  	$push4=, $0, $pop3
	br_if   	$pop4, 2        # 2: down to label5
# BB#7:                                 # %sw.bb2.i
	i32.load	$push5=, 12($5)
	i32.const	$push46=, 3
	i32.add 	$push6=, $pop5, $pop46
	i32.const	$push45=, -4
	i32.and 	$push7=, $pop6, $pop45
	tee_local	$push44=, $0=, $pop7
	i32.const	$push43=, 4
	i32.add 	$push8=, $pop44, $pop43
	i32.store	$discard=, 12($5), $pop8
	i32.load	$push9=, 0($0)
	i32.const	$push10=, 9
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, 1       # 1: down to label6
# BB#8:                                 # %lor.lhs.false4.i
	i32.load	$push12=, 12($5)
	i32.const	$push50=, 3
	i32.add 	$push13=, $pop12, $pop50
	i32.const	$push49=, -4
	i32.and 	$push14=, $pop13, $pop49
	tee_local	$push48=, $0=, $pop14
	i32.const	$push47=, 4
	i32.add 	$push15=, $pop48, $pop47
	i32.store	$discard=, 12($5), $pop15
	i32.load	$push16=, 0($0)
	i32.const	$push17=, 10
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	$pop18, 1       # 1: down to label6
.LBB1_9:                                # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.then6.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %sw.default.i
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	copy_local	$9=, $8
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.store	$push0=, 8($8), $9
	i32.store	$discard=, 12($8), $pop0
	block
	block
	block
	i32.const	$push1=, 5
	i32.eq  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label12
# BB#1:                                 # %entry
	block
	i32.const	$push3=, 1
	i32.ne  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label13
# BB#2:                                 # %sw.bb.i
	i32.load	$push19=, 12($8)
	i32.const	$push43=, 3
	i32.add 	$push20=, $pop19, $pop43
	i32.const	$push42=, -4
	i32.and 	$push21=, $pop20, $pop42
	tee_local	$push41=, $4=, $pop21
	i32.const	$push40=, 4
	i32.add 	$push22=, $pop41, $pop40
	i32.store	$discard=, 12($8), $pop22
	block
	i32.load	$push23=, 0($4)
	i32.const	$push39=, 3
	i32.ne  	$push24=, $pop23, $pop39
	br_if   	$pop24, 0       # 0: down to label14
# BB#3:                                 # %lor.lhs.false.i
	i32.load	$push25=, 12($8)
	i32.const	$push48=, 3
	i32.add 	$push26=, $pop25, $pop48
	i32.const	$push47=, -4
	i32.and 	$push27=, $pop26, $pop47
	tee_local	$push46=, $4=, $pop27
	i32.const	$push45=, 4
	i32.add 	$push28=, $pop46, $pop45
	i32.store	$discard=, 12($8), $pop28
	i32.load	$push29=, 0($4)
	i32.const	$push44=, 4
	i32.eq  	$push30=, $pop29, $pop44
	br_if   	$pop30, 3       # 3: down to label11
.LBB2_4:                                # %if.then.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %sw.default.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %sw.bb2.i
	end_block                       # label12:
	i32.load	$push5=, 12($8)
	i32.const	$push52=, 3
	i32.add 	$push6=, $pop5, $pop52
	i32.const	$push51=, -4
	i32.and 	$push7=, $pop6, $pop51
	tee_local	$push50=, $4=, $pop7
	i32.const	$push49=, 4
	i32.add 	$push8=, $pop50, $pop49
	i32.store	$discard=, 12($8), $pop8
	i32.load	$push9=, 0($4)
	i32.const	$push10=, 9
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, 1       # 1: down to label10
# BB#7:                                 # %lor.lhs.false4.i
	i32.load	$push12=, 12($8)
	i32.const	$push56=, 3
	i32.add 	$push13=, $pop12, $pop56
	i32.const	$push55=, -4
	i32.and 	$push14=, $pop13, $pop55
	tee_local	$push54=, $4=, $pop14
	i32.const	$push53=, 4
	i32.add 	$push15=, $pop54, $pop53
	i32.store	$discard=, 12($8), $pop15
	i32.load	$push16=, 0($4)
	i32.const	$push17=, 10
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	$pop18, 1       # 1: down to label10
.LBB2_8:                                # %h.exit
	end_block                       # label11:
	block
	i32.const	$push31=, 5
	i32.ne  	$push32=, $0, $pop31
	br_if   	$pop32, 0       # 0: down to label15
# BB#9:                                 # %h.exit
	i32.const	$push33=, 6
	i32.ne  	$push34=, $1, $pop33
	br_if   	$pop34, 0       # 0: down to label15
# BB#10:                                # %h.exit
	i32.const	$push35=, 7
	i32.ne  	$push36=, $2, $pop35
	br_if   	$pop36, 0       # 0: down to label15
# BB#11:                                # %h.exit
	i64.const	$push37=, 8
	i64.ne  	$push38=, $3, $pop37
	br_if   	$pop38, 0       # 0: down to label15
# BB#12:                                # %if.end
	i32.const	$7=, 16
	i32.add 	$8=, $9, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return
.LBB2_13:                               # %if.then
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %if.then6.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$11=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 8
	i32.sub 	$11=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$11=, 0($1), $11
	i64.const	$push0=, 17179869187
	i64.store	$discard=, 0($11):p2align=2, $pop0
	i32.const	$push2=, 1
	i64.const	$push1=, 2
	call    	f1@FUNCTION, $pop2, $pop1
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 8
	i32.add 	$11=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$11=, 0($3), $11
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 8
	i32.sub 	$11=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$11=, 0($5), $11
	i64.const	$push3=, 42949672969
	i64.store	$discard=, 0($11):p2align=2, $pop3
	i32.const	$push7=, 5
	i32.const	$push6=, 6
	i32.const	$push5=, 7
	i64.const	$push4=, 8
	call    	f2@FUNCTION, $pop7, $pop6, $pop5, $pop4
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 8
	i32.add 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i32.const	$push8=, 0
	i32.const	$10=, 16
	i32.add 	$11=, $11, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	return  	$pop8
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
