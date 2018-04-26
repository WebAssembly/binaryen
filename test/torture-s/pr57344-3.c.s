	.text
	.file	"pr57344-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, -3161
	i64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32
# %bb.0:                                # %entry
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
# %bb.1:                                # %for.body.lr.ph
	i64.const	$push4=, -3161
	call    	foo@FUNCTION, $pop4
	i32.const	$push28=, 0
	i32.load	$1=, i($pop28)
	i32.const	$push27=, 0
	i32.const	$push26=, 1
	i32.add 	$push5=, $1, $pop26
	i32.store	i($pop27), $pop5
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $1, $pop6
	br_if   	0, $pop7        # 0: down to label1
# %bb.2:                                # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push41=, 0
	i64.load	$0=, s+16($pop41)
	i64.const	$push40=, 7
	i64.shl 	$push15=, $0, $pop40
	i64.const	$push39=, 50
	i64.shr_u	$push16=, $pop15, $pop39
	i32.const	$push38=, 0
	i64.load8_u	$push9=, s+24($pop38)
	i64.const	$push37=, 7
	i64.shl 	$push10=, $pop9, $pop37
	i64.const	$push36=, 57
	i64.shr_u	$push8=, $0, $pop36
	i64.or  	$push11=, $pop10, $pop8
	i64.const	$push35=, 56
	i64.shl 	$push12=, $pop11, $pop35
	i64.const	$push34=, 56
	i64.shr_s	$push13=, $pop12, $pop34
	i64.const	$push33=, 14
	i64.shl 	$push14=, $pop13, $pop33
	i64.or  	$push17=, $pop16, $pop14
	call    	foo@FUNCTION, $pop17
	i32.const	$push32=, 0
	i32.load	$1=, i($pop32)
	i32.const	$push31=, 0
	i32.const	$push30=, 1
	i32.add 	$push18=, $1, $pop30
	i32.store	i($pop31), $pop18
	i32.const	$push29=, 0
	i32.lt_s	$push19=, $1, $pop29
	br_if   	0, $pop19       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push42=, 0
                                        # fallthrough-return: $pop42
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
