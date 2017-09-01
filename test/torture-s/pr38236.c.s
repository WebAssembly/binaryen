	.text
	.file	"pr38236.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push14=, $pop4, $pop6
	tee_local	$push13=, $4=, $pop14
	i32.const	$push7=, 12
	i32.add 	$push8=, $pop13, $pop7
	i32.const	$push9=, 8
	i32.add 	$push10=, $4, $pop9
	i32.select	$push0=, $pop8, $pop10, $3
	i32.const	$push1=, 1
	i32.store	0($pop0), $pop1
	i32.const	$push11=, 12
	i32.add 	$push12=, $4, $pop11
	i32.select	$push2=, $pop12, $0, $2
	i32.load	$push3=, 0($pop2)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push5=, 0
	i32.const	$push0=, 1
	i32.const	$push4=, 1
	i32.call	$push1=, foo@FUNCTION, $pop5, $0, $pop0, $pop4
	i32.const	$push3=, 1
	i32.ne  	$push2=, $pop1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
