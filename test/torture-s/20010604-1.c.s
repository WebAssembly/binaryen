	.text
	.file	"20010604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $6, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.eqz 	$push4=, $3
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %entry
	i32.eqz 	$push5=, $4
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %entry
	i32.eqz 	$push6=, $5
	br_if   	0, $pop6        # 0: down to label0
# BB#4:                                 # %if.end
	i32.add 	$push2=, $1, $0
	i32.add 	$push3=, $pop2, $2
	return  	$pop3
.LBB0_5:                                # %if.then
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
