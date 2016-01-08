	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51933.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block   	.LBB1_2
	i32.load8_u	$push0=, v1($3)
	br_if   	$pop0, .LBB1_2
# BB#1:                                 # %if.then
	call    	foo
.LBB1_2:                                # %for.cond.preheader
	i32.const	$4=, 1
	copy_local	$6=, $0
	copy_local	$7=, $2
	block   	.LBB1_4
	i32.lt_s	$push1=, $0, $4
	br_if   	$pop1, .LBB1_4
.LBB1_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_4
	i32.load16_u	$5=, 0($1)
	i32.const	$push2=, 256
	i32.lt_u	$push3=, $5, $pop2
	i32.const	$push4=, v2
	i32.add 	$push5=, $pop4, $5
	i32.const	$push8=, v3
	i32.const	$push6=, 255
	i32.and 	$push7=, $5, $pop6
	i32.add 	$push9=, $pop8, $pop7
	i32.select	$push10=, $pop3, $pop5, $pop9
	i32.load8_u	$push11=, 0($pop10)
	i32.store8	$discard=, 0($7), $pop11
	i32.const	$push12=, 2
	i32.add 	$1=, $1, $pop12
	i32.const	$push13=, -1
	i32.add 	$6=, $6, $pop13
	i32.add 	$7=, $7, $4
	br_if   	$6, .LBB1_3
.LBB1_4:                                # %for.end
	i32.add 	$push14=, $2, $0
	i32.store8	$discard=, 0($pop14), $3
	return  	$0
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 80
	i32.sub 	$12=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$12=, 0($3), $12
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_2
	i32.const	$push1=, v2
	i32.add 	$push2=, $pop1, $1
	i32.store8	$discard=, 0($pop2), $1
	i32.const	$push4=, v3
	i32.add 	$push5=, $pop4, $1
	i32.const	$push3=, 1
	i32.add 	$push0=, $1, $pop3
	i32.store8	$1=, 0($pop5), $pop0
	i32.const	$push6=, 256
	i32.ne  	$push7=, $1, $pop6
	br_if   	$pop7, .LBB2_1
.LBB2_2:                                # %for.body6.preheader
	i32.const	$push9=, 8
	i32.const	$5=, 0
	i32.add 	$5=, $12, $5
	i32.or  	$push10=, $5, $pop9
	i32.const	$push11=, 101
	i32.store16	$discard=, 0($pop10), $pop11
	i32.const	$push16=, 14
	i32.const	$6=, 0
	i32.add 	$6=, $12, $6
	i32.or  	$push17=, $6, $pop16
	i32.const	$push18=, 104
	i32.store16	$discard=, 0($pop17), $pop18
	i32.const	$push12=, 10
	i32.const	$7=, 0
	i32.add 	$7=, $12, $7
	i32.or  	$push13=, $7, $pop12
	i32.const	$push27=, 1638
	i32.store16	$discard=, 0($pop13), $pop27
	i32.const	$push14=, 12
	i32.const	$8=, 0
	i32.add 	$8=, $12, $8
	i32.or  	$push15=, $8, $pop14
	i32.const	$push28=, 1383
	i32.store16	$discard=, 0($pop15), $pop28
	i32.const	$push19=, 105
	i32.store16	$discard=, 16($12), $pop19
	i32.const	$push20=, 106
	i32.store16	$discard=, 18($12), $pop20
	i32.const	$push21=, 107
	i32.store16	$discard=, 20($12), $pop21
	i32.const	$push22=, 109
	i32.store16	$discard=, 24($12), $pop22
	i32.const	$push23=, 110
	i32.store16	$discard=, 26($12), $pop23
	i32.const	$push24=, 111
	i32.store16	$discard=, 28($12), $pop24
	i32.const	$push25=, 113
	i32.store16	$discard=, 32($12), $pop25
	i32.const	$push29=, 8300
	i32.store16	$discard=, 22($12), $pop29
	i32.const	$push30=, 1392
	i32.store16	$discard=, 30($12), $pop30
	i64.const	$push8=, 28147922879250529
	i64.store	$discard=, 0($12), $pop8
	i32.const	$push26=, 0
	i32.store16	$0=, 34($12), $pop26
	call    	foo
	i32.const	$1=, 17
	i32.const	$9=, 0
	i32.add 	$9=, $12, $9
	i32.const	$10=, 48
	i32.add 	$10=, $12, $10
	block   	.LBB2_5
	i32.call	$push31=, bar, $1, $9, $10
	i32.ne  	$push32=, $pop31, $1
	br_if   	$pop32, .LBB2_5
# BB#3:                                 # %lor.lhs.false
	i32.const	$push33=, .L.str
	i32.const	$push34=, 18
	i32.const	$11=, 48
	i32.add 	$11=, $12, $11
	i32.call	$push35=, memcmp, $11, $pop33, $pop34
	br_if   	$pop35, .LBB2_5
# BB#4:                                 # %if.end
	i32.const	$4=, 80
	i32.add 	$12=, $12, $4
	i32.const	$4=, __stack_pointer
	i32.store	$12=, 0($4), $12
	return  	$0
.LBB2_5:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	v1,@object              # @v1
	.lcomm	v1,1
	.type	v2,@object              # @v2
	.lcomm	v2,256,4
	.type	v3,@object              # @v3
	.lcomm	v3,256,4
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcdeghhijkmmnoqq"
	.size	.L.str, 18


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
