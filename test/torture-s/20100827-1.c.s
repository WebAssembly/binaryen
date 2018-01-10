	.text
	.file	"20100827-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.load8_u	$push0=, 0($0)
	i32.eqz 	$push5=, $pop0
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.end5.preheader
	i32.const	$push3=, 1
	i32.add 	$1=, $0, $pop3
	i32.const	$0=, 0
.LBB0_2:                                # %if.end5
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push4=, 1
	i32.add 	$3=, $0, $pop4
	i32.add 	$2=, $1, $0
	copy_local	$0=, $3
	i32.load8_u	$push1=, 0($2)
	br_if   	0, $pop1        # 0: up to label1
# %bb.3:                                # %do.end
	end_loop
	return  	$3
.LBB0_4:
	end_block                       # label0:
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
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
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
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
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
