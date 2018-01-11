	.text
	.file	"pr44575.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
	.local  	i32, f32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 16
	i32.sub 	$5=, $pop9, $pop11
	i32.store	12($5), $1
	i32.const	$push13=, 4
	i32.shl 	$2=, $0, $pop13
	i32.const	$push12=, 0
	f32.load	$3=, a+32($pop12)
	i32.const	$0=, 3
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	block   	
	block   	
	i32.const	$push16=, -1
	i32.add 	$push1=, $0, $pop16
	i32.const	$push15=, 2147483646
	i32.and 	$push2=, $pop1, $pop15
	i32.or  	$push3=, $pop2, $2
	i32.const	$push14=, 18
	i32.ne  	$push4=, $pop3, $pop14
	br_if   	0, $pop4        # 0: down to label3
# %bb.2:                                # %land.lhs.true
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$4=, 12($5)
	i32.const	$push18=, 12
	i32.add 	$push6=, $4, $pop18
	i32.store	12($5), $pop6
	i32.const	$push17=, 0
	i32.load	$1=, fails($pop17)
	f32.load	$push7=, 8($4)
	f32.eq  	$push8=, $3, $pop7
	br_if   	2, $pop8        # 2: down to label1
# %bb.3:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push19=, 1
	i32.add 	$1=, $1, $pop19
	br      	1               # 1: down to label2
.LBB0_4:                                # %sw.epilog.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push21=, 0
	i32.load	$push5=, fails($pop21)
	i32.const	$push20=, 1
	i32.add 	$1=, $pop5, $pop20
.LBB0_5:                                # %if.end.sink.split
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push22=, 0
	i32.store	fails($pop22), $1
.LBB0_6:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	block   	
	br_if   	0, $1           # 0: down to label4
# %bb.7:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push24=, 4
	i32.lt_u	$1=, $0, $pop24
	i32.const	$push23=, 1
	i32.add 	$push0=, $0, $pop23
	copy_local	$0=, $pop0
	br_if   	1, $1           # 1: up to label0
.LBB0_8:                                # %for.end
	end_block                       # label4:
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 48
	i32.sub 	$1=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $1
	i32.const	$push26=, 0
	i32.const	$push0=, -952139264
	i32.store	a+32($pop26), $pop0
	i32.const	$push13=, 32
	i32.add 	$push14=, $1, $pop13
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop14, $pop1
	i32.const	$push25=, -952139264
	i32.store	0($pop2), $pop25
	i32.const	$push15=, 16
	i32.add 	$push16=, $1, $pop15
	i32.const	$push24=, 8
	i32.add 	$push3=, $pop16, $pop24
	i32.const	$push23=, -952139264
	i32.store	0($pop3), $pop23
	i32.const	$push22=, 0
	i64.load	$0=, a+24($pop22)
	i64.store	32($1), $0
	i64.store	16($1), $0
	i32.const	$push17=, 16
	i32.add 	$push18=, $1, $pop17
	i32.store	4($1), $pop18
	i32.const	$push19=, 32
	i32.add 	$push20=, $1, $pop19
	i32.store	0($1), $pop20
	i32.const	$push4=, 1
	call    	check@FUNCTION, $pop4, $1
	block   	
	i32.const	$push21=, 0
	i32.load	$push5=, fails($pop21)
	br_if   	0, $pop5        # 0: down to label5
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 48
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push27=, 0
	return  	$pop27
.LBB1_2:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	fails                   # @fails
	.type	fails,@object
	.section	.bss.fails,"aw",@nobits
	.globl	fails
	.p2align	2
fails:
	.int32	0                       # 0x0
	.size	fails, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	60
	.size	a, 60


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
