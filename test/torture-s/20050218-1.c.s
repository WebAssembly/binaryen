	.text
	.file	"20050218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push8=, $2
	br_if   	0, $pop8        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i32.const	$6=, 0
	i32.const	$5=, a
	i32.const	$7=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load	$4=, 0($5)
	i32.call	$3=, strlen@FUNCTION, $4
	i32.add 	$push0=, $0, $6
	i32.call	$push1=, strncmp@FUNCTION, $pop0, $4, $3
	br_if   	2, $pop1        # 2: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$6=, $3, $6
	block   	
	i32.eqz 	$push9=, $1
	br_if   	0, $pop9        # 0: down to label3
# %bb.4:                                # %if.then6
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.call	$push2=, strlen@FUNCTION, $1
	i32.add 	$6=, $pop2, $6
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push7=, 4
	i32.add 	$5=, $5, $pop7
	i32.const	$push6=, 1
	i32.add 	$7=, $7, $pop6
	i32.lt_u	$push3=, $7, $2
	br_if   	0, $pop3        # 0: up to label2
.LBB0_6:
	end_loop
	end_block                       # label1:
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_7:
	end_block                       # label0:
	i32.const	$push5=, 2
                                        # fallthrough-return: $pop5
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
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$2=, a($pop9)
	i32.call	$0=, strlen@FUNCTION, $2
	block   	
	i32.const	$push8=, .L.str.4
	i32.call	$push0=, strncmp@FUNCTION, $pop8, $2, $0
	br_if   	0, $pop0        # 0: down to label4
# %bb.1:                                # %if.end.i
	i32.const	$push11=, 0
	i32.load	$2=, a+4($pop11)
	i32.call	$1=, strlen@FUNCTION, $2
	i32.const	$push10=, .L.str.4
	i32.add 	$push1=, $0, $pop10
	i32.call	$push2=, strncmp@FUNCTION, $pop1, $2, $1
	br_if   	0, $pop2        # 0: down to label4
# %bb.2:                                # %if.end.i.1
	i32.const	$push12=, 0
	i32.load	$2=, a+8($pop12)
	i32.add 	$push3=, $1, $0
	i32.const	$push4=, .L.str.4
	i32.add 	$push5=, $pop3, $pop4
	i32.call	$push6=, strlen@FUNCTION, $2
	i32.call	$push7=, strncmp@FUNCTION, $pop5, $2, $pop6
	br_if   	0, $pop7        # 0: down to label4
# %bb.3:                                # %if.end.i.2
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"bc"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"de"
	.size	.L.str.2, 3

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"fgh"
	.size	.L.str.3, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.int32	.L.str
	.int32	.L.str.1
	.int32	.L.str.2
	.int32	.L.str.3
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.size	a, 64

	.type	.L.str.4,@object        # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.4:
	.asciz	"abcde"
	.size	.L.str.4, 6


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strncmp, i32, i32, i32, i32
	.functype	strlen, i32, i32
	.functype	abort, void
