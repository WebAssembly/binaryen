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
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $1=, $pop4
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop3, $pop0
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$push1=, bar@FUNCTION, $0
	i32.store8	$discard=, 0($1), $pop1
	i32.const	$6=, 1
	block
	i32.call	$push21=, bar@FUNCTION, $0
	tee_local	$push20=, $7=, $pop21
	i32.const	$push2=, 255
	i32.and 	$push19=, $pop20, $pop2
	tee_local	$push18=, $5=, $pop19
	i32.const	$push3=, 39
	i32.eq  	$push4=, $pop18, $pop3
	i32.and 	$push5=, $pop4, $2
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push6=, 34
	i32.eq  	$push7=, $5, $pop6
	i32.and 	$push0=, $pop7, $3
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %if.end14.lr.ph
	i32.or  	$4=, $2, $3
	i32.const	$5=, 1
.LBB2_3:                                # %if.end14
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	br_if   	0, $4           # 0: down to label3
# BB#4:                                 # %land.lhs.true18
                                        #   in Loop: Header=BB2_3 Depth=1
	copy_local	$6=, $5
	i32.const	$push23=, 24
	i32.shl 	$push8=, $7, $pop23
	i32.const	$push22=, 24
	i32.shr_s	$push9=, $pop8, $pop22
	i32.call	$push10=, baz@FUNCTION, $pop9
	i32.const	$push30=, 0
	i32.eq  	$push31=, $pop10, $pop30
	br_if   	2, $pop31       # 2: down to label2
.LBB2_5:                                # %while.body.backedge
                                        #   in Loop: Header=BB2_3 Depth=1
	end_block                       # label3:
	i32.add 	$push12=, $1, $5
	i32.store8	$discard=, 0($pop12), $7
	i32.const	$push28=, 1
	i32.add 	$6=, $5, $pop28
	i32.call	$7=, bar@FUNCTION, $0
	i32.const	$push27=, 255
	i32.and 	$push26=, $7, $pop27
	tee_local	$push25=, $8=, $pop26
	i32.const	$push24=, 39
	i32.eq  	$push13=, $pop25, $pop24
	i32.and 	$push14=, $pop13, $2
	br_if   	1, $pop14       # 1: down to label2
# BB#6:                                 # %while.body.backedge
                                        #   in Loop: Header=BB2_3 Depth=1
	copy_local	$5=, $6
	i32.const	$push29=, 34
	i32.eq  	$push15=, $8, $pop29
	i32.and 	$push11=, $pop15, $3
	i32.const	$push32=, 0
	i32.eq  	$push33=, $pop11, $pop32
	br_if   	0, $pop33       # 0: up to label1
.LBB2_7:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.add 	$push16=, $1, $6
	i32.const	$push17=, 0
	i32.store8	$discard=, 0($pop16), $pop17
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 80
	i32.sub 	$18=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$18=, 0($1), $18
	i32.const	$push0=, .L.str
	i32.store	$discard=, 12($18), $pop0
	i32.const	$push2=, 1
	i32.const	$push1=, 0
	i32.const	$3=, 12
	i32.add 	$3=, $18, $3
	i32.const	$4=, 16
	i32.add 	$4=, $18, $4
	call    	foo@FUNCTION, $3, $4, $pop2, $pop1
	block
	block
	block
	block
	block
	i32.load	$push3=, 12($18)
	i32.const	$push4=, .L.str.1
	i32.call	$push5=, strcmp@FUNCTION, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.const	$push6=, .L.str.2
	i32.const	$5=, 16
	i32.add 	$5=, $18, $5
	i32.call	$push7=, strcmp@FUNCTION, $5, $pop6
	br_if   	0, $pop7        # 0: down to label8
