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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 16
	i32.sub 	$8=, $pop29, $pop30
	i32.const	$push31=, __stack_pointer
	i32.store	$discard=, 0($pop31), $8
	i32.load	$7=, 4($2)
	i32.load	$6=, 4($3)
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.store	$discard=, 4($8), $6
	i32.store	$discard=, 0($8):p2align=4, $7
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.const	$push20=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop20, $8
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
	i32.const	$push35=, 0
	i32.eq  	$push36=, $pop7, $pop35
	br_if   	0, $pop36       # 0: down to label4
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push8=, 12
	i32.call	$push26=, malloc@FUNCTION, $pop8
	tee_local	$push25=, $7=, $pop26
	i32.const	$push9=, 2
	i32.const	$push24=, 4
	i32.call	$push10=, calloc@FUNCTION, $pop9, $pop24
	i32.store	$push11=, 8($pop25), $pop10
	i32.const	$push12=, 1
	i32.store	$push13=, 0($7), $pop12
	i32.store	$2=, 0($pop11), $pop13
	i32.const	$push14=, 0
	i32.store	$discard=, 4($7), $pop14
	i32.const	$push23=, 12
	i32.call	$6=, malloc@FUNCTION, $pop23
	i32.const	$push15=, 3
	i32.const	$push22=, 4
	i32.call	$0=, calloc@FUNCTION, $pop15, $pop22
	i64.const	$push16=, -4294967294
	i64.store	$discard=, 0($6):p2align=2, $pop16
	i32.const	$push21=, 4
	i32.add 	$push17=, $5, $pop21
	i32.load	$5=, 0($pop17)
	i32.store	$discard=, 8($6), $0
	block
	i32.lt_s	$push18=, $5, $2
	br_if   	0, $pop18       # 0: down to label5
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push27=, 4
	i32.add 	$push19=, $3, $pop27
	i32.load	$push0=, 0($pop19)
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
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 16
	i32.add 	$push33=, $8, $pop32
	i32.store	$discard=, 0($pop34), $pop33
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.load	$push20=, 0($pop19)
	i32.const	$push21=, 16
	i32.sub 	$4=, $pop20, $pop21
	i32.const	$push22=, __stack_pointer
	i32.store	$discard=, 0($pop22), $4
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
	i32.const	$push18=, 12
	i32.call	$push17=, malloc@FUNCTION, $pop18
	tee_local	$push16=, $3=, $pop17
	i32.const	$push8=, 3
	i32.const	$push15=, 4
	i32.call	$push9=, calloc@FUNCTION, $pop8, $pop15
	i32.store	$push10=, 8($pop16), $pop9
	i32.store	$discard=, 8($pop10), $1
	i32.const	$push14=, 2
	i32.store	$1=, 0($3), $pop14
	i32.load	$2=, 4($0)
	i32.store	$push11=, 4($3), $1
	i32.store	$discard=, 4($4), $pop11
	i32.store	$discard=, 0($4):p2align=4, $2
	i32.const	$push12=, .L.str.1
	i32.call	$discard=, printf@FUNCTION, $pop12, $4
	i32.const	$push26=, 12
	i32.add 	$push27=, $4, $pop26
	i32.const	$push28=, 8
	i32.add 	$push29=, $4, $pop28
	i32.call	$discard=, DUPFFexgcd@FUNCTION, $pop27, $pop29, $0, $3
	i32.const	$push13=, 0
	i32.const	$push25=, __stack_pointer
	i32.const	$push23=, 16
	i32.add 	$push24=, $4, $pop23
	i32.store	$discard=, 0($pop25), $pop24
	return  	$pop13
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
