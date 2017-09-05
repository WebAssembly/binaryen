	.text
	.file	"931004-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$push20=, $pop10, $pop12
	tee_local	$push19=, $4=, $pop20
	i32.store	__stack_pointer($pop13), $pop19
	i32.const	$push18=, 4
	i32.add 	$push1=, $1, $pop18
	i32.store	12($4), $pop1
	block   	
	block   	
	i32.const	$push17=, 1
	i32.lt_s	$push2=, $0, $pop17
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load16_s	$push3=, 0($1)
	i32.ne  	$push4=, $3, $pop3
	br_if   	2, $pop4        # 2: down to label0
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push24=, 8
	i32.add 	$push5=, $1, $pop24
	i32.store	12($4), $pop5
	i32.const	$push23=, 4
	i32.add 	$1=, $1, $pop23
	i32.const	$push22=, -9
	i32.add 	$2=, $3, $pop22
	i32.const	$push21=, 1
	i32.add 	$push0=, $3, $pop21
	copy_local	$3=, $pop0
	i32.lt_s	$push6=, $2, $0
	br_if   	0, $pop6        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push7=, 0($1)
	i32.const	$push8=, 123
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#5:                                 # %if.end10
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $4, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	return  	$1
.LBB0_6:                                # %if.then
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
	i32.const	$push7=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push9=, $pop4, $pop6
	tee_local	$push8=, $0=, $pop9
	i32.store	__stack_pointer($pop7), $pop8
	i64.const	$push0=, 528280977420
	i64.store	8($0), $pop0
	i64.const	$push1=, 47244640266
	i64.store	0($0), $pop1
	i32.const	$push2=, 3
	i32.call	$drop=, f@FUNCTION, $pop2, $0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
