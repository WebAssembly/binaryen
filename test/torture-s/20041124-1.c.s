	.text
	.file	"20041124-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, gs($pop0)
	i32.store	0($0):p2align=1, $pop1
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$0=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $0
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	call    	foo@FUNCTION, $pop15
	block   	
	i32.load16_u	$push3=, 8($0)
	i32.const	$push16=, 0
	i32.load16_u	$push2=, gs($pop16)
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %entry
	i32.load16_u	$push0=, 10($0)
	i32.const	$push5=, 65535
	i32.and 	$push7=, $pop0, $pop5
	i32.const	$push18=, 0
	i32.load16_u	$push1=, gs+2($pop18)
	i32.const	$push17=, 65535
	i32.and 	$push6=, $pop1, $pop17
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	gs                      # @gs
	.type	gs,@object
	.section	.data.gs,"aw",@progbits
	.globl	gs
	.p2align	2
gs:
	.int16	100                     # 0x64
	.int16	200                     # 0xc8
	.size	gs, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
