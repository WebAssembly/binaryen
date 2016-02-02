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
	br_if   	$pop1, 0        # 0: down to label0
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
	i32.const	$push36=, 0
	i32.load	$0=, i($pop36)
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i64.load	$push0=, .Lmain.t+8($pop34):p2align=0
	i64.store	$discard=, s+24($pop35), $pop0
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i64.load	$push1=, .Lmain.t($pop32):p2align=0
	i64.store	$discard=, s+16($pop33):p2align=4, $pop1
	block
	i32.const	$push31=, 0
	i32.gt_s	$push2=, $0, $pop31
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push3=, -1220975898975746
	call    	foo@FUNCTION, $pop3
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.load	$push4=, i($pop39)
	tee_local	$push38=, $0=, $pop4
	i32.const	$push37=, 1
	i32.add 	$push5=, $pop38, $pop37
	i32.store	$discard=, i($pop40), $pop5
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $0, $pop6
	br_if   	$pop7, 0        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push8=, 0
	i64.load32_u	$push16=, s+24($pop8):p2align=3
	i32.const	$push48=, 0
	i64.load16_u	$push12=, s+28($pop48):p2align=2
	i32.const	$push47=, 0
	i64.load8_u	$push9=, s+30($pop47):p2align=1
	i64.const	$push10=, 16
	i64.shl 	$push11=, $pop9, $pop10
	i64.or  	$push13=, $pop12, $pop11
	i64.const	$push14=, 32
	i64.shl 	$push15=, $pop13, $pop14
	i64.or  	$push17=, $pop16, $pop15
	i64.const	$push21=, 7
	i64.shl 	$push22=, $pop17, $pop21
	i32.const	$push46=, 0
	i64.load	$push18=, s+16($pop46):p2align=4
	i64.const	$push19=, 57
	i64.shr_u	$push20=, $pop18, $pop19
	i64.or  	$push23=, $pop22, $pop20
	i64.const	$push24=, 8
	i64.shl 	$push25=, $pop23, $pop24
	i64.const	$push26=, 10
	i64.shr_s	$push27=, $pop25, $pop26
	call    	foo@FUNCTION, $pop27
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.load	$push28=, i($pop44)
	tee_local	$push43=, $0=, $pop28
	i32.const	$push42=, 1
	i32.add 	$push29=, $pop43, $pop42
	i32.store	$discard=, i($pop45), $pop29
	i32.const	$push41=, 0
	i32.lt_s	$push30=, $0, $pop41
	br_if   	$pop30, 0       # 0: up to label2
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
