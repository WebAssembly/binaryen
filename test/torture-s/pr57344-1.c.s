	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, -3161
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	#APP
	#NO_APP
	return
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$2=, i($0)
	block   	.LBB1_3
	i64.const	$push0=, 8583460864
	i64.store	$discard=, s+8($0), $pop0
	i32.gt_s	$push1=, $2, $0
	br_if   	$pop1, .LBB1_3
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, -3161
	call    	foo@FUNCTION, $pop2
	i32.load	$2=, i($0)
	i32.const	$1=, 1
	i32.add 	$push3=, $2, $1
	i32.store	$discard=, i($0), $pop3
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $2, $pop4
	br_if   	$pop5, .LBB1_3
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i64.load32_u	$push12=, s+8($0)
	i32.const	$push7=, s+8
	i32.const	$push6=, 4
	i32.add 	$push8=, $pop7, $pop6
	i64.load8_u	$push9=, 0($pop8)
	i64.const	$push10=, 32
	i64.shl 	$push11=, $pop9, $pop10
	i64.or  	$push13=, $pop12, $pop11
	i64.const	$push14=, 31
	i64.shl 	$push15=, $pop13, $pop14
	i64.const	$push16=, 24
	i64.shr_s	$push17=, $pop15, $pop16
	i64.const	$push18=, 18
	i64.shr_u	$push19=, $pop17, $pop18
	i32.wrap/i64	$push20=, $pop19
	call    	foo@FUNCTION, $pop20
	i32.load	$2=, i($0)
	i32.add 	$push21=, $2, $1
	i32.store	$discard=, i($0), $pop21
	i32.lt_s	$push22=, $2, $0
	br_if   	$pop22, .LBB1_2
.LBB1_3:                                # %for.end
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	4
s:
	.skip	16
	.size	s, 16

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
