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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 16
	i32.sub 	$9=, $pop28, $pop29
	i32.const	$push30=, __stack_pointer
	i32.store	$discard=, 0($pop30), $9
	i32.load	$8=, 4($2)
	i32.load	$7=, 4($3)
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.store	$discard=, 4($9), $7
	i32.store	$discard=, 0($9), $8
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.const	$push19=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop19, $9
	i32.load	$7=, 4($3)
	i32.load	$8=, 4($5)
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.lt_s	$push1=, $7, $8
	br_if   	0, $pop1        # 0: up to label1
# BB#2:                                 # %if.end
	end_loop                        # label2:
	block
	i32.const	$push2=, 2
	i32.ne  	$push3=, $7, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push4=, 1
	i32.ne  	$push5=, $8, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#4:                                 # %if.end11
	block
	i32.load	$push6=, 8($3)
	i32.load	$push7=, 0($pop6)
	i32.const	$push34=, 0
	i32.eq  	$push35=, $pop7, $pop34
	br_if   	0, $pop35       # 0: down to label4
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push8=, 12
	i32.call	$push25=, malloc@FUNCTION, $pop8
	tee_local	$push24=, $2=, $pop25
	i32.const	$push9=, 2
	i32.const	$push23=, 4
	i32.call	$push10=, calloc@FUNCTION, $pop9, $pop23
	i32.store	$push11=, 8($pop24), $pop10
	i32.const	$push13=, 1
	i32.store	$0=, 0($pop11), $pop13
	i64.const	$push12=, 1
	i64.store	$discard=, 0($2):p2align=2, $pop12
	i32.const	$push22=, 12
	i32.call	$8=, malloc@FUNCTION, $pop22
	i32.const	$push14=, 3
	i32.const	$push21=, 4
	i32.call	$6=, calloc@FUNCTION, $pop14, $pop21
	i64.const	$push15=, -4294967294
	i64.store	$discard=, 0($8):p2align=2, $pop15
	i32.const	$push20=, 4
	i32.add 	$push16=, $5, $pop20
	i32.load	$7=, 0($pop16)
	i32.store	$discard=, 8($8), $6
	block
	i32.lt_s	$push17=, $7, $0
	br_if   	0, $pop17       # 0: down to label5
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push26=, 4
	i32.add 	$push18=, $3, $pop26
	i32.load	$push0=, 0($pop18)
	i32.lt_s	$3=, $pop0, $7
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
	i32.store	$discard=, 0($1), $2
	i32.store	$discard=, 0($4), $8
.LBB7_10:                               # %cleanup
	end_block                       # label4:
	i32.const	$push33=, __stack_pointer
	i32.const	$push31=, 16
	i32.add 	$push32=, $9, $pop31
	i32.store	$discard=, 0($pop33), $pop32
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, __stack_pointer
	i32.load	$push21=, 0($pop20)
	i32.const	$push22=, 16
	i32.sub 	$3=, $pop21, $pop22
	i32.const	$push23=, __stack_pointer
	i32.store	$discard=, 0($pop23), $3
	i32.const	$push0=, 12
	i32.call	$push19=, malloc@FUNCTION, $pop0
	tee_local	$push18=, $2=, $pop19
	i32.const	$push2=, 2
	i32.const	$push1=, 4
	i32.call	$push3=, calloc@FUNCTION, $pop2, $pop1
	i32.store	$push4=, 8($pop18), $pop3
	i32.const	$push6=, 1
	i32.store	$0=, 4($pop4), $pop6
	i64.const	$push5=, 4294967297
	i64.store	$discard=, 0($2):p2align=2, $pop5
	i32.const	$push17=, 12
	i32.call	$push16=, malloc@FUNCTION, $pop17
	tee_local	$push15=, $1=, $pop16
	i32.const	$push7=, 3
	i32.const	$push14=, 4
	i32.call	$push8=, calloc@FUNCTION, $pop7, $pop14
	i32.store	$push9=, 8($pop15), $pop8
	i32.store	$discard=, 8($pop9), $0
	i32.load	$0=, 4($2)
	i64.const	$push10=, 8589934594
	i64.store	$discard=, 0($1):p2align=2, $pop10
	i32.const	$push13=, 2
	i32.store	$discard=, 4($3), $pop13
	i32.store	$discard=, 0($3), $0
	i32.const	$push11=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop11, $3
	i32.const	$push27=, 12
	i32.add 	$push28=, $3, $pop27
	i32.const	$push29=, 8
	i32.add 	$push30=, $3, $pop29
	i32.call	$discard=, DUPFFexgcd@FUNCTION, $pop28, $pop30, $2, $1
	i32.const	$push12=, 0
	i32.const	$push26=, __stack_pointer
	i32.const	$push24=, 16
	i32.add 	$push25=, $3, $pop24
	i32.store	$discard=, 0($pop26), $pop25
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
