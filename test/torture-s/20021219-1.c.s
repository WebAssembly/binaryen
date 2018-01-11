	.text
	.file	"20021219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
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
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 16
	i32.sub 	$1=, $pop13, $pop15
	i32.const	$push3=, 10
	i32.add 	$push4=, $1, $pop3
	i32.const	$push1=, 0
	i32.load8_u	$push2=, .Lmain.str+10($pop1)
	i32.store8	0($pop4), $pop2
	i32.const	$push6=, 8
	i32.add 	$push7=, $1, $pop6
	i32.const	$push17=, 0
	i32.load16_u	$push5=, .Lmain.str+8($pop17):p2align=0
	i32.store16	0($pop7), $pop5
	i32.const	$push16=, 0
	i64.load	$push8=, .Lmain.str($pop16):p2align=0
	i64.store	0($1), $pop8
	i32.const	$push9=, 6
	i32.or  	$1=, $1, $pop9
	i32.const	$0=, 32
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push20=, 255
	i32.and 	$0=, $0, $pop20
	block   	
	i32.const	$push19=, 32
	i32.eq  	$push10=, $0, $pop19
	br_if   	0, $pop10       # 0: down to label2
# %bb.2:                                # %while.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 13
	i32.ne  	$push11=, $0, $pop21
	br_if   	2, $pop11       # 2: down to label0
.LBB1_3:                                # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.load8_u	$0=, 0($1)
	i32.const	$push18=, 1
	i32.add 	$push0=, $1, $pop18
	copy_local	$1=, $pop0
	br      	0               # 0: up to label1
.LBB1_4:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lmain.str,@object      # @main.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.str:
	.asciz	"foo { xx }"
	.size	.Lmain.str, 11


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
