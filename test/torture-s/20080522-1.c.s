	.text
	.file	"20080522-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	i($pop1), $pop0
	i32.const	$push2=, 2
	i32.store	0($0), $pop2
	i32.const	$push4=, 0
	i32.load	$push3=, i($pop4)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.store	0($0), $pop0
	i32.const	$push2=, 0
	i32.const	$push1=, 1
	i32.store	i($pop2), $pop1
	i32.load	$push3=, 0($0)
                                        # fallthrough-return: $pop3
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
	i32.const	$push17=, 0
	i32.load	$push16=, __stack_pointer($pop17)
	i32.const	$push18=, 16
	i32.sub 	$0=, $pop16, $pop18
	i32.const	$push19=, 0
	i32.store	__stack_pointer($pop19), $0
	i32.const	$push0=, 0
	i32.store	12($0), $pop0
	block   	
	i32.const	$push27=, i
	i32.call	$push1=, foo@FUNCTION, $pop27
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push29=, i
	i32.call	$push4=, bar@FUNCTION, $pop29
	i32.const	$push28=, 1
	i32.ne  	$push5=, $pop4, $pop28
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end4
	i32.const	$push23=, 12
	i32.add 	$push24=, $0, $pop23
	i32.call	$push6=, foo@FUNCTION, $pop24
	i32.const	$push30=, 1
	i32.ne  	$push7=, $pop6, $pop30
	br_if   	0, $pop7        # 0: down to label0
# %bb.3:                                # %if.end8
	i32.load	$push8=, 12($0)
	i32.const	$push31=, 2
	i32.ne  	$push9=, $pop8, $pop31
	br_if   	0, $pop9        # 0: down to label0
# %bb.4:                                # %if.end11
	i32.const	$push25=, 12
	i32.add 	$push26=, $0, $pop25
	i32.call	$push10=, bar@FUNCTION, $pop26
	i32.const	$push32=, 2
	i32.ne  	$push11=, $pop10, $pop32
	br_if   	0, $pop11       # 0: down to label0
# %bb.5:                                # %if.end15
	i32.load	$push13=, 12($0)
	i32.const	$push12=, 2
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	0, $pop14       # 0: down to label0
# %bb.6:                                # %if.end18
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $0, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push15=, 0
	return  	$pop15
.LBB2_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	i,@object               # @i
	.section	.bss.i,"aw",@nobits
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
