	.text
	.file	"20140425-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push17=, $pop5, $pop7
	tee_local	$push16=, $1=, $pop17
	i32.store	__stack_pointer($pop8), $pop16
	i32.const	$push12=, 12
	i32.add 	$push13=, $1, $pop12
	call    	set@FUNCTION, $pop13
	i32.const	$push0=, 2
	i32.load	$push15=, 12($1)
	tee_local	$push14=, $0=, $pop15
	i32.shl 	$push1=, $pop0, $pop14
	i32.store	12($1), $pop1
	block   	
	i32.const	$push2=, 30
	i32.le_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.set,"ax",@progbits
	.type	set,@function           # -- Begin function set
set:                                    # @set
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	set, .Lfunc_end1-set
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
