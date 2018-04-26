	.text
	.file	"20081117-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i64.load	$push0=, 0($0)
	i64.const	$push1=, 16
	i64.shr_u	$push2=, $pop0, $pop1
	i32.wrap/i64	$push3=, $pop2
	i32.eq  	$push4=, $pop3, $1
                                        # fallthrough-return: $pop4
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
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push12=, 0
	i64.load	$push0=, s($pop12)
	i64.store	8($0), $pop0
	block   	
	i32.const	$push10=, 8
	i32.add 	$push11=, $0, $pop10
	i32.const	$push1=, -2023406815
	i32.call	$push2=, f@FUNCTION, $pop11, $pop1
	i32.eqz 	$push14=, $pop2
	br_if   	0, $pop14       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.p2align	3
s:
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.int8	33                      # 0x21
	.int8	67                      # 0x43
	.int8	101                     # 0x65
	.int8	135                     # 0x87
	.int8	2                       # 0x2
	.int8	0                       # 0x0
	.size	s, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
