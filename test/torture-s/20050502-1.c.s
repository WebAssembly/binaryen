	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050502-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, 0($0), $pop1
	i32.load8_s	$push2=, 0($1)
	return  	$pop2
func_end0:
	.size	bar, func_end0-bar

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 64
	i32.ne  	$push1=, $0, $pop0
	return  	$pop1
func_end1:
	.size	baz, func_end1-baz

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$push1=, bar, $0
	i32.store8	$discard=, 0($1), $pop1
	i32.call	$9=, bar, $0
	i32.const	$5=, 255
	i32.and 	$10=, $9, $5
	i32.const	$6=, 39
	i32.const	$11=, 1
	block   	BB2_7
	i32.eq  	$push2=, $10, $6
	i32.and 	$push3=, $pop2, $2
	br_if   	$pop3, BB2_7
# BB#1:                                 # %entry
	i32.const	$7=, 34
	i32.eq  	$push4=, $10, $7
	i32.and 	$push0=, $pop4, $3
	br_if   	$pop0, BB2_7
# BB#2:                                 # %if.end14.lr.ph
	i32.or  	$4=, $2, $3
	i32.const	$10=, 1
BB2_3:                                  # %if.end14
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB2_7
	block   	BB2_5
	br_if   	$4, BB2_5
# BB#4:                                 # %land.lhs.true18
                                        #   in Loop: Header=BB2_3 Depth=1
	i32.const	$8=, 24
	i32.shl 	$push5=, $9, $8
	i32.shr_s	$push6=, $pop5, $8
	i32.call	$8=, baz, $pop6
	copy_local	$11=, $10
	i32.const	$push15=, 0
	i32.eq  	$push16=, $8, $pop15
	br_if   	$pop16, BB2_7
BB2_5:                                  # %while.body.backedge
                                        #   in Loop: Header=BB2_3 Depth=1
	i32.add 	$push9=, $1, $10
	i32.store8	$discard=, 0($pop9), $9
	i32.const	$push8=, 1
	i32.add 	$11=, $10, $pop8
	i32.call	$9=, bar, $0
	i32.and 	$8=, $9, $5
	i32.eq  	$push10=, $8, $6
	i32.and 	$push11=, $pop10, $2
	br_if   	$pop11, BB2_7
# BB#6:                                 # %while.body.backedge
                                        #   in Loop: Header=BB2_3 Depth=1
	copy_local	$10=, $11
	i32.eq  	$push12=, $8, $7
	i32.and 	$push7=, $pop12, $3
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop7, $pop17
	br_if   	$pop18, BB2_3
BB2_7:                                  # %while.end
	i32.add 	$push13=, $1, $11
	i32.const	$push14=, 0
	i32.store8	$discard=, 0($pop13), $pop14
	return
func_end2:
	.size	foo, func_end2-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 80
	i32.sub 	$20=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$20=, 0($3), $20
	i32.const	$0=, 0
	i32.const	$1=, 1
	i32.const	$push0=, .str
	i32.store	$discard=, 12($20), $pop0
	i32.const	$5=, 12
	i32.add 	$5=, $20, $5
	i32.const	$6=, 16
	i32.add 	$6=, $20, $6
	call    	foo, $5, $6, $1, $0
	block   	BB3_15
	i32.load	$push1=, 12($20)
	i32.const	$push2=, .str.1
	i32.call	$push3=, strcmp, $pop1, $pop2
	br_if   	$pop3, BB3_15
# BB#1:                                 # %lor.lhs.false
	i32.const	$push4=, .str.2
	i32.const	$7=, 16
	i32.add 	$7=, $20, $7
	i32.call	$push5=, strcmp, $7, $pop4
	br_if   	$pop5, BB3_15
# BB#2:                                 # %if.end
	i32.const	$push6=, .str.3
	i32.store	$discard=, 12($20), $pop6
	i32.const	$8=, 12
	i32.add 	$8=, $20, $8
	i32.const	$9=, 16
	i32.add 	$9=, $20, $9
	call    	foo, $8, $9, $0, $1
	block   	BB3_14
	i32.load	$push7=, 12($20)
	i32.const	$push8=, .str.4
	i32.call	$push9=, strcmp, $pop7, $pop8
	br_if   	$pop9, BB3_14
# BB#3:                                 # %lor.lhs.false7
	i32.const	$push10=, .str.5
	i32.const	$10=, 16
	i32.add 	$10=, $20, $10
	i32.call	$push11=, strcmp, $10, $pop10
	br_if   	$pop11, BB3_14
