	.text
	.file	"930518-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push10=, 0
	i32.load	$push9=, bar($pop10)
	tee_local	$push8=, $2=, $pop9
	i32.const	$push7=, 1
	i32.gt_s	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push16=, 2
	i32.sub 	$push15=, $pop16, $2
	tee_local	$push14=, $1=, $pop15
	i32.store	0($0), $pop14
	i32.const	$push13=, 0
	i32.const	$push12=, 1
	i32.store	bar($pop13), $pop12
	i32.const	$push11=, 2
	i32.lt_s	$push1=, $1, $pop11
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %while.body.preheader
	i32.const	$push17=, 4
	i32.add 	$0=, $0, $pop17
	i32.const	$push2=, 3
	i32.sub 	$2=, $pop2, $2
.LBB0_3:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push23=, -2
	i32.add 	$push3=, $2, $pop23
	i32.store	0($0), $pop3
	i32.const	$push22=, 4
	i32.add 	$0=, $0, $pop22
	i32.const	$push21=, -1
	i32.add 	$push20=, $2, $pop21
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, 2
	i32.gt_s	$push4=, $pop19, $pop18
	br_if   	0, $pop4        # 0: up to label1
# BB#4:                                 # %while.end.loopexit
	end_loop
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.store	bar($pop6), $pop5
.LBB0_5:                                # %while.end
	end_block                       # label0:
	copy_local	$push24=, $0
                                        # fallthrough-return: $pop24
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$push23=, $pop12, $pop14
	tee_local	$push22=, $3=, $pop23
	i32.store	__stack_pointer($pop15), $pop22
	i64.const	$push0=, 0
	i64.store	8($3):p2align=2, $pop0
	block   	
	i32.const	$push21=, 0
	i32.load	$push20=, bar($pop21)
	tee_local	$push19=, $0=, $pop20
	i32.const	$push18=, 1
	i32.gt_s	$push1=, $pop19, $pop18
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %while.body.lr.ph.i
	i32.const	$push29=, 0
	i32.const	$push28=, 1
	i32.store	bar($pop29), $pop28
	i32.const	$push27=, 2
	i32.sub 	$push26=, $pop27, $0
	tee_local	$push25=, $2=, $pop26
	i32.store	8($3), $pop25
	i32.const	$push24=, 2
	i32.lt_s	$push2=, $2, $pop24
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %while.body.i.preheader
	i32.const	$push3=, 3
	i32.sub 	$2=, $pop3, $0
	i32.const	$push16=, 8
	i32.add 	$push17=, $3, $pop16
	i32.const	$push30=, 4
	i32.add 	$1=, $pop17, $pop30
.LBB1_3:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push36=, -2
	i32.add 	$push4=, $2, $pop36
	i32.store	0($1), $pop4
	i32.const	$push35=, 4
	i32.add 	$1=, $1, $pop35
	i32.const	$push34=, -1
	i32.add 	$push33=, $2, $pop34
	tee_local	$push32=, $2=, $pop33
	i32.const	$push31=, 2
	i32.gt_s	$push5=, $pop32, $pop31
	br_if   	0, $pop5        # 0: up to label3
# BB#4:                                 # %f.exit
	end_loop
	i32.const	$push7=, 0
	i32.const	$push37=, 1
	i32.store	bar($pop7), $pop37
	br_if   	0, $0           # 0: down to label2
# BB#5:                                 # %f.exit
	i32.const	$push8=, 12
	i32.add 	$push9=, $3, $pop8
	i32.load	$push6=, 0($pop9)
	i32.const	$push38=, 1
	i32.ne  	$push10=, $pop6, $pop38
	br_if   	0, $pop10       # 0: down to label2
# BB#6:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0                       # 0x0
	.size	bar, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
