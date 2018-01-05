	.text
	.file	"20020406-1.c"
	.section	.text.FFmul,"ax",@progbits
	.hidden	FFmul                   # -- Begin function FFmul
	.globl	FFmul
	.type	FFmul,@function
FFmul:                                  # @FFmul
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	FFmul, .Lfunc_end0-FFmul
                                        # -- End function
	.section	.text.DUPFFdeg,"ax",@progbits
	.hidden	DUPFFdeg                # -- Begin function DUPFFdeg
	.globl	DUPFFdeg
	.type	DUPFFdeg,@function
DUPFFdeg:                               # @DUPFFdeg
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 4($0)
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	DUPFFdeg, .Lfunc_end1-DUPFFdeg
                                        # -- End function
	.section	.text.DUPFFnew,"ax",@progbits
	.hidden	DUPFFnew                # -- Begin function DUPFFnew
	.globl	DUPFFnew
	.type	DUPFFnew,@function
DUPFFnew:                               # @DUPFFnew
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.call	$1=, malloc@FUNCTION, $pop0
	i32.const	$push1=, 0
	i32.store	8($1), $pop1
	block   	
	i32.const	$push10=, 0
	i32.lt_s	$push2=, $0, $pop10
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push3=, 8
	i32.add 	$push4=, $1, $pop3
	i32.const	$push5=, 1
	i32.add 	$push6=, $0, $pop5
	i32.const	$push7=, 4
	i32.call	$push8=, calloc@FUNCTION, $pop6, $pop7
	i32.store	0($pop4), $pop8
.LBB2_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push9=, -1
	i32.store	4($1), $pop9
	i32.store	0($1), $0
	copy_local	$push11=, $1
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end2:
	.size	DUPFFnew, .Lfunc_end2-DUPFFnew
                                        # -- End function
	.section	.text.DUPFFfree,"ax",@progbits
	.hidden	DUPFFfree               # -- Begin function DUPFFfree
	.globl	DUPFFfree
	.type	DUPFFfree,@function
DUPFFfree:                              # @DUPFFfree
	.param  	i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	DUPFFfree, .Lfunc_end3-DUPFFfree
                                        # -- End function
	.section	.text.DUPFFswap,"ax",@progbits
	.hidden	DUPFFswap               # -- Begin function DUPFFswap
	.globl	DUPFFswap
	.type	DUPFFswap,@function
DUPFFswap:                              # @DUPFFswap
	.param  	i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	DUPFFswap, .Lfunc_end4-DUPFFswap
                                        # -- End function
	.section	.text.DUPFFcopy,"ax",@progbits
	.hidden	DUPFFcopy               # -- Begin function DUPFFcopy
	.globl	DUPFFcopy
	.type	DUPFFcopy,@function
DUPFFcopy:                              # @DUPFFcopy
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	DUPFFcopy, .Lfunc_end5-DUPFFcopy
                                        # -- End function
	.section	.text.DUPFFshift_add,"ax",@progbits
	.hidden	DUPFFshift_add          # -- Begin function DUPFFshift_add
	.globl	DUPFFshift_add
	.type	DUPFFshift_add,@function
DUPFFshift_add:                         # @DUPFFshift_add
	.param  	i32, i32, i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	DUPFFshift_add, .Lfunc_end6-DUPFFshift_add
                                        # -- End function
	.section	.text.DUPFFexgcd,"ax",@progbits
	.hidden	DUPFFexgcd              # -- Begin function DUPFFexgcd
	.globl	DUPFFexgcd
	.type	DUPFFexgcd,@function
DUPFFexgcd:                             # @DUPFFexgcd
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 16
	i32.sub 	$8=, $pop17, $pop19
	i32.const	$push20=, 0
	i32.store	__stack_pointer($pop20), $8
	i32.load	$6=, 4($3)
	i32.load	$7=, 4($2)
.LBB7_1:                                # %tailrecurse
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	copy_local	$5=, $3
	copy_local	$3=, $2
	copy_local	$4=, $1
	copy_local	$1=, $0
	i32.store	4($8), $6
	i32.store	0($8), $7
	i32.const	$push24=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop24, $8
	i32.load	$7=, 4($5)
	i32.load	$6=, 4($3)
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.lt_s	$push1=, $6, $7
	br_if   	0, $pop1        # 0: up to label1
