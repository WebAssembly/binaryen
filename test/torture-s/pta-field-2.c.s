	.text
	.file	"pta-field-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -4
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 0
	i32.store	0($pop2), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push16=, $pop4, $pop6
	tee_local	$push15=, $1=, $pop16
	i32.store	__stack_pointer($pop7), $pop15
	i32.const	$push0=, 1
	i32.store	4($1), $pop0
	i32.const	$push1=, 2
	i32.store	0($1), $pop1
	i32.const	$push11=, 4
	i32.add 	$push12=, $1, $pop11
	i32.store	8($1), $pop12
	i32.store	12($1), $1
	i32.const	$push13=, 8
	i32.add 	$push14=, $1, $pop13
	i32.const	$push2=, 4
	i32.or  	$push3=, $pop14, $pop2
	call    	bar@FUNCTION, $pop3
	i32.load	$0=, 4($1)
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	copy_local	$push17=, $0
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$push18=, $pop6, $pop8
	tee_local	$push17=, $0=, $pop18
	i32.store	__stack_pointer($pop9), $pop17
	i32.const	$push0=, 1
	i32.store	4($0), $pop0
	i32.const	$push1=, 2
	i32.store	0($0), $pop1
	i32.const	$push13=, 4
	i32.add 	$push14=, $0, $pop13
	i32.store	8($0), $pop14
	i32.store	12($0), $0
	i32.const	$push15=, 8
	i32.add 	$push16=, $0, $pop15
	i32.const	$push2=, 4
	i32.or  	$push3=, $pop16, $pop2
	call    	bar@FUNCTION, $pop3
	block   	
	i32.load	$push4=, 4($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
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
