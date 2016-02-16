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
	block
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.ne  	$push3=, $0, $pop2
	br_if   	2, $pop3        # 2: down to label1
# BB#2:                                 # %sw.bb
	i32.load	$push16=, 12($5)
	i32.const	$push31=, 3
	i32.add 	$push17=, $pop16, $pop31
	i32.const	$push30=, -4
	i32.and 	$push29=, $pop17, $pop30
	tee_local	$push28=, $0=, $pop29
	i32.const	$push27=, 4
	i32.add 	$push18=, $pop28, $pop27
	i32.store	$discard=, 12($5), $pop18
	block
	i32.load	$push19=, 0($0)
	i32.const	$push26=, 3
	i32.ne  	$push20=, $pop19, $pop26
	br_if   	0, $pop20       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.load	$push21=, 12($5)
	i32.const	$push37=, 3
	i32.add 	$push22=, $pop21, $pop37
	i32.const	$push36=, -4
	i32.and 	$push35=, $pop22, $pop36
	tee_local	$push34=, $0=, $pop35
	i32.const	$push33=, 4
	i32.add 	$push23=, $pop34, $pop33
	i32.store	$discard=, 12($5), $pop23
	i32.load	$push24=, 0($0)
	i32.const	$push32=, 4
	i32.eq  	$push25=, $pop24, $pop32
	br_if   	2, $pop25       # 2: down to label2
.LBB0_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %sw.bb2
	end_block                       # label3:
	i32.load	$push4=, 12($5)
	i32.const	$push42=, 3
	i32.add 	$push5=, $pop4, $pop42
	i32.const	$push41=, -4
	i32.and 	$push40=, $pop5, $pop41
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 4
	i32.add 	$push6=, $pop39, $pop38
	i32.store	$discard=, 12($5), $pop6
	i32.load	$push7=, 0($0)
	i32.const	$push8=, 9
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	2, $pop9        # 2: down to label0
# BB#6:                                 # %lor.lhs.false4
	i32.load	$push10=, 12($5)
	i32.const	$push47=, 3
	i32.add 	$push11=, $pop10, $pop47
	i32.const	$push46=, -4
	i32.and 	$push45=, $pop11, $pop46
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 4
	i32.add 	$push12=, $pop44, $pop43
	i32.store	$discard=, 12($5), $pop12
	i32.load	$push13=, 0($0)
	i32.const	$push14=, 10
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	2, $pop15       # 2: down to label0
.LBB0_7:                                # %return
	end_block                       # label2:
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB0_8:                                # %sw.default
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
	.param  	i32, i64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$push0=, 8($6), $2
	i32.store	$discard=, 12($6), $pop0
	block
	block
	block
	block
	i32.const	$push1=, 1
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label8
# BB#1:                                 # %sw.bb.i
	i32.load	$push17=, 12($6)
	i32.const	$push34=, 3
	i32.add 	$push18=, $pop17, $pop34
	i32.const	$push33=, -4
	i32.and 	$push32=, $pop18, $pop33
	tee_local	$push31=, $0=, $pop32
	i32.const	$push30=, 4
	i32.add 	$push19=, $pop31, $pop30
	i32.store	$discard=, 12($6), $pop19
	block
	i32.load	$push20=, 0($0)
	i32.const	$push29=, 3
	i32.ne  	$push21=, $pop20, $pop29
	br_if   	0, $pop21       # 0: down to label9
# BB#2:                                 # %lor.lhs.false.i
	i32.load	$push22=, 12($6)
	i32.const	$push40=, 3
	i32.add 	$push23=, $pop22, $pop40
	i32.const	$push39=, -4
	i32.and 	$push38=, $pop23, $pop39
	tee_local	$push37=, $0=, $pop38
	i32.const	$push36=, 4
	i32.add 	$push24=, $pop37, $pop36
	i32.store	$discard=, 12($6), $pop24
	i32.load	$push25=, 0($0)
	i32.const	$push35=, 4
	i32.ne  	$push26=, $pop25, $pop35
	br_if   	0, $pop26       # 0: down to label9
# BB#3:                                 # %h.exit
	i64.const	$push27=, 2
	i64.ne  	$push28=, $1, $pop27
	br_if   	2, $pop28       # 2: down to label7
# BB#4:                                 # %if.end
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB1_5:                                # %if.then.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %entry
	end_block                       # label8:
	i32.const	$push3=, 5
	i32.ne  	$push4=, $0, $pop3
	br_if   	1, $pop4        # 1: down to label6
