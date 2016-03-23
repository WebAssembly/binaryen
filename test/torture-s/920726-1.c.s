	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920726-1.c"
	.section	.text.first,"ax",@progbits
	.hidden	first
	.globl	first
	.type	first,@function
first:                                  # @first
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$4=, $pop15, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $4
	i32.store	$discard=, 12($4), $2
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.load8_u	$push7=, 0($1)
	tee_local	$push6=, $2=, $pop7
	i32.const	$push5=, 105
	i32.eq  	$push0=, $pop6, $pop5
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push21=, 0
	i32.eq  	$push22=, $2, $pop21
	br_if   	3, $pop22       # 3: down to label1
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 1
	i32.add 	$3=, $0, $pop12
	i32.store8	$discard=, 0($0), $2
	copy_local	$0=, $3
	br      	1               # 1: down to label2
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.load	$push11=, 12($4)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push1=, $pop10, $pop9
	i32.store	$discard=, 12($4), $pop1
	i32.load	$push2=, 0($2)
	i32.store	$discard=, 0($4):p2align=4, $pop2
	i32.const	$push8=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop8, $4
	i32.call	$push3=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop3
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push13=, 1
	i32.add 	$1=, $1, $pop13
	br      	0               # 0: up to label0
.LBB0_6:                                # %for.end
	end_loop                        # label1:
	i32.const	$push4=, 0
	i32.store8	$discard=, 0($0), $pop4
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	$discard=, 0($pop20), $pop19
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$4=, $pop15, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $4
	i32.store	$discard=, 12($4), $2
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	block
	block
	i32.load8_u	$push7=, 0($1)
	tee_local	$push6=, $2=, $pop7
	i32.const	$push5=, 105
	i32.eq  	$push0=, $pop6, $pop5
	br_if   	0, $pop0        # 0: down to label7
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 0
	i32.eq  	$push22=, $2, $pop21
	br_if   	3, $pop22       # 3: down to label5
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 1
	i32.add 	$3=, $0, $pop12
	i32.store8	$discard=, 0($0), $2
	copy_local	$0=, $3
	br      	1               # 1: down to label6
.LBB1_4:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.load	$push11=, 12($4)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push1=, $pop10, $pop9
	i32.store	$discard=, 12($4), $pop1
	i32.load	$push2=, 0($2)
	i32.store	$discard=, 0($4):p2align=4, $pop2
	i32.const	$push8=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop8, $4
	i32.call	$push3=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop3
.LBB1_5:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push13=, 1
	i32.add 	$1=, $1, $pop13
	br      	0               # 0: up to label4
.LBB1_6:                                # %for.end
	end_loop                        # label5:
	i32.const	$push4=, 0
	i32.store8	$discard=, 0($0), $pop4
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	$discard=, 0($pop20), $pop19
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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 256
	i32.sub 	$1=, $pop9, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $1
	i64.const	$push0=, 85899345925
	i64.store	$0=, 16($1):p2align=4, $pop0
	i32.const	$push12=, 144
	i32.add 	$push13=, $1, $pop12
	i32.const	$push1=, .L.str.1
	i32.const	$push14=, 16
	i32.add 	$push15=, $1, $pop14
	i32.call	$discard=, first@FUNCTION, $pop13, $pop1, $pop15
	i64.store	$discard=, 0($1):p2align=4, $0
	i32.const	$push16=, 32
	i32.add 	$push17=, $1, $pop16
	i32.const	$push6=, .L.str.1
	i32.call	$discard=, second@FUNCTION, $pop17, $pop6, $1
	block
	i32.const	$push5=, .L.str.2
	i32.const	$push18=, 144
	i32.add 	$push19=, $1, $pop18
	i32.call	$push2=, strcmp@FUNCTION, $pop5, $pop19
	br_if   	0, $pop2        # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.const	$push7=, .L.str.2
	i32.const	$push20=, 32
	i32.add 	$push21=, $1, $pop20
	i32.call	$push3=, strcmp@FUNCTION, $pop7, $pop21
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
