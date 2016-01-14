	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050502-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
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
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 64
	i32.ne  	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$push1=, bar@FUNCTION, $0
	i32.store8	$discard=, 0($1), $pop1
	i32.call	$9=, bar@FUNCTION, $0
	i32.const	$5=, 255
	i32.and 	$10=, $9, $5
	i32.const	$6=, 39
	i32.const	$11=, 1
	block
	i32.eq  	$push2=, $10, $6
	i32.and 	$push3=, $pop2, $2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$7=, 34
	i32.eq  	$push4=, $10, $7
	i32.and 	$push0=, $pop4, $3
	br_if   	$pop0, 0        # 0: down to label0
# BB#2:                                 # %if.end14.lr.ph
	i32.or  	$4=, $2, $3
	i32.const	$10=, 1
.LBB2_3:                                # %if.end14
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	br_if   	$4, 0           # 0: down to label3
# BB#4:                                 # %land.lhs.true18
                                        #   in Loop: Header=BB2_3 Depth=1
	i32.const	$8=, 24
	i32.shl 	$push5=, $9, $8
	i32.shr_s	$push6=, $pop5, $8
	i32.call	$8=, baz@FUNCTION, $pop6
	copy_local	$11=, $10
	i32.const	$push15=, 0
	i32.eq  	$push16=, $8, $pop15
	br_if   	$pop16, 2       # 2: down to label2
.LBB2_5:                                # %while.body.backedge
                                        #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label3:
	i32.add 	$push9=, $1, $10
	i32.store8	$discard=, 0($pop9), $9
	i32.const	$push8=, 1
	i32.add 	$11=, $10, $pop8
	i32.call	$9=, bar@FUNCTION, $0
	i32.and 	$8=, $9, $5
	i32.eq  	$push10=, $8, $6
	i32.and 	$push11=, $pop10, $2
	br_if   	$pop11, 1       # 1: down to label2
# BB#6:                                 # %while.body.backedge
                                        #   in Loop: Header=BB2_3 Depth=1
	copy_local	$10=, $11
	i32.eq  	$push12=, $8, $7
	i32.and 	$push7=, $pop12, $3
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop7, $pop17
	br_if   	$pop18, 0       # 0: up to label1
.LBB2_7:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.add 	$push13=, $1, $11
	i32.const	$push14=, 0
	i32.store8	$discard=, 0($pop13), $pop14
	return
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
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
	i32.const	$push0=, .L.str
	i32.store	$discard=, 12($20), $pop0
	i32.const	$5=, 12
	i32.add 	$5=, $20, $5
	i32.const	$6=, 16
	i32.add 	$6=, $20, $6
	call    	foo@FUNCTION, $5, $6, $1, $0
	block
	i32.load	$push1=, 12($20)
	i32.const	$push2=, .L.str.1
	i32.call	$push3=, strcmp@FUNCTION, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.const	$push4=, .L.str.2
	i32.const	$7=, 16
	i32.add 	$7=, $20, $7
	i32.call	$push5=, strcmp@FUNCTION, $7, $pop4
	br_if   	$pop5, 0        # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$push6=, .L.str.3
	i32.store	$discard=, 12($20), $pop6
	i32.const	$8=, 12
	i32.add 	$8=, $20, $8
	i32.const	$9=, 16
	i32.add 	$9=, $20, $9
	call    	foo@FUNCTION, $8, $9, $0, $1
	block
	i32.load	$push7=, 12($20)
	i32.const	$push8=, .L.str.4
	i32.call	$push9=, strcmp@FUNCTION, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label5
# BB#3:                                 # %lor.lhs.false7
	i32.const	$push10=, .L.str.5
	i32.const	$10=, 16
	i32.add 	$10=, $20, $10
	i32.call	$push11=, strcmp@FUNCTION, $10, $pop10
	br_if   	$pop11, 0       # 0: down to label5
# BB#4:                                 # %if.end12
	i32.const	$push12=, .L.str.6
	i32.store	$discard=, 12($20), $pop12
	i32.const	$11=, 12
	i32.add 	$11=, $20, $11
	i32.const	$12=, 16
	i32.add 	$12=, $20, $12
	call    	foo@FUNCTION, $11, $12, $1, $1
	block
	i32.load	$push13=, 12($20)
	i32.const	$push14=, .L.str.7
	i32.call	$push15=, strcmp@FUNCTION, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label6
