	.text
	.file	"20020418-1.c"
	.section	.text.gcc_crash,"ax",@progbits
	.hidden	gcc_crash               # -- Begin function gcc_crash
	.globl	gcc_crash
	.type	gcc_crash,@function
gcc_crash:                              # @gcc_crash
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $2=, $pop4
	i32.const	$push0=, 51
	i32.le_s	$push1=, $pop3, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 60
	i32.gt_s	$1=, $2, $pop2
.LBB0_2:                                # %top
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
	br_if   	0, $1           # 0: up to label1
# BB#3:                                 # %if.end6
	end_loop
	i32.store	0($0), $2
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	unreachable
	unreachable
	.endfunc
.Lfunc_end0:
	.size	gcc_crash, .Lfunc_end0-gcc_crash
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %gcc_crash.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
