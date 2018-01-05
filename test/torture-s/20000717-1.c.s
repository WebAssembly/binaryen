	.text
	.file	"20000717-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($1)
	block   	
	i32.load	$push0=, 4($1)
	i32.eq  	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push2=, 8($1)
	i32.eq  	$push3=, $2, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end
	return  	$1
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($0)
	block   	
	i32.load	$push1=, 4($0)
	i32.eq  	$push2=, $2, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %entry
	i32.load	$push0=, 8($0)
	i32.eq  	$push3=, $2, $pop0
	br_if   	0, $pop3        # 0: down to label1
# %bb.2:                                # %bar.exit
	return  	$0
.LBB1_3:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$0=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $0
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.t+8($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push10=, 0
	i64.load	$push4=, .Lmain.t($pop10):p2align=2
	i64.store	0($0), $pop4
	i32.call	$drop=, foo@FUNCTION, $0, $0
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	.Lmain.t,@object        # @main.t
	.section	.rodata..Lmain.t,"a",@progbits
	.p2align	2
.Lmain.t:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	.Lmain.t, 12


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
