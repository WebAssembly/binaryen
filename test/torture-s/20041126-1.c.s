	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041126-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.inc
	i32.load	$push1=, 4($0)
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %for.inc.1
	i32.load	$push2=, 8($0)
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %for.inc.2
	i32.load	$push3=, 12($0)
	br_if   	0, $pop3        # 0: down to label0
# BB#4:                                 # %for.inc.3
	i32.load	$push4=, 16($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#5:                                 # %for.cond1.preheader
	i32.const	$1=, 5
.LBB0_6:                                # %for.cond1
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.const	$push10=, 9
	i32.gt_s	$push5=, $1, $pop10
	br_if   	2, $pop5        # 2: down to label1
# BB#7:                                 # %for.body3
                                        #   in Loop: Header=BB0_6 Depth=1
	i32.const	$push14=, 1
	i32.add 	$push6=, $1, $pop14
	i32.const	$push13=, 2
	i32.shl 	$push7=, $1, $pop13
	i32.add 	$push8=, $0, $pop7
	i32.load	$push12=, 0($pop8)
	tee_local	$push11=, $1=, $pop12
	i32.eq  	$push9=, $pop6, $pop11
	br_if   	0, $pop9        # 0: up to label2
# BB#8:                                 # %if.then6
	end_loop                        # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %for.end10
	end_block                       # label1:
	return
.LBB0_10:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %for.cond1.i.preheader
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 48
	i32.sub 	$push21=, $pop15, $pop16
	i32.store	$push1=, __stack_pointer($pop17), $pop21
	i32.const	$push3=, .Lmain.a
	i32.const	$push2=, 40
	i32.call	$push23=, memcpy@FUNCTION, $pop1, $pop3, $pop2
	tee_local	$push22=, $0=, $pop23
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop22, $pop4
	i32.const	$push6=, 0
	i32.store	$drop=, 0($pop5), $pop6
	i64.const	$push7=, 0
	i64.store	$push0=, 8($0), $pop7
	i64.store	$drop=, 0($0), $pop0
	i32.const	$1=, 5
.LBB1_1:                                # %for.cond1.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	i32.const	$push24=, 9
	i32.gt_s	$push8=, $1, $pop24
	br_if   	2, $pop8        # 2: down to label4
# BB#2:                                 # %for.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push28=, 1
	i32.add 	$push10=, $1, $pop28
	i32.const	$push27=, 2
	i32.shl 	$push11=, $1, $pop27
	i32.add 	$push12=, $0, $pop11
	i32.load	$push26=, 0($pop12)
	tee_local	$push25=, $1=, $pop26
	i32.eq  	$push13=, $pop10, $pop25
	br_if   	0, $pop13       # 0: up to label5
# BB#3:                                 # %if.then6.i
	end_loop                        # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %check.exit
	end_block                       # label4:
	i32.const	$push20=, 0
	i32.const	$push18=, 48
	i32.add 	$push19=, $0, $pop18
	i32.store	$drop=, __stack_pointer($pop20), $pop19
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.a,@object        # @main.a
	.section	.rodata..Lmain.a,"a",@progbits
	.p2align	4
.Lmain.a:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.size	.Lmain.a, 40


	.ident	"clang version 3.9.0 "
	.functype	abort, void
