	.text
	.file	"20090527-1.c"
	.section	.text.new_unit,"ax",@progbits
	.hidden	new_unit                # -- Begin function new_unit
	.globl	new_unit
	.type	new_unit,@function
new_unit:                               # @new_unit
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$1=, 4($0)
	block   	
	i32.const	$push6=, 1
	i32.ne  	$push0=, $1, $pop6
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$1=, 0
	i32.const	$push1=, 4
	i32.add 	$push2=, $0, $pop1
	i32.const	$push7=, 0
	i32.store	0($pop2), $pop7
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.load	$push3=, 0($0)
	i32.const	$push8=, 1
	i32.ne  	$push4=, $pop3, $pop8
	br_if   	0, $pop4        # 0: down to label1
# %bb.3:                                # %if.then3
	i32.const	$push5=, 0
	i32.store	0($0), $pop5
.LBB0_4:                                # %if.end5
	end_block                       # label1:
	block   	
	br_if   	0, $1           # 0: down to label2
# %bb.5:                                # %sw.epilog
	return
.LBB0_6:                                # %sw.default
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	new_unit, .Lfunc_end0-new_unit
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %new_unit.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
