	.text
	.file	"pr53465.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push3=, 1
	i32.lt_s	$push0=, $1, $pop3
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$3=, 0
                                        # implicit-def: %29
	i32.const	$5=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	copy_local	$2=, $4
	i32.load	$4=, 0($0)
	i32.eqz 	$push6=, $4
	br_if   	1, $pop6        # 1: down to label1
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	block   	
	i32.eqz 	$push7=, $5
	br_if   	0, $pop7        # 0: down to label3
# %bb.4:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.le_s	$push1=, $4, $2
	br_if   	3, $pop1        # 3: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push5=, 1
	i32.add 	$3=, $3, $pop5
	i32.const	$push4=, 4
	i32.add 	$0=, $0, $pop4
	i32.const	$5=, 1
	i32.lt_s	$push2=, $3, $1
	br_if   	0, $pop2        # 0: up to label2
.LBB0_6:                                # %for.end
	end_loop
	end_block                       # label1:
	return
.LBB0_7:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
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
# %bb.0:                                # %for.cond.i.1
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
