	.text
	.file	"920909-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1026
	i32.add 	$0=, $0, $pop0
	block   	
	i32.const	$push1=, 5
	i32.gt_u	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %switch.lookup
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, .Lswitch.table.f
	i32.add 	$push7=, $pop5, $pop6
	i32.load	$push8=, 0($pop7)
	return  	$pop8
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
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
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lswitch.table.f,@object # @switch.table.f
	.section	.rodata..Lswitch.table.f,"a",@progbits
	.p2align	4
.Lswitch.table.f:
	.int32	1027                    # 0x403
	.int32	1029                    # 0x405
	.int32	1031                    # 0x407
	.int32	1033                    # 0x409
	.int32	1                       # 0x1
	.int32	4                       # 0x4
	.size	.Lswitch.table.f, 24


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
