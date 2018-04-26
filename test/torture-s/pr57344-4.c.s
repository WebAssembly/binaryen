	.text
	.file	"pr57344-4.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, -1220975898975746
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i64.load	$push0=, .Lmain.t+8($pop27):p2align=0
	i64.store	s+24($pop28), $pop0
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i64.load	$push1=, .Lmain.t($pop25):p2align=0
	i64.store	s+16($pop26), $pop1
	block   	
	i32.const	$push24=, 0
	i32.load	$push2=, i($pop24)
	i32.const	$push23=, 0
	i32.gt_s	$push3=, $pop2, $pop23
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i64.const	$push4=, -1220975898975746
	call    	foo@FUNCTION, $pop4
	i32.const	$push31=, 0
	i32.load	$0=, i($pop31)
	i32.const	$push30=, 0
	i32.const	$push29=, 1
	i32.add 	$push5=, $0, $pop29
	i32.store	i($pop30), $pop5
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label1
# %bb.2:                                # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push45=, 0
	i64.load32_u	$push15=, s+24($pop45)
	i32.const	$push44=, 0
	i64.load16_u	$push12=, s+28($pop44)
	i32.const	$push43=, 0
	i64.load8_u	$push10=, s+30($pop43)
	i64.const	$push42=, 16
	i64.shl 	$push11=, $pop10, $pop42
	i64.or  	$push13=, $pop12, $pop11
	i64.const	$push41=, 32
	i64.shl 	$push14=, $pop13, $pop41
	i64.or  	$push16=, $pop15, $pop14
	i64.const	$push40=, 7
	i64.shl 	$push17=, $pop16, $pop40
	i32.const	$push39=, 0
	i64.load	$push8=, s+16($pop39)
	i64.const	$push38=, 57
	i64.shr_u	$push9=, $pop8, $pop38
	i64.or  	$push18=, $pop17, $pop9
	i64.const	$push37=, 8
	i64.shl 	$push19=, $pop18, $pop37
	i64.const	$push36=, 10
	i64.shr_s	$push20=, $pop19, $pop36
	call    	foo@FUNCTION, $pop20
	i32.const	$push35=, 0
	i32.load	$0=, i($pop35)
	i32.const	$push34=, 0
	i32.const	$push33=, 1
	i32.add 	$push21=, $0, $pop33
	i32.store	i($pop34), $pop21
	i32.const	$push32=, 0
	i32.lt_s	$push22=, $0, $pop32
	br_if   	0, $pop22       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push46=, 0
                                        # fallthrough-return: $pop46
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
