	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39100.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$16=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$16=, 0($10), $16
	i32.const	$12=, 12
	i32.add 	$12=, $16, $12
	copy_local	$7=, $12
	i32.const	$13=, 8
	i32.add 	$13=, $16, $13
	copy_local	$8=, $13
	i32.const	$push0=, 0
	i32.store	$push1=, 12($16), $pop0
	i32.store	$2=, 8($16), $pop1
	block
	i32.const	$push15=, 0
	i32.eq  	$push16=, $1, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#1:                                 # %while.body.lr.ph.lr.ph
	i32.const	$push4=, 6
	i32.add 	$3=, $0, $pop4
	i32.const	$14=, 8
	i32.add 	$14=, $16, $14
	copy_local	$6=, $14
	i32.const	$15=, 12
	i32.add 	$15=, $16, $15
	copy_local	$7=, $15
.LBB0_2:                                # %while.body.lr.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label1:
	copy_local	$5=, $1
.LBB0_3:                                # %while.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label3:
	i32.load	$1=, 4($5)
	i32.const	$push11=, 4
	i32.add 	$8=, $5, $pop11
	i32.load8_u	$push2=, 0($5):p2align=2
	i32.const	$push10=, 1
	i32.and 	$push3=, $pop2, $pop10
	br_if   	1, $pop3        # 1: down to label4
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push14=, 4
	i32.add 	$4=, $0, $pop14
	i32.load16_u	$push6=, 0($4):p2align=2
	i32.const	$push13=, 1
	i32.add 	$push7=, $pop6, $pop13
	i32.store16	$discard=, 0($4):p2align=2, $pop7
	i32.store	$discard=, 0($6), $5
	copy_local	$5=, $1
	copy_local	$6=, $8
	br_if   	0, $1           # 0: up to label3
	br      	3               # 3: down to label2
.LBB0_5:                                # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label4:
	i32.load16_u	$4=, 0($3)
	i32.store	$discard=, 0($7), $5
	i32.const	$push12=, 1
	i32.add 	$push5=, $4, $pop12
	i32.store16	$discard=, 0($3), $pop5
	copy_local	$7=, $8
	copy_local	$8=, $6
	br_if   	0, $1           # 0: up to label1
.LBB0_6:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.load	$push8=, 8($16)
	i32.store	$discard=, 0($7), $pop8
	i32.store	$discard=, 0($8), $2
	i32.load	$push9=, 12($16)
	i32.store	$discard=, 0($0), $pop9
	i32.const	$11=, 16
	i32.add 	$16=, $16, $11
	i32.const	$11=, __stack_pointer
	i32.store	$16=, 0($11), $16
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$6=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	i32.const	$push8=, 12
	i32.or  	$push9=, $6, $pop8
	i32.const	$push2=, 0
	i32.store	$push3=, 0($6):p2align=4, $pop2
	i32.store	$discard=, 0($pop9), $pop3
	i32.const	$push4=, 4
	i32.or  	$push5=, $6, $pop4
	i32.const	$push6=, 8
	i32.or  	$push0=, $6, $pop6
	i32.store	$push26=, 0($pop5), $pop0
	tee_local	$push25=, $0=, $pop26
	i32.const	$push7=, 1
	i32.store	$discard=, 0($pop25):p2align=3, $pop7
	i64.const	$push1=, 0
	i64.store	$discard=, 24($6), $pop1
	i32.const	$4=, 24
	i32.add 	$4=, $6, $4
	i32.call	$discard=, foo@FUNCTION, $4, $6
	i32.const	$push24=, 4
	i32.const	$5=, 24
	i32.add 	$5=, $6, $5
	block
	block
	block
	block
	i32.or  	$push10=, $5, $pop24
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 65537
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label8
# BB#1:                                 # %if.end
	i32.load	$push14=, 24($6):p2align=3
	i32.ne  	$push15=, $pop14, $0
	br_if   	1, $pop15       # 1: down to label7
# BB#2:                                 # %if.end13
	i32.const	$push16=, 12
	i32.or  	$push17=, $6, $pop16
	i32.load	$push18=, 0($pop17)
	i32.ne  	$push19=, $pop18, $6
	br_if   	2, $pop19       # 2: down to label6
# BB#3:                                 # %if.end20
	i32.const	$push20=, 4
	i32.or  	$push21=, $6, $pop20
	i32.load	$push22=, 0($pop21)
	br_if   	3, $pop22       # 3: down to label5
# BB#4:                                 # %if.end24
	i32.const	$push23=, 0
	i32.const	$3=, 32
	i32.add 	$6=, $6, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	return  	$pop23
.LBB1_5:                                # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then12
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then19
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then23
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
