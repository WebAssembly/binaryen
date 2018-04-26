	.text
	.file	"pr20100-1.c"
	.section	.text.frob,"ax",@progbits
	.hidden	frob                    # -- Begin function frob
	.globl	frob
	.type	frob,@function
frob:                                   # @frob
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store16	p($pop0), $1
	i32.const	$push12=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $0, $pop1
	i32.const	$push11=, 0
	i32.load8_u	$push3=, e($pop11)
	i32.const	$push4=, -1
	i32.add 	$push5=, $pop3, $pop4
	i32.eq  	$push6=, $pop5, $0
	i32.select	$0=, $pop12, $pop2, $pop6
	i32.const	$push10=, 0
	i32.store16	g($pop10), $0
	i32.const	$push7=, 65535
	i32.and 	$push8=, $0, $pop7
	i32.eq  	$push9=, $pop8, $1
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	frob, .Lfunc_end0-frob
                                        # -- End function
	.section	.text.get_n,"ax",@progbits
	.hidden	get_n                   # -- Begin function get_n
	.globl	get_n
	.type	get_n,@function
get_n:                                  # @get_n
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$3=, 0
	i32.const	$push13=, 0
	i32.load16_u	$2=, g($pop13)
	i32.const	$push12=, 0
	i32.load16_u	$0=, p($pop12)
	block   	
	i32.eq  	$push0=, $0, $2
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push14=, 0
	i32.load8_u	$push1=, e($pop14)
	i32.const	$push2=, -1
	i32.add 	$1=, $pop1, $pop2
	i32.const	$3=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push20=, 65535
	i32.and 	$2=, $2, $pop20
	i32.const	$push19=, 0
	i32.const	$push18=, 1
	i32.add 	$push4=, $2, $pop18
	i32.eq  	$push3=, $1, $2
	i32.select	$2=, $pop19, $pop4, $pop3
	i32.const	$push17=, 1
	i32.add 	$3=, $3, $pop17
	i32.const	$push16=, 65535
	i32.and 	$push5=, $3, $pop16
	i32.const	$push15=, 4
	i32.gt_u	$push6=, $pop5, $pop15
	br_if   	1, $pop6        # 1: down to label1
# %bb.3:                                # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push21=, 65535
	i32.and 	$push7=, $2, $pop21
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: up to label2
.LBB1_4:                                # %while.cond.while.end_crit_edge
	end_loop
	end_block                       # label1:
	i32.const	$push9=, 0
	i32.store16	g($pop9), $2
.LBB1_5:                                # %while.end
	end_block                       # label0:
	i32.const	$push10=, 65535
	i32.and 	$push11=, $3, $pop10
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end1:
	.size	get_n, .Lfunc_end1-get_n
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	i32.store16	p($pop1), $pop0
	i32.const	$push6=, 0
	i32.const	$push2=, 3
	i32.store8	e($pop6), $pop2
	i32.const	$push5=, 0
	i32.const	$push4=, 2
	i32.store16	g($pop5), $pop4
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	g,@object               # @g
	.section	.bss.g,"aw",@nobits
	.p2align	1
g:
	.int16	0                       # 0x0
	.size	g, 2

	.type	p,@object               # @p
	.section	.bss.p,"aw",@nobits
	.p2align	1
p:
	.int16	0                       # 0x0
	.size	p, 2

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
