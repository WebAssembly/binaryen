	.text
	.file	"pr40657.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 16
	i32.sub 	$push5=, $pop0, $pop2
	tee_local	$push4=, $1=, $pop5
	i32.store	12($pop4), $0
	i32.const	$push3=, 12
	i32.add 	$0=, $1, $pop3
	#APP
	#NO_APP
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
	.result 	i64
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$push11=, $pop1, $pop3
	tee_local	$push10=, $1=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.const	$push8=, 12
	i32.add 	$push9=, $1, $pop8
	call    	bar@FUNCTION, $pop9
	i32.const	$push0=, 0
	i64.load	$0=, v($pop0)
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $1, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	copy_local	$push12=, $0
                                        # fallthrough-return: $pop12
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
# BB#0:                                 # %entry
	block   	
	i64.call	$push0=, foo@FUNCTION
	i32.const	$push3=, 0
	i64.load	$push1=, v($pop3)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	3
v:
	.int64	20015998343868          # 0x123456789abc
	.size	v, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
