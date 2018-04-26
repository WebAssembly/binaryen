	.text
	.file	"20001009-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, b($pop3)
	i32.eqz 	$push7=, $pop0
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i32.const	$0=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	#APP
	#NO_APP
	i32.const	$push6=, 0
	i32.load	$push1=, b($pop6)
	i32.const	$push5=, -1
	i32.add 	$1=, $pop1, $pop5
	i32.const	$push4=, 0
	i32.store	b($pop4), $1
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop
	end_block                       # label0:
	i32.const	$push2=, -1
                                        # fallthrough-return: $pop2
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
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, b($pop2)
	i32.eqz 	$push7=, $pop0
	br_if   	0, $pop7        # 0: down to label2
# %bb.1:                                # %for.body.i.preheader
	i32.const	$0=, 1
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	#APP
	#NO_APP
	i32.const	$push5=, 0
	i32.load	$push1=, b($pop5)
	i32.const	$push4=, -1
	i32.add 	$1=, $pop1, $pop4
	i32.const	$push3=, 0
	i32.store	b($pop3), $1
	br_if   	0, $1           # 0: up to label3
.LBB1_3:                                # %foo.exit
	end_loop
	end_block                       # label2:
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
