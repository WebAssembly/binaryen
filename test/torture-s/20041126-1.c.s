	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041126-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %for.inc
	i32.load	$push1=, 4($0)
	br_if   	$pop1, 0        # 0: down to label0
# BB#2:                                 # %for.inc.1
	i32.load	$push2=, 8($0)
	br_if   	$pop2, 0        # 0: down to label0
# BB#3:                                 # %for.inc.2
	i32.load	$push3=, 12($0)
	br_if   	$pop3, 0        # 0: down to label0
# BB#4:                                 # %for.inc.3
	i32.const	$3=, 5
	i32.load	$push4=, 16($0)
	br_if   	$pop4, 0        # 0: down to label0
.LBB0_5:                                # %for.cond1
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.const	$push5=, 9
	i32.gt_s	$push6=, $3, $pop5
	br_if   	$pop6, 2        # 2: down to label1
# BB#6:                                 # %for.body3
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push7=, 2
	i32.shl 	$push8=, $3, $pop7
	i32.add 	$push9=, $0, $pop8
	i32.load	$1=, 0($pop9)
	i32.const	$push10=, 1
	i32.add 	$2=, $3, $pop10
	copy_local	$3=, $1
	i32.eq  	$push11=, $1, $2
	br_if   	$pop11, 0       # 0: up to label2
# BB#7:                                 # %if.then6
	end_loop                        # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %for.end10
	end_block                       # label1:
	return
.LBB0_9:                                # %if.then
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.cond1.i.preheader
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 48
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.const	$push0=, .Lmain.a
	i32.const	$push1=, 40
	i32.call	$discard=, memcpy@FUNCTION, $6, $pop0, $pop1
	i32.const	$push2=, 16
	i32.add 	$push3=, $6, $pop2
	i32.const	$push4=, 0
	i32.store	$discard=, 0($pop3):p2align=4, $pop4
	i32.const	$push5=, 8
	i32.or  	$push6=, $6, $pop5
	i64.const	$push7=, 0
	i64.store	$push8=, 0($pop6), $pop7
	i64.store	$discard=, 0($6):p2align=4, $pop8
	i32.const	$2=, 5
.LBB1_1:                                # %for.cond1.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	i32.const	$push14=, 9
	i32.gt_s	$push9=, $2, $pop14
	br_if   	$pop9, 2        # 2: down to label4
# BB#2:                                 # %for.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 2
	i32.shl 	$push11=, $2, $pop16
	i32.add 	$push12=, $6, $pop11
	i32.load	$0=, 0($pop12)
	i32.const	$push15=, 1
	i32.add 	$1=, $2, $pop15
	copy_local	$2=, $0
	i32.eq  	$push13=, $0, $1
	br_if   	$pop13, 0       # 0: up to label5
# BB#3:                                 # %if.then6.i
	end_loop                        # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %check.exit
	end_block                       # label4:
	i32.const	$push10=, 0
	i32.const	$5=, 48
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return  	$pop10
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
