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
	i32.const	$push24=, 0
	i32.load	$0=, i($pop24)
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i64.load	$push0=, .Lmain.t+8($pop22):p2align=0
	i64.store	$drop=, s+24($pop23), $pop0
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i64.load	$push1=, .Lmain.t($pop20):p2align=0
	i64.store	$drop=, s+16($pop21), $pop1
	block
	i32.const	$push19=, 0
	i32.gt_s	$push2=, $0, $pop19
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push3=, -3161
	call    	foo@FUNCTION, $pop3
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, i($pop28)
	tee_local	$push26=, $0=, $pop27
	i32.const	$push25=, 1
	i32.add 	$push4=, $pop26, $pop25
	i32.store	$drop=, i($pop29), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push46=, 0
	i64.load	$push45=, s+16($pop46)
	tee_local	$push44=, $1=, $pop45
	i64.const	$push43=, 7
	i64.shl 	$push13=, $pop44, $pop43
	i64.const	$push42=, 50
	i64.shr_u	$push15=, $pop13, $pop42
	i32.const	$push41=, 0
	i64.load8_u	$push7=, s+24($pop41)
	i64.const	$push40=, 7
	i64.shl 	$push9=, $pop7, $pop40
	i64.const	$push39=, 57
	i64.shr_u	$push8=, $1, $pop39
	i64.or  	$push10=, $pop9, $pop8
	i64.const	$push38=, 56
	i64.shl 	$push11=, $pop10, $pop38
	i64.const	$push37=, 56
	i64.shr_s	$push12=, $pop11, $pop37
	i64.const	$push36=, 14
	i64.shl 	$push14=, $pop12, $pop36
	i64.or  	$push16=, $pop15, $pop14
	call    	foo@FUNCTION, $pop16
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push33=, i($pop34)
	tee_local	$push32=, $0=, $pop33
	i32.const	$push31=, 1
	i32.add 	$push17=, $pop32, $pop31
	i32.store	$drop=, i($pop35), $pop17
	i32.const	$push30=, 0
	i32.lt_s	$push18=, $0, $pop30
	br_if   	0, $pop18       # 0: up to label2
.LBB1_4:                                # %for.end
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
