	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000224-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push10=, 0
	i32.load	$push9=, loop_1($pop10)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push7=, 1
	i32.lt_s	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push12=, 0
	i32.load	$3=, flag($pop12)
	i32.const	$push11=, 0
	i32.load	$1=, loop_2($pop11)
	i32.const	$4=, 0
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push19=, 1
	i32.and 	$2=, $3, $pop19
	i32.const	$push18=, 1
	i32.add 	$3=, $3, $pop18
	i32.const	$push17=, 0
	i32.sub 	$push3=, $pop17, $2
	i32.const	$push16=, 0
	i32.const	$push15=, 1
	i32.lt_s	$push1=, $1, $pop15
	i32.select	$push2=, $pop16, $1, $pop1
	i32.and 	$push4=, $pop3, $pop2
	i32.add 	$push14=, $4, $pop4
	tee_local	$push13=, $4=, $pop14
	i32.gt_s	$push5=, $0, $pop13
	br_if   	0, $pop5        # 0: up to label1
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop
	i32.const	$push6=, 0
	i32.store	flag($pop6), $3
.LBB0_4:                                # %while.end
	end_block                       # label0:
	i32.const	$push20=, 1
                                        # fallthrough-return: $pop20
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
	i32.call	$drop=, test@FUNCTION
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


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
