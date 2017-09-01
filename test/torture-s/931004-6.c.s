	.text
	.file	"931004-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 16
	i32.sub 	$push24=, $pop14, $pop16
	tee_local	$push23=, $4=, $pop24
	i32.store	__stack_pointer($pop17), $pop23
	i32.const	$push22=, 4
	i32.add 	$push1=, $1, $pop22
	i32.store	12($4), $pop1
	block   	
	block   	
	i32.const	$push21=, 1
	i32.lt_s	$push2=, $0, $pop21
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load16_s	$push3=, 0($1)
	i32.ne  	$push4=, $2, $pop3
	br_if   	2, $pop4        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push26=, 10
	i32.add 	$push5=, $2, $pop26
	i32.const	$push25=, 2
	i32.add 	$push6=, $1, $pop25
	i32.load16_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	2, $pop8        # 2: down to label0
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 8
	i32.add 	$push9=, $1, $pop30
	i32.store	12($4), $pop9
	i32.const	$push29=, 4
	i32.add 	$1=, $1, $pop29
	i32.const	$push28=, -9
	i32.add 	$3=, $2, $pop28
	i32.const	$push27=, 1
	i32.add 	$push0=, $2, $pop27
	copy_local	$2=, $pop0
	i32.lt_s	$push10=, $3, $0
	br_if   	0, $pop10       # 0: up to label2
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 123
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#6:                                 # %if.end16
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return  	$1
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 48
	i32.sub 	$push19=, $pop7, $pop9
	tee_local	$push18=, $0=, $pop19
	i32.store	__stack_pointer($pop10), $pop18
	i64.const	$push0=, 6192501028618251
	i64.store	36($0):p2align=2, $pop0
	i32.const	$push1=, 1310730
	i32.store	32($0), $pop1
	i32.const	$push17=, 1310730
	i32.store	28($0), $pop17
	i32.const	$push2=, 123
	i32.store	12($0), $pop2
	i32.load	$push3=, 36($0)
	i32.store	24($0), $pop3
	i32.load	$push4=, 40($0)
	i32.store	20($0), $pop4
	i32.const	$push11=, 20
	i32.add 	$push12=, $0, $pop11
	i32.store	8($0), $pop12
	i32.const	$push13=, 24
	i32.add 	$push14=, $0, $pop13
	i32.store	4($0), $pop14
	i32.const	$push15=, 28
	i32.add 	$push16=, $0, $pop15
	i32.store	0($0), $pop16
	i32.const	$push5=, 3
	i32.call	$drop=, f@FUNCTION, $pop5, $0
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
