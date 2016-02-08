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
	i32.select	$push6=, $pop11, $pop5, $pop3
	tee_local	$push10=, $0=, $pop6
	i32.store16	$discard=, g($pop12), $pop10
	i32.const	$push7=, 65535
	i32.and 	$push8=, $0, $pop7
	i32.eq  	$push9=, $1, $pop8
	return  	$pop9
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
	i32.const	$push18=, 0
	i32.load16_u	$push0=, p($pop18)
	tee_local	$push17=, $3=, $pop0
	i32.const	$push16=, 0
	i32.load16_u	$push14=, g($pop16)
	tee_local	$push15=, $2=, $pop14
	i32.eq  	$push1=, $pop17, $pop15
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push19=, 0
	i32.load8_u	$push2=, e($pop19)
	i32.const	$push3=, -1
	i32.add 	$0=, $pop2, $pop3
	i32.const	$1=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push26=, 0
	i32.const	$push25=, 65535
	i32.and 	$push4=, $2, $pop25
	tee_local	$push24=, $2=, $pop4
	i32.const	$push23=, 1
	i32.add 	$push6=, $pop24, $pop23
	i32.eq  	$push5=, $2, $0
	i32.select	$2=, $pop26, $pop6, $pop5
	i32.const	$push22=, 1
	i32.add 	$1=, $1, $pop22
	i32.const	$push21=, 65535
	i32.and 	$push7=, $1, $pop21
	i32.const	$push20=, 4
	i32.gt_u	$push8=, $pop7, $pop20
	br_if   	1, $pop8        # 1: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push27=, 65535
	i32.and 	$push9=, $2, $pop27
	i32.ne  	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: up to label1
.LBB1_4:                                # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push11=, 0
	i32.store16	$discard=, g($pop11), $2
.LBB1_5:                                # %while.end
	end_block                       # label0:
	i32.const	$push12=, 65535
	i32.and 	$push13=, $1, $pop12
	return  	$pop13
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
