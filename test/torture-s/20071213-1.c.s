	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071213-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h
	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.ne  	$push3=, $0, $pop2
	br_if   	2, $pop3        # 2: down to label0
# BB#2:                                 # %sw.bb
	block
	i32.load	$push10=, 0($1)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label3
# BB#3:                                 # %lor.lhs.false
	i32.load	$push13=, 4($1)
	i32.const	$push14=, 4
	i32.eq  	$push15=, $pop13, $pop14
	br_if   	2, $pop15       # 2: down to label1
.LBB0_4:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %sw.bb4
	end_block                       # label2:
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label0
# BB#6:                                 # %lor.lhs.false8
	i32.load	$push7=, 4($1)
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB0_7:                                # %return
	end_block                       # label1:
	return
.LBB0_8:                                # %sw.default
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 16
	i32.sub 	$push25=, $pop19, $pop20
	i32.store	$push27=, __stack_pointer($pop21), $pop25
	tee_local	$push26=, $3=, $pop27
	i32.store	$drop=, 12($pop26), $2
	block
	block
	block
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %sw.bb.i
	i32.load	$push10=, 0($2)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label5
# BB#2:                                 # %lor.lhs.false.i
	i32.load	$push13=, 4($2)
	i32.const	$push14=, 4
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	1, $pop15       # 1: down to label5
# BB#3:                                 # %h.exit
	i64.const	$push16=, 2
	i64.ne  	$push17=, $1, $pop16
	br_if   	1, $pop17       # 1: down to label5
# BB#4:                                 # %if.end
	i32.const	$push24=, 0
	i32.const	$push22=, 16
	i32.add 	$push23=, $3, $pop22
	i32.store	$drop=, __stack_pointer($pop24), $pop23
	return
.LBB1_5:                                # %entry
	end_block                       # label6:
	i32.const	$push2=, 5
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label4
# BB#6:                                 # %sw.bb4.i
	i32.load	$push4=, 0($2)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label4
# BB#7:                                 # %lor.lhs.false8.i
	i32.load	$push7=, 4($2)
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label4
.LBB1_8:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %sw.default.i
	end_block                       # label4:
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push31=, $pop25, $pop26
	i32.store	$push33=, __stack_pointer($pop27), $pop31
	tee_local	$push32=, $5=, $pop33
	i32.store	$drop=, 12($pop32), $4
	block
	block
	block
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label9
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.ne  	$push3=, $0, $pop2
	br_if   	2, $pop3        # 2: down to label7
# BB#2:                                 # %sw.bb.i
	block
	i32.load	$push10=, 0($4)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label10
# BB#3:                                 # %lor.lhs.false.i
	i32.load	$push13=, 4($4)
	i32.const	$push14=, 4
	i32.eq  	$push15=, $pop13, $pop14
	br_if   	2, $pop15       # 2: down to label8
.LBB2_4:                                # %if.then.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %sw.bb4.i
	end_block                       # label9:
	i32.load	$push4=, 0($4)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label7
# BB#6:                                 # %lor.lhs.false8.i
	i32.load	$push7=, 4($4)
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label7
.LBB2_7:                                # %h.exit
	end_block                       # label8:
	i32.const	$push16=, 5
	i32.ne  	$push17=, $0, $pop16
	br_if   	0, $pop17       # 0: down to label7
# BB#8:                                 # %h.exit
	i32.const	$push18=, 6
	i32.ne  	$push19=, $1, $pop18
	br_if   	0, $pop19       # 0: down to label7
# BB#9:                                 # %h.exit
	i32.const	$push20=, 7
	i32.ne  	$push21=, $2, $pop20
	br_if   	0, $pop21       # 0: down to label7
# BB#10:                                # %h.exit
	i64.const	$push22=, 8
	i64.ne  	$push23=, $3, $pop22
	br_if   	0, $pop23       # 0: down to label7
# BB#11:                                # %if.end
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $5, $pop28
	i32.store	$drop=, __stack_pointer($pop30), $pop29
	return
.LBB2_12:                               # %if.then
	end_block                       # label7:
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 32
	i32.sub 	$push18=, $pop10, $pop11
	i32.store	$push20=, __stack_pointer($pop12), $pop18
	tee_local	$push19=, $0=, $pop20
	i64.const	$push0=, 17179869187
	i64.store	$drop=, 16($pop19), $pop0
	i32.const	$push2=, 1
	i64.const	$push1=, 2
	i32.const	$push16=, 16
	i32.add 	$push17=, $0, $pop16
	call    	f1@FUNCTION, $pop2, $pop1, $pop17
	i64.const	$push3=, 42949672969
	i64.store	$drop=, 0($0), $pop3
	i32.const	$push7=, 5
	i32.const	$push6=, 6
	i32.const	$push5=, 7
	i64.const	$push4=, 8
	call    	f2@FUNCTION, $pop7, $pop6, $pop5, $pop4, $0
	i32.const	$push15=, 0
	i32.const	$push13=, 32
	i32.add 	$push14=, $0, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
