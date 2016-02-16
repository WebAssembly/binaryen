	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-4.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
# BB#0:                                 # %entry
	block
	i64.const	$push0=, -1220975898975746
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push34=, 0
	i32.load	$0=, i($pop34)
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i64.load	$push0=, .Lmain.t+8($pop32):p2align=0
	i64.store	$discard=, s+24($pop33), $pop0
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i64.load	$push1=, .Lmain.t($pop30):p2align=0
	i64.store	$discard=, s+16($pop31):p2align=4, $pop1
	block
	i32.const	$push29=, 0
	i32.gt_s	$push2=, $0, $pop29
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push3=, -1220975898975746
	call    	foo@FUNCTION, $pop3
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load	$push37=, i($pop38)
	tee_local	$push36=, $0=, $pop37
	i32.const	$push35=, 1
	i32.add 	$push4=, $pop36, $pop35
	i32.store	$discard=, i($pop39), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push7=, 0
	i64.load32_u	$push15=, s+24($pop7):p2align=3
	i32.const	$push48=, 0
	i64.load16_u	$push11=, s+28($pop48):p2align=2
	i32.const	$push47=, 0
	i64.load8_u	$push8=, s+30($pop47):p2align=1
	i64.const	$push9=, 16
	i64.shl 	$push10=, $pop8, $pop9
	i64.or  	$push12=, $pop11, $pop10
	i64.const	$push13=, 32
	i64.shl 	$push14=, $pop12, $pop13
	i64.or  	$push16=, $pop15, $pop14
	i64.const	$push20=, 7
	i64.shl 	$push21=, $pop16, $pop20
	i32.const	$push46=, 0
	i64.load	$push17=, s+16($pop46):p2align=4
	i64.const	$push18=, 57
	i64.shr_u	$push19=, $pop17, $pop18
	i64.or  	$push22=, $pop21, $pop19
	i64.const	$push23=, 8
	i64.shl 	$push24=, $pop22, $pop23
	i64.const	$push25=, 10
	i64.shr_s	$push26=, $pop24, $pop25
	call    	foo@FUNCTION, $pop26
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.load	$push43=, i($pop44)
	tee_local	$push42=, $0=, $pop43
	i32.const	$push41=, 1
	i32.add 	$push27=, $pop42, $pop41
	i32.store	$discard=, i($pop45), $pop27
	i32.const	$push40=, 0
	i32.lt_s	$push28=, $0, $pop40
	br_if   	0, $pop28       # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push49=, 0
	return  	$pop49
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
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	240                     # 0xf0
	.int8	15                      # 0xf
	.int8	25                      # 0x19
	.int8	42                      # 0x2a
	.int8	59                      # 0x3b
	.int8	76                      # 0x4c
	.int8	221                     # 0xdd
	.int8	1                       # 0x1
	.int8	0                       # 0x0
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
