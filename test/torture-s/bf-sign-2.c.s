	.text
	.file	"bf-sign-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# %bb.0:                                # %entry
	block   	
	i32.const	$push20=, 0
	i32.load8_u	$push0=, x($pop20)
	i32.const	$push1=, 6
	i32.and 	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push21=, 0
	i32.load	$push3=, x+4($pop21)
	i32.const	$push4=, 1
	i32.shl 	$push5=, $pop3, $pop4
	i32.const	$push6=, 3
	i32.ge_s	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end5
	i32.const	$push22=, 0
	i64.load	$0=, x+8($pop22)
	i32.wrap/i64	$push8=, $0
	i32.const	$push9=, 2
	i32.ge_s	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.3:                                # %if.end13
	i32.const	$push23=, 0
	i32.load	$push11=, x+28($pop23)
	i32.const	$push12=, 262128
	i32.and 	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# %bb.4:                                # %if.end20
	i64.const	$push14=, 9223372028264841216
	i64.and 	$push15=, $0, $pop14
	i64.eqz 	$push16=, $pop15
	i32.eqz 	$push26=, $pop16
	br_if   	0, $pop26       # 0: down to label0
# %bb.5:                                # %if.end35
	i32.const	$push24=, 0
	i32.load8_u	$push17=, x+20($pop24)
	i32.const	$push18=, 6
	i32.and 	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.6:                                # %if.end50
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	32
	.size	x, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
