	.text
	.file	"990127-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$4=, $pop12, $pop14
	i32.const	$push15=, 0
	i32.store	__stack_pointer($pop15), $4
	i32.const	$push0=, 20
	i32.store	8($4), $pop0
	i32.const	$push26=, 10
	i32.store	12($4), $pop26
	i32.const	$push16=, 12
	i32.add 	$push17=, $4, $pop16
	copy_local	$2=, $pop17
	i32.const	$0=, 0
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	                # label0:
	i32.const	$push20=, 8
	i32.add 	$push21=, $4, $pop20
	i32.const	$push22=, 12
	i32.add 	$push23=, $4, $pop22
	i32.const	$push18=, 12
	i32.add 	$push19=, $4, $pop18
	i32.eq  	$push1=, $2, $pop19
	i32.select	$1=, $pop21, $pop23, $pop1
	i32.load	$2=, 0($1)
	i32.const	$push27=, -1
	i32.add 	$push2=, $2, $pop27
	i32.store	0($1), $pop2
	block   	
	i32.eqz 	$push35=, $2
	br_if   	0, $pop35       # 0: down to label1
# %bb.2:                                # %while.body.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push28=, 1
	i32.add 	$1=, $3, $pop28
.LBB0_3:                                # %while.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label2:
	copy_local	$3=, $1
	i32.const	$push29=, 3
	i32.le_s	$push3=, $2, $pop29
	br_if   	1, $pop3        # 1: down to label1
# %bb.4:                                # %while.cond
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.load	$2=, 8($4)
	i32.const	$push31=, -1
	i32.add 	$push4=, $2, $pop31
	i32.store	8($4), $pop4
	i32.const	$push30=, 1
	i32.add 	$1=, $3, $pop30
	br_if   	0, $2           # 0: up to label2
.LBB0_5:                                # %while.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label1:
	i32.const	$push34=, 1
	i32.add 	$3=, $3, $pop34
	i32.const	$push33=, 1
	i32.add 	$0=, $0, $pop33
	i32.const	$push24=, 8
	i32.add 	$push25=, $4, $pop24
	copy_local	$2=, $pop25
	i32.const	$push32=, 10
	i32.ne  	$push5=, $0, $pop32
	br_if   	0, $pop5        # 0: up to label0
# %bb.6:                                # %for.end
	end_loop
	block   	
	i32.load	$push7=, 8($4)
	i32.const	$push6=, -5
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label3
# %bb.7:                                # %for.end
	i32.const	$push9=, 43
	i32.ne  	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label3
# %bb.8:                                # %if.end13
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_9:                                # %if.then12
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