# %bb.2:                                # %if.end
	end_loop
	block   	
	i32.const	$push2=, 2
	i32.ne  	$push3=, $6, $pop2
	br_if   	0, $pop3        # 0: down to label2
# %bb.3:                                # %if.end
	i32.const	$push4=, 1
	i32.ne  	$push5=, $7, $pop4
	br_if   	0, $pop5        # 0: down to label2
# %bb.4:                                # %if.end11
	block   	
	i32.load	$push6=, 8($3)
	i32.load	$push7=, 0($pop6)
	i32.eqz 	$push31=, $pop7
	br_if   	0, $pop31       # 0: down to label3
# %bb.5:                                # %DUPFFnew.exit
	i32.const	$push8=, 12
	i32.call	$6=, malloc@FUNCTION, $pop8
	i32.const	$push9=, 2
	i32.const	$push29=, 4
	i32.call	$7=, calloc@FUNCTION, $pop9, $pop29
	i32.store	8($6), $7
	i32.const	$push10=, 1
	i32.store	0($7), $pop10
	i64.const	$push11=, 1
	i64.store	0($6):p2align=2, $pop11
	i32.const	$push28=, 12
	i32.call	$7=, malloc@FUNCTION, $pop28
	i32.const	$push12=, 3
	i32.const	$push27=, 4
	i32.call	$2=, calloc@FUNCTION, $pop12, $pop27
	i64.const	$push13=, -4294967294
	i64.store	0($7):p2align=2, $pop13
	i32.store	8($7), $2
	i32.const	$push26=, 4
	i32.add 	$push14=, $5, $pop26
	i32.load	$5=, 0($pop14)
	block   	
	i32.const	$push25=, 1
	i32.lt_s	$push15=, $5, $pop25
	br_if   	0, $pop15       # 0: down to label4
# %bb.6:                                # %while.body.lr.ph
	i32.const	$push30=, 4
	i32.add 	$push16=, $3, $pop30
	i32.load	$push0=, 0($pop16)
	i32.lt_s	$3=, $pop0, $5
.LBB7_7:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	br_if   	0, $3           # 0: up to label5
.LBB7_8:                                # %while.cond40
                                        # =>This Inner Loop Header: Depth=1
	end_loop
	loop    	                # label6:
	br      	0               # 0: up to label6
.LBB7_9:                                # %if.end57
	end_loop
	end_block                       # label4:
	i32.store	0($1), $6
	i32.store	0($4), $7
.LBB7_10:                               # %cleanup
	end_block                       # label3:
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $8, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return  	$3
.LBB7_11:                               # %if.then10
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	DUPFFexgcd, .Lfunc_end7-DUPFFexgcd
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$3=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $3
	i32.const	$push0=, 12
	i32.call	$0=, malloc@FUNCTION, $pop0
	i32.const	$push2=, 2
	i32.const	$push1=, 4
	i32.call	$1=, calloc@FUNCTION, $pop2, $pop1
	i32.store	8($0), $1
	i32.const	$push3=, 1
	i32.store	4($1), $pop3
	i64.const	$push4=, 4294967297
	i64.store	0($0):p2align=2, $pop4
	i32.const	$push23=, 12
	i32.call	$1=, malloc@FUNCTION, $pop23
	i32.const	$push5=, 3
	i32.const	$push22=, 4
	i32.call	$2=, calloc@FUNCTION, $pop5, $pop22
	i32.store	8($1), $2
	i32.const	$push21=, 1
	i32.store	8($2), $pop21
	i64.const	$push6=, 8589934594
	i64.store	0($1):p2align=2, $pop6
	i64.const	$push7=, 8589934593
	i64.store	0($3), $pop7
	i32.const	$push8=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop8, $3
	i32.const	$push17=, 12
	i32.add 	$push18=, $3, $pop17
	i32.const	$push19=, 8
	i32.add 	$push20=, $3, $pop19
	i32.call	$drop=, DUPFFexgcd@FUNCTION, $pop18, $pop20, $0, $1
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $3, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"DUPFFexgcd called on degrees %d and %d\n"
	.size	.L.str, 40

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"calling DUPFFexgcd on degrees %d and %d\n"
	.size	.L.str.1, 41


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	malloc, i32, i32
	.functype	calloc, i32, i32, i32
	.functype	printf, i32, i32
	.functype	abort, void
