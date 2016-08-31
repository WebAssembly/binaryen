	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20100-1.c"
	.section	.text.frob,"ax",@progbits
	.hidden	frob
	.globl	frob
	.type	frob,@function
frob:                                   # @frob
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store16	$drop=, p($pop0), $1
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
	i32.store16	$drop=, g($pop14), $pop10
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
	loop                            # label1:
	i32.const	$push27=, 1
	i32.add 	$3=, $3, $pop27
	i32.const	$push26=, 0
	i32.const	$push25=, 65535
	i32.and 	$push24=, $2, $pop25
	tee_local	$push23=, $2=, $pop24
	i32.const	$push22=, 1
	i32.add 	$push4=, $pop23, $pop22
	i32.eq  	$push3=, $2, $1
	i32.select	$push21=, $pop26, $pop4, $pop3
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, 65535
	i32.and 	$push5=, $pop20, $pop19
	i32.eq  	$push6=, $0, $pop5
	br_if   	1, $pop6        # 1: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push29=, 65535
	i32.and 	$push7=, $3, $pop29
	i32.const	$push28=, 5
	i32.lt_u	$push8=, $pop7, $pop28
	br_if   	0, $pop8        # 0: up to label1
.LBB1_4:                                # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push9=, 0
	i32.store16	$drop=, g($pop9), $2
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
	i32.store16	$drop=, p($pop1), $pop0
	i32.const	$push6=, 0
	i32.const	$push2=, 3
	i32.store8	$drop=, e($pop6), $pop2
	i32.const	$push5=, 0
	i32.const	$push4=, 2
	i32.store16	$drop=, g($pop5), $pop4
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


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
