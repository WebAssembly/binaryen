	.text
	.file	"20000412-6.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %bug.exit
	block   	
	i32.const	$push1=, 512
	i32.const	$push13=, 0
	i32.load16_u	$push0=, buf($pop13)
	i32.sub 	$push2=, $pop1, $pop0
	i32.const	$push12=, 0
	i32.load16_u	$push3=, buf+2($pop12)
	i32.sub 	$push4=, $pop2, $pop3
	i32.const	$push11=, 0
	i32.load16_u	$push5=, buf+4($pop11)
	i32.sub 	$push6=, $pop4, $pop5
	i32.const	$push7=, 65535
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push9=, 491
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.bug,"ax",@progbits
	.hidden	bug                     # -- Begin function bug
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.ge_u	$push0=, $1, $2
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %for.body.preheader
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push7=, 65535
	i32.and 	$push1=, $0, $pop7
	i32.load16_u	$push2=, 0($1)
	i32.sub 	$0=, $pop1, $pop2
	i32.const	$push6=, 2
	i32.add 	$1=, $1, $pop6
	i32.lt_u	$push3=, $1, $2
	br_if   	0, $pop3        # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.const	$push4=, 65535
	i32.and 	$push5=, $0, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug
                                        # -- End function
	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.data.buf,"aw",@progbits
	.globl	buf
	.p2align	1
buf:
	.int16	1                       # 0x1
	.int16	4                       # 0x4
	.int16	16                      # 0x10
	.int16	64                      # 0x40
	.int16	256                     # 0x100
	.size	buf, 10


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
