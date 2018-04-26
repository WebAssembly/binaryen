	.text
	.file	"20111208-1.c"
	.section	.text.pack_unpack,"ax",@progbits
	.hidden	pack_unpack             # -- Begin function pack_unpack
	.globl	pack_unpack
	.type	pack_unpack,@function
pack_unpack:                            # @pack_unpack
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.call	$3=, strlen@FUNCTION, $1
	block   	
	i32.const	$push8=, 1
	i32.lt_s	$push0=, $3, $pop8
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %while.body.preheader
	i32.add 	$2=, $1, $3
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	copy_local	$3=, $1
	i32.const	$push10=, 1
	i32.add 	$1=, $3, $pop10
	i32.load8_s	$3=, 0($3)
	block   	
	i32.const	$push9=, 108
	i32.eq  	$push1=, $3, $pop9
	br_if   	0, $pop1        # 0: down to label2
# %bb.3:                                # %while.body
                                        #   in Loop: Header=BB0_2 Depth=1
	block   	
	i32.const	$push11=, 115
	i32.ne  	$push2=, $3, $pop11
	br_if   	0, $pop2        # 0: down to label3
# %bb.4:                                # %sw.bb4
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load16_s	$push4=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop4
	i32.const	$push12=, 2
	i32.add 	$0=, $0, $pop12
.LBB0_5:                                # %sw.epilog13
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.lt_u	$push6=, $1, $2
	br_if   	1, $pop6        # 1: up to label1
	br      	2               # 2: down to label0
.LBB0_6:                                # %sw.bb7
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label2:
	i32.load	$push3=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop3
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	i32.lt_u	$push5=, $1, $2
	br_if   	0, $pop5        # 0: up to label1
.LBB0_7:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.load8_s	$push7=, 0($0)
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	pack_unpack, .Lfunc_end0-pack_unpack
                                        # -- End function
	.section	.text.do_something,"ax",@progbits
	.type	do_something,@function  # -- Begin function do_something
do_something:                           # @do_something
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	a($pop0), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	do_something, .Lfunc_end1-do_something
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 384
	call    	do_something@FUNCTION, $pop0
	i32.const	$push1=, -1071776001
	call    	do_something@FUNCTION, $pop1
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strlen, i32, i32
