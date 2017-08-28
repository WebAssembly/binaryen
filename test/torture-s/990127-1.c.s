	.text
	.file	"990127-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$push28=, $pop12, $pop14
	tee_local	$push27=, $4=, $pop28
	i32.store	__stack_pointer($pop15), $pop27
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
	i32.select	$push33=, $pop21, $pop23, $pop1
	tee_local	$push32=, $2=, $pop33
	i32.load	$push31=, 0($2)
	tee_local	$push30=, $2=, $pop31
	i32.const	$push29=, -1
	i32.add 	$push2=, $pop30, $pop29
	i32.store	0($pop32), $pop2
	block   	
	i32.eqz 	$push45=, $2
	br_if   	0, $pop45       # 0: down to label1
# BB#2:                                 # %while.body.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push34=, 1
	i32.add 	$1=, $3, $pop34
.LBB0_3:                                # %while.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label2:
	copy_local	$3=, $1
	i32.const	$push35=, 3
	i32.le_s	$push3=, $2, $pop35
	br_if   	1, $pop3        # 1: down to label1
# BB#4:                                 # %while.cond
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.load	$push39=, 8($4)
	tee_local	$push38=, $2=, $pop39
	i32.const	$push37=, -1
	i32.add 	$push4=, $pop38, $pop37
	i32.store	8($4), $pop4
	i32.const	$push36=, 1
	i32.add 	$1=, $3, $pop36
	br_if   	0, $2           # 0: up to label2
.LBB0_5:                                # %while.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label1:
	i32.const	$push44=, 1
	i32.add 	$3=, $3, $pop44
	i32.const	$push24=, 8
	i32.add 	$push25=, $4, $pop24
	copy_local	$2=, $pop25
	i32.const	$push43=, 1
	i32.add 	$push42=, $0, $pop43
	tee_local	$push41=, $0=, $pop42
	i32.const	$push40=, 10
	i32.ne  	$push5=, $pop41, $pop40
	br_if   	0, $pop5        # 0: up to label0
# BB#6:                                 # %for.end
	end_loop
	block   	
	i32.load	$push7=, 8($4)
	i32.const	$push6=, -5
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label3
# BB#7:                                 # %for.end
	i32.const	$push9=, 43
	i32.ne  	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#8:                                 # %if.end13
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

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
