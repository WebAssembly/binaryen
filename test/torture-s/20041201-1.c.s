	.text
	.file	"20041201-1.c"
	.section	.text.checkScc2,"ax",@progbits
	.hidden	checkScc2               # -- Begin function checkScc2
	.globl	checkScc2
	.type	checkScc2,@function
checkScc2:                              # @checkScc2
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$1=, 1
	block   	
	i32.load8_u	$push1=, 0($0)
	i32.const	$push14=, 1
	i32.ne  	$push2=, $pop1, $pop14
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %entry
	i32.load8_u	$push0=, 1($0)
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop0, $pop3
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %lor.rhs
	i32.load8_u	$push7=, 2($0)
	i32.const	$push8=, 3
	i32.ne  	$push9=, $pop7, $pop8
	i32.const	$push15=, 3
	i32.add 	$push10=, $0, $pop15
	i32.load8_u	$push11=, 0($pop10)
	i32.const	$push12=, 4
	i32.ne  	$push13=, $pop11, $pop12
	i32.or  	$1=, $pop9, $pop13
.LBB0_3:                                # %lor.end
	end_block                       # label0:
	copy_local	$push16=, $1
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end0:
	.size	checkScc2, .Lfunc_end0-checkScc2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$0=, 1
	block   	
	i32.const	$push15=, 0
	i32.load8_u	$push1=, s($pop15)
	i32.const	$push14=, 1
	i32.ne  	$push2=, $pop1, $pop14
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push16=, 0
	i32.load8_u	$push0=, s+1($pop16)
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop0, $pop3
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# %bb.2:                                # %lor.rhs.i
	i32.const	$push7=, 0
	i32.load8_u	$push11=, s+2($pop7)
	i32.const	$push12=, 3
	i32.ne  	$push13=, $pop11, $pop12
	i32.const	$push17=, 0
	i32.load8_u	$push8=, s+3($pop17)
	i32.const	$push9=, 4
	i32.ne  	$push10=, $pop8, $pop9
	i32.or  	$0=, $pop13, $pop10
.LBB1_3:                                # %checkScc2.exit
	end_block                       # label1:
	copy_local	$push18=, $0
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
s:
	.int8	1                       # 0x1
	.int8	2                       # 0x2
	.int8	3                       # 0x3
	.int8	4                       # 0x4
	.size	s, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
