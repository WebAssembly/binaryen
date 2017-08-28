	.text
	.file	"20000412-3.c"
	.section	.text.z,"ax",@progbits
	.hidden	z                       # -- Begin function z
	.globl	z
	.type	z,@function
z:                                      # @z
	.result 	i32
# BB#0:                                 # %f.exit
	i32.const	$push0=, 96
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	z, .Lfunc_end0-z
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 70
	block   	
	i32.load8_u	$push1=, 0($0)
	i32.load8_u	$push0=, 0($1)
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_s	$push4=, 1($1)
	i32.load8_s	$push3=, 1($0)
	i32.add 	$2=, $pop4, $pop3
.LBB2_2:                                # %return
	end_block                       # label0:
	copy_local	$push5=, $2
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
