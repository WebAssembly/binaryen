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
	i32.ge_s	$push2=, $3, $4
	br_if   	0, $pop2        # 0: down to label0
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
	i32.eqz 	$push12=, $3
	br_if   	0, $pop12       # 0: down to label7
# BB#3:                                 # %if.end3
	copy_local	$4=, $5
	i32.eqz 	$push13=, $5
	br_if   	1, $pop13       # 1: down to label6
.LBB0_4:                                # %l3
	end_block                       # label7:
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.load	$3=, 0($pop11)
	i32.const	$push8=, 4
	i32.add 	$push9=, $1, $pop8
	i32.store	$discard=, 0($pop9), $4
	br_if   	1, $3           # 1: down to label5
# BB#5:                                 # %if.end19
	i32.eqz 	$push14=, $4
	br_if   	2, $pop14       # 2: down to label4
# BB#6:                                 # %if.end24
	i32.store	$discard=, 8($4), $3
	return
.LBB0_7:                                # %if.end6
	end_block                       # label6:
	i32.const	$push4=, 4
	i32.add 	$push5=, $1, $pop4
	i32.load	$push1=, 0($1)
	i32.load	$push3=, 0($pop1)
	i32.store	$push0=, 0($pop5), $pop3
	br_if   	2, $pop0        # 2: down to label3
# BB#8:                                 # %if.end12
	i32.const	$push6=, 0
	i32.const	$push7=, -1
	i32.store	$discard=, 12($pop6), $pop7
	return
.LBB0_9:                                # %if.then18
	end_block                       # label5:
	call    	g@FUNCTION, $3, $3
	unreachable
.LBB0_10:                               # %if.then23
	end_block                       # label4:
	call    	g@FUNCTION, $3, $3
	unreachable
.LBB0_11:                               # %if.then11
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push34=, __stack_pointer
	i32.const	$push31=, __stack_pointer
	i32.load	$push32=, 0($pop31)
	i32.const	$push33=, 48
	i32.sub 	$push41=, $pop32, $pop33
	i32.store	$push50=, 0($pop34), $pop41
	tee_local	$push49=, $1=, $pop50
	i32.const	$push3=, 24
	i32.add 	$push4=, $pop49, $pop3
	i32.const	$push0=, 0
	i32.load	$push5=, .Lmain.s+16($pop0)
	i32.store	$discard=, 0($pop4), $pop5
	i32.const	$push48=, 0
	i64.load	$push1=, .Lmain.uv+8($pop48)
	i64.store	$discard=, 40($1), $pop1
	i32.const	$push47=, 0
	i64.load	$push2=, .Lmain.uv($pop47)
	i64.store	$discard=, 32($1), $pop2
	i32.const	$push6=, 16
	i32.add 	$push46=, $1, $pop6
	tee_local	$push45=, $0=, $pop46
	i32.const	$push44=, 0
	i64.load	$push7=, .Lmain.s+8($pop44):p2align=2
	i64.store	$discard=, 0($pop45), $pop7
	i32.const	$push43=, 0
	i64.load	$push8=, .Lmain.s($pop43):p2align=2
	i64.store	$discard=, 8($1), $pop8
	i32.const	$push42=, 0
	i32.const	$push35=, 8
	i32.add 	$push36=, $1, $pop35
	i32.const	$push10=, 20000
	i32.const	$push9=, 10000
	i32.const	$push37=, 32
	i32.add 	$push38=, $1, $pop37
	call    	f@FUNCTION, $pop42, $pop36, $1, $pop10, $pop9, $pop38
	block
	i32.load	$push11=, 12($1)
	i32.const	$push39=, 32
	i32.add 	$push40=, $1, $pop39
	i32.ne  	$push12=, $pop11, $pop40
	br_if   	0, $pop12       # 0: down to label8
# BB#1:                                 # %lor.lhs.false
	i32.load	$push13=, 0($0)
	br_if   	0, $pop13       # 0: down to label8
# BB#2:                                 # %lor.lhs.false6
	i32.const	$push14=, 20
	i32.add 	$push15=, $1, $pop14
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 999
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label8
# BB#3:                                 # %lor.lhs.false11
	i32.const	$push19=, 24
	i32.add 	$push20=, $1, $pop19
	i32.load	$push21=, 0($pop20)
	i32.const	$push22=, 777
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label8
# BB#4:                                 # %lor.lhs.false16
	i64.load	$push24=, 32($1)
	i64.const	$push25=, 953482739823
	i64.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label8
# BB#5:                                 # %lor.lhs.false24
	i64.load	$push27=, 40($1)
	i64.const	$push28=, 1906965479424
	i64.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label8
# BB#6:                                 # %if.end
	i32.const	$push30=, 0
	call    	exit@FUNCTION, $pop30
	unreachable
.LBB2_7:                                # %if.then
	end_block                       # label8:
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
