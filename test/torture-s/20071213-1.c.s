	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071213-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h
	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($1)
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
	i32.const	$push9=, 3
	i32.ne  	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#3:                                 # %lor.lhs.false
	i32.load	$push11=, 4($1)
	i32.const	$push12=, 4
	i32.eq  	$push13=, $pop11, $pop12
	br_if   	2, $pop13       # 2: down to label1
.LBB0_4:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %sw.bb4
	end_block                       # label2:
	i32.const	$push4=, 9
	i32.ne  	$push5=, $2, $pop4
	br_if   	1, $pop5        # 1: down to label0
# BB#6:                                 # %lor.lhs.false8
	i32.load	$push6=, 4($1)
	i32.const	$push7=, 10
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	1, $pop8        # 1: down to label0
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 16
	i32.sub 	$push24=, $pop17, $pop18
	tee_local	$push23=, $4=, $pop24
	i32.store	__stack_pointer($pop19), $pop23
	i32.store	12($4), $2
	i32.load	$3=, 0($2)
	block   	
	block   	
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %sw.bb.i
	i32.const	$push9=, 3
	i32.ne  	$push10=, $3, $pop9
	br_if   	1, $pop10       # 1: down to label5
# BB#2:                                 # %lor.lhs.false.i
	i32.load	$push11=, 4($2)
	i32.const	$push12=, 4
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label5
# BB#3:                                 # %h.exit
	i64.const	$push14=, 2
	i64.ne  	$push15=, $1, $pop14
	br_if   	1, $pop15       # 1: down to label5
# BB#4:                                 # %if.end
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $4, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	return
.LBB1_5:                                # %entry
	end_block                       # label6:
	i32.const	$push2=, 5
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label4
# BB#6:                                 # %sw.bb4.i
	i32.const	$push4=, 9
	i32.ne  	$push5=, $3, $pop4
	br_if   	1, $pop5        # 1: down to label4
# BB#7:                                 # %lor.lhs.false8.i
	i32.load	$push6=, 4($2)
	i32.const	$push7=, 10
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	1, $pop8        # 1: down to label4
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 16
	i32.sub 	$push30=, $pop23, $pop24
	tee_local	$push29=, $6=, $pop30
	i32.store	__stack_pointer($pop25), $pop29
	i32.store	12($6), $4
	i32.load	$5=, 0($4)
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
	i32.const	$push9=, 3
	i32.ne  	$push10=, $5, $pop9
	br_if   	0, $pop10       # 0: down to label10
# BB#3:                                 # %lor.lhs.false.i
	i32.load	$push11=, 4($4)
	i32.const	$push12=, 4
	i32.eq  	$push13=, $pop11, $pop12
	br_if   	2, $pop13       # 2: down to label8
.LBB2_4:                                # %if.then.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %sw.bb4.i
	end_block                       # label9:
	i32.const	$push4=, 9
	i32.ne  	$push5=, $5, $pop4
	br_if   	1, $pop5        # 1: down to label7
# BB#6:                                 # %lor.lhs.false8.i
	i32.load	$push6=, 4($4)
	i32.const	$push7=, 10
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	1, $pop8        # 1: down to label7
.LBB2_7:                                # %h.exit
	end_block                       # label8:
	i32.const	$push14=, 5
	i32.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label7
# BB#8:                                 # %h.exit
	i32.const	$push16=, 6
	i32.ne  	$push17=, $1, $pop16
	br_if   	0, $pop17       # 0: down to label7
# BB#9:                                 # %h.exit
	i32.const	$push18=, 7
	i32.ne  	$push19=, $2, $pop18
	br_if   	0, $pop19       # 0: down to label7
# BB#10:                                # %h.exit
	i64.const	$push20=, 8
	i64.ne  	$push21=, $3, $pop20
	br_if   	0, $pop21       # 0: down to label7
# BB#11:                                # %if.end
	i32.const	$push28=, 0
	i32.const	$push26=, 16
	i32.add 	$push27=, $6, $pop26
	i32.store	__stack_pointer($pop28), $pop27
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
	i32.sub 	$push19=, $pop10, $pop11
	tee_local	$push18=, $0=, $pop19
	i32.store	__stack_pointer($pop12), $pop18
	i64.const	$push0=, 17179869187
	i64.store	16($0), $pop0
	i32.const	$push2=, 1
	i64.const	$push1=, 2
	i32.const	$push16=, 16
	i32.add 	$push17=, $0, $pop16
	call    	f1@FUNCTION, $pop2, $pop1, $pop17
	i64.const	$push3=, 42949672969
	i64.store	0($0), $pop3
	i32.const	$push7=, 5
	i32.const	$push6=, 6
	i32.const	$push5=, 7
	i64.const	$push4=, 8
	call    	f2@FUNCTION, $pop7, $pop6, $pop5, $pop4, $0
	i32.const	$push15=, 0
	i32.const	$push13=, 32
	i32.add 	$push14=, $0, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
