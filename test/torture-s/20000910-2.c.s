	.text
	.file	"20000910-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push7=, 0
	i32.load	$push0=, list($pop7)
	i32.const	$push6=, 42
	i32.call	$push1=, strchr@FUNCTION, $pop0, $pop6
	i32.eqz 	$push10=, $pop1
	br_if   	0, $pop10       # 0: down to label1
# %bb.1:                                # %if.then.i
	i32.const	$push9=, 0
	i32.load	$push2=, list+4($pop9)
	i32.const	$push8=, 42
	i32.call	$push3=, strchr@FUNCTION, $pop2, $pop8
	i32.eqz 	$push11=, $pop3
	br_if   	1, $pop11       # 1: down to label0
# %bb.2:                                # %foo.exit
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_3:                                # %if.then2.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.else.i
	end_block                       # label0:
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"*"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"e"
	.size	.L.str.1, 2

	.hidden	list                    # @list
	.type	list,@object
	.section	.data.list,"aw",@progbits
	.globl	list
	.p2align	2
list:
	.int32	.L.str
	.int32	.L.str.1
	.size	list, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
	.functype	strchr, i32, i32, i32
