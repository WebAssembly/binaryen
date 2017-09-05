	.text
	.file	"950809-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.add 	$push5=, $0, $pop0
	tee_local	$push4=, $1=, $pop5
	i32.load	$2=, 0($pop4)
	i32.load	$3=, 12($0)
	i32.load	$push3=, 8($0)
	tee_local	$push2=, $4=, $pop3
	i32.load	$5=, 8($pop2)
	i32.load	$push1=, 0($4)
	i32.store	8($4), $pop1
	i32.store	0($4), $2
	i32.store	0($0), $4
	i32.load	$4=, 4($4)
	i32.store	12($0), $5
	i32.store	0($1), $3
	i32.store	4($0), $4
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
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, main.sc($pop6)
	tee_local	$push4=, $0=, $pop5
	i32.store	main.sc+8($pop7), $pop4
	i32.const	$push3=, 0
	i32.const	$push0=, 11
	i32.store	main.sc($pop3), $pop0
	block   	
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.sc,@object         # @main.sc
	.section	.data.main.sc,"aw",@progbits
	.p2align	2
main.sc:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	main.sc, 12


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
