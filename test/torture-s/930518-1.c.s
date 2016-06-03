	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930518-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push6=, 0
	i32.load	$push5=, bar($pop6)
	tee_local	$push4=, $2=, $pop5
	i32.const	$push1=, 1
	i32.gt_s	$push2=, $pop4, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, 2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.sub 	$push11=, $3, $2
	tee_local	$push10=, $3=, $pop11
	i32.store	$1=, 0($0), $pop10
	i32.const	$2=, 1
	i32.const	$push9=, 4
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 0
	i32.const	$push7=, 1
	i32.store	$push0=, bar($pop8), $pop7
	i32.gt_s	$push3=, $1, $pop0
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	copy_local	$push12=, $0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push21=, $pop16, $pop17
	i32.store	$push25=, __stack_pointer($pop18), $pop21
	tee_local	$push24=, $1=, $pop25
	i64.const	$push0=, 0
	i64.store	$drop=, 8($pop24):p2align=2, $pop0
	block
	i32.const	$push1=, 0
	i32.load	$push23=, bar($pop1)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push2=, 1
	i32.gt_s	$push3=, $pop22, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#1:                                 # %while.body.i.preheader
	i32.const	$3=, 2
	i32.const	$push19=, 8
	i32.add 	$push20=, $1, $pop19
	copy_local	$4=, $pop20
.LBB1_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.sub 	$push29=, $3, $2
	tee_local	$push28=, $3=, $pop29
	i32.store	$0=, 0($4), $pop28
	i32.const	$push27=, 4
	i32.add 	$4=, $4, $pop27
	i32.const	$2=, 1
	i32.const	$push26=, 1
	i32.gt_s	$push4=, $0, $pop26
	br_if   	0, $pop4        # 0: up to label4
# BB#3:                                 # %f.exit
	end_loop                        # label5:
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.store	$4=, bar($pop7), $pop6
	i32.load	$push9=, 8($1)
	i32.const	$push8=, 2
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %f.exit
	i32.const	$push11=, 12
	i32.add 	$push12=, $1, $pop11
	i32.load	$push5=, 0($pop12)
	i32.ne  	$push13=, $pop5, $4
	br_if   	0, $pop13       # 0: down to label3
# BB#5:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0                       # 0x0
	.size	bar, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
