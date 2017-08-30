	.text
	.file	"20000605-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$0=, 256
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push3=, -1
	i32.add 	$push2=, $0, $pop3
	tee_local	$push1=, $0=, $pop2
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %render_image_rgb_a.exit
	end_loop
	block   	
	br_if   	0, $0           # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
