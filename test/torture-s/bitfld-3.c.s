	.text
	.file	"bitfld-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i64.load	$push0=, a($pop10)
	i64.const	$push1=, 8589934591
	i64.and 	$0=, $pop0, $pop1
	block   	
	i64.mul 	$push2=, $0, $0
	i64.const	$push3=, 0
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push11=, 0
	i64.load	$push5=, a+8($pop11)
	i64.const	$push6=, 1099511627775
	i64.and 	$1=, $pop5, $pop6
	i64.mul 	$push7=, $1, $0
	i64.mul 	$push8=, $1, $1
	i64.or  	$push9=, $pop7, $pop8
	i64.eqz 	$drop=, $pop9
.LBB0_2:                                # %if.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	16                      # 0x10
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	16                      # 0x10
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	16                      # 0x10
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	2
	.size	a, 24

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	3
b:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	1                       # 0x1
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	1                       # 0x1
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.skip	2
	.size	b, 24

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	3
c:
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	1                       # 0x1
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	2
	.size	c, 24


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
