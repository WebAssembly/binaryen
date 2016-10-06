	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-3.c"
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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i64.load	$push0=, .Lmain.t+8($pop24):p2align=0
	i64.store	s+24($pop25), $pop0
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i64.load	$push1=, .Lmain.t($pop22):p2align=0
	i64.store	s+16($pop23), $pop1
	block   	
	i32.const	$push21=, 0
	i32.load	$push2=, i($pop21)
	i32.const	$push20=, 0
	i32.gt_s	$push3=, $pop2, $pop20
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push4=, -3161
	call    	foo@FUNCTION, $pop4
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push28=, i($pop29)
	tee_local	$push27=, $1=, $pop28
	i32.const	$push26=, 1
	i32.add 	$push5=, $pop27, $pop26
	i32.store	i($pop30), $pop5
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $1, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push47=, 0
	i64.load	$push46=, s+16($pop47)
	tee_local	$push45=, $0=, $pop46
	i64.const	$push44=, 7
	i64.shl 	$push15=, $pop45, $pop44
	i64.const	$push43=, 50
	i64.shr_u	$push16=, $pop15, $pop43
	i32.const	$push42=, 0
	i64.load8_u	$push9=, s+24($pop42)
	i64.const	$push41=, 7
	i64.shl 	$push10=, $pop9, $pop41
	i64.const	$push40=, 57
	i64.shr_u	$push8=, $0, $pop40
	i64.or  	$push11=, $pop10, $pop8
	i64.const	$push39=, 56
	i64.shl 	$push12=, $pop11, $pop39
	i64.const	$push38=, 56
	i64.shr_s	$push13=, $pop12, $pop38
	i64.const	$push37=, 14
	i64.shl 	$push14=, $pop13, $pop37
	i64.or  	$push17=, $pop16, $pop14
	call    	foo@FUNCTION, $pop17
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push34=, i($pop35)
	tee_local	$push33=, $1=, $pop34
	i32.const	$push32=, 1
	i32.add 	$push18=, $pop33, $pop32
	i32.store	i($pop36), $pop18
	i32.const	$push31=, 0
	i32.lt_s	$push19=, $1, $pop31
	br_if   	0, $pop19       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push48=, 0
                                        # fallthrough-return: $pop48
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
