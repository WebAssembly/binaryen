	.text
	.file	"20000801-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push4=, 1
	i32.lt_s	$push0=, $1, $pop4
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %while.body.preheader
	i32.add 	$2=, $0, $1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push8=, 3
	i32.add 	$1=, $0, $pop8
	i32.load8_u	$4=, 0($1)
	i32.load8_u	$push1=, 0($0)
	i32.store8	0($1), $pop1
	i32.store8	0($0), $4
	i32.const	$push7=, 2
	i32.add 	$1=, $0, $pop7
	i32.load8_u	$3=, 0($1)
	i32.const	$push6=, 1
	i32.add 	$4=, $0, $pop6
	i32.load8_u	$push2=, 0($4)
	i32.store8	0($1), $pop2
	i32.store8	0($4), $3
	i32.const	$push5=, 4
	i32.add 	$0=, $0, $pop5
	i32.lt_u	$push3=, $0, $2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
