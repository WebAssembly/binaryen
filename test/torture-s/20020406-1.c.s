	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020406-1.c"
	.globl	FFmul
	.type	FFmul,@function
FFmul:                                  # @FFmul
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
func_end0:
	.size	FFmul, func_end0-FFmul

	.globl	DUPFFdeg
	.type	DUPFFdeg,@function
DUPFFdeg:                               # @DUPFFdeg
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($0)
	return  	$pop0
func_end1:
	.size	DUPFFdeg, func_end1-DUPFFdeg

	.globl	DUPFFnew
	.type	DUPFFnew,@function
DUPFFnew:                               # @DUPFFnew
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	BB2_2
	i32.const	$push0=, 12
	i32.call	$1=, malloc, $pop0
	i32.const	$push1=, 0
	i32.store	$push2=, 8($1), $pop1
	i32.lt_s	$push3=, $0, $pop2
	br_if   	$pop3, BB2_2
# BB#1:                                 # %if.then
	i32.const	$push4=, 1
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, 4
	i32.call	$2=, calloc, $pop5, $pop6
	i32.const	$push7=, 8
	i32.add 	$push8=, $1, $pop7
	i32.store	$discard=, 0($pop8), $2
BB2_2:                                  # %if.end
	i32.store	$discard=, 0($1), $0
	i32.const	$push9=, -1
	i32.store	$discard=, 4($1), $pop9
	return  	$1
func_end2:
	.size	DUPFFnew, func_end2-DUPFFnew

	.globl	DUPFFfree
	.type	DUPFFfree,@function
DUPFFfree:                              # @DUPFFfree
	.param  	i32
# BB#0:                                 # %entry
	return
func_end3:
	.size	DUPFFfree, func_end3-DUPFFfree

	.globl	DUPFFswap
	.type	DUPFFswap,@function
DUPFFswap:                              # @DUPFFswap
	.param  	i32, i32
# BB#0:                                 # %entry
	return
func_end4:
	.size	DUPFFswap, func_end4-DUPFFswap

	.globl	DUPFFcopy
	.type	DUPFFcopy,@function
DUPFFcopy:                              # @DUPFFcopy
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
func_end5:
	.size	DUPFFcopy, func_end5-DUPFFcopy

	.globl	DUPFFshift_add
	.type	DUPFFshift_add,@function
DUPFFshift_add:                         # @DUPFFshift_add
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	return
func_end6:
	.size	DUPFFshift_add, func_end6-DUPFFshift_add

	.globl	DUPFFexgcd
	.type	DUPFFexgcd,@function
DUPFFexgcd:                             # @DUPFFexgcd
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 16
	i32.sub 	$13=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$13=, 0($15), $13
	i32.load	$9=, 4($2)
	i32.load	$8=, 4($3)
BB7_1:                                  # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB7_2
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 8
	i32.sub 	$13=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$discard=, 0($13), $9
	i32.const	$6=, 4
	i32.add 	$9=, $13, $6
	i32.store	$discard=, 0($9), $8
	i32.const	$push1=, .str
	i32.call	$discard=, iprintf, $pop1
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 8
	i32.add 	$13=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$13=, 0($13), $13
	i32.load	$8=, 4($3)
	i32.load	$9=, 4($5)
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.lt_s	$push2=, $8, $9
	br_if   	$pop2, BB7_1
BB7_2:                                  # %if.end
	i32.const	$2=, 2
	block   	BB7_11
	i32.ne  	$push3=, $8, $2
	br_if   	$pop3, BB7_11
# BB#3:                                 # %if.end
	i32.const	$8=, 1
	i32.ne  	$push4=, $9, $8
	br_if   	$pop4, BB7_11
# BB#4:                                 # %if.end11
	block   	BB7_10
	i32.load	$push5=, 8($3)
	i32.load	$push6=, 0($pop5)
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop6, $pop15
	br_if   	$pop16, BB7_10
# BB#5:                                 # %DUPFFnew.exit
	i32.const	$0=, 12
	i32.call	$9=, malloc, $0
	i32.call	$7=, calloc, $2, $6
	i32.store	$push7=, 8($9), $7
	i32.store	$push8=, 0($9), $8
	i32.store	$7=, 0($pop7), $pop8
	i32.const	$push9=, 0
	i32.store	$discard=, 4($9), $pop9
	i32.call	$8=, malloc, $0
	i32.const	$push10=, 3
	i32.call	$0=, calloc, $pop10, $6
	i32.store	$discard=, 8($8), $0
	i32.store	$discard=, 0($8), $2
	block   	BB7_9
	i32.const	$push11=, -1
	i32.store	$discard=, 4($8), $pop11
	i32.add 	$push12=, $5, $6
	i32.load	$5=, 0($pop12)
	i32.lt_s	$push13=, $5, $7
	br_if   	$pop13, BB7_9
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.add 	$push14=, $3, $6
	i32.load	$push0=, 0($pop14)
	i32.lt_s	$3=, $pop0, $5
BB7_7:                                  # %while.cond40.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB7_8
	br_if   	$3, BB7_7
BB7_8:                                  # %while.cond40
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB7_9
	br      	BB7_8
BB7_9:                                  # %if.end57
	i32.store	$discard=, 0($1), $9
	i32.store	$discard=, 0($4), $8
BB7_10:                                 # %cleanup
	i32.const	$16=, 16
	i32.add 	$13=, $13, $16
	i32.const	$16=, __stack_pointer
	i32.store	$13=, 0($16), $13
	return  	$3
BB7_11:                                 # %if.then10
	call    	abort
	unreachable
func_end7:
	.size	DUPFFexgcd, func_end7-DUPFFexgcd

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$15=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$15=, 0($11), $15
	i32.const	$4=, 12
	i32.call	$0=, malloc, $4
	i32.const	$1=, 4
	i32.const	$2=, 2
	i32.call	$3=, calloc, $2, $1
	i32.store	$discard=, 8($0), $3
	i32.const	$push0=, 1
	i32.store	$push1=, 0($0), $pop0
	i32.store	$push2=, 4($3), $pop1
	i32.store	$3=, 4($0), $pop2
	i32.call	$4=, malloc, $4
	i32.const	$push3=, 3
	i32.call	$5=, calloc, $pop3, $1
	i32.store	$push4=, 8($4), $5
	i32.store	$discard=, 8($pop4), $3
	i32.store	$push5=, 0($4), $2
	i32.store	$2=, 4($4), $pop5
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 8
	i32.sub 	$15=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$15=, 0($7), $15
	i32.store	$discard=, 0($15), $3
	i32.add 	$1=, $15, $1
	i32.store	$discard=, 0($1), $2
	i32.const	$push6=, .str.1
	i32.call	$discard=, iprintf, $pop6
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 8
	i32.add 	$15=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$15=, 0($9), $15
	i32.const	$13=, 12
	i32.add 	$13=, $15, $13
	i32.const	$14=, 8
	i32.add 	$14=, $15, $14
	i32.call	$discard=, DUPFFexgcd, $13, $14, $0, $4
	i32.const	$push7=, 0
	i32.const	$12=, 16
	i32.add 	$15=, $15, $12
	i32.const	$12=, __stack_pointer
	i32.store	$15=, 0($12), $15
	return  	$pop7
func_end8:
	.size	main, func_end8-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"DUPFFexgcd called on degrees %d and %d\n"
	.size	.str, 40

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"calling DUPFFexgcd on degrees %d and %d\n"
	.size	.str.1, 41


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
