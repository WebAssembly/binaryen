	.text
	.file	"960327-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 10
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 16
	i32.sub 	$push20=, $pop11, $pop13
	tee_local	$push19=, $3=, $pop20
	i32.store	__stack_pointer($pop14), $pop19
	i32.const	$push0=, 0
	i64.load	$push1=, .Lf.s+6($pop0):p2align=0
	i64.store	6($3):p2align=1, $pop1
	i32.const	$push18=, 0
	i64.load	$push2=, .Lf.s($pop18):p2align=0
	i64.store	0($3), $pop2
	i32.const	$push3=, 13
	i32.add 	$2=, $3, $pop3
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push25=, -2
	i32.add 	$1=, $2, $pop25
	i32.const	$push24=, -1
	i32.add 	$push23=, $2, $pop24
	tee_local	$push22=, $0=, $pop23
	copy_local	$2=, $pop22
	i32.load8_u	$push4=, 0($1)
	i32.const	$push21=, 48
	i32.eq  	$push5=, $pop4, $pop21
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %while.end
	end_loop
	i32.const	$push6=, 88
	i32.store16	0($0):p2align=0, $pop6
	block   	
	i32.const	$push7=, 12
	i32.add 	$push8=, $3, $pop7
	i32.load8_u	$push9=, 0($pop8)
	i32.const	$push26=, 88
	i32.ne  	$push10=, $pop9, $pop26
	br_if   	0, $pop10       # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push17=, 0
	i32.const	$push15=, 16
	i32.add 	$push16=, $3, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	return  	$2
.LBB1_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$drop=, f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	.Lf.s,@object           # @f.s
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lf.s:
	.asciz	"abcedfg012345"
	.size	.Lf.s, 14


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
