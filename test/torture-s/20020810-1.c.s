	.text
	.file	"20020810-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push1=, 0($0)
	i32.const	$push6=, 0
	i32.load	$push0=, R($pop6)
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push4=, 4($0)
	i32.const	$push7=, 0
	i32.load	$push3=, R+4($pop7)
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, R($pop0)
	i64.store	0($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %f.exit
	block   	
	i32.const	$push12=, 0
	i32.load	$push2=, R($pop12)
	i32.const	$push11=, 0
	i64.load	$push10=, R($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.wrap/i64	$push3=, $pop9
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %f.exit
	i32.const	$push13=, 0
	i32.load	$push0=, R+4($pop13)
	i64.const	$push5=, 32
	i64.shr_u	$push6=, $0, $pop5
	i32.wrap/i64	$push1=, $pop6
	i32.ne  	$push7=, $pop0, $pop1
	br_if   	0, $pop7        # 0: down to label1
# BB#2:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	R                       # @R
	.type	R,@object
	.section	.data.R,"aw",@progbits
	.globl	R
	.p2align	3
R:
	.int32	100                     # 0x64
	.int32	200                     # 0xc8
	.size	R, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
