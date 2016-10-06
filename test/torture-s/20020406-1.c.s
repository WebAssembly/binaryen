	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020406-1.c"
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
	i32.const	$push0=, 12
	i32.call	$push12=, malloc@FUNCTION, $pop0
	tee_local	$push11=, $1=, $pop12
	i32.const	$push1=, 0
	i32.store	8($pop11), $pop1
	block   	
	i32.const	$push10=, 0
	i32.lt_s	$push2=, $0, $pop10
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
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
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push25=, $pop18, $pop19
	tee_local	$push24=, $8=, $pop25
	i32.store	__stack_pointer($pop20), $pop24
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
	i32.const	$push30=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop30, $8
	copy_local	$0=, $4
	copy_local	$2=, $5
	i32.load	$push29=, 4($3)
	tee_local	$push28=, $6=, $pop29
	i32.load	$push27=, 4($5)
	tee_local	$push26=, $7=, $pop27
	i32.lt_s	$push1=, $pop28, $pop26
	br_if   	0, $pop1        # 0: up to label1
# BB#2:                                 # %if.end
	end_loop
	block   	
	i32.const	$push2=, 2
	i32.ne  	$push3=, $6, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push4=, 1
	i32.ne  	$push5=, $7, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#4:                                 # %if.end11
	block   	
	i32.load	$push6=, 8($3)
	i32.load	$push7=, 0($pop6)
	i32.eqz 	$push43=, $pop7
	br_if   	0, $pop43       # 0: down to label3
# BB#5:                                 # %DUPFFnew.exit167
	i32.const	$push8=, 12
	i32.call	$push41=, malloc@FUNCTION, $pop8
	tee_local	$push40=, $6=, $pop41
	i32.const	$push9=, 2
	i32.const	$push39=, 4
	i32.call	$push38=, calloc@FUNCTION, $pop9, $pop39
	tee_local	$push37=, $2=, $pop38
	i32.store	8($pop40), $pop37
	i32.const	$push10=, 1
	i32.store	0($2), $pop10
	i64.const	$push11=, 1
	i64.store	0($6):p2align=2, $pop11
	i32.const	$push36=, 12
	i32.call	$2=, malloc@FUNCTION, $pop36
	i32.const	$push12=, 3
	i32.const	$push35=, 4
	i32.call	$7=, calloc@FUNCTION, $pop12, $pop35
	i64.const	$push13=, -4294967294
	i64.store	0($2):p2align=2, $pop13
	i32.store	8($2), $7
	block   	
	i32.const	$push34=, 4
	i32.add 	$push14=, $5, $pop34
	i32.load	$push33=, 0($pop14)
	tee_local	$push32=, $5=, $pop33
	i32.const	$push31=, 1
	i32.lt_s	$push15=, $pop32, $pop31
	br_if   	0, $pop15       # 0: down to label4
# BB#6:                                 # %while.cond40.preheader.lr.ph
	i32.const	$push42=, 4
	i32.add 	$push16=, $3, $pop42
	i32.load	$push0=, 0($pop16)
	i32.lt_s	$3=, $pop0, $5
.LBB7_7:                                # %while.cond40.preheader
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
	i32.store	0($4), $2
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push33=, $pop10, $pop11
	tee_local	$push32=, $3=, $pop33
	i32.store	__stack_pointer($pop12), $pop32
	i32.const	$push0=, 12
	i32.call	$push31=, malloc@FUNCTION, $pop0
	tee_local	$push30=, $0=, $pop31
	i32.const	$push2=, 2
	i32.const	$push1=, 4
	i32.call	$push29=, calloc@FUNCTION, $pop2, $pop1
	tee_local	$push28=, $1=, $pop29
	i32.store	8($pop30), $pop28
	i32.const	$push3=, 1
	i32.store	4($1), $pop3
	i64.const	$push4=, 4294967297
	i64.store	0($0):p2align=2, $pop4
	i32.const	$push27=, 12
	i32.call	$push26=, malloc@FUNCTION, $pop27
	tee_local	$push25=, $1=, $pop26
	i32.const	$push5=, 3
	i32.const	$push24=, 4
	i32.call	$push23=, calloc@FUNCTION, $pop5, $pop24
	tee_local	$push22=, $2=, $pop23
	i32.store	8($pop25), $pop22
	i32.const	$push21=, 1
	i32.store	8($2), $pop21
	i64.const	$push6=, 8589934594
	i64.store	0($1):p2align=2, $pop6
	i32.load	$2=, 4($0)
	i32.const	$push20=, 2
	i32.store	4($3), $pop20
	i32.store	0($3), $2
	i32.const	$push7=, .L.str.1
	i32.call	$drop=, printf@FUNCTION, $pop7, $3
	i32.const	$push16=, 12
	i32.add 	$push17=, $3, $pop16
	i32.const	$push18=, 8
	i32.add 	$push19=, $3, $pop18
	i32.call	$drop=, DUPFFexgcd@FUNCTION, $pop17, $pop19, $0, $1
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $3, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	malloc, i32, i32
	.functype	calloc, i32, i32, i32
	.functype	printf, i32, i32
	.functype	abort, void
