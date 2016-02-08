	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
# BB#0:                                 # %entry
	block
	i64.const	$push0=, -3161
	i64.ne  	$push1=, $0, $pop0
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
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push33=, 0
	i32.load	$0=, i($pop33)
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i64.load	$push0=, .Lmain.t+8($pop31):p2align=0
	i64.store	$discard=, s+24($pop32), $pop0
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i64.load	$push1=, .Lmain.t($pop29):p2align=0
	i64.store	$discard=, s+16($pop30):p2align=4, $pop1
	block
	i32.const	$push28=, 0
	i32.gt_s	$push2=, $0, $pop28
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push3=, -3161
	call    	foo@FUNCTION, $pop3
	i32.const	$push37=, 0
	i32.const	$push36=, 0
	i32.load	$push4=, i($pop36)
	tee_local	$push35=, $0=, $pop4
	i32.const	$push34=, 1
	i32.add 	$push5=, $pop35, $pop34
	i32.store	$discard=, i($pop37), $pop5
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push8=, 0
	i64.load	$push10=, s+16($pop8):p2align=4
	tee_local	$push46=, $1=, $pop10
	i64.const	$push13=, 7
	i64.shl 	$push19=, $pop46, $pop13
	i64.const	$push22=, 50
	i64.shr_u	$push23=, $pop19, $pop22
	i32.const	$push45=, 0
	i64.load8_u	$push9=, s+24($pop45):p2align=3
	i64.const	$push44=, 7
	i64.shl 	$push14=, $pop9, $pop44
	i64.const	$push11=, 57
	i64.shr_u	$push12=, $1, $pop11
	i64.or  	$push15=, $pop14, $pop12
	i64.const	$push16=, 56
	i64.shl 	$push17=, $pop15, $pop16
	i64.const	$push43=, 56
	i64.shr_s	$push18=, $pop17, $pop43
	i64.const	$push20=, 14
	i64.shl 	$push21=, $pop18, $pop20
	i64.or  	$push24=, $pop23, $pop21
	call    	foo@FUNCTION, $pop24
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.load	$push25=, i($pop41)
	tee_local	$push40=, $0=, $pop25
	i32.const	$push39=, 1
	i32.add 	$push26=, $pop40, $pop39
	i32.store	$discard=, i($pop42), $pop26
	i32.const	$push38=, 0
	i32.lt_s	$push27=, $0, $pop38
	br_if   	0, $pop27       # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push47=, 0
	return  	$pop47
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.t,@object        # @main.t
	.section	.rodata.cst16,"aM",@progbits,16
.Lmain.t:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	56                      # 0x38
	.int8	157                     # 0x9d
	.int8	255                     # 0xff
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.skip	6
	.size	.Lmain.t, 16

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	4
s:
	.skip	32
	.size	s, 32

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.9.0 "
