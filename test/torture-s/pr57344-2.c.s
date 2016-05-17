	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -3161
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	#APP
	#NO_APP
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.load	$0=, i($pop20)
	i32.const	$push19=, 0
	i64.const	$push0=, 562525691183104
	i64.store	$drop=, s+8($pop19), $pop0
	block
	i32.const	$push18=, 0
	i32.gt_s	$push1=, $0, $pop18
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, -3161
	call    	foo@FUNCTION, $pop2
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push23=, i($pop24)
	tee_local	$push22=, $0=, $pop23
	i32.const	$push21=, 1
	i32.add 	$push3=, $pop22, $pop21
	i32.store	$drop=, i($pop25), $pop3
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push38=, 0
	i64.load32_u	$push11=, s+8($pop38)
	i32.const	$push37=, 0
	i64.load16_u	$push8=, s+12($pop37)
	i32.const	$push36=, 0
	i64.load8_u	$push6=, s+14($pop36)
	i64.const	$push35=, 16
	i64.shl 	$push7=, $pop6, $pop35
	i64.or  	$push9=, $pop8, $pop7
	i64.const	$push34=, 32
	i64.shl 	$push10=, $pop9, $pop34
	i64.or  	$push12=, $pop11, $pop10
	i64.const	$push33=, 15
	i64.shl 	$push13=, $pop12, $pop33
	i64.const	$push32=, 42
	i64.shr_s	$push14=, $pop13, $pop32
	i32.wrap/i64	$push15=, $pop14
	call    	foo@FUNCTION, $pop15
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.load	$push29=, i($pop30)
	tee_local	$push28=, $0=, $pop29
	i32.const	$push27=, 1
	i32.add 	$push16=, $pop28, $pop27
	i32.store	$drop=, i($pop31), $pop16
	i32.const	$push26=, 0
	i32.lt_s	$push17=, $0, $pop26
	br_if   	0, $pop17       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push39=, 0
	return  	$pop39
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	4
s:
	.skip	16
	.size	s, 16

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.9.0 "
