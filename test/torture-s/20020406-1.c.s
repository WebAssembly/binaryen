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
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
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
                                        # fallthrough-return: $pop0
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
	i32.call	$push12=, malloc@FUNCTION, $pop1
	tee_local	$push11=, $1=, $pop12
	i32.const	$push2=, 0
	i32.store	$push0=, 8($pop11), $pop2
	i32.lt_s	$push3=, $0, $pop0
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push4=, 8
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, 1
	i32.add 	$push7=, $0, $pop6
	i32.const	$push8=, 4
	i32.call	$push9=, calloc@FUNCTION, $pop7, $pop8
	i32.store	$drop=, 0($pop5), $pop9
.LBB2_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push10=, -1
	i32.store	$drop=, 4($1), $pop10
	i32.store	$drop=, 0($1), $0
	copy_local	$push13=, $1
                                        # fallthrough-return: $pop13
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
                                        # fallthrough-return
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
                                        # fallthrough-return
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
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
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
                                        # fallthrough-return
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
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop20, $pop21
	i32.store	$4=, __stack_pointer($pop22), $pop26
	i32.load	$7=, 4($3)
	i32.load	$8=, 4($2)
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$6=, $3
	copy_local	$3=, $2
	copy_local	$5=, $1
	copy_local	$1=, $0
	i32.store	$drop=, 4($4), $7
	i32.store	$drop=, 0($4), $8
	i32.const	$push31=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop31, $4
	copy_local	$0=, $5
	copy_local	$2=, $6
	i32.load	$push30=, 4($3)
	tee_local	$push29=, $7=, $pop30
	i32.load	$push28=, 4($6)
	tee_local	$push27=, $8=, $pop28
	i32.lt_s	$push2=, $pop29, $pop27
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
	i32.eqz 	$push41=, $pop8
	br_if   	0, $pop41       # 0: down to label4
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push9=, 12
	i32.call	$push39=, malloc@FUNCTION, $pop9
	tee_local	$push38=, $7=, $pop39
	i32.const	$push10=, 2
	i32.const	$push37=, 4
	i32.call	$push11=, calloc@FUNCTION, $pop10, $pop37
	i32.store	$push0=, 8($pop38), $pop11
	i32.const	$push12=, 1
	i32.store	$8=, 0($pop0), $pop12
	i64.const	$push13=, 1
	i64.store	$drop=, 0($7):p2align=2, $pop13
	i32.const	$push36=, 12
	i32.call	$2=, malloc@FUNCTION, $pop36
	i32.const	$push14=, 3
	i32.const	$push35=, 4
	i32.call	$0=, calloc@FUNCTION, $pop14, $pop35
	i64.const	$push15=, -4294967294
	i64.store	$drop=, 0($2):p2align=2, $pop15
	i32.store	$drop=, 8($2), $0
	block
	i32.const	$push34=, 4
	i32.add 	$push16=, $6, $pop34
	i32.load	$push33=, 0($pop16)
	tee_local	$push32=, $6=, $pop33
	i32.lt_s	$push17=, $pop32, $8
	br_if   	0, $pop17       # 0: down to label5
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push40=, 4
	i32.add 	$push18=, $3, $pop40
	i32.load	$push1=, 0($pop18)
	i32.lt_s	$3=, $pop1, $6
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
	i32.store	$drop=, 0($1), $7
	i32.store	$drop=, 0($5), $2
.LBB7_10:                               # %cleanup
	end_block                       # label4:
	i32.const	$push25=, 0
	i32.const	$push23=, 16
	i32.add 	$push24=, $4, $pop23
	i32.store	$drop=, __stack_pointer($pop25), $pop24
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
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 16
	i32.sub 	$push24=, $pop14, $pop15
	i32.store	$1=, __stack_pointer($pop16), $pop24
	i32.const	$push2=, 12
	i32.call	$push31=, malloc@FUNCTION, $pop2
	tee_local	$push30=, $2=, $pop31
	i32.const	$push4=, 2
	i32.const	$push3=, 4
	i32.call	$push5=, calloc@FUNCTION, $pop4, $pop3
	i32.store	$push0=, 8($pop30), $pop5
	i32.const	$push6=, 1
	i32.store	$0=, 4($pop0), $pop6
	i64.const	$push7=, 4294967297
	i64.store	$drop=, 0($2):p2align=2, $pop7
	i32.const	$push29=, 12
	i32.call	$push28=, malloc@FUNCTION, $pop29
	tee_local	$push27=, $3=, $pop28
	i32.const	$push8=, 3
	i32.const	$push26=, 4
	i32.call	$push9=, calloc@FUNCTION, $pop8, $pop26
	i32.store	$push1=, 8($pop27), $pop9
	i32.store	$drop=, 8($pop1), $0
	i64.const	$push10=, 8589934594
	i64.store	$drop=, 0($3):p2align=2, $pop10
	i32.load	$0=, 4($2)
	i32.const	$push25=, 2
	i32.store	$drop=, 4($1), $pop25
	i32.store	$drop=, 0($1), $0
	i32.const	$push11=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop11, $1
	i32.const	$push20=, 12
	i32.add 	$push21=, $1, $pop20
	i32.const	$push22=, 8
	i32.add 	$push23=, $1, $pop22
	i32.call	$drop=, DUPFFexgcd@FUNCTION, $pop21, $pop23, $2, $3
	i32.const	$push19=, 0
	i32.const	$push17=, 16
	i32.add 	$push18=, $1, $pop17
	i32.store	$drop=, __stack_pointer($pop19), $pop18
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
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
	.functype	malloc, i32, i32
	.functype	calloc, i32, i32, i32
	.functype	printf, i32, i32
	.functype	abort, void
