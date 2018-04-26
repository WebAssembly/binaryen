	.text
	.file	"pr59229.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, i($pop0)
	block   	
	i32.const	$push1=, -1
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, 6
	i32.ge_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push7=, .L.str
	i32.const	$push5=, 1
	i32.add 	$push6=, $1, $pop5
	i32.call	$push8=, memcmp@FUNCTION, $0, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# %bb.2:                                # %if.end4
	i32.const	$push9=, 538976288
	i32.store	0($0):p2align=0, $pop9
	i32.const	$push10=, 6
	i32.add 	$push11=, $0, $pop10
	i32.const	$push12=, 32
	i32.store8	0($pop11), $pop12
	i32.const	$push13=, 4
	i32.add 	$push14=, $0, $pop13
	i32.const	$push15=, 8224
	i32.store16	0($pop14):p2align=0, $pop15
	return
.LBB0_3:                                # %if.then
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$2=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $2
	block   	
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 5
	i32.gt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push13=, 9
	i32.add 	$push14=, $2, $pop13
	i32.const	$push4=, 1
	i32.add 	$push5=, $1, $pop4
	i32.call	$drop=, memcpy@FUNCTION, $pop14, $0, $pop5
	i32.const	$push15=, 9
	i32.add 	$push16=, $2, $pop15
	call    	bar@FUNCTION, $pop16
.LBB1_2:                                # %return
	end_block                       # label1:
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $2, $pop10
	i32.store	__stack_pointer($pop12), $pop11
                                        # fallthrough-return
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
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.const	$push2=, 0
	i32.store	i($pop3), $pop2
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push8=, .L.str.1
	call    	foo@FUNCTION, $pop8, $1
	i32.const	$push7=, 0
	i32.load	$0=, i($pop7)
	i32.const	$push6=, 1
	i32.add 	$1=, $0, $pop6
	i32.const	$push5=, 0
	i32.store	i($pop5), $1
	i32.const	$push4=, 15
	i32.lt_s	$push0=, $0, $pop4
	br_if   	0, $pop0        # 0: up to label2
# %bb.2:                                # %for.end
	end_loop
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcdefg"
	.size	.L.str, 8

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"abcdefghijklmnop"
	.size	.L.str.1, 17


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
