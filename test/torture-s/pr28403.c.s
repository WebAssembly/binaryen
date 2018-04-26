	.text
	.file	"pr28403.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.add 	$push3=, $pop2, $4
	i32.add 	$push4=, $pop3, $5
	i32.add 	$push5=, $pop4, $6
	i32.add 	$push6=, $pop5, $7
	i32.store	global($pop7), $pop6
	copy_local	$push8=, $7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
	.result 	i64
# %bb.0:                                # %entry
	i32.const	$push4=, 1
	i32.const	$push3=, 2
	i32.const	$push10=, 1
	i32.const	$push2=, 3
	i32.const	$push9=, 1
	i32.const	$push1=, 4
	i32.const	$push8=, 1
	i32.const	$push0=, 5
	i32.call	$drop=, foo@FUNCTION, $pop4, $pop3, $pop10, $pop2, $pop9, $pop1, $pop8, $pop0
	i32.const	$push5=, 0
	i64.load32_u	$push6=, global($pop5)
	i64.shr_u	$push7=, $0, $pop6
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, 81985529216486895
	i64.call	$push1=, bar@FUNCTION, $pop0
	i64.const	$push2=, 312749974122
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
