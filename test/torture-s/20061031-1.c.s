	.text
	.file	"20061031-1.c"
	.section	.text.ff,"ax",@progbits
	.hidden	ff                      # -- Begin function ff
	.globl	ff
	.type	ff,@function
ff:                                     # @ff
	.param  	i32
# %bb.0:                                # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ff, .Lfunc_end0-ff
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	call    	ff@FUNCTION, $0
	i32.const	$push0=, 2
	i32.add 	$1=, $0, $pop0
	block   	
	i32.const	$push4=, 65535
	i32.and 	$push1=, $1, $pop4
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.then
	#APP
	#NO_APP
.LBB1_2:                                # %for.inc
	end_block                       # label0:
	call    	ff@FUNCTION, $0
	block   	
	i32.add 	$push2=, $1, $0
	i32.const	$push5=, 65535
	i32.and 	$push3=, $pop2, $pop5
	i32.eqz 	$push6=, $pop3
	br_if   	0, $pop6        # 0: down to label1
# %bb.3:                                # %for.inc.1
	return
.LBB1_4:                                # %if.then.1
	end_block                       # label1:
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	nunmap                  # @nunmap
	.type	nunmap,@object
	.section	.rodata.nunmap,"a",@progbits
	.globl	nunmap
nunmap:
	.ascii	"\021\377\001"
	.size	nunmap, 3


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
