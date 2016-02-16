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
	i32.const	$push30=, 0
	i32.load	$0=, i($pop30)
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i64.load	$push0=, .Lmain.t+8($pop28):p2align=0
	i64.store	$discard=, s+24($pop29), $pop0
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i64.load	$push1=, .Lmain.t($pop26):p2align=0
	i64.store	$discard=, s+16($pop27):p2align=4, $pop1
	block
	i32.const	$push25=, 0
	i32.gt_s	$push2=, $0, $pop25
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push3=, -3161
	call    	foo@FUNCTION, $pop3
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load	$push33=, i($pop34)
	tee_local	$push32=, $0=, $pop33
	i32.const	$push31=, 1
	i32.add 	$push4=, $pop32, $pop31
	i32.store	$discard=, i($pop35), $pop4
	i32.const	$push5=, -1
	i32.gt_s	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push7=, 0
	i64.load	$push46=, s+16($pop7):p2align=4
	tee_local	$push45=, $1=, $pop46
	i64.const	$push11=, 7
	i64.shl 	$push17=, $pop45, $pop11
	i64.const	$push20=, 50
	i64.shr_u	$push21=, $pop17, $pop20
	i32.const	$push44=, 0
	i64.load8_u	$push8=, s+24($pop44):p2align=3
	i64.const	$push43=, 7
	i64.shl 	$push12=, $pop8, $pop43
	i64.const	$push9=, 57
	i64.shr_u	$push10=, $1, $pop9
	i64.or  	$push13=, $pop12, $pop10
	i64.const	$push14=, 56
	i64.shl 	$push15=, $pop13, $pop14
	i64.const	$push42=, 56
	i64.shr_s	$push16=, $pop15, $pop42
	i64.const	$push18=, 14
	i64.shl 	$push19=, $pop16, $pop18
	i64.or  	$push22=, $pop21, $pop19
	call    	foo@FUNCTION, $pop22
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.load	$push39=, i($pop40)
	tee_local	$push38=, $0=, $pop39
	i32.const	$push37=, 1
	i32.add 	$push23=, $pop38, $pop37
	i32.store	$discard=, i($pop41), $pop23
	i32.const	$push36=, 0
	i32.lt_s	$push24=, $0, $pop36
	br_if   	0, $pop24       # 0: up to label2
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
