	.text
	.file	"20000706-5.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push13=, c($pop0)
	tee_local	$push12=, $1=, $pop13
	i32.load	$push1=, 0($pop12)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push4=, 4($1)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push8=, 4
	i32.ne  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %lor.lhs.false3
	i32.load	$push7=, 8($1)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop7, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	c($pop0), $0
	block   	
	i32.load	$push1=, 0($0)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.load	$push4=, 4($0)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %lor.lhs.false3.i
	i32.const	$push8=, 4
	i32.ne  	$push9=, $1, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#3:                                 # %lor.lhs.false3.i
	i32.load	$push7=, 8($0)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop7, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#4:                                 # %bar.exit
	return
.LBB1_5:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push8=, 32
	i32.sub 	$push13=, $pop6, $pop8
	tee_local	$push12=, $0=, $pop13
	i32.store	__stack_pointer($pop9), $pop12
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 3
	i32.store	0($pop1), $pop2
	i32.const	$push11=, 3
	i32.store	24($0), $pop11
	i64.const	$push3=, 8589934593
	i64.store	0($0), $pop3
	i64.const	$push10=, 8589934593
	i64.store	16($0), $pop10
	i32.const	$push4=, 4
	call    	foo@FUNCTION, $0, $pop4
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0
	.size	c, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
