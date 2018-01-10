	.text
	.file	"pr56837.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, -8192
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push3=, a+8192
	i32.add 	$push0=, $0, $pop3
	i64.const	$push2=, 4294967295
	i64.store	0($pop0), $pop2
	i32.const	$push1=, 8
	i32.add 	$0=, $0, $pop1
	br_if   	0, $0           # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
                                        # fallthrough-return
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
	.local  	i32, i32
# %bb.0:                                # %entry
	call    	foo@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, a
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.load	$push1=, 0($0)
	i32.const	$push6=, -1
	i32.ne  	$push2=, $pop1, $pop6
	br_if   	1, $pop2        # 1: down to label1
# %bb.2:                                # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push7=, 4
	i32.add 	$push3=, $0, $pop7
	i32.load	$push0=, 0($pop3)
	br_if   	1, $pop0        # 1: down to label1
# %bb.3:                                # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, 1
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, 8
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 1023
	i32.le_u	$push4=, $1, $pop8
	br_if   	0, $pop4        # 0: up to label2
# %bb.4:                                # %for.end
	end_loop
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_5:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	8192
	.size	a, 8192


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
