	.text
	.file	"pr59358.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($0)
	block   	
	block   	
	i32.const	$push0=, 16
	i32.gt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.ge_s	$push2=, $2, $1
	br_if   	1, $pop2        # 1: down to label0
# %bb.2:                                # %while.cond.preheader
.LBB0_3:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	copy_local	$0=, $2
	i32.const	$push6=, 1
	i32.shl 	$2=, $0, $pop6
	i32.lt_s	$push3=, $0, $1
	br_if   	0, $pop3        # 0: up to label2
# %bb.4:                                # %if.end
	end_loop
	return  	$0
.LBB0_5:
	end_block                       # label1:
	copy_local	$push5=, $2
	return  	$pop5
.LBB0_6:
	end_block                       # label0:
	copy_local	$push4=, $2
                                        # fallthrough-return: $pop4
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i32.load	$push16=, __stack_pointer($pop17)
	i32.const	$push18=, 16
	i32.sub 	$6=, $pop16, $pop18
	i32.const	$push19=, 0
	i32.store	__stack_pointer($pop19), $6
	i32.const	$push27=, 1
	i32.store	12($6), $pop27
	i32.const	$0=, 2
	i32.const	$1=, 2
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push31=, -1
	i32.add 	$5=, $0, $pop31
	i32.const	$push23=, 12
	i32.add 	$push24=, $6, $pop23
	i32.const	$push30=, 16
	i32.call	$3=, foo@FUNCTION, $pop24, $pop30
	copy_local	$4=, $1
	block   	
	block   	
	i32.const	$push29=, 2147483640
	i32.and 	$push1=, $5, $pop29
	i32.const	$push28=, 8
	i32.eq  	$push2=, $pop1, $pop28
	br_if   	0, $pop2        # 0: down to label6
# %bb.2:                                # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push33=, 2147483644
	i32.and 	$push3=, $5, $pop33
	i32.const	$push32=, 4
	i32.ne  	$push4=, $pop3, $pop32
	br_if   	0, $pop4        # 0: down to label7
# %bb.3:                                # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push34=, 2
	i32.shl 	$push14=, $2, $pop34
	i32.eq  	$push6=, $3, $pop14
	br_if   	2, $pop6        # 2: down to label5
	br      	4               # 4: down to label3
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push37=, 24
	i32.const	$push36=, 16
	i32.const	$push35=, 6
	i32.eq  	$push5=, $1, $pop35
	i32.select	$4=, $pop37, $pop36, $pop5
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.ne  	$push7=, $3, $4
	br_if   	2, $pop7        # 2: down to label3
.LBB1_6:                                # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push25=, 12
	i32.add 	$push26=, $6, $pop25
	i32.const	$push39=, 7
	i32.call	$3=, foo@FUNCTION, $pop26, $pop39
	block   	
	block   	
	i32.const	$push38=, 6
	i32.gt_u	$push8=, $5, $pop38
	br_if   	0, $pop8        # 0: down to label9
# %bb.7:                                # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push40=, 4
	i32.lt_u	$push9=, $5, $pop40
	br_if   	0, $pop9        # 0: down to label10
# %bb.8:                                # %if.then24
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push41=, 1
	i32.shl 	$push15=, $2, $pop41
	i32.eq  	$push11=, $3, $pop15
	br_if   	2, $pop11       # 2: down to label8
	br      	4               # 4: down to label3
.LBB1_9:                                # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push44=, 12
	i32.const	$push43=, 8
	i32.const	$push42=, 6
	i32.eq  	$push10=, $1, $pop42
	i32.select	$5=, $pop44, $pop43, $pop10
.LBB1_10:                               # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push12=, $3, $5
	br_if   	2, $pop12       # 2: down to label3
.LBB1_11:                               # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push48=, 1
	i32.add 	$2=, $2, $pop48
	i32.const	$push47=, 2
	i32.add 	$1=, $1, $pop47
	i32.store	12($6), $0
	i32.const	$push46=, 16
	i32.gt_u	$5=, $0, $pop46
	i32.const	$push45=, 1
	i32.add 	$push0=, $0, $pop45
	copy_local	$0=, $pop0
	i32.eqz 	$push49=, $5
	br_if   	0, $pop49       # 0: up to label4
# %bb.12:                               # %for.end
	end_loop
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $6, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_13:                               # %if.then17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
