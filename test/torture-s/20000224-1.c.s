	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000224-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$0=, loop_1($2)
	i32.const	$3=, 1
	block
	i32.lt_s	$push0=, $0, $3
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.load	$1=, loop_2($2)
	i32.load	$5=, flag($2)
	copy_local	$6=, $2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$4=, 31
	i32.shl 	$push2=, $5, $4
	i32.shr_s	$push3=, $pop2, $4
	i32.lt_s	$push1=, $1, $3
	i32.select	$push4=, $pop1, $2, $1
	i32.and 	$push5=, $pop3, $pop4
	i32.add 	$6=, $6, $pop5
	i32.add 	$5=, $5, $3
	i32.gt_s	$push6=, $0, $6
	br_if   	$pop6, 0        # 0: up to label1
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push7=, 0
	i32.store	$discard=, flag($pop7), $5
.LBB0_4:                                # %while.end
	end_block                       # label0:
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$0=, loop_1($2)
	i32.const	$3=, 1
	block
	i32.lt_s	$push0=, $0, $3
	br_if   	$pop0, 0        # 0: down to label3
# BB#1:                                 # %while.body.lr.ph.i
	i32.load	$1=, loop_2($2)
	i32.load	$5=, flag($2)
	copy_local	$6=, $2
.LBB1_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$4=, 31
	i32.lt_s	$push1=, $1, $3
	i32.shl 	$push2=, $5, $4
	i32.shr_s	$push3=, $pop2, $4
	i32.and 	$push4=, $pop3, $1
	i32.select	$push5=, $pop1, $2, $pop4
	i32.add 	$6=, $pop5, $6
	i32.add 	$5=, $5, $3
	i32.gt_s	$push6=, $0, $6
	br_if   	$pop6, 0        # 0: up to label4
# BB#3:                                 # %while.cond.while.end_crit_edge.i
	end_loop                        # label5:
	i32.const	$push7=, 0
	i32.store	$discard=, flag($pop7), $5
.LBB1_4:                                # %test.exit
	end_block                       # label3:
	call    	exit@FUNCTION, $2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	loop_1                  # @loop_1
	.type	loop_1,@object
	.section	.data.loop_1,"aw",@progbits
	.globl	loop_1
	.align	2
loop_1:
	.int32	100                     # 0x64
	.size	loop_1, 4

	.hidden	loop_2                  # @loop_2
	.type	loop_2,@object
	.section	.data.loop_2,"aw",@progbits
	.globl	loop_2
	.align	2
loop_2:
	.int32	7                       # 0x7
	.size	loop_2, 4

	.hidden	flag                    # @flag
	.type	flag,@object
	.section	.bss.flag,"aw",@nobits
	.globl	flag
	.align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
