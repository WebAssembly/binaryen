	.text
	.file	"961122-1.c"
	.section	.text.addhi,"ax",@progbits
	.hidden	addhi                   # -- Begin function addhi
	.globl	addhi
	.type	addhi,@function
addhi:                                  # @addhi
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.const	$push6=, 0
	i64.load	$push4=, acc($pop6)
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.add 	$push5=, $pop4, $pop2
	i64.store	acc($pop3), $pop5
	copy_local	$push7=, $0
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	addhi, .Lfunc_end0-addhi
                                        # -- End function
	.section	.text.subhi,"ax",@progbits
	.hidden	subhi                   # -- Begin function subhi
	.globl	subhi
	.type	subhi,@function
subhi:                                  # @subhi
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.const	$push6=, 0
	i64.load	$push4=, acc($pop6)
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.sub 	$push5=, $pop4, $pop2
	i64.store	acc($pop3), $pop5
	copy_local	$push7=, $0
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end1:
	.size	subhi, .Lfunc_end1-subhi
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end4
	i32.const	$push1=, 0
	i64.const	$push0=, 281470681743360
	i64.store	acc($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	acc                     # @acc
	.type	acc,@object
	.section	.bss.acc,"aw",@nobits
	.globl	acc
	.p2align	3
acc:
	.int64	0                       # 0x0
	.size	acc, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
