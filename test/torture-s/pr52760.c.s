	.text
	.file	"pr52760.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.preheader
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load16_u	$2=, 0($1)
	i32.const	$push42=, 24
	i32.shl 	$push2=, $2, $pop42
	i32.const	$push41=, 8
	i32.shl 	$push3=, $2, $pop41
	i32.const	$push40=, 16711680
	i32.and 	$push4=, $pop3, $pop40
	i32.or  	$push5=, $pop2, $pop4
	i32.const	$push39=, 16
	i32.shr_u	$push6=, $pop5, $pop39
	i32.store16	0($1), $pop6
	i32.const	$push38=, 2
	i32.add 	$2=, $1, $pop38
	i32.load16_u	$3=, 0($2)
	i32.const	$push37=, 24
	i32.shl 	$push7=, $3, $pop37
	i32.const	$push36=, 8
	i32.shl 	$push8=, $3, $pop36
	i32.const	$push35=, 16711680
	i32.and 	$push9=, $pop8, $pop35
	i32.or  	$push10=, $pop7, $pop9
	i32.const	$push34=, 16
	i32.shr_u	$push11=, $pop10, $pop34
	i32.store16	0($2), $pop11
	i32.const	$push33=, 4
	i32.add 	$2=, $1, $pop33
	i32.load16_u	$3=, 0($2)
	i32.const	$push32=, 24
	i32.shl 	$push12=, $3, $pop32
	i32.const	$push31=, 8
	i32.shl 	$push13=, $3, $pop31
	i32.const	$push30=, 16711680
	i32.and 	$push14=, $pop13, $pop30
	i32.or  	$push15=, $pop12, $pop14
	i32.const	$push29=, 16
	i32.shr_u	$push16=, $pop15, $pop29
	i32.store16	0($2), $pop16
	i32.const	$push28=, 6
	i32.add 	$2=, $1, $pop28
	i32.load16_u	$3=, 0($2)
	i32.const	$push27=, 24
	i32.shl 	$push17=, $3, $pop27
	i32.const	$push26=, 8
	i32.shl 	$push18=, $3, $pop26
	i32.const	$push25=, 16711680
	i32.and 	$push19=, $pop18, $pop25
	i32.or  	$push20=, $pop17, $pop19
	i32.const	$push24=, 16
	i32.shr_u	$push21=, $pop20, $pop24
	i32.store16	0($2), $pop21
	i32.const	$push23=, 8
	i32.add 	$1=, $1, $pop23
	i32.const	$push22=, -1
	i32.add 	$0=, $0, $pop22
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 16
	i32.sub 	$0=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $0
	i64.const	$push0=, 434320308619640833
	i64.store	8($0), $pop0
	i32.const	$push1=, 1
	i32.const	$push22=, 8
	i32.add 	$push23=, $0, $pop22
	call    	foo@FUNCTION, $pop1, $pop23
	block   	
	i32.load16_u	$push3=, 8($0)
	i32.const	$push2=, 256
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label2
# %bb.1:                                # %lor.lhs.false
	i32.load16_u	$push6=, 10($0)
	i32.const	$push5=, 770
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label2
# %bb.2:                                # %lor.lhs.false5
	i32.load16_u	$push9=, 12($0)
	i32.const	$push8=, 1284
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label2
# %bb.3:                                # %lor.lhs.false9
	i32.load16_u	$push12=, 14($0)
	i32.const	$push11=, 1798
	i32.ne  	$push13=, $pop12, $pop11
	br_if   	0, $pop13       # 0: down to label2
# %bb.4:                                # %if.end
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $0, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
