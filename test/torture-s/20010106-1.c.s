	.text
	.file	"20010106-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 2
	i32.add 	$0=, $0, $pop6
	block   	
	i32.const	$push0=, 7
	i32.ge_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %switch.lookup
	i32.const	$push7=, 2
	i32.shl 	$push2=, $0, $pop7
	i32.const	$push3=, .Lswitch.table.f
	i32.add 	$push4=, $pop2, $pop3
	i32.load	$push5=, 0($pop4)
	return  	$pop5
.LBB0_2:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	.int32	33                      # 0x21
	.int32	0                       # 0x0
	.int32	7                       # 0x7
	.int32	4                       # 0x4
	.int32	3                       # 0x3
	.int32	15                      # 0xf
	.int32	9                       # 0x9
	.size	.Lswitch.table.f, 28


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