# BB#2:                                 # %if.end
	i32.const	$push8=, .L.str.3
	i32.store	$discard=, 12($18), $pop8
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.const	$6=, 12
	i32.add 	$6=, $18, $6
	i32.const	$7=, 16
	i32.add 	$7=, $18, $7
	call    	foo@FUNCTION, $6, $7, $pop10, $pop9
	i32.load	$push11=, 12($18)
	i32.const	$push12=, .L.str.4
	i32.call	$push13=, strcmp@FUNCTION, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label7
# BB#3:                                 # %lor.lhs.false7
	i32.const	$push14=, .L.str.5
	i32.const	$8=, 16
	i32.add 	$8=, $18, $8
	i32.call	$push15=, strcmp@FUNCTION, $8, $pop14
	br_if   	1, $pop15       # 1: down to label7
# BB#4:                                 # %if.end12
	i32.const	$push16=, .L.str.6
	i32.store	$discard=, 12($18), $pop16
	i32.const	$push17=, 1
	i32.const	$push38=, 1
	i32.const	$9=, 12
	i32.add 	$9=, $18, $9
	i32.const	$10=, 16
	i32.add 	$10=, $18, $10
	call    	foo@FUNCTION, $9, $10, $pop17, $pop38
	i32.load	$push18=, 12($18)
	i32.const	$push19=, .L.str.7
	i32.call	$push20=, strcmp@FUNCTION, $pop18, $pop19
	br_if   	2, $pop20       # 2: down to label6
# BB#5:                                 # %lor.lhs.false16
	i32.const	$push21=, .L.str.8
	i32.const	$11=, 16
	i32.add 	$11=, $18, $11
	i32.call	$push22=, strcmp@FUNCTION, $11, $pop21
	br_if   	2, $pop22       # 2: down to label6
# BB#6:                                 # %if.end21
	i32.const	$push23=, .L.str.9
	i32.store	$discard=, 12($18), $pop23
	i32.const	$push24=, 1
	i32.const	$push39=, 1
	i32.const	$12=, 12
	i32.add 	$12=, $18, $12
	i32.const	$13=, 16
	i32.add 	$13=, $18, $13
	call    	foo@FUNCTION, $12, $13, $pop24, $pop39
	i32.load	$push25=, 12($18)
	i32.const	$push26=, .L.str.10
	i32.call	$push27=, strcmp@FUNCTION, $pop25, $pop26
	br_if   	3, $pop27       # 3: down to label5
# BB#7:                                 # %lor.lhs.false25
	i32.const	$push28=, .L.str.11
	i32.const	$14=, 16
	i32.add 	$14=, $18, $14
	i32.call	$push29=, strcmp@FUNCTION, $14, $pop28
	br_if   	3, $pop29       # 3: down to label5
# BB#8:                                 # %if.end30
	i32.const	$push30=, .L.str.12
	i32.store	$discard=, 12($18), $pop30
	i32.const	$push31=, 0
	i32.const	$push40=, 0
	i32.const	$15=, 12
	i32.add 	$15=, $18, $15
	i32.const	$16=, 16
	i32.add 	$16=, $18, $16
	call    	foo@FUNCTION, $15, $16, $pop31, $pop40
	i32.load	$push32=, 12($18)
	i32.const	$push33=, .L.str.13
	i32.call	$push34=, strcmp@FUNCTION, $pop32, $pop33
	br_if   	4, $pop34       # 4: down to label4
# BB#9:                                 # %lor.lhs.false34
	i32.const	$push35=, .L.str.14
	i32.const	$17=, 16
	i32.add 	$17=, $18, $17
	i32.call	$push36=, strcmp@FUNCTION, $17, $pop35
	br_if   	4, $pop36       # 4: down to label4
# BB#10:                                # %if.end39
	i32.const	$push37=, 0
	i32.const	$2=, 80
	i32.add 	$18=, $18, $2
	i32.const	$2=, __stack_pointer
	i32.store	$18=, 0($2), $18
	return  	$pop37
.LBB3_11:                               # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB3_12:                               # %if.then11
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB3_13:                               # %if.then20
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB3_14:                               # %if.then29
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB3_15:                               # %if.then38
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
