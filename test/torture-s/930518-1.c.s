	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930518-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push5=, 0
	i32.load	$push4=, bar($pop5)
	tee_local	$push3=, $1=, $pop4
	i32.const	$push0=, 1
	i32.gt_s	$push1=, $pop3, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, 2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.sub 	$push11=, $2, $1
	tee_local	$push10=, $2=, $pop11
	i32.store	0($0), $pop10
	i32.const	$1=, 1
	i32.const	$push9=, 0
	i32.const	$push8=, 1
	i32.store	bar($pop9), $pop8
	i32.const	$push7=, 4
	i32.add 	$0=, $0, $pop7
	i32.const	$push6=, 1
	i32.gt_s	$push2=, $2, $pop6
	br_if   	0, $pop2        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
	copy_local	$push12=, $0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push23=, $pop15, $pop16
	tee_local	$push22=, $3=, $pop23
	i32.store	__stack_pointer($pop17), $pop22
	i64.const	$push0=, 0
	i64.store	8($3):p2align=2, $pop0
	block   	
	i32.const	$push1=, 0
	i32.load	$push21=, bar($pop1)
	tee_local	$push20=, $0=, $pop21
	i32.const	$push2=, 1
	i32.gt_s	$push3=, $pop20, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %while.body.i.preheader
	i32.const	$1=, 2
	i32.const	$push18=, 8
	i32.add 	$push19=, $3, $pop18
	copy_local	$2=, $pop19
.LBB1_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.sub 	$push27=, $1, $0
	tee_local	$push26=, $1=, $pop27
	i32.store	0($2), $pop26
	i32.const	$push25=, 4
	i32.add 	$2=, $2, $pop25
	i32.const	$0=, 1
	i32.const	$push24=, 1
	i32.gt_s	$push4=, $1, $pop24
	br_if   	0, $pop4        # 0: up to label3
# BB#3:                                 # %f.exit
	end_loop
	i32.const	$push6=, 0
	i32.const	$push28=, 1
	i32.store	bar($pop6), $pop28
	i32.load	$push8=, 8($3)
	i32.const	$push7=, 2
	i32.ne  	$push9=, $pop8, $pop7
	br_if   	0, $pop9        # 0: down to label2
# BB#4:                                 # %f.exit
	i32.const	$push10=, 12
	i32.add 	$push11=, $3, $pop10
	i32.load	$push5=, 0($pop11)
	i32.const	$push29=, 1
	i32.ne  	$push12=, $pop5, $pop29
	br_if   	0, $pop12       # 0: down to label2
# BB#5:                                 # %if.end
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0                       # 0x0
	.size	bar, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