# BB#7:                                 # %sw.bb2.i
	i32.load	$push5=, 12($6)
	i32.const	$push45=, 3
	i32.add 	$push6=, $pop5, $pop45
	i32.const	$push44=, -4
	i32.and 	$push43=, $pop6, $pop44
	tee_local	$push42=, $0=, $pop43
	i32.const	$push41=, 4
	i32.add 	$push7=, $pop42, $pop41
	i32.store	$discard=, 12($6), $pop7
	i32.load	$push8=, 0($0)
	i32.const	$push9=, 9
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	2, $pop10       # 2: down to label5
# BB#8:                                 # %lor.lhs.false4.i
	i32.load	$push11=, 12($6)
	i32.const	$push50=, 3
	i32.add 	$push12=, $pop11, $pop50
	i32.const	$push49=, -4
	i32.and 	$push48=, $pop12, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 4
	i32.add 	$push13=, $pop47, $pop46
	i32.store	$discard=, 12($6), $pop13
	i32.load	$push14=, 0($0)
	i32.const	$push15=, 10
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	2, $pop16       # 2: down to label5
.LBB1_9:                                # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %sw.default.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then6.i
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
	.param  	i32, i32, i32, i64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.store	$push0=, 8($8), $4
	i32.store	$discard=, 12($8), $pop0
	block
	block
	block
	block
	block
	i32.const	$push1=, 5
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label14
# BB#1:                                 # %entry
	i32.const	$push3=, 1
	i32.ne  	$push4=, $0, $pop3
	br_if   	2, $pop4        # 2: down to label12
# BB#2:                                 # %sw.bb.i
	i32.load	$push17=, 12($8)
	i32.const	$push40=, 3
	i32.add 	$push18=, $pop17, $pop40
	i32.const	$push39=, -4
	i32.and 	$push38=, $pop18, $pop39
	tee_local	$push37=, $4=, $pop38
	i32.const	$push36=, 4
	i32.add 	$push19=, $pop37, $pop36
	i32.store	$discard=, 12($8), $pop19
	block
	i32.load	$push20=, 0($4)
	i32.const	$push35=, 3
	i32.ne  	$push21=, $pop20, $pop35
	br_if   	0, $pop21       # 0: down to label15
# BB#3:                                 # %lor.lhs.false.i
	i32.load	$push22=, 12($8)
	i32.const	$push46=, 3
	i32.add 	$push23=, $pop22, $pop46
	i32.const	$push45=, -4
	i32.and 	$push44=, $pop23, $pop45
	tee_local	$push43=, $4=, $pop44
	i32.const	$push42=, 4
	i32.add 	$push24=, $pop43, $pop42
	i32.store	$discard=, 12($8), $pop24
	i32.load	$push25=, 0($4)
	i32.const	$push41=, 4
	i32.eq  	$push26=, $pop25, $pop41
	br_if   	2, $pop26       # 2: down to label13
.LBB2_4:                                # %if.then.i
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %sw.bb2.i
	end_block                       # label14:
	i32.load	$push5=, 12($8)
	i32.const	$push51=, 3
	i32.add 	$push6=, $pop5, $pop51
	i32.const	$push50=, -4
	i32.and 	$push49=, $pop6, $pop50
	tee_local	$push48=, $4=, $pop49
	i32.const	$push47=, 4
	i32.add 	$push7=, $pop48, $pop47
	i32.store	$discard=, 12($8), $pop7
	i32.load	$push8=, 0($4)
	i32.const	$push9=, 9
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	2, $pop10       # 2: down to label11
# BB#6:                                 # %lor.lhs.false4.i
	i32.load	$push11=, 12($8)
	i32.const	$push56=, 3
	i32.add 	$push12=, $pop11, $pop56
	i32.const	$push55=, -4
	i32.and 	$push54=, $pop12, $pop55
	tee_local	$push53=, $4=, $pop54
	i32.const	$push52=, 4
	i32.add 	$push13=, $pop53, $pop52
	i32.store	$discard=, 12($8), $pop13
	i32.load	$push14=, 0($4)
	i32.const	$push15=, 10
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	2, $pop16       # 2: down to label11
.LBB2_7:                                # %h.exit
	end_block                       # label13:
	i32.const	$push27=, 5
	i32.ne  	$push28=, $0, $pop27
	br_if   	2, $pop28       # 2: down to label10
# BB#8:                                 # %h.exit
	i32.const	$push29=, 6
	i32.ne  	$push30=, $1, $pop29
	br_if   	2, $pop30       # 2: down to label10
# BB#9:                                 # %h.exit
	i32.const	$push31=, 7
	i32.ne  	$push32=, $2, $pop31
	br_if   	2, $pop32       # 2: down to label10
# BB#10:                                # %h.exit
	i64.const	$push33=, 8
	i64.ne  	$push34=, $3, $pop33
	br_if   	2, $pop34       # 2: down to label10
# BB#11:                                # %if.end
	i32.const	$7=, 16
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return
.LBB2_12:                               # %sw.default.i
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB2_13:                               # %if.then6.i
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB2_14:                               # %if.then
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 32
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i64.const	$push0=, 17179869187
	i64.store	$discard=, 16($4):p2align=4, $pop0
	i32.const	$push2=, 1
	i64.const	$push1=, 2
	i32.const	$3=, 16
	i32.add 	$3=, $4, $3
	call    	f1@FUNCTION, $pop2, $pop1, $3
	i64.const	$push3=, 42949672969
	i64.store	$discard=, 0($4):p2align=4, $pop3
	i32.const	$push7=, 5
	i32.const	$push6=, 6
	i32.const	$push5=, 7
	i64.const	$push4=, 8
	call    	f2@FUNCTION, $pop7, $pop6, $pop5, $pop4, $4
	i32.const	$push8=, 0
	i32.const	$2=, 32
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop8
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
