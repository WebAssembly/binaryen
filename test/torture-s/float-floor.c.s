	.text
	.file	"float-floor.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	f64.load	$push1=, d($pop0)
	f64.floor	$0=, $pop1
	block   	
	block   	
	f64.abs 	$push7=, $0
	f64.const	$push8=, 0x1p31
	f64.lt  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$2=, -2147483648
	br      	1               # 1: down to label0
.LBB0_2:                                # %entry
	end_block                       # label1:
	i32.trunc_s/f64	$2=, $0
.LBB0_3:                                # %entry
	end_block                       # label0:
	block   	
	i32.const	$push2=, 1023
	i32.ne  	$push3=, $2, $pop2
	br_if   	0, $pop3        # 0: down to label2
# %bb.4:                                # %lor.lhs.false
	f32.demote/f64	$1=, $0
	block   	
	block   	
	f32.abs 	$push10=, $1
	f32.const	$push11=, 0x1p31
	f32.lt  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label4
# %bb.5:                                # %lor.lhs.false
	i32.const	$2=, -2147483648
	br      	1               # 1: down to label3
.LBB0_6:                                # %lor.lhs.false
	end_block                       # label4:
	i32.trunc_s/f32	$2=, $1
.LBB0_7:                                # %lor.lhs.false
	end_block                       # label3:
	i32.const	$push4=, 1023
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label2
# %bb.8:                                # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB0_9:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	3
d:
	.int64	4652218414805286912     # double 1023.9999694824219
	.size	d, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
