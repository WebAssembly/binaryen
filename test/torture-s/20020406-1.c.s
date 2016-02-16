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
	i32.const	$push0=, 12
	i32.call	$push12=, malloc@FUNCTION, $pop0
	tee_local	$push11=, $1=, $pop12
	i32.const	$push1=, 0
	i32.store	$push2=, 8($pop11), $pop1
	i32.lt_s	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	i32.const	$push4=, 1
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, 4
	i32.call	$push7=, calloc@FUNCTION, $pop5, $pop6
	i32.store	$discard=, 0($pop9), $pop7
.LBB2_2:                                # %if.end
	end_block                       # label0:
	i32.store	$discard=, 0($1), $0
	i32.const	$push10=, -1
	i32.store	$discard=, 4($1), $pop10
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$12=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$12=, 0($10), $12
	i32.load	$8=, 4($2)
	i32.load	$7=, 4($3)
	i32.const	$push1=, 4
	i32.or  	$6=, $12, $pop1
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.store	$discard=, 0($6), $7
	i32.store	$discard=, 0($12):p2align=4, $8
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.const	$push21=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop21, $12
	i32.load	$7=, 4($3)
	i32.load	$8=, 4($5)
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.lt_s	$push2=, $7, $8
	br_if   	0, $pop2        # 0: up to label1
# BB#2:                                 # %if.end
	end_loop                        # label2:
	block
	i32.const	$push3=, 2
	i32.ne  	$push4=, $7, $pop3
	br_if   	0, $pop4        # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push5=, 1
	i32.ne  	$push6=, $8, $pop5
	br_if   	0, $pop6        # 0: down to label3
# BB#4:                                 # %if.end11
	block
	i32.load	$push7=, 8($3)
	i32.load	$push8=, 0($pop7)
	i32.const	$push29=, 0
	i32.eq  	$push30=, $pop8, $pop29
	br_if   	0, $pop30       # 0: down to label4
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push9=, 12
	i32.call	$push27=, malloc@FUNCTION, $pop9
	tee_local	$push26=, $8=, $pop27
	i32.const	$push10=, 2
	i32.const	$push25=, 4
	i32.call	$push11=, calloc@FUNCTION, $pop10, $pop25
	i32.store	$push12=, 8($pop26), $pop11
	i32.const	$push13=, 1
	i32.store	$push14=, 0($8), $pop13
	i32.store	$2=, 0($pop12), $pop14
	i32.const	$push15=, 0
	i32.store	$discard=, 4($8), $pop15
	i32.const	$push24=, 12
	i32.call	$7=, malloc@FUNCTION, $pop24
	i32.const	$push16=, 3
	i32.const	$push23=, 4
	i32.call	$0=, calloc@FUNCTION, $pop16, $pop23
	i64.const	$push17=, -4294967294
	i64.store	$discard=, 0($7):p2align=2, $pop17
	i32.const	$push22=, 4
	i32.add 	$push18=, $5, $pop22
	i32.load	$5=, 0($pop18)
	i32.store	$discard=, 8($7), $0
	block
	i32.lt_s	$push19=, $5, $2
	br_if   	0, $pop19       # 0: down to label5
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push28=, 4
	i32.add 	$push20=, $3, $pop28
	i32.load	$push0=, 0($pop20)
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
	i32.store	$discard=, 0($1), $8
	i32.store	$discard=, 0($4), $7
.LBB7_10:                               # %cleanup
	end_block                       # label4:
	i32.const	$11=, 16
	i32.add 	$12=, $12, $11
	i32.const	$11=, __stack_pointer
	i32.store	$12=, 0($11), $12
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.const	$push0=, 12
	i32.call	$0=, malloc@FUNCTION, $pop0
	i32.const	$push2=, 2
	i32.const	$push1=, 4
	i32.call	$push3=, calloc@FUNCTION, $pop2, $pop1
	i32.store	$push4=, 8($0), $pop3
	i32.const	$push5=, 1
	i32.store	$push6=, 0($0), $pop5
	i32.store	$push7=, 4($pop4), $pop6
	i32.store	$1=, 4($0), $pop7
	i32.const	$push20=, 12
	i32.call	$push19=, malloc@FUNCTION, $pop20
	tee_local	$push18=, $3=, $pop19
	i32.const	$push8=, 3
	i32.const	$push17=, 4
	i32.call	$push9=, calloc@FUNCTION, $pop8, $pop17
	i32.store	$push10=, 8($pop18), $pop9
	i32.store	$discard=, 8($pop10), $1
	i32.const	$push16=, 2
	i32.store	$push11=, 0($3), $pop16
	i32.store	$1=, 4($3), $pop11
	i32.load	$2=, 4($0)
	i32.const	$push15=, 4
	i32.or  	$push12=, $9, $pop15
	i32.store	$discard=, 0($pop12), $1
	i32.store	$discard=, 0($9):p2align=4, $2
	i32.const	$push13=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop13, $9
	i32.const	$7=, 12
	i32.add 	$7=, $9, $7
	i32.const	$8=, 8
	i32.add 	$8=, $9, $8
	i32.call	$discard=, DUPFFexgcd@FUNCTION, $7, $8, $0, $3
	i32.const	$push14=, 0
	i32.const	$6=, 16
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	return  	$pop14
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
