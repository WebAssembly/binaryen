	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48571-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -2492
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push0=, c
	i32.add 	$0=, $pop0, $1
	i32.const	$push6=, 2496
	i32.add 	$push7=, $0, $pop6
	i32.const	$push1=, 2492
	i32.add 	$push2=, $0, $pop1
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 1
	i32.shl 	$push5=, $pop3, $pop4
	i32.store	$discard=, 0($pop7), $pop5
	i32.const	$push8=, 4
	i32.add 	$1=, $1, $pop8
	br_if   	$1, 0           # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, -2496
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$3=, c
	i32.add 	$push0=, $3, $2
	i32.const	$push1=, 2496
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, 1
	i32.store	$4=, 0($pop2), $pop3
	i32.const	$0=, 4
	i32.add 	$2=, $2, $0
	br_if   	$2, 0           # 0: up to label2
# BB#2:                                 # %for.end
	end_loop                        # label3:
	call    	bar@FUNCTION
	i32.const	$2=, 0
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	i32.load	$push4=, 0($3)
	i32.ne  	$push5=, $pop4, $4
	br_if   	$pop5, 2        # 2: down to label4
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$1=, 1
	i32.shl 	$4=, $4, $1
	i32.add 	$2=, $2, $1
	i32.add 	$3=, $3, $0
	i32.const	$push6=, 624
	i32.lt_u	$push7=, $2, $pop6
	br_if   	$pop7, 0        # 0: up to label5
# BB#5:                                 # %for.end8
	end_loop                        # label6:
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_6:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	4
c:
	.skip	2496
	.size	c, 2496


	.ident	"clang version 3.9.0 "
