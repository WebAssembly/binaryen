	.text
	.file	"20060910-1.c"
	.section	.text.input_getc_complicated,"ax",@progbits
	.hidden	input_getc_complicated  # -- Begin function input_getc_complicated
	.globl	input_getc_complicated
	.type	input_getc_complicated,@function
input_getc_complicated:                 # @input_getc_complicated
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.load	$push37=, 0($0)
	tee_local	$push36=, $2=, $pop37
	i32.const	$push35=, 1
	i32.add 	$push0=, $pop36, $pop35
	i32.load	$push34=, 4($0)
	tee_local	$push33=, $1=, $pop34
	i32.lt_u	$push32=, $2, $pop33
	tee_local	$push31=, $3=, $pop32
	i32.select	$push30=, $pop0, $2, $pop31
	tee_local	$push29=, $2=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push1=, $pop29, $pop28
	i32.lt_u	$push27=, $2, $1
	tee_local	$push26=, $4=, $pop27
	i32.select	$push25=, $pop1, $2, $pop26
	tee_local	$push24=, $2=, $pop25
	i32.const	$push23=, 1
	i32.add 	$push2=, $pop24, $pop23
	i32.lt_u	$push22=, $2, $1
	tee_local	$push21=, $5=, $pop22
	i32.select	$push20=, $pop2, $2, $pop21
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, 1
	i32.add 	$push3=, $pop19, $pop18
	i32.lt_u	$push17=, $2, $1
	tee_local	$push16=, $6=, $pop17
	i32.select	$push15=, $pop3, $2, $pop16
	tee_local	$push14=, $2=, $pop15
	i32.const	$push13=, 1
	i32.add 	$push4=, $pop14, $pop13
	i32.lt_u	$push12=, $2, $1
	tee_local	$push11=, $7=, $pop12
	i32.select	$2=, $pop4, $2, $pop11
	block   	
	br_if   	0, $3           # 0: down to label0
# BB#1:                                 # %entry
	br_if   	0, $4           # 0: down to label0
# BB#2:                                 # %entry
	br_if   	0, $5           # 0: down to label0
# BB#3:                                 # %entry
	br_if   	0, $6           # 0: down to label0
# BB#4:                                 # %entry
	br_if   	0, $7           # 0: down to label0
# BB#5:                                 # %entry
	i32.lt_u	$push5=, $2, $1
	br_if   	0, $pop5        # 0: down to label0
# BB#6:
	i32.const	$push10=, 1
	return  	$pop10
.LBB1_7:
	end_block                       # label0:
	i32.const	$push38=, 1
	i32.add 	$push7=, $2, $pop38
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
# BB#0:                                 # %if.end2
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
