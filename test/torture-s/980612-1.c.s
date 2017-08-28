	.text
	.file	"980612-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, f
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.h,"ax",@progbits
	.hidden	h                       # -- Begin function h
	.globl	h
	.type	h,@function
h:                                      # @h
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	h, .Lfunc_end1-h
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push0=, 255
	i32.store8	f+1($pop7), $pop0
	block   	
	i32.const	$push6=, 0
	i32.load8_u	$push1=, f($pop6)
	i32.const	$push2=, 111
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.gt_u	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
f:
	.int8	5                       # 0x5
	.int8	0                       # 0x0
	.size	f, 2


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