# BB#5:                                 # %lor.lhs.false16
	i32.const	$push16=, .L.str.8
	i32.const	$13=, 16
	i32.add 	$13=, $20, $13
	i32.call	$push17=, strcmp@FUNCTION, $13, $pop16
	br_if   	$pop17, 0       # 0: down to label6
# BB#6:                                 # %if.end21
	i32.const	$push18=, .L.str.9
	i32.store	$discard=, 12($20), $pop18
	i32.const	$14=, 12
	i32.add 	$14=, $20, $14
	i32.const	$15=, 16
	i32.add 	$15=, $20, $15
	call    	foo@FUNCTION, $14, $15, $1, $1
	block
	i32.load	$push19=, 12($20)
	i32.const	$push20=, .L.str.10
	i32.call	$push21=, strcmp@FUNCTION, $pop19, $pop20
	br_if   	$pop21, 0       # 0: down to label7
# BB#7:                                 # %lor.lhs.false25
	i32.const	$push22=, .L.str.11
	i32.const	$16=, 16
	i32.add 	$16=, $20, $16
	i32.call	$push23=, strcmp@FUNCTION, $16, $pop22
	br_if   	$pop23, 0       # 0: down to label7
# BB#8:                                 # %if.end30
	i32.const	$push24=, .L.str.12
	i32.store	$discard=, 12($20), $pop24
	i32.const	$17=, 12
	i32.add 	$17=, $20, $17
	i32.const	$18=, 16
	i32.add 	$18=, $20, $18
	call    	foo@FUNCTION, $17, $18, $0, $0
	block
	i32.load	$push25=, 12($20)
	i32.const	$push26=, .L.str.13
	i32.call	$push27=, strcmp@FUNCTION, $pop25, $pop26
	br_if   	$pop27, 0       # 0: down to label8
# BB#9:                                 # %lor.lhs.false34
	i32.const	$push28=, .L.str.14
	i32.const	$19=, 16
	i32.add 	$19=, $20, $19
	i32.call	$push29=, strcmp@FUNCTION, $19, $pop28
	br_if   	$pop29, 0       # 0: down to label8
# BB#10:                                # %if.end39
	i32.const	$4=, 80
	i32.add 	$20=, $20, $4
	i32.const	$4=, __stack_pointer
	i32.store	$20=, 0($4), $20
	return  	$0
.LBB3_11:                               # %if.then38
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB3_12:                               # %if.then29
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB3_13:                               # %if.then20
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB3_14:                               # %if.then11
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB3_15:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcde'fgh"
	.size	.L.str, 10

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"fgh"
	.size	.L.str.1, 4

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"abcde"
	.size	.L.str.2, 6

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"ABCDEFG\"HI"
	.size	.L.str.3, 11

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"HI"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"ABCDEFG"
	.size	.L.str.5, 8

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"abcd\"e'fgh"
	.size	.L.str.6, 11

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"e'fgh"
	.size	.L.str.7, 6

	.type	.L.str.8,@object        # @.str.8
.L.str.8:
	.asciz	"abcd"
	.size	.L.str.8, 5

	.type	.L.str.9,@object        # @.str.9
.L.str.9:
	.asciz	"ABCDEF'G\"HI"
	.size	.L.str.9, 12

	.type	.L.str.10,@object       # @.str.10
.L.str.10:
	.asciz	"G\"HI"
	.size	.L.str.10, 5

	.type	.L.str.11,@object       # @.str.11
.L.str.11:
	.asciz	"ABCDEF"
	.size	.L.str.11, 7

	.type	.L.str.12,@object       # @.str.12
.L.str.12:
	.asciz	"abcdef@gh"
	.size	.L.str.12, 10

	.type	.L.str.13,@object       # @.str.13
.L.str.13:
	.asciz	"gh"
	.size	.L.str.13, 3

	.type	.L.str.14,@object       # @.str.14
.L.str.14:
	.asciz	"abcdef"
	.size	.L.str.14, 7


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
