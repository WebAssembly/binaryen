	.text
	.file	"960312-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 16
	i32.add 	$3=, $0, $pop0
	i32.load	$4=, 0($3)
	i32.load	$5=, 12($0)
	i32.load	$6=, 8($0)
	i32.load	$7=, 0($6)
	i32.load	$2=, 8($6)
	i32.load	$1=, 4($6)
	#APP
	#NO_APP
	i32.store	0($6), $4
	i32.store	8($6), $7
	i32.store	0($0), $6
	i32.store	12($0), $2
	i32.store	0($3), $5
	i32.store	4($0), $1
	copy_local	$push1=, $0
                                        # fallthrough-return: $pop1
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
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load8_u	$2=, main.sc.0($pop7)
	i32.const	$push6=, 0
	i32.load	$1=, main.sc.2($pop6)
	i32.const	$0=, 3
	#APP
	#NO_APP
	i32.const	$push5=, 0
	i32.const	$push0=, 1
	i32.store8	main.sc.0($pop5), $pop0
	i32.const	$push4=, 0
	i32.const	$push2=, 11
	i32.const	$push1=, 2
	i32.select	$push3=, $pop2, $pop1, $2
	i32.store	main.sc.2($pop4), $pop3
	block   	
	i32.eqz 	$push9=, $2
	br_if   	0, $pop9        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.sc.0,@object       # @main.sc.0
	.section	.bss.main.sc.0,"aw",@nobits
	.p2align	2
main.sc.0:
	.int8	0                       # 0x0
	.size	main.sc.0, 1

	.type	main.sc.2,@object       # @main.sc.2
	.section	.data.main.sc.2,"aw",@progbits
	.p2align	2
main.sc.2:
	.int32	4                       # 0x4
	.size	main.sc.2, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
