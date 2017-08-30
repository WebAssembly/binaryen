	.text
	.file	"20000113-1.c"
	.section	.text.foobar,"ax",@progbits
	.hidden	foobar                  # -- Begin function foobar
	.globl	foobar
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 1
	i32.and 	$push11=, $0, $pop1
	tee_local	$push10=, $0=, $pop11
	i32.eqz 	$push14=, $pop10
	br_if   	0, $pop14       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push0=, 3
	i32.and 	$push13=, $1, $pop0
	tee_local	$push12=, $1=, $pop13
	i32.sub 	$push2=, $pop12, $0
	i32.mul 	$push3=, $pop2, $1
	i32.add 	$push4=, $pop3, $2
	i32.const	$push5=, 7
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foobar, .Lfunc_end0-foobar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
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
