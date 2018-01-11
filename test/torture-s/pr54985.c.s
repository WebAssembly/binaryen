	.text
	.file	"pr54985.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$5=, 0
	block   	
	i32.eqz 	$push4=, $1
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push1=, 4
	i32.add 	$3=, $0, $pop1
	i32.load	$4=, 0($0)
.LBB0_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push2=, -1
	i32.add 	$1=, $1, $pop2
	i32.eqz 	$push5=, $1
	br_if   	1, $pop5        # 1: down to label0
# %bb.3:                                # %while.cond.while.body_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$0=, 0($3)
	i32.lt_s	$2=, $0, $4
	i32.const	$push3=, 4
	i32.add 	$push0=, $3, $pop3
	copy_local	$3=, $pop0
	copy_local	$4=, $0
	br_if   	0, $2           # 0: up to label1
# %bb.4:
	end_loop
	i32.const	$5=, 1
.LBB0_5:                                # %cleanup
	end_block                       # label0:
	copy_local	$push6=, $5
                                        # fallthrough-return: $pop6
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i64.const	$push0=, 4294967298
	i64.store	8($0), $pop0
	block   	
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push1=, 2
	i32.call	$push2=, foo@FUNCTION, $pop12, $pop1
	br_if   	0, $pop2        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
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
