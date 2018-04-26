	.text
	.file	"20071216-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.call	$0=, bar@FUNCTION
	i32.const	$push3=, -37
	i32.const	$push2=, -1
	i32.const	$push0=, -38
	i32.eq  	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
	i32.const	$push5=, -4095
	i32.lt_u	$push6=, $0, $pop5
	i32.select	$push7=, $0, $pop4, $pop6
                                        # fallthrough-return: $pop7
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
	i32.const	$push26=, 0
	i32.const	$push0=, 26
	i32.store	x($pop26), $pop0
	i32.call	$0=, bar@FUNCTION
	block   	
	i32.const	$push25=, -37
	i32.const	$push24=, -1
	i32.const	$push23=, -38
	i32.eq  	$push1=, $0, $pop23
	i32.select	$push2=, $pop25, $pop24, $pop1
	i32.const	$push22=, -4095
	i32.lt_u	$push3=, $0, $pop22
	i32.select	$push4=, $0, $pop2, $pop3
	i32.const	$push21=, 26
	i32.ne  	$push5=, $pop4, $pop21
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push32=, 0
	i32.const	$push6=, -39
	i32.store	x($pop32), $pop6
	i32.call	$0=, bar@FUNCTION
	i32.const	$push31=, -37
	i32.const	$push30=, -1
	i32.const	$push29=, -38
	i32.eq  	$push7=, $0, $pop29
	i32.select	$push8=, $pop31, $pop30, $pop7
	i32.const	$push28=, -4095
	i32.lt_u	$push9=, $0, $pop28
	i32.select	$push10=, $0, $pop8, $pop9
	i32.const	$push27=, -1
	i32.ne  	$push11=, $pop10, $pop27
	br_if   	0, $pop11       # 0: down to label0
# %bb.2:                                # %if.end4
	i32.const	$push35=, 0
	i32.const	$push12=, -38
	i32.store	x($pop35), $pop12
	i32.call	$0=, bar@FUNCTION
	i32.const	$push15=, -37
	i32.const	$push14=, -1
	i32.const	$push34=, -38
	i32.eq  	$push13=, $0, $pop34
	i32.select	$push16=, $pop15, $pop14, $pop13
	i32.const	$push17=, -4095
	i32.lt_u	$push18=, $0, $pop17
	i32.select	$push19=, $0, $pop16, $pop18
	i32.const	$push33=, -37
	i32.ne  	$push20=, $pop19, $pop33
	br_if   	0, $pop20       # 0: down to label0
# %bb.3:                                # %if.end8
	i32.const	$push36=, 0
	return  	$pop36
.LBB2_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	x,@object               # @x
	.section	.bss.x,"aw",@nobits
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
