	.text
	.file	"20001228-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1                    # -- Begin function foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1
                                        # -- End function
	.section	.text.foo2,"ax",@progbits
	.hidden	foo2                    # -- Begin function foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop2, $pop4
	tee_local	$push5=, $0=, $pop6
	i32.const	$push0=, 1
	i32.store	12($pop5), $pop0
	i32.load8_s	$push1=, 12($0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2
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
	i32.sub 	$push10=, $pop4, $pop6
	tee_local	$push9=, $0=, $pop10
	i32.store	__stack_pointer($pop7), $pop9
	i32.const	$push0=, 1
	i32.store	12($0), $pop0
	block   	
	i32.load8_u	$push1=, 12($0)
	i32.const	$push8=, 1
	i32.ne  	$push2=, $pop1, $pop8
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
