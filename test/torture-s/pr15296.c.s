	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr15296.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.ge_s	$push1=, $3, $4
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %l0
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	br      	0               # 0: up to label1
.LBB0_2:                                # %if.end.split
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$4=, 0
	block
	block
	block
	block
	block
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $3, $pop12
	br_if   	0, $pop13       # 0: down to label8
# BB#3:                                 # %if.end3
	copy_local	$4=, $5
	i32.const	$push14=, 0
	i32.eq  	$push15=, $5, $pop14
	br_if   	1, $pop15       # 1: down to label7
.LBB0_4:                                # %l3
	end_block                       # label8:
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.load	$3=, 0($pop11)
	i32.const	$push8=, 4
	i32.add 	$push9=, $1, $pop8
	i32.store	$1=, 0($pop9), $4
	br_if   	2, $3           # 2: down to label5
# BB#5:                                 # %if.end19
	i32.const	$push16=, 0
	i32.eq  	$push17=, $1, $pop16
	br_if   	3, $pop17       # 3: down to label4
# BB#6:                                 # %if.end24
	i32.store	$discard=, 8($1), $3
	br      	1               # 1: down to label6
.LBB0_7:                                # %if.end6
	end_block                       # label7:
	i32.const	$push3=, 4
	i32.add 	$push4=, $1, $pop3
	i32.load	$push0=, 0($1)
	i32.load	$push2=, 0($pop0)
	i32.store	$push5=, 0($pop4), $pop2
	br_if   	3, $pop5        # 3: down to label3
# BB#8:                                 # %if.end12
	i32.const	$push6=, 0
	i32.const	$push7=, -1
	i32.store	$discard=, 12($pop6), $pop7
.LBB0_9:                                # %l4
	end_block                       # label6:
	return
.LBB0_10:                               # %if.then18
	end_block                       # label5:
	call    	g@FUNCTION, $3, $3
	unreachable
.LBB0_11:                               # %if.then23
	end_block                       # label4:
	call    	g@FUNCTION, $3, $3
	unreachable
.LBB0_12:                               # %if.then11
	end_block                       # label3:
	call    	g@FUNCTION, $3, $3
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$13=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$13=, 0($2), $13
	i32.const	$push5=, 16
	i32.const	$3=, 8
	i32.add 	$3=, $13, $3
	i32.add 	$push6=, $3, $pop5
	i32.const	$push0=, 0
	i32.load	$push7=, .Lmain.s+16($pop0)
	i32.store	$discard=, 0($pop6):p2align=3, $pop7
	i32.const	$push2=, 8
	i32.const	$4=, 32
	i32.add 	$4=, $13, $4
	i32.or  	$push3=, $4, $pop2
	i32.const	$push43=, 0
	i64.load	$push1=, .Lmain.uv+8($pop43)
	i64.store	$discard=, 0($pop3), $pop1
	i32.const	$push42=, 0
	i64.load	$push4=, .Lmain.uv($pop42):p2align=4
	i64.store	$discard=, 32($13):p2align=4, $pop4
	i32.const	$push41=, 8
	i32.const	$5=, 8
	i32.add 	$5=, $13, $5
	i32.add 	$push40=, $5, $pop41
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 0
	i64.load	$push8=, .Lmain.s+8($pop38):p2align=2
	i64.store	$discard=, 0($pop39), $pop8
	i32.const	$push37=, 0
	i64.load	$push9=, .Lmain.s($pop37):p2align=2
	i64.store	$discard=, 8($13), $pop9
	i32.const	$push36=, 0
	i32.const	$push13=, 20000
	i32.const	$push12=, 10000
	i32.const	$6=, 8
	i32.add 	$6=, $13, $6
	i32.const	$7=, 32
	i32.add 	$7=, $13, $7
	call    	f@FUNCTION, $pop36, $6, $0, $pop13, $pop12, $7
	i32.const	$push10=, 4
	i32.const	$8=, 8
	i32.add 	$8=, $13, $8
	i32.or  	$push11=, $8, $pop10
	i32.load	$push14=, 0($pop11)
	i32.const	$9=, 32
	i32.add 	$9=, $13, $9
	block
	i32.ne  	$push15=, $pop14, $9
	br_if   	0, $pop15       # 0: down to label9
# BB#1:                                 # %lor.lhs.false
	i32.load	$push16=, 0($0):p2align=3
	br_if   	0, $pop16       # 0: down to label9
# BB#2:                                 # %lor.lhs.false6
	i32.const	$push17=, 12
	i32.const	$10=, 8
	i32.add 	$10=, $13, $10
	i32.add 	$push18=, $10, $pop17
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 999
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label9
# BB#3:                                 # %lor.lhs.false11
	i32.const	$push22=, 16
	i32.const	$11=, 8
	i32.add 	$11=, $13, $11
	i32.add 	$push23=, $11, $pop22
	i32.load	$push24=, 0($pop23):p2align=3
	i32.const	$push25=, 777
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label9
# BB#4:                                 # %lor.lhs.false16
	i64.load	$push27=, 32($13):p2align=4
	i64.const	$push28=, 953482739823
	i64.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label9
# BB#5:                                 # %lor.lhs.false24
	i32.const	$push30=, 8
	i32.const	$12=, 32
	i32.add 	$12=, $13, $12
	i32.or  	$push31=, $12, $pop30
	i64.load	$push32=, 0($pop31)
	i64.const	$push33=, 1906965479424
	i64.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label9
# BB#6:                                 # %if.end
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
.LBB2_7:                                # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lmain.uv,@object       # @main.uv
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.Lmain.uv:
	.int32	111                     # 0x6f
	.int32	222                     # 0xde
	.int32	333                     # 0x14d
	.int32	444                     # 0x1bc
	.size	.Lmain.uv, 16

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
	.p2align	2
.Lmain.s:
	.int32	0
	.int32	555                     # 0x22b
	.skip	4
	.int32	999                     # 0x3e7
	.int32	777                     # 0x309
	.size	.Lmain.s, 20


	.ident	"clang version 3.9.0 "
