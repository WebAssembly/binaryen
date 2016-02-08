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
	i32.const	$push27=, 0
	i32.load	$0=, i($pop27)
	i32.const	$push26=, 0
	i64.const	$push0=, 562525691183104
	i64.store	$discard=, s+8($pop26), $pop0
	block
	i32.const	$push25=, 0
	i32.gt_s	$push1=, $0, $pop25
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, -3161
	call    	foo@FUNCTION, $pop2
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.load	$push3=, i($pop30)
	tee_local	$push29=, $0=, $pop3
	i32.const	$push28=, 1
	i32.add 	$push4=, $pop29, $pop28
	i32.store	$discard=, i($pop31), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push7=, 0
	i64.load32_u	$push15=, s+8($pop7):p2align=3
	i32.const	$push38=, 0
	i64.load16_u	$push11=, s+12($pop38):p2align=2
	i32.const	$push37=, 0
	i64.load8_u	$push8=, s+14($pop37):p2align=1
	i64.const	$push9=, 16
	i64.shl 	$push10=, $pop8, $pop9
	i64.or  	$push12=, $pop11, $pop10
	i64.const	$push13=, 32
	i64.shl 	$push14=, $pop12, $pop13
	i64.or  	$push16=, $pop15, $pop14
	i64.const	$push17=, 15
	i64.shl 	$push18=, $pop16, $pop17
	i64.const	$push19=, 42
	i64.shr_s	$push20=, $pop18, $pop19
	i32.wrap/i64	$push21=, $pop20
	call    	foo@FUNCTION, $pop21
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push22=, i($pop35)
	tee_local	$push34=, $0=, $pop22
	i32.const	$push33=, 1
	i32.add 	$push23=, $pop34, $pop33
	i32.store	$discard=, i($pop36), $pop23
	i32.const	$push32=, 0
	i32.lt_s	$push24=, $0, $pop32
	br_if   	0, $pop24       # 0: up to label2
.LBB1_3:                                # %for.end
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
