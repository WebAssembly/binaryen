	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920726-1.c"
	.section	.text.first,"ax",@progbits
	.hidden	first
	.globl	first
	.type	first,@function
first:                                  # @first
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push15=, 0($pop9), $pop13
	tee_local	$push14=, $3=, $pop15
	i32.store	$discard=, 12($pop14), $2
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.load8_u	$push23=, 0($1)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 105
	i32.ne  	$push1=, $pop22, $pop21
	br_if   	0, $pop1        # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push20=, 12($3)
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, 4
	i32.add 	$push2=, $pop19, $pop18
	i32.store	$discard=, 12($3), $pop2
	i32.load	$push3=, 0($2)
	i32.store	$discard=, 0($3), $pop3
	i32.const	$push17=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop17, $3
	i32.call	$push4=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop4
	i32.const	$push16=, 1
	i32.add 	$1=, $1, $pop16
	br      	1               # 1: up to label0
.LBB0_3:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.eqz 	$push26=, $2
	br_if   	1, $pop26       # 1: down to label1
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	$discard=, 0($0), $2
	i32.const	$push25=, 1
	i32.add 	$push0=, $0, $pop25
	copy_local	$0=, $pop0
	i32.const	$push24=, 1
	i32.add 	$1=, $1, $pop24
	br      	0               # 0: up to label0
.LBB0_5:                                # %for.end
	end_loop                        # label1:
	i32.const	$push5=, 0
	i32.store8	$discard=, 0($0), $pop5
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $3, $pop10
	i32.store	$discard=, 0($pop12), $pop11
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push15=, 0($pop9), $pop13
	tee_local	$push14=, $3=, $pop15
	i32.store	$discard=, 12($pop14), $2
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	block
	i32.load8_u	$push23=, 0($1)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 105
	i32.ne  	$push1=, $pop22, $pop21
	br_if   	0, $pop1        # 0: down to label5
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push20=, 12($3)
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, 4
	i32.add 	$push2=, $pop19, $pop18
	i32.store	$discard=, 12($3), $pop2
	i32.load	$push3=, 0($2)
	i32.store	$discard=, 0($3), $pop3
	i32.const	$push17=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop17, $3
	i32.call	$push4=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop4
	i32.const	$push16=, 1
	i32.add 	$1=, $1, $pop16
	br      	1               # 1: up to label3
.LBB1_3:                                # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.eqz 	$push26=, $2
	br_if   	1, $pop26       # 1: down to label4
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store8	$discard=, 0($0), $2
	i32.const	$push25=, 1
	i32.add 	$push0=, $0, $pop25
	copy_local	$0=, $pop0
	i32.const	$push24=, 1
	i32.add 	$1=, $1, $pop24
	br      	0               # 0: up to label3
.LBB1_5:                                # %for.end
	end_loop                        # label4:
	i32.const	$push5=, 0
	i32.store8	$discard=, 0($0), $pop5
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $3, $pop10
	i32.store	$discard=, 0($pop12), $pop11
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
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 256
	i32.sub 	$push19=, $pop6, $pop7
	i32.store	$push23=, 0($pop8), $pop19
	tee_local	$push22=, $1=, $pop23
	i64.const	$push0=, 85899345925
	i64.store	$0=, 16($pop22), $pop0
	i32.const	$push9=, 144
	i32.add 	$push10=, $1, $pop9
	i32.const	$push1=, .L.str.1
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.call	$discard=, first@FUNCTION, $pop10, $pop1, $pop12
	i64.store	$discard=, 0($1), $0
	i32.const	$push13=, 32
	i32.add 	$push14=, $1, $pop13
	i32.const	$push21=, .L.str.1
	i32.call	$discard=, second@FUNCTION, $pop14, $pop21, $1
	block
	i32.const	$push20=, .L.str.2
	i32.const	$push15=, 144
	i32.add 	$push16=, $1, $pop15
	i32.call	$push2=, strcmp@FUNCTION, $pop20, $pop16
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	i32.const	$push24=, .L.str.2
	i32.const	$push17=, 32
	i32.add 	$push18=, $1, $pop17
	i32.call	$push3=, strcmp@FUNCTION, $pop24, $pop18
	br_if   	0, $pop3        # 0: down to label6
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label6:
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
