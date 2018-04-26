	.text
	.file	"20031010-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push4=, $2
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.then
	block   	
	i32.eqz 	$push5=, $3
	br_if   	0, $pop5        # 0: down to label1
# %bb.2:                                # %if.then4
	i32.select	$push1=, $1, $0, $4
	i32.select	$push0=, $0, $1, $4
	i32.sub 	$push2=, $pop1, $pop0
	return  	$pop2
.LBB0_3:
	end_block                       # label1:
	i32.sub 	$push3=, $0, $1
	return  	$pop3
.LBB0_4:                                # %if.end9
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 2
	i32.const	$push1=, 3
	i32.const	$push0=, 1
	i32.const	$push6=, 1
	i32.const	$push5=, 1
	i32.call	$push3=, foo@FUNCTION, $pop2, $pop1, $pop0, $pop6, $pop5
	i32.eqz 	$push7=, $pop3
	br_if   	0, $pop7        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
