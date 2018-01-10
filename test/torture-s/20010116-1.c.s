	.text
	.file	"20010116-1.c"
	.section	.text.find,"ax",@progbits
	.hidden	find                    # -- Begin function find
	.globl	find
	.type	find,@function
find:                                   # @find
	.param  	i32, i32
# %bb.0:                                # %for.cond
	i32.sub 	$1=, $1, $0
	block   	
	i32.const	$push0=, 37
	i32.lt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body
	i32.const	$push2=, 12
	i32.div_u	$push3=, $1, $pop2
	i32.const	$push4=, 2
	i32.shr_u	$push5=, $pop3, $pop4
	call    	ok@FUNCTION, $pop5
	unreachable
.LBB0_2:                                # %for.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	find, .Lfunc_end0-find
                                        # -- End function
	.section	.text.ok,"ax",@progbits
	.hidden	ok                      # -- Begin function ok
	.globl	ok
	.type	ok,@function
ok:                                     # @ok
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	ok, .Lfunc_end1-ok
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	call    	ok@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
