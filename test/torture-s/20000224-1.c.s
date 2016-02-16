	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000224-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push11=, 0
	i32.load	$push10=, loop_1($pop11)
	tee_local	$push9=, $3=, $pop10
	i32.const	$push8=, 1
	i32.lt_s	$push0=, $pop9, $pop8
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push13=, 0
	i32.load	$0=, loop_2($pop13)
	i32.const	$push12=, 0
	i32.load	$1=, flag($pop12)
	i32.const	$2=, 0
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push18=, 31
	i32.shl 	$push2=, $1, $pop18
	i32.const	$push17=, 31
	i32.shr_s	$push3=, $pop2, $pop17
	i32.const	$push16=, 0
	i32.const	$push15=, 1
	i32.lt_s	$push1=, $0, $pop15
	i32.select	$push4=, $pop16, $0, $pop1
	i32.and 	$push5=, $pop3, $pop4
	i32.add 	$2=, $2, $pop5
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	i32.gt_s	$push6=, $3, $2
	br_if   	0, $pop6        # 0: up to label1
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push7=, 0
	i32.store	$discard=, flag($pop7), $1
.LBB0_4:                                # %while.end
	end_block                       # label0:
	i32.const	$push19=, 1
	return  	$pop19
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$discard=, test@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	loop_1                  # @loop_1
	.type	loop_1,@object
	.section	.data.loop_1,"aw",@progbits
	.globl	loop_1
	.p2align	2
loop_1:
	.int32	100                     # 0x64
	.size	loop_1, 4

	.hidden	loop_2                  # @loop_2
	.type	loop_2,@object
	.section	.data.loop_2,"aw",@progbits
	.globl	loop_2
	.p2align	2
loop_2:
	.int32	7                       # 0x7
	.size	loop_2, 4

	.hidden	flag                    # @flag
	.type	flag,@object
	.section	.bss.flag,"aw",@nobits
	.globl	flag
	.p2align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 3.9.0 "
