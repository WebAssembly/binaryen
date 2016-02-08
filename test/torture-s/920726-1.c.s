	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920726-1.c"
	.section	.text.first,"ax",@progbits
	.hidden	first
	.globl	first
	.type	first,@function
first:                                  # @first
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$11=, $8, $9
	copy_local	$12=, $11
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	i32.store	$discard=, 12($11), $12
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.load8_u	$push0=, 0($1)
	tee_local	$push9=, $3=, $pop0
	i32.const	$push8=, 105
	i32.eq  	$push1=, $pop9, $pop8
	br_if   	0, $pop1        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push17=, 0
	i32.eq  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label4
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$2=, $0, $pop15
	i32.store8	$discard=, 0($0), $3
	copy_local	$0=, $2
	br      	2               # 2: down to label2
.LBB0_4:                                # %for.end
	end_block                       # label4:
	i32.const	$push7=, 0
	i32.store8	$discard=, 0($0), $pop7
	i32.const	$10=, 16
	i32.add 	$11=, $12, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	return  	$0
.LBB0_5:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.load	$push2=, 12($11)
	i32.const	$push14=, 3
	i32.add 	$push3=, $pop2, $pop14
	i32.const	$push13=, -4
	i32.and 	$push4=, $pop3, $pop13
	tee_local	$push12=, $3=, $pop4
	i32.const	$push11=, 4
	i32.add 	$push5=, $pop12, $pop11
	i32.store	$discard=, 12($11), $pop5
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.sub 	$11=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$11=, 0($5), $11
	i32.load	$push6=, 0($3)
	i32.store	$discard=, 0($11), $pop6
	i32.const	$push10=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop10
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 4
	i32.add 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i32.call	$3=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $3
.LBB0_6:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push16=, 1
	i32.add 	$1=, $1, $pop16
	br      	0               # 0: up to label0
.LBB0_7:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	first, .Lfunc_end0-first

	.section	.text.second,"ax",@progbits
	.hidden	second
	.globl	second
	.type	second,@function
second:                                 # @second
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$11=, $8, $9
	copy_local	$12=, $11
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	i32.store	$discard=, 12($11), $12
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	block
	block
	i32.load8_u	$push0=, 0($1)
	tee_local	$push9=, $3=, $pop0
	i32.const	$push8=, 105
	i32.eq  	$push1=, $pop9, $pop8
	br_if   	0, $pop1        # 0: down to label8
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push17=, 0
	i32.eq  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label9
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push15=, 1
	i32.add 	$2=, $0, $pop15
	i32.store8	$discard=, 0($0), $3
	copy_local	$0=, $2
	br      	2               # 2: down to label7
.LBB1_4:                                # %for.end
	end_block                       # label9:
	i32.const	$push7=, 0
	i32.store8	$discard=, 0($0), $pop7
	i32.const	$10=, 16
	i32.add 	$11=, $12, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	return  	$0
.LBB1_5:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.load	$push2=, 12($11)
	i32.const	$push14=, 3
	i32.add 	$push3=, $pop2, $pop14
	i32.const	$push13=, -4
	i32.and 	$push4=, $pop3, $pop13
	tee_local	$push12=, $3=, $pop4
	i32.const	$push11=, 4
	i32.add 	$push5=, $pop12, $pop11
	i32.store	$discard=, 12($11), $pop5
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.sub 	$11=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$11=, 0($5), $11
	i32.load	$push6=, 0($3)
	i32.store	$discard=, 0($11), $pop6
	i32.const	$push10=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop10
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 4
	i32.add 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i32.call	$3=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $3
.LBB1_6:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push16=, 1
	i32.add 	$1=, $1, $pop16
	br      	0               # 0: up to label5
.LBB1_7:
	end_loop                        # label6:
	.endfunc
.Lfunc_end1:
	.size	second, .Lfunc_end1-second

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 240
	i32.sub 	$16=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$16=, 0($11), $16
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 8
	i32.sub 	$16=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$16=, 0($3), $16
	i64.const	$push0=, 85899345925
	i64.store	$0=, 0($16):p2align=2, $pop0
	i32.const	$push1=, .L.str.1
	i32.const	$12=, 128
	i32.add 	$12=, $16, $12
	i32.call	$discard=, first@FUNCTION, $12, $pop1
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 8
	i32.add 	$16=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$16=, 0($5), $16
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 8
	i32.sub 	$16=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$16=, 0($7), $16
	i64.store	$discard=, 0($16):p2align=2, $0
	i32.const	$push4=, .L.str.1
	i32.const	$13=, 16
	i32.add 	$13=, $16, $13
	i32.call	$discard=, second@FUNCTION, $13, $pop4
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 8
	i32.add 	$16=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$16=, 0($9), $16
	i32.const	$push3=, .L.str.2
	i32.const	$14=, 128
	i32.add 	$14=, $16, $14
	i32.call	$1=, strcmp@FUNCTION, $pop3, $14
	block
	br_if   	0, $1           # 0: down to label10
# BB#1:                                 # %lor.lhs.false
	i32.const	$push5=, .L.str.2
	i32.const	$15=, 16
	i32.add 	$15=, $16, $15
	i32.call	$1=, strcmp@FUNCTION, $pop5, $15
	br_if   	0, $1           # 0: down to label10
# BB#2:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"i i "
	.size	.L.str.1, 5

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"5 20 "
	.size	.L.str.2, 6


	.ident	"clang version 3.9.0 "
