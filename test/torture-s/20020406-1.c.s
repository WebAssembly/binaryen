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
	i32.const	$push2=, 4
	i32.or  	$6=, $12, $pop2
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.store	$discard=, 0($6), $7
	i32.store	$discard=, 0($12):p2align=4, $8
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.const	$push22=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop22, $12
	i32.load	$7=, 4($3)
	i32.load	$8=, 4($5)
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.lt_s	$push3=, $7, $8
	br_if   	0, $pop3        # 0: up to label1
# BB#2:                                 # %if.end
	end_loop                        # label2:
	block
	i32.const	$push4=, 2
	i32.ne  	$push5=, $7, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push6=, 1
	i32.ne  	$push7=, $8, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#4:                                 # %if.end11
	block
	i32.load	$push8=, 8($3)
	i32.load	$push9=, 0($pop8)
	i32.const	$push29=, 0
	i32.eq  	$push30=, $pop9, $pop29
	br_if   	0, $pop30       # 0: down to label4
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push10=, 12
	i32.call	$push0=, malloc@FUNCTION, $pop10
	tee_local	$push27=, $8=, $pop0
	i32.const	$push11=, 2
	i32.const	$push26=, 4
	i32.call	$push12=, calloc@FUNCTION, $pop11, $pop26
	i32.store	$push13=, 8($pop27), $pop12
	i32.const	$push14=, 1
	i32.store	$push15=, 0($8), $pop14
	i32.store	$2=, 0($pop13), $pop15
	i32.const	$push16=, 0
	i32.store	$discard=, 4($8), $pop16
	i32.const	$push25=, 12
	i32.call	$7=, malloc@FUNCTION, $pop25
	i32.const	$push17=, 3
	i32.const	$push24=, 4
	i32.call	$0=, calloc@FUNCTION, $pop17, $pop24
	i64.const	$push18=, -4294967294
	i64.store	$discard=, 0($7):p2align=2, $pop18
	i32.const	$push23=, 4
	i32.add 	$push19=, $5, $pop23
	i32.load	$5=, 0($pop19)
	i32.store	$discard=, 8($7), $0
	block
	i32.lt_s	$push20=, $5, $2
	br_if   	0, $pop20       # 0: down to label5
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push28=, 4
	i32.add 	$push21=, $3, $pop28
	i32.load	$push1=, 0($pop21)
	i32.lt_s	$3=, $pop1, $5
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
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
	i32.const	$push21=, 12
	i32.call	$push8=, malloc@FUNCTION, $pop21
	tee_local	$push20=, $2=, $pop8
	i32.const	$push9=, 3
	i32.const	$push19=, 4
	i32.call	$push10=, calloc@FUNCTION, $pop9, $pop19
	i32.store	$push11=, 8($pop20), $pop10
	i32.store	$discard=, 8($pop11), $1
	i32.const	$push18=, 4
	i32.or  	$push14=, $8, $pop18
	i32.const	$push17=, 2
	i32.store	$push12=, 0($2), $pop17
	i32.store	$push13=, 4($2), $pop12
	i32.store	$discard=, 0($pop14), $pop13
	i32.store	$discard=, 0($8):p2align=4, $1
	i32.const	$push15=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop15, $8
	i32.const	$6=, 12
	i32.add 	$6=, $8, $6
	i32.const	$7=, 8
	i32.add 	$7=, $8, $7
	i32.call	$discard=, DUPFFexgcd@FUNCTION, $6, $7, $0, $2
	i32.const	$push16=, 0
	i32.const	$5=, 16
	i32.add 	$8=, $8, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	return  	$pop16
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
