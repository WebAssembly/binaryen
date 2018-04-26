	.text
	.file	"20041213-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$2=, 0
	i32.const	$3=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	copy_local	$1=, $3
	block   	
	block   	
	i32.ge_s	$push0=, $2, $1
	br_if   	0, $pop0        # 0: down to label4
# %bb.3:                                # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push3=, 1
	i32.shl 	$push2=, $1, $pop3
	i32.sub 	$3=, $pop2, $2
	br      	1               # 1: down to label3
.LBB0_4:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$3=, $1
	i32.ne  	$push1=, $2, $1
	br_if   	3, $pop1        # 3: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
	copy_local	$2=, $1
	br_if   	0, $0           # 0: up to label2
.LBB0_6:                                # %for.end7
	end_loop
	end_block                       # label1:
	return
.LBB0_7:                                # %if.then
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
	i32.const	$push0=, 2
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