# BB#4:                                 # %if.end12
	i32.const	$push12=, .str.6
	i32.store	$discard=, 12($20), $pop12
	i32.const	$11=, 12
	i32.add 	$11=, $20, $11
	i32.const	$12=, 16
	i32.add 	$12=, $20, $12
	call    	foo, $11, $12, $1, $1
	block   	BB3_13
	i32.load	$push13=, 12($20)
	i32.const	$push14=, .str.7
	i32.call	$push15=, strcmp, $pop13, $pop14
	br_if   	$pop15, BB3_13
# BB#5:                                 # %lor.lhs.false16
	i32.const	$push16=, .str.8
	i32.const	$13=, 16
	i32.add 	$13=, $20, $13
	i32.call	$push17=, strcmp, $13, $pop16
	br_if   	$pop17, BB3_13
# BB#6:                                 # %if.end21
	i32.const	$push18=, .str.9
	i32.store	$discard=, 12($20), $pop18
	i32.const	$14=, 12
	i32.add 	$14=, $20, $14
	i32.const	$15=, 16
	i32.add 	$15=, $20, $15
	call    	foo, $14, $15, $1, $1
	block   	BB3_12
	i32.load	$push19=, 12($20)
	i32.const	$push20=, .str.10
	i32.call	$push21=, strcmp, $pop19, $pop20
	br_if   	$pop21, BB3_12
# BB#7:                                 # %lor.lhs.false25
	i32.const	$push22=, .str.11
	i32.const	$16=, 16
	i32.add 	$16=, $20, $16
	i32.call	$push23=, strcmp, $16, $pop22
	br_if   	$pop23, BB3_12
# BB#8:                                 # %if.end30
	i32.const	$push24=, .str.12
	i32.store	$discard=, 12($20), $pop24
	i32.const	$17=, 12
	i32.add 	$17=, $20, $17
	i32.const	$18=, 16
	i32.add 	$18=, $20, $18
	call    	foo, $17, $18, $0, $0
	block   	BB3_11
	i32.load	$push25=, 12($20)
	i32.const	$push26=, .str.13
	i32.call	$push27=, strcmp, $pop25, $pop26
	br_if   	$pop27, BB3_11
# BB#9:                                 # %lor.lhs.false34
	i32.const	$push28=, .str.14
	i32.const	$19=, 16
	i32.add 	$19=, $20, $19
	i32.call	$push29=, strcmp, $19, $pop28
	br_if   	$pop29, BB3_11
# BB#10:                                # %if.end39
	i32.const	$4=, 80
	i32.add 	$20=, $20, $4
	i32.const	$4=, __stack_pointer
	i32.store	$20=, 0($4), $20
	return  	$0
BB3_11:                                 # %if.then38
	call    	abort
	unreachable
BB3_12:                                 # %if.then29
	call    	abort
	unreachable
BB3_13:                                 # %if.then20
	call    	abort
	unreachable
BB3_14:                                 # %if.then11
	call    	abort
	unreachable
BB3_15:                                 # %if.then
	call    	abort
	unreachable
func_end3:
	.size	main, func_end3-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"abcde'fgh"
	.size	.str, 10

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"fgh"
	.size	.str.1, 4

	.type	.str.2,@object          # @.str.2
.str.2:
	.asciz	"abcde"
	.size	.str.2, 6

	.type	.str.3,@object          # @.str.3
.str.3:
	.asciz	"ABCDEFG\"HI"
	.size	.str.3, 11

	.type	.str.4,@object          # @.str.4
.str.4:
	.asciz	"HI"
	.size	.str.4, 3

	.type	.str.5,@object          # @.str.5
.str.5:
	.asciz	"ABCDEFG"
	.size	.str.5, 8

	.type	.str.6,@object          # @.str.6
.str.6:
	.asciz	"abcd\"e'fgh"
	.size	.str.6, 11

	.type	.str.7,@object          # @.str.7
.str.7:
	.asciz	"e'fgh"
	.size	.str.7, 6

	.type	.str.8,@object          # @.str.8
.str.8:
	.asciz	"abcd"
	.size	.str.8, 5

	.type	.str.9,@object          # @.str.9
.str.9:
	.asciz	"ABCDEF'G\"HI"
	.size	.str.9, 12

	.type	.str.10,@object         # @.str.10
.str.10:
	.asciz	"G\"HI"
	.size	.str.10, 5

	.type	.str.11,@object         # @.str.11
.str.11:
	.asciz	"ABCDEF"
	.size	.str.11, 7

	.type	.str.12,@object         # @.str.12
.str.12:
	.asciz	"abcdef@gh"
	.size	.str.12, 10

	.type	.str.13,@object         # @.str.13
.str.13:
	.asciz	"gh"
	.size	.str.13, 3

	.type	.str.14,@object         # @.str.14
.str.14:
	.asciz	"abcdef"
	.size	.str.14, 7


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
