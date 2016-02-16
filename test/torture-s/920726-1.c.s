	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920726-1.c"
	.section	.text.first,"ax",@progbits
	.hidden	first
	.globl	first
	.type	first,@function
first:                                  # @first
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$discard=, 12($7), $2
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.load8_u	$push9=, 0($1)
	tee_local	$push8=, $2=, $pop9
	i32.const	$push7=, 105
	i32.eq  	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push18=, 0
	i32.eq  	$push19=, $2, $pop18
	br_if   	3, $pop19       # 3: down to label1
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push16=, 1
	i32.add 	$3=, $0, $pop16
	i32.store8	$discard=, 0($0), $2
	copy_local	$0=, $3
	br      	1               # 1: down to label2
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.load	$push1=, 12($7)
	i32.const	$push15=, 3
	i32.add 	$push2=, $pop1, $pop15
	i32.const	$push14=, -4
	i32.and 	$push13=, $pop2, $pop14
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 4
	i32.add 	$push3=, $pop12, $pop11
	i32.store	$discard=, 12($7), $pop3
	i32.load	$push4=, 0($2)
	i32.store	$discard=, 0($7):p2align=4, $pop4
	i32.const	$push10=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop10, $7
	i32.call	$push5=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	br      	0               # 0: up to label0
.LBB0_6:                                # %for.end
	end_loop                        # label1:
	i32.const	$push6=, 0
	i32.store8	$discard=, 0($0), $pop6
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	first, .Lfunc_end0-first

	.section	.text.second,"ax",@progbits
	.hidden	second
	.globl	second
	.type	second,@function
second:                                 # @second
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$discard=, 12($7), $2
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	block
	i32.load8_u	$push9=, 0($1)
	tee_local	$push8=, $2=, $pop9
	i32.const	$push7=, 105
	i32.eq  	$push0=, $pop8, $pop7
	br_if   	0, $pop0        # 0: down to label7
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 0
	i32.eq  	$push19=, $2, $pop18
	br_if   	3, $pop19       # 3: down to label5
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 1
	i32.add 	$3=, $0, $pop16
	i32.store8	$discard=, 0($0), $2
	copy_local	$0=, $3
	br      	1               # 1: down to label6
.LBB1_4:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.load	$push1=, 12($7)
	i32.const	$push15=, 3
	i32.add 	$push2=, $pop1, $pop15
	i32.const	$push14=, -4
	i32.and 	$push13=, $pop2, $pop14
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 4
	i32.add 	$push3=, $pop12, $pop11
	i32.store	$discard=, 12($7), $pop3
	i32.load	$push4=, 0($2)
	i32.store	$discard=, 0($7):p2align=4, $pop4
	i32.const	$push10=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop10, $7
	i32.call	$push5=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop5
.LBB1_5:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	br      	0               # 0: up to label4
.LBB1_6:                                # %for.end
	end_loop                        # label5:
	i32.const	$push6=, 0
	i32.store8	$discard=, 0($0), $pop6
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	second, .Lfunc_end1-second

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 256
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i64.const	$push0=, 85899345925
	i64.store	$0=, 16($8):p2align=4, $pop0
	i32.const	$push1=, .L.str.1
	i32.const	$3=, 144
	i32.add 	$3=, $8, $3
	i32.const	$4=, 16
	i32.add 	$4=, $8, $4
	i32.call	$discard=, first@FUNCTION, $3, $pop1, $4
	i64.store	$discard=, 0($8):p2align=4, $0
	i32.const	$push6=, .L.str.1
	i32.const	$5=, 32
	i32.add 	$5=, $8, $5
	i32.call	$discard=, second@FUNCTION, $5, $pop6, $8
	i32.const	$push5=, .L.str.2
	i32.const	$6=, 144
	i32.add 	$6=, $8, $6
	block
	i32.call	$push2=, strcmp@FUNCTION, $pop5, $6
	br_if   	0, $pop2        # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.const	$push7=, .L.str.2
	i32.const	$7=, 32
	i32.add 	$7=, $8, $7
	i32.call	$push3=, strcmp@FUNCTION, $pop7, $7
	br_if   	0, $pop3        # 0: down to label8
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label8:
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
