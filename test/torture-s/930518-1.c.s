	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930518-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push6=, 0
	i32.load	$push5=, bar($pop6)
	tee_local	$push4=, $4=, $pop5
	i32.const	$push1=, 1
	i32.gt_s	$push2=, $pop4, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$3=, 2
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.sub 	$3=, $3, $4
	i32.store	$1=, 0($0), $3
	i32.const	$4=, 1
	i32.const	$push9=, 0
	i32.const	$push8=, 1
	i32.store	$2=, bar($pop9), $pop8
	i32.const	$push7=, 4
	i32.add 	$push0=, $0, $pop7
	copy_local	$0=, $pop0
	i32.gt_s	$push3=, $1, $2
	br_if   	0, $pop3        # 0: up to label1
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push20=, $pop15, $pop16
	i32.store	$2=, 0($pop17), $pop20
	i32.const	$push21=, 0
	i32.load	$3=, bar($pop21)
	i64.const	$push1=, 0
	i64.store	$discard=, 8($2):p2align=2, $pop1
	block
	i32.const	$push2=, 1
	i32.gt_s	$push3=, $3, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#1:                                 # %while.body.i.preheader
	i32.const	$4=, 2
	i32.const	$push18=, 8
	i32.add 	$push19=, $2, $pop18
	copy_local	$5=, $pop19
.LBB1_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.sub 	$4=, $4, $3
	i32.store	$0=, 0($5), $4
	i32.const	$3=, 1
	i32.const	$push24=, 0
	i32.const	$push23=, 1
	i32.store	$1=, bar($pop24), $pop23
	i32.const	$push22=, 4
	i32.add 	$push0=, $5, $pop22
	copy_local	$5=, $pop0
	i32.gt_s	$push4=, $0, $1
	br_if   	0, $pop4        # 0: up to label4
# BB#3:                                 # %f.exit
	end_loop                        # label5:
	i32.load	$push6=, 8($2)
	i32.const	$push9=, 2
	i32.ne  	$push10=, $pop6, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %f.exit
	i32.const	$push7=, 12
	i32.add 	$push8=, $2, $pop7
	i32.load	$push5=, 0($pop8)
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop5, $pop11
	br_if   	0, $pop12       # 0: down to label3
# BB#5:                                 # %if.end
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
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
