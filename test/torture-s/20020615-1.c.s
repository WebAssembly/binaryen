	.text
	.file	"20020615-1.c"
	.section	.text.line_hints,"ax",@progbits
	.hidden	line_hints              # -- Begin function line_hints
	.globl	line_hints
	.type	line_hints,@function
line_hints:                             # @line_hints
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$push3=, 0($2)
	i32.load	$push2=, 0($1)
	i32.sub 	$6=, $pop3, $pop2
	i32.const	$8=, 0
	i32.load	$3=, 4($0)
	i32.const	$push30=, 0
	i32.sub 	$push4=, $pop30, $6
	i32.select	$6=, $pop4, $6, $3
	i32.load	$push6=, 4($2)
	i32.load	$push5=, 4($1)
	i32.sub 	$2=, $pop6, $pop5
	i32.load	$4=, 8($0)
	i32.const	$push29=, 0
	i32.sub 	$push7=, $pop29, $2
	i32.select	$7=, $pop7, $2, $4
	i32.load	$1=, 0($0)
	i32.select	$2=, $7, $6, $1
	i32.const	$push8=, 31
	i32.shr_s	$0=, $2, $pop8
	i32.add 	$push9=, $2, $0
	i32.xor 	$5=, $pop9, $0
	i32.select	$0=, $6, $7, $1
	i32.const	$push28=, 31
	i32.shr_s	$6=, $0, $pop28
	i32.add 	$push10=, $0, $6
	i32.xor 	$6=, $pop10, $6
	block   	
	block   	
	i32.eqz 	$push34=, $0
	br_if   	0, $pop34       # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push31=, 4
	i32.shr_s	$push1=, $6, $pop31
	i32.gt_s	$push11=, $5, $pop1
	br_if   	0, $pop11       # 0: down to label1
# %bb.2:                                # %if.then21
	i32.const	$push16=, 2
	i32.const	$push15=, 1
	i32.const	$push13=, 0
	i32.gt_s	$push14=, $0, $pop13
	i32.select	$0=, $pop16, $pop15, $pop14
	i32.const	$push17=, 3
	i32.xor 	$push18=, $0, $pop17
	i32.select	$push12=, $4, $3, $1
	i32.select	$8=, $pop18, $0, $pop12
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.eqz 	$push35=, $2
	br_if   	0, $pop35       # 0: down to label0
# %bb.4:                                # %if.else
	i32.const	$push32=, 4
	i32.shr_s	$push19=, $5, $pop32
	i32.gt_s	$push20=, $6, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.5:                                # %if.then31
	i32.const	$push21=, 29
	i32.shr_u	$push22=, $2, $pop21
	i32.const	$push23=, 4
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push33=, 4
	i32.add 	$0=, $pop24, $pop33
	i32.const	$push25=, 12
	i32.xor 	$push26=, $0, $pop25
	i32.select	$push0=, $3, $4, $1
	i32.select	$push27=, $pop26, $0, $pop0
	return  	$pop27
.LBB0_6:                                # %if.end40
	end_block                       # label0:
	copy_local	$push36=, $8
                                        # fallthrough-return: $pop36
	.endfunc
.Lfunc_end0:
	.size	line_hints, .Lfunc_end0-line_hints
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
