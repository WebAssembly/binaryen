	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050826-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB0_6
	i32.const	$push0=, .str
	i32.const	$push1=, 8
	i32.call	$push2=, memcmp, $0, $pop0, $pop1
	br_if   	$pop2, BB0_6
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 7
	i32.add 	$1=, $0, $pop3
	i32.const	$0=, 0
BB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB0_5
	loop    	BB0_4
	i32.add 	$push4=, $1, $0
	i32.load8_u	$push5=, 0($pop4)
	br_if   	$pop5, BB0_5
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$0=, $0, $pop6
	i32.const	$push7=, 2040
	i32.le_u	$push8=, $0, $pop7
	br_if   	$pop8, BB0_2
BB0_4:                                  # %for.end
	return
BB0_5:                                  # %if.then2
	call    	abort
	unreachable
BB0_6:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, a
	i32.const	$1=, 0
	i32.const	$push0=, 2048
	call    	memset, $0, $1, $pop0
	i32.load8_u	$push2=, .str.1+4($1)
	i32.store8	$discard=, a+5($1), $pop2
	i32.load8_u	$push3=, .str.1+3($1)
	i32.store8	$discard=, a+4($1), $pop3
	i32.load8_u	$push4=, .str.1+2($1)
	i32.store8	$discard=, a+3($1), $pop4
	i32.load8_u	$push5=, .str.1+1($1)
	i32.store8	$discard=, a+2($1), $pop5
	i32.load8_u	$push6=, .str.1($1)
	i32.store8	$discard=, a+1($1), $pop6
	i32.const	$push1=, 1
	i32.store8	$3=, a($1), $pop1
	i32.const	$4=, 8
	i32.store8	$2=, a+6($1), $3
	block   	BB1_5
	i32.const	$push7=, .str
	i32.call	$push8=, memcmp, $0, $pop7, $4
	br_if   	$pop8, BB1_5
BB1_1:                                  # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block   	BB1_4
	loop    	BB1_3
	i32.const	$push9=, -7
	i32.add 	$push10=, $4, $pop9
	i32.const	$push11=, 2040
	i32.gt_u	$push12=, $pop10, $pop11
	br_if   	$pop12, BB1_4
# BB#2:                                 # %for.cond.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$3=, $0, $4
	i32.add 	$4=, $4, $2
	i32.load8_u	$push13=, 0($3)
	i32.const	$push14=, 0
	i32.eq  	$push15=, $pop13, $pop14
	br_if   	$pop15, BB1_1
BB1_3:                                  # %if.then2.i
	call    	abort
	unreachable
BB1_4:                                  # %bar.exit
	return  	$1
BB1_5:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, a
	i32.const	$1=, 0
	i32.const	$push0=, 2048
	call    	memset, $0, $1, $pop0
	i32.load8_u	$push2=, .str.1+4($1)
	i32.store8	$discard=, a+5($1), $pop2
	i32.load8_u	$push3=, .str.1+3($1)
	i32.store8	$discard=, a+4($1), $pop3
	i32.load8_u	$push4=, .str.1+2($1)
	i32.store8	$discard=, a+3($1), $pop4
	i32.load8_u	$push5=, .str.1+1($1)
	i32.store8	$discard=, a+2($1), $pop5
	i32.load8_u	$push6=, .str.1($1)
	i32.store8	$discard=, a+1($1), $pop6
	i32.const	$push1=, 1
	i32.store8	$3=, a($1), $pop1
	i32.const	$4=, 8
	i32.store8	$2=, a+6($1), $3
	block   	BB2_5
	i32.const	$push7=, .str
	i32.call	$push8=, memcmp, $0, $pop7, $4
	br_if   	$pop8, BB2_5
BB2_1:                                  # %for.cond.i.i
                                        # =>This Inner Loop Header: Depth=1
	block   	BB2_4
	loop    	BB2_3
	i32.const	$push9=, -7
	i32.add 	$push10=, $4, $pop9
	i32.const	$push11=, 2040
	i32.gt_u	$push12=, $pop10, $pop11
	br_if   	$pop12, BB2_4
# BB#2:                                 # %for.cond.i.for.body.i_crit_edge.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$3=, $0, $4
	i32.add 	$4=, $4, $2
	i32.load8_u	$push13=, 0($3)
	i32.const	$push14=, 0
	i32.eq  	$push15=, $pop13, $pop14
	br_if   	$pop15, BB2_1
BB2_3:                                  # %if.then2.i.i
	call    	abort
	unreachable
BB2_4:                                  # %foo.exit
	return  	$1
BB2_5:                                  # %if.then.i.i
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"\001HELLO\001"
	.size	.str, 8

	.type	a,@object               # @a
	.bss
	.globl	a
a:
	.zero	2048
	.size	a, 2048

	.type	.str.1,@object          # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.1:
	.asciz	"HELLO"
	.size	.str.1, 6


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
