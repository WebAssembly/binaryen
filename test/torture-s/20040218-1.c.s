	.text
	.file	"20040218-1.c"
	.section	.text.xb,"ax",@progbits
	.hidden	xb                      # -- Begin function xb
	.globl	xb
	.type	xb,@function
xb:                                     # @xb
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.add 	$push2=, $pop1, $pop0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	xb, .Lfunc_end0-xb
                                        # -- End function
	.section	.text.xw,"ax",@progbits
	.hidden	xw                      # -- Begin function xw
	.globl	xw
	.type	xw,@function
xw:                                     # @xw
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load16_u	$push1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.add 	$push2=, $pop1, $pop0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	xw, .Lfunc_end1-xw
                                        # -- End function
	.section	.text.yb,"ax",@progbits
	.hidden	yb                      # -- Begin function yb
	.globl	yb
	.type	yb,@function
yb:                                     # @yb
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load16_u	$push0=, 2($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, 16
	i32.shl 	$push4=, $pop2, $pop3
	i32.const	$push6=, 16
	i32.shr_s	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	yb, .Lfunc_end2-yb
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$0=, $pop12, $pop14
	i32.const	$push15=, 0
	i32.store	__stack_pointer($pop15), $0
	i64.const	$push0=, 68723771703295
	i64.store	8($0), $pop0
	i32.const	$push1=, 1048641535
	i32.store	4($0), $pop1
	block   	
	i32.const	$push16=, 8
	i32.add 	$push17=, $0, $pop16
	i32.call	$push3=, xb@FUNCTION, $pop17
	i32.const	$push2=, 16255
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.const	$push18=, 8
	i32.add 	$push19=, $0, $pop18
	i32.call	$push6=, xw@FUNCTION, $pop19
	i32.const	$push5=, 81535
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %lor.lhs.false4
	i32.const	$push20=, 4
	i32.add 	$push21=, $0, $pop20
	i32.call	$push9=, yb@FUNCTION, $pop21
	i32.const	$push8=, 16255
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label0
# %bb.3:                                # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
