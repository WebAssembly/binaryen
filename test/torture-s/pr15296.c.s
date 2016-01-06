	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr15296.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.ge_s	$push1=, $3, $4
	br_if   	$pop1, BB0_2
BB0_1:                                  # %l0
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	br      	BB0_1
BB0_2:                                  # %if.end.split
	i32.const	$4=, 0
	block   	BB0_12
	block   	BB0_11
	block   	BB0_10
	block   	BB0_7
	i32.const	$push12=, 0
	i32.eq  	$push13=, $3, $pop12
	br_if   	$pop13, BB0_7
# BB#3:                                 # %if.end3
	copy_local	$4=, $5
	br_if   	$5, BB0_7
# BB#4:                                 # %if.end6
	block   	BB0_6
	i32.const	$push3=, 4
	i32.add 	$push4=, $1, $pop3
	i32.load	$push0=, 0($1)
	i32.load	$push2=, 0($pop0)
	i32.store	$push5=, 0($pop4), $pop2
	br_if   	$pop5, BB0_6
# BB#5:                                 # %if.end12
	i32.const	$push6=, 0
	i32.const	$push7=, -1
	i32.store	$discard=, 12($pop6), $pop7
	br      	BB0_10
BB0_6:                                  # %if.then11
	call    	g, $3, $3
	unreachable
BB0_7:                                  # %l3
	i32.const	$push8=, 4
	i32.add 	$push9=, $1, $pop8
	i32.store	$discard=, 0($pop9), $4
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.load	$3=, 0($pop11)
	br_if   	$3, BB0_12
# BB#8:                                 # %if.end19
	i32.const	$push14=, 0
	i32.eq  	$push15=, $4, $pop14
	br_if   	$pop15, BB0_11
# BB#9:                                 # %if.end24
	i32.store	$discard=, 8($4), $3
BB0_10:                                 # %l4
	return
BB0_11:                                 # %if.then23
	call    	g, $3, $3
	unreachable
BB0_12:                                 # %if.then18
	call    	g, $3, $3
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort
	unreachable
func_end1:
	.size	g, func_end1-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 48
	i32.sub 	$16=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$16=, 0($7), $16
	i32.const	$0=, 0
	i32.const	$push2=, 16
	i32.const	$8=, 8
	i32.add 	$8=, $16, $8
	i32.add 	$3=, $8, $pop2
	i32.load	$push3=, main.s+16($0)
	i32.store	$discard=, 0($3), $pop3
	i32.const	$4=, 4
	i32.const	$1=, 8
	i32.const	$9=, 32
	i32.add 	$9=, $16, $9
	i32.or  	$2=, $9, $1
	i64.load	$push0=, main.uv+8($0)
	i64.store	$discard=, 0($2), $pop0
	i64.load	$push1=, main.uv($0)
	i64.store	$discard=, 32($16), $pop1
	i64.const	$5=, 32
	i32.const	$10=, 8
	i32.add 	$10=, $16, $10
	i32.add 	$1=, $10, $1
	i32.const	$push4=, main.s+8
	i32.add 	$push5=, $pop4, $4
	i64.load32_u	$push6=, 0($pop5)
	i64.shl 	$push7=, $pop6, $5
	i64.load32_u	$push8=, main.s+8($0)
	i64.or  	$push9=, $pop7, $pop8
	i64.store	$discard=, 0($1), $pop9
	i32.const	$push10=, main.s
	i32.add 	$push11=, $pop10, $4
	i64.load32_u	$push12=, 0($pop11)
	i64.shl 	$push13=, $pop12, $5
	i64.load32_u	$push14=, main.s($0)
	i64.or  	$push15=, $pop13, $pop14
	i64.store	$discard=, 8($16), $pop15
	i32.const	$push17=, 20000
	i32.const	$push16=, 10000
	i32.const	$11=, 8
	i32.add 	$11=, $16, $11
	i32.const	$12=, 32
	i32.add 	$12=, $16, $12
	call    	f, $0, $11, $0, $pop17, $pop16, $12
	i32.const	$13=, 8
	i32.add 	$13=, $16, $13
	i32.or  	$push18=, $13, $4
	i32.load	$push19=, 0($pop18)
	i32.const	$14=, 32
	i32.add 	$14=, $16, $14
	block   	BB2_7
	i32.ne  	$push20=, $pop19, $14
	br_if   	$pop20, BB2_7
# BB#1:                                 # %lor.lhs.false
	i32.load	$push21=, 0($1)
	br_if   	$pop21, BB2_7
# BB#2:                                 # %lor.lhs.false6
	i32.const	$push22=, 12
	i32.const	$15=, 8
	i32.add 	$15=, $16, $15
	i32.add 	$push23=, $15, $pop22
	i32.load	$push24=, 0($pop23)
	i32.const	$push25=, 999
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, BB2_7
# BB#3:                                 # %lor.lhs.false11
	i32.load	$push27=, 0($3)
	i32.const	$push28=, 777
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	$pop29, BB2_7
# BB#4:                                 # %lor.lhs.false16
	i64.load	$push30=, 32($16)
	i64.const	$push31=, 953482739823
	i64.ne  	$push32=, $pop30, $pop31
	br_if   	$pop32, BB2_7
# BB#5:                                 # %lor.lhs.false24
	i64.load	$push33=, 0($2)
	i64.const	$push34=, 1906965479424
	i64.ne  	$push35=, $pop33, $pop34
	br_if   	$pop35, BB2_7
# BB#6:                                 # %if.end
	call    	exit, $0
	unreachable
BB2_7:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	main.uv,@object         # @main.uv
	.section	.rodata.cst16,"aM",@progbits,16
	.align	4
main.uv:
	.int32	111                     # 0x6f
	.int32	222                     # 0xde
	.int32	333                     # 0x14d
	.int32	444                     # 0x1bc
	.size	main.uv, 16

	.type	main.s,@object          # @main.s
	.section	.rodata,"a",@progbits
	.align	2
main.s:
	.int32	0
	.int32	555                     # 0x22b
	.zero	4
	.int32	999                     # 0x3e7
	.int32	777                     # 0x309
	.size	main.s, 20


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
