	.text
	.file	"20000819-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.sub 	$1=, $pop0, $1
	block   	
	block   	
	i32.const	$push8=, 0
	i32.gt_s	$push1=, $1, $pop8
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push2=, 2
	i32.shl 	$push3=, $1, $pop2
	i32.add 	$1=, $0, $pop3
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load	$push4=, 0($1)
	i32.const	$push9=, 1
	i32.le_s	$push5=, $pop4, $pop9
	br_if   	2, $pop5        # 2: down to label0
# %bb.3:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push10=, 4
	i32.add 	$1=, $1, $pop10
	i32.le_u	$push6=, $1, $0
	br_if   	0, $pop6        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
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
# %bb.0:                                # %entry
	i32.const	$push1=, a+4
	i32.const	$push0=, 1
	call    	foo@FUNCTION, $pop1, $pop0
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.size	a, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
