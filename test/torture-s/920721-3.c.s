	.text
	.file	"920721-3.c"
	.section	.text.ru,"ax",@progbits
	.hidden	ru                      # -- Begin function ru
	.globl	ru
	.type	ru,@function
ru:                                     # @ru
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push8=, 65535
	i32.and 	$push0=, $0, $pop8
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push3=, 2
	i32.add 	$push4=, $0, $pop3
	i32.const	$push9=, 65535
	i32.and 	$push5=, $pop4, $pop9
	i32.const	$push6=, 7
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end8
	return  	$0
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	ru, .Lfunc_end0-ru
                                        # -- End function
	.section	.text.rs,"ax",@progbits
	.hidden	rs                      # -- Begin function rs
	.globl	rs
	.type	rs,@function
rs:                                     # @rs
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 5
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.end8
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	rs, .Lfunc_end1-rs
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
