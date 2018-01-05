	.text
	.file	"pr49419.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$5=, 0
	i32.const	$push34=, 0
	i32.load	$4=, t($pop34)
	block   	
	i32.const	$push3=, 1
	i32.lt_s	$push4=, $3, $pop3
	br_if   	0, $pop4        # 0: down to label2
# %bb.2:                                # %if.end
	i32.const	$push5=, 12
	i32.mul 	$push6=, $0, $pop5
	i32.add 	$push7=, $4, $pop6
	i32.load	$push2=, 0($pop7)
	i32.ne  	$push8=, $pop2, $1
	br_if   	0, $pop8        # 0: down to label2
# %bb.3:                                # %for.body.lr.ph
	i32.const	$5=, 1
	i32.const	$push10=, 2
	i32.lt_s	$push11=, $3, $pop10
	br_if   	0, $pop11       # 0: down to label2
# %bb.4:                                # %for.body.lr.ph
	i32.const	$push12=, 12
	i32.mul 	$push13=, $0, $pop12
	i32.add 	$push14=, $4, $pop13
	i32.load	$6=, 4($pop14)
	i32.const	$push35=, 12
	i32.mul 	$push15=, $6, $pop35
	i32.add 	$push16=, $4, $pop15
	i32.load	$push9=, 0($pop16)
	i32.ne  	$push17=, $pop9, $1
	br_if   	0, $pop17       # 0: down to label2
# %bb.5:                                # %for.body.preheader
	i32.const	$5=, 1
.LBB0_6:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push36=, 1
	i32.add 	$5=, $5, $pop36
	i32.ge_s	$push19=, $5, $3
	br_if   	1, $pop19       # 1: down to label2
# %bb.7:                                # %for.body
                                        #   in Loop: Header=BB0_6 Depth=1
	i32.const	$push38=, 12
	i32.mul 	$push20=, $6, $pop38
	i32.add 	$push21=, $4, $pop20
	i32.load	$6=, 4($pop21)
	i32.const	$push37=, 12
	i32.mul 	$push22=, $6, $pop37
	i32.add 	$push23=, $4, $pop22
	i32.load	$push18=, 0($pop23)
	i32.eq  	$push24=, $pop18, $1
	br_if   	0, $pop24       # 0: up to label3
.LBB0_8:                                # %for.end
	end_loop
	end_block                       # label2:
	i32.eq  	$push25=, $5, $3
	br_if   	1, $pop25       # 1: down to label0
# %bb.9:                                # %if.end7
	block   	
	i32.const	$push39=, 1
	i32.lt_s	$push26=, $5, $pop39
	br_if   	0, $pop26       # 0: down to label4
# %bb.10:                               # %for.body10.preheader
	i32.const	$push40=, 1
	i32.add 	$6=, $5, $pop40
	i32.const	$push27=, 2
	i32.shl 	$push28=, $5, $pop27
	i32.add 	$3=, $2, $pop28
.LBB0_11:                               # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push44=, 12
	i32.mul 	$push29=, $0, $pop44
	i32.add 	$0=, $4, $pop29
	i32.load	$push30=, 8($0)
	i32.store	0($3), $pop30
	i32.const	$push43=, -4
	i32.add 	$3=, $3, $pop43
	i32.const	$push42=, -1
	i32.add 	$6=, $6, $pop42
	i32.load	$0=, 4($0)
	i32.const	$push41=, 1
	i32.gt_s	$push31=, $6, $pop41
	br_if   	0, $pop31       # 0: up to label5
.LBB0_12:                               # %for.end16
	end_loop
	end_block                       # label4:
	i32.store	0($2), $0
	i32.const	$push45=, 1
	i32.add 	$push33=, $5, $pop45
	return  	$pop33
.LBB0_13:
	end_block                       # label1:
	i32.const	$push32=, 0
	return  	$pop32
.LBB0_14:                               # %if.then6
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
# %bb.0:                                # %lor.lhs.false
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 48
	i32.sub 	$0=, $pop10, $pop12
	i32.const	$push0=, 32
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.store	0($pop1), $pop2
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 0
	i64.store	0($pop4), $pop5
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i64.const	$push16=, 0
	i64.store	0($pop7), $pop16
	i64.const	$push15=, 0
	i64.store	8($0), $pop15
	i64.const	$push8=, 4294967297
	i64.store	0($0), $pop8
	i32.const	$push14=, 0
	i32.store	t($pop14), $0
	i32.const	$push9=, 2
	i32.store	8($0), $pop9
	i32.const	$push13=, 0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.int32	0
	.size	t, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
