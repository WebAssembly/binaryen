	.text
	.file	"pr43385.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %entry
	i32.eqz 	$push6=, $1
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.then
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, e($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	e($pop0), $pop3
.LBB0_3:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
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
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.ne  	$push2=, $0, $pop0
	i32.const	$push4=, 0
	i32.ne  	$push1=, $1, $pop4
	i32.and 	$push3=, $pop2, $pop1
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
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
	#APP
	#NO_APP
	i32.const	$push26=, 1
	i32.add 	$2=, $0, $pop26
	i32.const	$push0=, 2
	i32.add 	$1=, $0, $pop0
	call    	foo@FUNCTION, $1, $2
	block   	
	i32.const	$push25=, 0
	i32.load	$push1=, e($pop25)
	i32.const	$push24=, 1
	i32.ne  	$push2=, $pop1, $pop24
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %if.end
	call    	foo@FUNCTION, $1, $0
	i32.const	$push28=, 0
	i32.load	$push3=, e($pop28)
	i32.const	$push27=, 1
	i32.ne  	$push4=, $pop3, $pop27
	br_if   	0, $pop4        # 0: down to label1
# %bb.2:                                # %if.end5
	call    	foo@FUNCTION, $2, $2
	i32.const	$push30=, 0
	i32.load	$push5=, e($pop30)
	i32.const	$push29=, 2
	i32.ne  	$push6=, $pop5, $pop29
	br_if   	0, $pop6        # 0: down to label1
# %bb.3:                                # %if.end10
	call    	foo@FUNCTION, $2, $0
	i32.const	$push32=, 0
	i32.load	$push7=, e($pop32)
	i32.const	$push31=, 2
	i32.ne  	$push8=, $pop7, $pop31
	br_if   	0, $pop8        # 0: down to label1
# %bb.4:                                # %if.end14
	call    	foo@FUNCTION, $0, $2
	i32.const	$push34=, 0
	i32.load	$push9=, e($pop34)
	i32.const	$push33=, 2
	i32.ne  	$push10=, $pop9, $pop33
	br_if   	0, $pop10       # 0: down to label1
# %bb.5:                                # %if.end18
	call    	foo@FUNCTION, $0, $0
	i32.const	$push36=, 0
	i32.load	$push11=, e($pop36)
	i32.const	$push35=, 2
	i32.ne  	$push12=, $pop11, $pop35
	br_if   	0, $pop12       # 0: down to label1
# %bb.6:                                # %if.end21
	i32.call	$push13=, bar@FUNCTION, $1, $2
	i32.const	$push14=, 1
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label1
# %bb.7:                                # %if.end26
	i32.call	$push16=, bar@FUNCTION, $1, $0
	br_if   	0, $pop16       # 0: down to label1
# %bb.8:                                # %if.end31
	i32.call	$push17=, bar@FUNCTION, $2, $2
	i32.const	$push18=, 1
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label1
# %bb.9:                                # %if.end37
	i32.call	$push20=, bar@FUNCTION, $2, $0
	br_if   	0, $pop20       # 0: down to label1
# %bb.10:                               # %if.end42
	i32.call	$push21=, bar@FUNCTION, $0, $2
	br_if   	0, $pop21       # 0: down to label1
# %bb.11:                               # %if.end47
	i32.call	$push22=, bar@FUNCTION, $0, $0
	br_if   	0, $pop22       # 0: down to label1
# %bb.12:                               # %if.end51
	i32.const	$push23=, 0
	return  	$pop23
.LBB2_13:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
