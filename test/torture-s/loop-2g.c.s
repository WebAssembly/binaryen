	.text
	.file	"loop-2g.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 39
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.lr.ph
	i32.add 	$push4=, $1, $0
	i32.const	$push5=, 254
	i32.const	$push2=, 40
	i32.sub 	$push3=, $pop2, $0
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop5, $pop3
.LBB0_2:                                # %for.end
	end_block                       # label0:
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 2147450880
	i32.const	$push5=, 65536
	i32.const	$push4=, 3
	i32.const	$push3=, 50
	i32.const	$push0=, .L.str
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.call	$push1=, open@FUNCTION, $pop0, $pop19, $pop18
	i64.const	$push2=, 0
	i32.call	$0=, mmap@FUNCTION, $pop6, $pop5, $pop4, $pop3, $pop1, $pop2
	block   	
	i32.const	$push7=, -1
	i32.eq  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label1
# %bb.1:                                # %if.end
	i64.const	$push9=, -72340172838076674
	i64.store	32766($0):p2align=0, $pop9
	i32.const	$push24=, 0
	i32.store8	32805($0), $pop24
	i32.const	$push10=, 32797
	i32.add 	$push11=, $0, $pop10
	i64.const	$push23=, -72340172838076674
	i64.store	0($pop11):p2align=0, $pop23
	i32.const	$push12=, 32790
	i32.add 	$push13=, $0, $pop12
	i64.const	$push22=, -72340172838076674
	i64.store	0($pop13):p2align=0, $pop22
	i32.const	$push14=, 32782
	i32.add 	$push15=, $0, $pop14
	i64.const	$push21=, -72340172838076674
	i64.store	0($pop15):p2align=0, $pop21
	i32.const	$push16=, 32774
	i32.add 	$push17=, $0, $pop16
	i64.const	$push20=, -72340172838076674
	i64.store	0($pop17):p2align=0, $pop20
.LBB1_2:                                # %if.end15
	end_block                       # label1:
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"/dev/zero"
	.size	.L.str, 10


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	open, i32, i32, i32
	.functype	mmap, i32, i32, i32, i32, i32, i32, i64
	.functype	exit, void, i32
