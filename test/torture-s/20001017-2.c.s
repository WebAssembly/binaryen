	.text
	.file	"20001017-2.c"
	.section	.text.fn_4parms,"ax",@progbits
	.hidden	fn_4parms               # -- Begin function fn_4parms
	.globl	fn_4parms
	.type	fn_4parms,@function
fn_4parms:                              # @fn_4parms
	.param  	i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push3=, 0($2)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %lor.lhs.false2
	i32.load	$push6=, 0($3)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	fn_4parms, .Lfunc_end0-fn_4parms
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %fn_4parms.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
