	.text
	.file	"pr43784.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 256
	i32.sub 	$2=, $pop9, $pop11
	i32.const	$push12=, 0
	i32.store	__stack_pointer($pop12), $2
	i32.const	$1=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push18=, v
	i32.add 	$push0=, $1, $pop18
	i32.store8	0($pop0), $1
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, 256
	i32.ne  	$push1=, $1, $pop16
	br_if   	0, $pop1        # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
	call    	rp@FUNCTION, $2
	i32.const	$push3=, v+4
	i32.const	$push2=, 256
	i32.call	$0=, memcpy@FUNCTION, $pop3, $2, $pop2
	i32.const	$1=, 0
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.add 	$push4=, $1, $0
	i32.load8_u	$push5=, 0($pop4)
	i32.ne  	$push6=, $1, $pop5
	br_if   	1, $pop6        # 1: down to label1
# %bb.4:                                # %for.cond1
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push20=, 1
	i32.add 	$1=, $1, $pop20
	i32.const	$push19=, 255
	i32.le_u	$push7=, $1, $pop19
	br_if   	0, $pop7        # 0: up to label2
# %bb.5:                                # %for.end12
	end_loop
	i32.const	$push15=, 0
	i32.const	$push13=, 256
	i32.add 	$push14=, $2, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.rp,"ax",@progbits
	.type	rp,@function            # -- Begin function rp
rp:                                     # @rp
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, v
	i32.const	$push0=, 256
	i32.call	$drop=, memcpy@FUNCTION, $0, $pop1, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	rp, .Lfunc_end1-rp
                                        # -- End function
	.type	v,@object               # @v
	.section	.bss.v,"aw",@nobits
	.p2align	2
v:
	.skip	260
	.size	v, 260


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
