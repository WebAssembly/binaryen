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
	i32.const	$2=, 2
	block
	i32.const	$push7=, 0
	i32.load	$push6=, bar($pop7)
	tee_local	$push5=, $3=, $pop6
	i32.const	$push4=, 1
	i32.gt_s	$push1=, $pop5, $pop4
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push2=, 4
	i32.add 	$1=, $0, $pop2
	i32.sub 	$push0=, $2, $3
	i32.store	$2=, 0($0), $pop0
	copy_local	$0=, $1
	i32.const	$push9=, 0
	i32.const	$push8=, 1
	i32.store	$3=, bar($pop9), $pop8
	i32.gt_s	$push3=, $2, $3
	br_if   	0, $pop3        # 0: up to label1
.LBB0_2:                                # %while.end
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$9=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	i32.const	$push1=, 0
	i32.store	$3=, 12($9), $pop1
	i32.const	$7=, 8
	i32.add 	$7=, $9, $7
	copy_local	$2=, $7
	i32.const	$1=, 2
	block
	i32.store	$push16=, 8($9), $3
	tee_local	$push15=, $4=, $pop16
	i32.load	$push14=, bar($pop15)
	tee_local	$push13=, $3=, $pop14
	i32.const	$push12=, 1
	i32.gt_s	$push2=, $pop13, $pop12
	br_if   	0, $pop2        # 0: down to label3
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push18=, 4
	i32.add 	$0=, $2, $pop18
	i32.sub 	$push0=, $1, $3
	i32.store	$1=, 0($2), $pop0
	copy_local	$2=, $0
	i32.const	$push17=, 1
	i32.store	$3=, bar($4), $pop17
	i32.gt_s	$push3=, $1, $3
	br_if   	0, $pop3        # 0: up to label4
# BB#2:                                 # %f.exit
	end_loop                        # label5:
	i32.load	$push5=, 8($9)
	i32.const	$push7=, 2
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#3:                                 # %f.exit
	i32.const	$push19=, 4
	i32.const	$8=, 8
	i32.add 	$8=, $9, $8
	i32.add 	$push6=, $8, $pop19
	i32.load	$push4=, 0($pop6)
	i32.const	$push9=, 1
	i32.ne  	$push10=, $pop4, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB1_5:                                # %if.then
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
