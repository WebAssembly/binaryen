	.text
	.file	"20060910-1.c"
	.section	.text.input_getc_complicated,"ax",@progbits
	.hidden	input_getc_complicated  # -- Begin function input_getc_complicated
	.globl	input_getc_complicated
	.type	input_getc_complicated,@function
input_getc_complicated:                 # @input_getc_complicated
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	input_getc_complicated, .Lfunc_end0-input_getc_complicated
                                        # -- End function
	.section	.text.check_header,"ax",@progbits
	.hidden	check_header            # -- Begin function check_header
	.globl	check_header
	.type	check_header,@function
check_header:                           # @check_header
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$1=, 4($0)
	i32.load	$2=, 0($0)
	i32.lt_u	$3=, $2, $1
	i32.const	$push15=, 1
	i32.add 	$push0=, $2, $pop15
	i32.select	$2=, $pop0, $2, $3
	i32.lt_u	$4=, $2, $1
	i32.const	$push14=, 1
	i32.add 	$push1=, $2, $pop14
	i32.select	$2=, $pop1, $2, $4
	i32.lt_u	$5=, $2, $1
	i32.const	$push13=, 1
	i32.add 	$push2=, $2, $pop13
	i32.select	$2=, $pop2, $2, $5
	i32.lt_u	$6=, $2, $1
	i32.const	$push12=, 1
	i32.add 	$push3=, $2, $pop12
	i32.select	$2=, $pop3, $2, $6
	i32.lt_u	$7=, $2, $1
	i32.const	$push11=, 1
	i32.add 	$push4=, $2, $pop11
	i32.select	$2=, $pop4, $2, $7
	block   	
	br_if   	0, $3           # 0: down to label0
# %bb.1:                                # %entry
	br_if   	0, $4           # 0: down to label0
# %bb.2:                                # %entry
	br_if   	0, $5           # 0: down to label0
# %bb.3:                                # %entry
	br_if   	0, $6           # 0: down to label0
# %bb.4:                                # %entry
	br_if   	0, $7           # 0: down to label0
# %bb.5:                                # %entry
	i32.lt_u	$push5=, $2, $1
	br_if   	0, $pop5        # 0: down to label0
# %bb.6:
	i32.const	$push10=, 1
	return  	$pop10
.LBB1_7:
	end_block                       # label0:
	i32.const	$push16=, 1
	i32.add 	$push7=, $2, $pop16
	i32.lt_u	$push6=, $2, $1
	i32.select	$push8=, $pop7, $2, $pop6
	i32.store	0($0), $pop8
	i32.const	$push9=, 1
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end1:
	.size	check_header, .Lfunc_end1-check_header
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end2
	i32.const	$push1=, 0
	i32.const	$push0=, b+6
	i32.store	s($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, b+6
	i32.store	s+4($pop4), $pop3
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
b:
	.skip	6
	.size	b, 6

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	8
	.size	s, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
