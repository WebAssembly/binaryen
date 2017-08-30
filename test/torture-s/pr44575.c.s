	.text
	.file	"pr44575.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
	.local  	f32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.load	$push19=, __stack_pointer($pop20)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop19, $pop21
	tee_local	$push25=, $4=, $pop26
	i32.store	12($pop25), $1
	i32.const	$push24=, 0
	f32.load	$2=, a+32($pop24)
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 4
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.or  	$push23=, $pop1, $pop2
	tee_local	$push22=, $1=, $pop23
	i32.const	$push3=, 18
	i32.ne  	$push4=, $pop22, $pop3
	br_if   	0, $pop4        # 0: down to label3
# BB#1:                                 # %land.lhs.true
	i32.load	$push29=, 12($4)
	tee_local	$push28=, $3=, $pop29
	i32.const	$push5=, 12
	i32.add 	$push6=, $pop28, $pop5
	i32.store	12($4), $pop6
	i32.const	$push27=, 0
	i32.load	$0=, fails($pop27)
	f32.load	$push7=, 8($3)
	f32.ne  	$push8=, $2, $pop7
	br_if   	1, $pop8        # 1: down to label2
# BB#2:                                 # %if.end
	br_if   	3, $0           # 3: down to label0
	br      	2               # 2: down to label1
.LBB0_3:                                # %sw.epilog.thread
	end_block                       # label3:
	i32.const	$push30=, 0
	i32.load	$0=, fails($pop30)
.LBB0_4:                                # %if.end.sink.split
	end_block                       # label2:
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.add 	$push32=, $0, $pop9
	tee_local	$push31=, $0=, $pop32
	i32.store	fails($pop10), $pop31
	br_if   	1, $0           # 1: down to label0
.LBB0_5:                                # %for.cond
	end_block                       # label1:
	block   	
	i32.const	$push11=, 18
	i32.ne  	$push12=, $1, $pop11
	br_if   	0, $pop12       # 0: down to label4
# BB#6:                                 # %land.lhs.true.1
	i32.load	$push34=, 12($4)
	tee_local	$push33=, $0=, $pop34
	i32.const	$push13=, 12
	i32.add 	$push14=, $pop33, $pop13
	i32.store	12($4), $pop14
	f32.load	$push15=, 8($0)
	f32.eq  	$push16=, $2, $pop15
	br_if   	1, $pop16       # 1: down to label0
.LBB0_7:                                # %if.end.1
	end_block                       # label4:
	i32.const	$push18=, 0
	i32.const	$push17=, 1
	i32.store	fails($pop18), $pop17
.LBB0_8:                                # %for.end
	end_block                       # label0:
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
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 48
	i32.sub 	$push30=, $pop6, $pop8
	tee_local	$push29=, $1=, $pop30
	i32.store	__stack_pointer($pop9), $pop29
	i32.const	$push28=, 0
	i32.const	$push0=, -952139264
	i32.store	a+32($pop28), $pop0
	i32.const	$push13=, 32
	i32.add 	$push14=, $1, $pop13
	i32.const	$push1=, 8
	i32.add 	$push2=, $pop14, $pop1
	i32.const	$push27=, -952139264
	i32.store	0($pop2), $pop27
	i32.const	$push15=, 16
	i32.add 	$push16=, $1, $pop15
	i32.const	$push26=, 8
	i32.add 	$push3=, $pop16, $pop26
	i32.const	$push25=, -952139264
	i32.store	0($pop3), $pop25
	i32.const	$push24=, 0
	i64.load	$push23=, a+24($pop24)
	tee_local	$push22=, $0=, $pop23
	i64.store	32($1), $pop22
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
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 48
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push31=, 0
	return  	$pop31
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
