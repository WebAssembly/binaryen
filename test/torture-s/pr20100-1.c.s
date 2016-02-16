	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20100-1.c"
	.section	.text.frob,"ax",@progbits
	.hidden	frob
	.globl	frob
	.type	frob,@function
frob:                                   # @frob
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_u	$2=, e($pop0)
	i32.const	$push13=, 0
	i32.store16	$discard=, p($pop13), $1
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.const	$push4=, 1
	i32.add 	$push5=, $0, $pop4
	i32.const	$push1=, -1
	i32.add 	$push2=, $2, $pop1
	i32.eq  	$push3=, $0, $pop2
	i32.select	$push10=, $pop11, $pop5, $pop3
	tee_local	$push9=, $0=, $pop10
	i32.store16	$discard=, g($pop12), $pop9
	i32.const	$push6=, 65535
	i32.and 	$push7=, $0, $pop6
	i32.eq  	$push8=, $1, $pop7
	return  	$pop8
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
	i32.const	$1=, 0
	block
	i32.const	$push17=, 0
	i32.load16_u	$push16=, p($pop17)
	tee_local	$push15=, $3=, $pop16
	i32.const	$push14=, 0
	i32.load16_u	$push13=, g($pop14)
	tee_local	$push12=, $2=, $pop13
	i32.eq  	$push0=, $pop15, $pop12
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push18=, 0
	i32.load8_u	$push1=, e($pop18)
	i32.const	$push2=, -1
	i32.add 	$0=, $pop1, $pop2
	i32.const	$1=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push26=, 0
	i32.const	$push25=, 65535
	i32.and 	$push24=, $2, $pop25
	tee_local	$push23=, $2=, $pop24
	i32.const	$push22=, 1
	i32.add 	$push4=, $pop23, $pop22
	i32.eq  	$push3=, $2, $0
	i32.select	$2=, $pop26, $pop4, $pop3
	i32.const	$push21=, 1
	i32.add 	$1=, $1, $pop21
	i32.const	$push20=, 65535
	i32.and 	$push5=, $1, $pop20
	i32.const	$push19=, 4
	i32.gt_u	$push6=, $pop5, $pop19
	br_if   	1, $pop6        # 1: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push27=, 65535
	i32.and 	$push7=, $2, $pop27
	i32.ne  	$push8=, $3, $pop7
	br_if   	0, $pop8        # 0: up to label1
.LBB1_4:                                # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push9=, 0
	i32.store16	$discard=, g($pop9), $2
.LBB1_5:                                # %while.end
	end_block                       # label0:
	i32.const	$push10=, 65535
	i32.and 	$push11=, $1, $pop10
	return  	$pop11
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
	i32.const	$push0=, 3
	i32.store8	$discard=, e($pop1), $pop0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.const	$push2=, 2
	i32.store16	$push3=, p($pop5), $pop2
	i32.store16	$discard=, g($pop6), $pop3
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	g,@object               # @g
	.lcomm	g,2,1
	.type	p,@object               # @p
	.lcomm	p,2,1
	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1


	.ident	"clang version 3.9.0 "
