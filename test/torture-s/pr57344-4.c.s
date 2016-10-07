	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-4.c"
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
# BB#1:                                 # %for.body.preheader
	i64.const	$push4=, -1220975898975746
	call    	foo@FUNCTION, $pop4
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push31=, i($pop32)
	tee_local	$push30=, $0=, $pop31
	i32.const	$push29=, 1
	i32.add 	$push5=, $pop30, $pop29
	i32.store	i($pop33), $pop5
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#2:                                 # %for.body.for.body_crit_edge.preheader
.LBB1_3:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push49=, 0
	i64.load32_u	$push15=, s+24($pop49)
	i32.const	$push48=, 0
	i64.load16_u	$push12=, s+28($pop48)
	i32.const	$push47=, 0
	i64.load8_u	$push10=, s+30($pop47)
	i64.const	$push46=, 16
	i64.shl 	$push11=, $pop10, $pop46
	i64.or  	$push13=, $pop12, $pop11
	i64.const	$push45=, 32
	i64.shl 	$push14=, $pop13, $pop45
	i64.or  	$push16=, $pop15, $pop14
	i64.const	$push44=, 7
	i64.shl 	$push17=, $pop16, $pop44
	i32.const	$push43=, 0
	i64.load	$push8=, s+16($pop43)
	i64.const	$push42=, 57
	i64.shr_u	$push9=, $pop8, $pop42
	i64.or  	$push18=, $pop17, $pop9
	i64.const	$push41=, 8
	i64.shl 	$push19=, $pop18, $pop41
	i64.const	$push40=, 10
	i64.shr_s	$push20=, $pop19, $pop40
	call    	foo@FUNCTION, $pop20
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load	$push37=, i($pop38)
	tee_local	$push36=, $0=, $pop37
	i32.const	$push35=, 1
	i32.add 	$push21=, $pop36, $pop35
	i32.store	i($pop39), $pop21
	i32.const	$push34=, 0
	i32.lt_s	$push22=, $0, $pop34
	br_if   	0, $pop22       # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push50=, 0
                                        # fallthrough-return: $pop50
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
