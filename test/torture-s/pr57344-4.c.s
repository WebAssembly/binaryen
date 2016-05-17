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
	i32.const	$push27=, 0
	i32.load	$0=, i($pop27)
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i64.load	$push0=, .Lmain.t+8($pop25):p2align=0
	i64.store	$drop=, s+24($pop26), $pop0
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i64.load	$push1=, .Lmain.t($pop23):p2align=0
	i64.store	$drop=, s+16($pop24), $pop1
	block
	i32.const	$push22=, 0
	i32.gt_s	$push2=, $0, $pop22
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push3=, -1220975898975746
	call    	foo@FUNCTION, $pop3
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.load	$push30=, i($pop31)
	tee_local	$push29=, $0=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push4=, $pop29, $pop28
	i32.store	$drop=, i($pop32), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push48=, 0
	i64.load32_u	$push12=, s+24($pop48)
	i32.const	$push47=, 0
	i64.load16_u	$push9=, s+28($pop47)
	i32.const	$push46=, 0
	i64.load8_u	$push7=, s+30($pop46)
	i64.const	$push45=, 16
	i64.shl 	$push8=, $pop7, $pop45
	i64.or  	$push10=, $pop9, $pop8
	i64.const	$push44=, 32
	i64.shl 	$push11=, $pop10, $pop44
	i64.or  	$push13=, $pop12, $pop11
	i64.const	$push43=, 7
	i64.shl 	$push16=, $pop13, $pop43
	i32.const	$push42=, 0
	i64.load	$push14=, s+16($pop42)
	i64.const	$push41=, 57
	i64.shr_u	$push15=, $pop14, $pop41
	i64.or  	$push17=, $pop16, $pop15
	i64.const	$push40=, 8
	i64.shl 	$push18=, $pop17, $pop40
	i64.const	$push39=, 10
	i64.shr_s	$push19=, $pop18, $pop39
	call    	foo@FUNCTION, $pop19
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.load	$push36=, i($pop37)
	tee_local	$push35=, $0=, $pop36
	i32.const	$push34=, 1
	i32.add 	$push20=, $pop35, $pop34
	i32.store	$drop=, i($pop38), $pop20
	i32.const	$push33=, 0
	i32.lt_s	$push21=, $0, $pop33
	br_if   	0, $pop21       # 0: up to label2
.LBB1_4:                                # %for.end
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
