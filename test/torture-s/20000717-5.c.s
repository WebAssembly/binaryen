	.text
	.file	"20000717-5.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($3)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push3=, 4($3)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %lor.lhs.false2
	i32.const	$push7=, 6
	i32.ne  	$push8=, $2, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %lor.lhs.false2
	i32.const	$push9=, 5
	i32.ne  	$push10=, $1, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.4:                                # %lor.lhs.false2
	i32.const	$push11=, 4
	i32.ne  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label0
# %bb.5:                                # %lor.lhs.false2
	i32.load	$push6=, 8($3)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop6, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.6:                                # %if.end
	return  	$3
.LBB0_7:                                # %if.then
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
	.param  	i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push1=, 0($0)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop0, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.2:                                # %lor.lhs.false2.i
	i32.const	$push7=, 6
	i32.ne  	$push8=, $3, $pop7
	br_if   	0, $pop8        # 0: down to label1
# %bb.3:                                # %lor.lhs.false2.i
	i32.const	$push9=, 5
	i32.ne  	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label1
# %bb.4:                                # %lor.lhs.false2.i
	i32.const	$push11=, 4
	i32.ne  	$push12=, $1, $pop11
	br_if   	0, $pop12       # 0: down to label1
# %bb.5:                                # %lor.lhs.false2.i
	i32.load	$push6=, 8($0)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop6, $pop13
	br_if   	0, $pop14       # 0: down to label1
# %bb.6:                                # %bar.exit
	return  	$0
.LBB1_7:                                # %if.then.i
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
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$0=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $0
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.t+8($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push13=, 0
	i64.load	$push4=, .Lmain.t($pop13):p2align=2
	i64.store	0($0), $pop4
	i32.const	$push7=, 4
	i32.const	$push6=, 5
	i32.const	$push5=, 6
	i32.call	$drop=, foo@FUNCTION, $0, $pop7, $pop6, $pop5
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
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
