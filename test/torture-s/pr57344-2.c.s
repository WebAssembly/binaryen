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
	i32.const	$push25=, 0
	i32.load	$0=, i($pop25)
	i32.const	$push24=, 0
	i64.const	$push0=, 562525691183104
	i64.store	$discard=, s+8($pop24), $pop0
	block
	i32.const	$push23=, 0
	i32.gt_s	$push1=, $0, $pop23
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, -3161
	call    	foo@FUNCTION, $pop2
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push28=, i($pop29)
	tee_local	$push27=, $0=, $pop28
	i32.const	$push26=, 1
	i32.add 	$push3=, $pop27, $pop26
	i32.store	$discard=, i($pop30), $pop3
	i32.const	$push4=, -1
	i32.gt_s	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push6=, 0
	i64.load32_u	$push14=, s+8($pop6):p2align=3
	i32.const	$push38=, 0
	i64.load16_u	$push10=, s+12($pop38):p2align=2
	i32.const	$push37=, 0
	i64.load8_u	$push7=, s+14($pop37):p2align=1
	i64.const	$push8=, 16
	i64.shl 	$push9=, $pop7, $pop8
	i64.or  	$push11=, $pop10, $pop9
	i64.const	$push12=, 32
	i64.shl 	$push13=, $pop11, $pop12
	i64.or  	$push15=, $pop14, $pop13
	i64.const	$push16=, 15
	i64.shl 	$push17=, $pop15, $pop16
	i64.const	$push18=, 42
	i64.shr_s	$push19=, $pop17, $pop18
	i32.wrap/i64	$push20=, $pop19
	call    	foo@FUNCTION, $pop20
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push34=, i($pop35)
	tee_local	$push33=, $0=, $pop34
	i32.const	$push32=, 1
	i32.add 	$push21=, $pop33, $pop32
	i32.store	$discard=, i($pop36), $pop21
	i32.const	$push31=, 0
	i32.lt_s	$push22=, $0, $pop31
	br_if   	0, $pop22       # 0: up to label2
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
