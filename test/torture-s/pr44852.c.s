	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44852.c"
	.section	.text.sf,"ax",@progbits
	.hidden	sf
	.globl	sf
	.type	sf,@function
sf:                                     # @sf
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label2:
	i32.const	$push0=, -1
	i32.add 	$3=, $0, $pop0
	i32.load8_u	$2=, 0($3)
	i32.const	$push1=, 57
	i32.ne  	$push2=, $2, $pop1
	br_if   	$pop2, 2        # 2: down to label1
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $3
	i32.ne  	$push5=, $1, $3
	br_if   	$pop5, 0        # 0: up to label2
# BB#3:                                 # %if.then
	end_loop                        # label3:
	i32.const	$push4=, 1
	i32.add 	$0=, $3, $pop4
	i32.const	$push6=, 48
	i32.store8	$discard=, 0($1), $pop6
	i32.const	$2=, 49
	br      	1               # 1: down to label0
.LBB0_4:                                # %while.end.loopexit
	end_block                       # label1:
	i32.const	$push3=, 1
	i32.add 	$2=, $2, $pop3
	copy_local	$1=, $3
.LBB0_5:                                # %while.end
	end_block                       # label0:
	i32.store8	$discard=, 0($1), $2
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	sf, .Lfunc_end0-sf

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$14=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$14=, 0($6), $14
	i32.const	$0=, 0
	i32.const	$1=, 1
	i32.const	$push1=, 6
	i32.const	$8=, 8
	i32.add 	$8=, $14, $8
	i32.add 	$push2=, $8, $pop1
	i32.load8_u	$push0=, .Lmain.s+6($0)
	i32.store8	$discard=, 0($pop2), $pop0
	i32.const	$2=, 8
	i32.const	$3=, .Lmain.s
	i32.const	$4=, 2
	i32.const	$push9=, 4
	i32.const	$9=, 8
	i32.add 	$9=, $14, $9
	i32.add 	$push10=, $9, $pop9
	i32.const	$push3=, .Lmain.s+4
	i32.add 	$push4=, $pop3, $1
	i32.load8_u	$push5=, 0($pop4)
	i32.shl 	$push6=, $pop5, $2
	i32.load8_u	$push7=, .Lmain.s+4($0)
	i32.or  	$push8=, $pop6, $pop7
	i32.store16	$discard=, 0($pop10), $pop8
	i32.const	$push11=, 3
	i32.add 	$push12=, $3, $pop11
	i32.load8_u	$push13=, 0($pop12)
	i32.shl 	$push14=, $pop13, $2
	i32.add 	$push15=, $3, $4
	i32.load8_u	$push16=, 0($pop15)
	i32.or  	$push17=, $pop14, $pop16
	i32.const	$push18=, 16
	i32.shl 	$push19=, $pop17, $pop18
	i32.add 	$push20=, $3, $1
	i32.load8_u	$push21=, 0($pop20)
	i32.shl 	$push22=, $pop21, $2
	i32.load8_u	$push23=, .Lmain.s($0)
	i32.or  	$push24=, $pop22, $pop23
	i32.or  	$push25=, $pop19, $pop24
	i32.store	$discard=, 8($14), $pop25
	i32.const	$10=, 8
	i32.add 	$10=, $14, $10
	i32.or  	$push26=, $10, $4
	i32.const	$11=, 8
	i32.add 	$11=, $14, $11
	i32.call	$push27=, sf@FUNCTION, $pop26, $11
	i32.const	$12=, 8
	i32.add 	$12=, $14, $12
	block
	i32.or  	$push28=, $12, $1
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, 0       # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.const	$push30=, .L.str
	i32.const	$13=, 8
	i32.add 	$13=, $14, $13
	i32.call	$push31=, strcmp@FUNCTION, $13, $pop30
	br_if   	$pop31, 0       # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$7=, 16
	i32.add 	$14=, $14, $7
	i32.const	$7=, __stack_pointer
	i32.store	$14=, 0($7), $14
	return  	$0
.LBB1_3:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.s:
	.asciz	"999999"
	.size	.Lmain.s, 7

	.type	.L.str,@object          # @.str
.L.str:
	.asciz	"199999"
	.size	.L.str, 7


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
