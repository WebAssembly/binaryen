	.text
	.file	"pr20527-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.gt_s	$push0=, $2, $3
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i32.const	$push10=, -1
	i32.add 	$4=, $2, $pop10
	i32.const	$push1=, 2
	i32.shl 	$2=, $2, $pop1
	i32.add 	$0=, $0, $2
	i32.add 	$push2=, $1, $2
	i32.const	$push9=, 4
	i32.add 	$2=, $pop2, $pop9
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push5=, 0($2)
	i32.const	$push15=, -4
	i32.add 	$push3=, $2, $pop15
	i32.load	$push4=, 0($pop3)
	i32.sub 	$push6=, $pop5, $pop4
	i32.add 	$1=, $pop6, $1
	i32.const	$push14=, -1
	i32.add 	$push7=, $1, $pop14
	i32.store	0($0), $pop7
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	i32.const	$push12=, 4
	i32.add 	$2=, $2, $pop12
	i32.const	$push11=, 1
	i32.add 	$4=, $4, $pop11
	i32.lt_s	$push8=, $4, $3
	br_if   	0, $pop8        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 16
	i32.sub 	$0=, $pop13, $pop15
	i32.const	$push16=, 0
	i32.store	__stack_pointer($pop16), $0
	i32.const	$push17=, 4
	i32.add 	$push18=, $0, $pop17
	i32.const	$push2=, b
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	call    	f@FUNCTION, $pop18, $pop2, $pop1, $pop0
	block   	
	i32.load	$push4=, 4($0)
	i32.const	$push3=, 3
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label2
# %bb.1:                                # %lor.lhs.false
	i32.load	$push7=, 8($0)
	i32.const	$push6=, 9
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label2
# %bb.2:                                # %lor.lhs.false3
	i32.load	$push10=, 12($0)
	i32.const	$push9=, 21
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label2
# %bb.3:                                # %if.end
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	4
b:
	.int32	1                       # 0x1
	.int32	5                       # 0x5
	.int32	11                      # 0xb
	.int32	23                      # 0x17
	.size	b, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
