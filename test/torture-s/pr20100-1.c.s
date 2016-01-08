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
	i32.const	$2=, 0
	i32.load8_u	$push0=, e($2)
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop0, $pop1
	i32.eq  	$push3=, $0, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $0, $pop4
	i32.select	$0=, $pop3, $2, $pop5
	i32.store16	$discard=, p($2), $1
	i32.store16	$discard=, g($2), $0
	i32.const	$push6=, 65535
	i32.and 	$push7=, $0, $pop6
	i32.eq  	$push8=, $pop7, $1
	return  	$pop8
.Lfunc_end0:
	.size	frob, .Lfunc_end0-frob

	.section	.text.get_n,"ax",@progbits
	.hidden	get_n
	.globl	get_n
	.type	get_n,@function
get_n:                                  # @get_n
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	i32.load16_u	$0=, p($6)
	i32.load16_u	$5=, g($6)
	block   	.LBB1_5
	i32.eq  	$push0=, $0, $5
	br_if   	$pop0, .LBB1_5
# BB#1:                                 # %while.body.lr.ph
	i32.const	$2=, 0
	i32.load8_u	$push1=, e($2)
	i32.const	$push2=, -1
	i32.add 	$1=, $pop1, $pop2
	copy_local	$6=, $2
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_4
	i32.const	$3=, 65535
	i32.and 	$5=, $5, $3
	i32.const	$4=, 1
	i32.eq  	$push3=, $5, $1
	i32.add 	$push4=, $5, $4
	i32.select	$5=, $pop3, $2, $pop4
	i32.add 	$6=, $6, $4
	i32.and 	$push5=, $6, $3
	i32.const	$push6=, 4
	i32.gt_u	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB1_4
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.and 	$push8=, $5, $3
	i32.ne  	$push9=, $0, $pop8
	br_if   	$pop9, .LBB1_2
.LBB1_4:                                # %while.cond.while.end_crit_edge
	i32.const	$push10=, 0
	i32.store16	$discard=, g($pop10), $5
.LBB1_5:                                # %while.end
	i32.const	$push11=, 65535
	i32.and 	$push12=, $6, $pop11
	return  	$pop12
.Lfunc_end1:
	.size	get_n, .Lfunc_end1-get_n

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 3
	i32.store8	$discard=, e($0), $pop0
	i32.const	$push1=, 2
	i32.store16	$push2=, p($0), $pop1
	i32.store16	$discard=, g($0), $pop2
	call    	exit, $0
	unreachable
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
