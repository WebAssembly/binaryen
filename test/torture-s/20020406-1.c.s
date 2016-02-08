	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020406-1.c"
	.section	.text.FFmul,"ax",@progbits
	.hidden	FFmul
	.globl	FFmul
	.type	FFmul,@function
FFmul:                                  # @FFmul
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	FFmul, .Lfunc_end0-FFmul

	.section	.text.DUPFFdeg,"ax",@progbits
	.hidden	DUPFFdeg
	.globl	DUPFFdeg
	.type	DUPFFdeg,@function
DUPFFdeg:                               # @DUPFFdeg
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($0)
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	DUPFFdeg, .Lfunc_end1-DUPFFdeg

	.section	.text.DUPFFnew,"ax",@progbits
	.hidden	DUPFFnew
	.globl	DUPFFnew
	.type	DUPFFnew,@function
DUPFFnew:                               # @DUPFFnew
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 12
	i32.call	$push0=, malloc@FUNCTION, $pop1
	tee_local	$push12=, $1=, $pop0
	i32.const	$push2=, 0
	i32.store	$push3=, 8($pop12), $pop2
	i32.lt_s	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push9=, 8
	i32.add 	$push10=, $1, $pop9
	i32.const	$push5=, 1
	i32.add 	$push6=, $0, $pop5
	i32.const	$push7=, 4
	i32.call	$push8=, calloc@FUNCTION, $pop6, $pop7
	i32.store	$discard=, 0($pop10), $pop8
.LBB2_2:                                # %if.end
	end_block                       # label0:
	i32.store	$discard=, 0($1), $0
	i32.const	$push11=, -1
	i32.store	$discard=, 4($1), $pop11
	return  	$1
	.endfunc
.Lfunc_end2:
	.size	DUPFFnew, .Lfunc_end2-DUPFFnew

	.section	.text.DUPFFfree,"ax",@progbits
	.hidden	DUPFFfree
	.globl	DUPFFfree
	.type	DUPFFfree,@function
DUPFFfree:                              # @DUPFFfree
	.param  	i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end3:
	.size	DUPFFfree, .Lfunc_end3-DUPFFfree

	.section	.text.DUPFFswap,"ax",@progbits
	.hidden	DUPFFswap
	.globl	DUPFFswap
	.type	DUPFFswap,@function
DUPFFswap:                              # @DUPFFswap
	.param  	i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end4:
	.size	DUPFFswap, .Lfunc_end4-DUPFFswap

	.section	.text.DUPFFcopy,"ax",@progbits
	.hidden	DUPFFcopy
	.globl	DUPFFcopy
	.type	DUPFFcopy,@function
DUPFFcopy:                              # @DUPFFcopy
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
	.endfunc
.Lfunc_end5:
	.size	DUPFFcopy, .Lfunc_end5-DUPFFcopy

	.section	.text.DUPFFshift_add,"ax",@progbits
	.hidden	DUPFFshift_add
	.globl	DUPFFshift_add
	.type	DUPFFshift_add,@function
DUPFFshift_add:                         # @DUPFFshift_add
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end6:
	.size	DUPFFshift_add, .Lfunc_end6-DUPFFshift_add

	.section	.text.DUPFFexgcd,"ax",@progbits
	.hidden	DUPFFexgcd
	.globl	DUPFFexgcd
	.type	DUPFFexgcd,@function
DUPFFexgcd:                             # @DUPFFexgcd
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 16
	i32.sub 	$15=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$15=, 0($13), $15
	i32.load	$7=, 4($2)
	i32.load	$6=, 4($3)
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 8
	i32.sub 	$15=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$15=, 0($9), $15
	i32.store	$discard=, 0($15), $7
	i32.const	$push20=, 4
	i32.add 	$7=, $15, $pop20
	i32.store	$discard=, 0($7), $6
	i32.const	$push19=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop19
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 8
	i32.add 	$15=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$15=, 0($11), $15
	i32.load	$6=, 4($3)
	i32.load	$7=, 4($5)
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.lt_s	$push1=, $6, $7
	br_if   	0, $pop1        # 0: up to label1
