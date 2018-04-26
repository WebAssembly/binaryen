	.text
	.file	"960416-1.c"
	.section	.text.f_le,"ax",@progbits
	.hidden	f_le                    # -- Begin function f_le
	.globl	f_le
	.type	f_le,@function
f_le:                                   # @f_le
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i64, i64, i64, i64
# %bb.0:                                # %entry
	i32.load	$2=, 4($1)
	i32.load	$1=, 0($1)
	i32.sub 	$3=, $1, $2
	i32.gt_u	$4=, $3, $1
	i32.load	$5=, 0($0)
	i32.load	$0=, 4($0)
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $3
	i32.select	$push2=, $pop1, $3, $4
	i64.extend_u/i32	$push3=, $pop2
	i32.sub 	$push4=, $0, $5
	i64.extend_u/i32	$push5=, $pop4
	i64.mul 	$push6=, $pop3, $pop5
	i64.const	$push8=, -1
	i64.const	$push7=, 0
	i64.select	$push9=, $pop8, $pop7, $4
	i64.xor 	$6=, $pop6, $pop9
	i64.extend_u/i32	$push11=, $2
	i64.extend_u/i32	$push10=, $0
	i64.mul 	$7=, $pop11, $pop10
	i64.extend_u/i32	$push13=, $1
	i64.extend_u/i32	$push12=, $5
	i64.mul 	$8=, $pop13, $pop12
	i64.const	$push14=, 32
	i64.shr_u	$push15=, $8, $pop14
	i64.add 	$9=, $pop15, $7
	i64.const	$push26=, 32
	i64.shr_u	$push20=, $7, $pop26
	i64.add 	$push21=, $9, $pop20
	i64.const	$push25=, 32
	i64.shr_u	$push19=, $6, $pop25
	i64.add 	$push22=, $pop21, $pop19
	i32.wrap/i64	$push23=, $pop22
	i64.add 	$push16=, $9, $8
	i64.add 	$push17=, $pop16, $6
	i32.wrap/i64	$push18=, $pop17
	i32.add 	$push24=, $pop23, $pop18
                                        # fallthrough-return: $pop24
	.endfunc
.Lfunc_end0:
	.size	f_le, .Lfunc_end0-f_le
                                        # -- End function
	.section	.text.f_be,"ax",@progbits
	.hidden	f_be                    # -- Begin function f_be
	.globl	f_be
	.type	f_be,@function
f_be:                                   # @f_be
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i64, i64, i64, i64
# %bb.0:                                # %entry
	i32.load	$2=, 0($1)
	i32.load	$1=, 4($1)
	i32.sub 	$3=, $1, $2
	i32.gt_u	$4=, $3, $1
	i32.load	$5=, 4($0)
	i32.load	$0=, 0($0)
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $3
	i32.select	$push2=, $pop1, $3, $4
	i64.extend_u/i32	$push3=, $pop2
	i32.sub 	$push4=, $0, $5
	i64.extend_u/i32	$push5=, $pop4
	i64.mul 	$push6=, $pop3, $pop5
	i64.const	$push8=, -1
	i64.const	$push7=, 0
	i64.select	$push9=, $pop8, $pop7, $4
	i64.xor 	$6=, $pop6, $pop9
	i64.extend_u/i32	$push13=, $1
	i64.extend_u/i32	$push12=, $5
	i64.mul 	$7=, $pop13, $pop12
	i64.const	$push14=, 4294967295
	i64.and 	$8=, $7, $pop14
	i64.extend_u/i32	$push18=, $2
	i64.extend_u/i32	$push17=, $0
	i64.mul 	$9=, $pop18, $pop17
	i64.add 	$push25=, $8, $9
	i64.const	$push37=, 4294967295
	i64.and 	$push26=, $9, $pop37
	i64.add 	$push27=, $pop25, $pop26
	i64.const	$push36=, 4294967295
	i64.and 	$push24=, $6, $pop36
	i64.add 	$push28=, $pop27, $pop24
	i64.const	$push10=, 32
	i64.shr_u	$push29=, $pop28, $pop10
	i32.wrap/i64	$push30=, $pop29
	i64.const	$push35=, 32
	i64.shr_u	$push15=, $7, $pop35
	i64.add 	$push16=, $pop15, $8
	i64.const	$push34=, 32
	i64.shr_u	$push19=, $9, $pop34
	i64.add 	$push20=, $pop16, $pop19
	i64.const	$push33=, 32
	i64.shr_u	$push11=, $6, $pop33
	i64.add 	$push21=, $pop20, $pop11
	i64.const	$push32=, 32
	i64.shr_u	$push22=, $pop21, $pop32
	i32.wrap/i64	$push23=, $pop22
	i32.add 	$push31=, $pop30, $pop23
                                        # fallthrough-return: $pop31
	.endfunc
.Lfunc_end1:
	.size	f_be, .Lfunc_end1-f_be
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end12
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
