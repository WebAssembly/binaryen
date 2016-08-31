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
	i32.eqz 	$push14=, $3
	br_if   	0, $pop14       # 0: down to label7
# BB#3:                                 # %if.end3
	copy_local	$4=, $5
	i32.eqz 	$push15=, $5
	br_if   	1, $pop15       # 1: down to label6
.LBB0_4:                                # %l3
	end_block                       # label7:
	i32.const	$push6=, 4
	i32.add 	$push7=, $1, $pop6
	i32.store	$drop=, 0($pop7), $4
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	i32.load	$push11=, 0($pop9)
	tee_local	$push10=, $3=, $pop11
	br_if   	1, $pop10       # 1: down to label5
# BB#5:                                 # %if.end19
	i32.eqz 	$push16=, $4
	br_if   	2, $pop16       # 2: down to label4
# BB#6:                                 # %if.end24
	i32.store	$drop=, 8($4), $3
	return
.LBB0_7:                                # %if.end6
	end_block                       # label6:
	i32.const	$push2=, 4
	i32.add 	$push3=, $1, $pop2
	i32.load	$push0=, 0($1)
	i32.load	$push13=, 0($pop0)
	tee_local	$push12=, $3=, $pop13
	i32.store	$drop=, 0($pop3), $pop12
	br_if   	2, $3           # 2: down to label3
# BB#8:                                 # %if.end12
	i32.const	$push5=, 0
	i32.const	$push4=, -1
	i32.store	$drop=, 12($pop5), $pop4
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
	i32.const	$push34=, 0
	i32.const	$push31=, 0
	i32.load	$push32=, __stack_pointer($pop31)
	i32.const	$push33=, 48
	i32.sub 	$push49=, $pop32, $pop33
	tee_local	$push48=, $1=, $pop49
	i32.store	$drop=, __stack_pointer($pop34), $pop48
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.uv+8($pop0)
	i64.store	$drop=, 40($1), $pop1
	i32.const	$push47=, 0
	i64.load	$push2=, .Lmain.uv($pop47)
	i64.store	$drop=, 32($1), $pop2
	i32.const	$push3=, 24
	i32.add 	$push4=, $1, $pop3
	i32.const	$push46=, 0
	i32.load	$push5=, .Lmain.s+16($pop46)
	i32.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 16
	i32.add 	$push45=, $1, $pop6
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 0
	i64.load	$push7=, .Lmain.s+8($pop43):p2align=2
	i64.store	$drop=, 0($pop44), $pop7
	i32.const	$push42=, 0
	i64.load	$push8=, .Lmain.s($pop42):p2align=2
	i64.store	$drop=, 8($1), $pop8
	i32.const	$push41=, 0
	i32.const	$push35=, 8
	i32.add 	$push36=, $1, $pop35
	i32.const	$push10=, 20000
	i32.const	$push9=, 10000
	i32.const	$push37=, 32
	i32.add 	$push38=, $1, $pop37
	call    	f@FUNCTION, $pop41, $pop36, $1, $pop10, $pop9, $pop38
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
	i64.load	$push25=, 32($1)
	i64.const	$push24=, 953482739823
	i64.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label8
# BB#5:                                 # %lor.lhs.false24
	i64.load	$push28=, 40($1)
	i64.const	$push27=, 1906965479424
	i64.ne  	$push29=, $pop28, $pop27
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
