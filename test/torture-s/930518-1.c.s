	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930518-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push7=, 0
	i32.load	$push6=, bar($pop7)
	tee_local	$push5=, $2=, $pop6
	i32.const	$push1=, 1
	i32.gt_s	$push2=, $pop5, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$1=, 2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.sub 	$push0=, $1, $2
	i32.store	$1=, 0($0), $pop0
	i32.const	$push9=, 4
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 0
	i32.const	$push3=, 1
	i32.store	$2=, bar($pop8), $pop3
	i32.gt_s	$push4=, $1, $2
	br_if   	0, $pop4        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 16
	i32.sub 	$3=, $pop19, $pop20
	i32.const	$push21=, __stack_pointer
	i32.store	$discard=, 0($pop21), $3
	i32.const	$push15=, 0
	i32.load	$0=, bar($pop15)
	i64.const	$push1=, 0
	i64.store	$discard=, 8($3):p2align=2, $pop1
	block
	i32.const	$push2=, 1
	i32.gt_s	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#1:                                 # %while.body.i.preheader
	i32.const	$1=, 2
	i32.const	$push22=, 8
	i32.add 	$push23=, $3, $pop22
	copy_local	$2=, $pop23
.LBB1_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.sub 	$push0=, $1, $0
	i32.store	$1=, 0($2), $pop0
	i32.const	$push17=, 4
	i32.add 	$2=, $2, $pop17
	i32.const	$push16=, 0
	i32.const	$push4=, 1
	i32.store	$0=, bar($pop16), $pop4
	i32.gt_s	$push5=, $1, $0
	br_if   	0, $pop5        # 0: up to label4
# BB#3:                                 # %f.exit
	end_loop                        # label5:
	i32.load	$push7=, 8($3)
	i32.const	$push10=, 2
	i32.ne  	$push11=, $pop7, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#4:                                 # %f.exit
	i32.const	$push24=, 8
	i32.add 	$push25=, $3, $pop24
	i32.const	$push8=, 4
	i32.add 	$push9=, $pop25, $pop8
	i32.load	$push6=, 0($pop9)
	i32.const	$push12=, 1
	i32.ne  	$push13=, $pop6, $pop12
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
