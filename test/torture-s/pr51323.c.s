	.text
	.file	"pr51323.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push1=, 9
	i32.ne  	$push2=, $2, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %entry
	br_if   	0, $1           # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push0=, v($pop3)
	i32.ne  	$push4=, $pop0, $0
	br_if   	0, $pop4        # 0: down to label0
# %bb.3:                                # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 0
	call    	foo@FUNCTION, $pop0, $pop1, $0
                                        # fallthrough-return
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 48
	i32.sub 	$0=, $pop11, $pop13
	i32.const	$push14=, 0
	i32.store	__stack_pointer($pop14), $0
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	v($pop1), $pop0
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop19, $pop2
	i32.const	$push4=, 4
	i32.store	0($pop3), $pop4
	i64.const	$push5=, 12884901890
	i64.store	32($0), $pop5
	i32.const	$push29=, 4
	i32.store	40($0), $pop29
	i64.const	$push28=, 12884901890
	i64.store	16($0), $pop28
	i32.const	$push6=, 9
	i32.const	$push20=, 16
	i32.add 	$push21=, $0, $pop20
	call    	bar@FUNCTION, $pop6, $pop21
	i32.const	$push27=, 0
	i32.const	$push7=, 17
	i32.store	v($pop27), $pop7
	i32.const	$push26=, 8
	i32.add 	$push8=, $0, $pop26
	i32.const	$push9=, 18
	i32.store	0($pop8), $pop9
	i64.const	$push10=, 73014444048
	i64.store	32($0), $pop10
	i32.const	$push25=, 18
	i32.store	40($0), $pop25
	i64.const	$push24=, 73014444048
	i64.store	0($0), $pop24
	i32.const	$push23=, 9
	call    	bar@FUNCTION, $pop23, $0
	i32.const	$push17=, 0
	i32.const	$push15=, 48
	i32.add 	$push16=, $0, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	i32.const	$push22=, 0
                                        # fallthrough-return: $pop22
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	2
v:
	.int32	0                       # 0x0
	.size	v, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
