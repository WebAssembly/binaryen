	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20100-1.c"
	.section	.text.frob,"ax",@progbits
	.hidden	frob
	.globl	frob
	.type	frob,@function
frob:                                   # @frob
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store16	p($pop0), $1
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $0, $pop1
	i32.const	$push12=, 0
	i32.load8_u	$push3=, e($pop12)
	i32.const	$push4=, -1
	i32.add 	$push5=, $pop3, $pop4
	i32.eq  	$push6=, $0, $pop5
	i32.select	$push11=, $pop13, $pop2, $pop6
	tee_local	$push10=, $0=, $pop11
	i32.store16	g($pop14), $pop10
	i32.const	$push7=, 65535
	i32.and 	$push8=, $0, $pop7
	i32.eq  	$push9=, $pop8, $1
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	frob, .Lfunc_end0-frob

	.section	.text.get_n,"ax",@progbits
	.hidden	get_n
	.globl	get_n
	.type	get_n,@function
get_n:                                  # @get_n
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block   	
	i32.const	$push17=, 0
	i32.load16_u	$push16=, p($pop17)
	tee_local	$push15=, $0=, $pop16
	i32.const	$push14=, 0
	i32.load16_u	$push13=, g($pop14)
	tee_local	$push12=, $2=, $pop13
	i32.eq  	$push0=, $pop15, $pop12
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push18=, 0
	i32.load8_u	$push1=, e($pop18)
	i32.const	$push2=, -1
	i32.add 	$1=, $pop1, $pop2
	i32.const	$3=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push28=, 0
	i32.const	$push27=, 65535
	i32.and 	$push26=, $2, $pop27
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, 1
	i32.add 	$push4=, $pop25, $pop24
	i32.eq  	$push3=, $2, $1
	i32.select	$2=, $pop28, $pop4, $pop3
	i32.const	$push23=, 1
	i32.add 	$push22=, $3, $pop23
	tee_local	$push21=, $3=, $pop22
	i32.const	$push20=, 65535
	i32.and 	$push5=, $pop21, $pop20
	i32.const	$push19=, 4
	i32.gt_u	$push6=, $pop5, $pop19
	br_if   	1, $pop6        # 1: down to label1
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push29=, 65535
	i32.and 	$push7=, $2, $pop29
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
