	.text
	.file	"20071211-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i64.load	$push0=, sv($pop16)
	i64.const	$push1=, -1099511627776
	i64.or  	$push2=, $pop0, $pop1
	i64.store	sv($pop17), $pop2
	#APP
	#NO_APP
	i32.const	$push15=, 0
	i64.load	$0=, sv($pop15)
	i64.const	$push5=, 40
	i64.shr_u	$push6=, $0, $pop5
	i64.const	$push7=, 1
	i64.add 	$1=, $pop6, $pop7
	i32.const	$push14=, 0
	i64.const	$push13=, 40
	i64.shl 	$push8=, $1, $pop13
	i64.const	$push3=, 1099511627775
	i64.and 	$push4=, $0, $pop3
	i64.or  	$push9=, $pop8, $pop4
	i64.store	sv($pop14), $pop9
	block   	
	i64.const	$push10=, 16777215
	i64.and 	$push11=, $1, $pop10
	i64.eqz 	$push12=, $pop11
	i32.eqz 	$push19=, $pop12
	br_if   	0, $pop19       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push18=, 0
	return  	$pop18
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	sv                      # @sv
	.type	sv,@object
	.section	.bss.sv,"aw",@nobits
	.globl	sv
	.p2align	3
sv:
	.skip	8
	.size	sv, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
