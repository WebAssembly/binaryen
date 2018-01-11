	.text
	.file	"usmul.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.mul 	$push0=, $1, $0
                                        # fallthrough-return: $pop0
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
	i32.mul 	$push0=, $1, $0
                                        # fallthrough-return: $pop0
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
	i32.const	$push0=, -2
	i32.const	$push33=, 65535
	i32.call	$push1=, foo@FUNCTION, $pop0, $pop33
	i32.const	$push2=, -131070
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 2
	i32.const	$push34=, 65535
	i32.call	$push5=, foo@FUNCTION, $pop4, $pop34
	i32.const	$push6=, 131070
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end4
	i32.const	$push8=, -32768
	i32.const	$push35=, 32768
	i32.call	$push9=, foo@FUNCTION, $pop8, $pop35
	i32.const	$push10=, -1073741824
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.3:                                # %if.end8
	i32.const	$push12=, 32767
	i32.const	$push36=, 32768
	i32.call	$push13=, foo@FUNCTION, $pop12, $pop36
	i32.const	$push14=, 1073709056
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# %bb.4:                                # %if.end12
	i32.const	$push37=, 65535
	i32.const	$push16=, -2
	i32.call	$push17=, bar@FUNCTION, $pop37, $pop16
	i32.const	$push18=, -131070
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.5:                                # %if.end16
	i32.const	$push38=, 65535
	i32.const	$push20=, 2
	i32.call	$push21=, bar@FUNCTION, $pop38, $pop20
	i32.const	$push22=, 131070
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.6:                                # %if.end20
	i32.const	$push39=, 32768
	i32.const	$push24=, -32768
	i32.call	$push25=, bar@FUNCTION, $pop39, $pop24
	i32.const	$push26=, -1073741824
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.7:                                # %if.end24
	i32.const	$push40=, 32768
	i32.const	$push28=, 32767
	i32.call	$push29=, bar@FUNCTION, $pop40, $pop28
	i32.const	$push30=, 1073709056
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# %bb.8:                                # %if.end28
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
	unreachable
.LBB2_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