# BB#2:                                 # %if.end
	end_loop                        # label2:
	block
	i32.const	$push2=, 2
	i32.ne  	$push3=, $6, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push4=, 1
	i32.ne  	$push5=, $7, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#4:                                 # %if.end11
	block
	i32.load	$push6=, 8($3)
	i32.load	$push7=, 0($pop6)
	i32.const	$push26=, 0
	i32.eq  	$push27=, $pop7, $pop26
	br_if   	0, $pop27       # 0: down to label4
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push8=, 12
	i32.call	$7=, malloc@FUNCTION, $pop8
	i32.const	$push9=, 2
	i32.const	$push24=, 4
	i32.call	$6=, calloc@FUNCTION, $pop9, $pop24
	i32.store	$push10=, 8($7), $6
	i32.const	$push11=, 1
	i32.store	$push12=, 0($7), $pop11
	i32.store	$2=, 0($pop10), $pop12
	i32.const	$push13=, 0
	i32.store	$discard=, 4($7), $pop13
	i32.const	$push23=, 12
	i32.call	$6=, malloc@FUNCTION, $pop23
	i32.const	$push14=, 3
	i32.const	$push22=, 4
	i32.call	$0=, calloc@FUNCTION, $pop14, $pop22
	i64.const	$push15=, -4294967294
	i64.store	$discard=, 0($6):p2align=2, $pop15
	i32.const	$push21=, 4
	i32.add 	$push16=, $5, $pop21
	i32.load	$5=, 0($pop16)
	i32.store	$discard=, 8($6), $0
	block
	i32.lt_s	$push17=, $5, $2
	br_if   	0, $pop17       # 0: down to label5
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push25=, 4
	i32.add 	$push18=, $3, $pop25
	i32.load	$push0=, 0($pop18)
	i32.lt_s	$3=, $pop0, $5
.LBB7_7:                                # %while.cond40.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	br_if   	0, $3           # 0: up to label6
.LBB7_8:                                # %while.cond40
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label7:
	loop                            # label8:
	br      	0               # 0: up to label8
.LBB7_9:                                # %if.end57
	end_loop                        # label9:
	end_block                       # label5:
	i32.store	$discard=, 0($1), $7
	i32.store	$discard=, 0($4), $6
.LBB7_10:                               # %cleanup
	end_block                       # label4:
	i32.const	$14=, 16
	i32.add 	$15=, $15, $14
	i32.const	$14=, __stack_pointer
	i32.store	$15=, 0($14), $15
	return  	$3
.LBB7_11:                               # %if.then10
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	DUPFFexgcd, .Lfunc_end7-DUPFFexgcd

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$13=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$13=, 0($9), $13
	i32.const	$push0=, 12
	i32.call	$0=, malloc@FUNCTION, $pop0
	i32.const	$push2=, 2
	i32.const	$push1=, 4
	i32.call	$2=, calloc@FUNCTION, $pop2, $pop1
	i32.store	$push3=, 8($0), $2
	i32.const	$push4=, 1
	i32.store	$push5=, 0($0), $pop4
	i32.store	$push6=, 4($pop3), $pop5
	i32.store	$1=, 4($0), $pop6
	i32.const	$push15=, 12
	i32.call	$2=, malloc@FUNCTION, $pop15
	i32.const	$push7=, 3
	i32.const	$push14=, 4
	i32.call	$3=, calloc@FUNCTION, $pop7, $pop14
	i32.store	$push8=, 8($2), $3
	i32.store	$discard=, 8($pop8), $1
	i32.const	$push13=, 2
	i32.store	$push9=, 0($2), $pop13
	i32.store	$discard=, 4($2), $pop9
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 8
	i32.sub 	$13=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$13=, 0($5), $13
	i64.const	$push10=, 8589934593
	i64.store	$discard=, 0($13):p2align=2, $pop10
	i32.const	$push11=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop11
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 8
	i32.add 	$13=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$13=, 0($7), $13
	i32.const	$11=, 12
	i32.add 	$11=, $13, $11
	i32.const	$12=, 8
	i32.add 	$12=, $13, $12
	i32.call	$discard=, DUPFFexgcd@FUNCTION, $11, $12, $0, $2
	i32.const	$push12=, 0
	i32.const	$10=, 16
	i32.add 	$13=, $13, $10
	i32.const	$10=, __stack_pointer
	i32.store	$13=, 0($10), $13
	return  	$pop12
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"DUPFFexgcd called on degrees %d and %d\n"
	.size	.L.str, 40

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"calling DUPFFexgcd on degrees %d and %d\n"
	.size	.L.str.1, 41


	.ident	"clang version 3.9.0 "
