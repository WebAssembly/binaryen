	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48571-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, c($pop0)
	i32.const	$0=, 4
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push8=, 1
	i32.shl 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.store	$drop=, c($0), $pop6
	i32.const	$push5=, 4
	i32.add 	$push4=, $0, $pop5
	tee_local	$push3=, $0=, $pop4
	i32.const	$push2=, 2496
	i32.ne  	$push1=, $pop3, $pop2
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -2496
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push7=, 1
	i32.store	$drop=, c+2496($0), $pop7
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label2
# BB#2:                                 # %for.end
	end_loop                        # label3:
	call    	bar@FUNCTION
	i32.const	$2=, 0
	i32.const	$0=, c
	i32.const	$1=, 1
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label5:
	i32.load	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	2, $pop1        # 2: down to label4
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	i32.const	$push12=, 1
	i32.shl 	$1=, $1, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $2, $pop11
	tee_local	$push9=, $2=, $pop10
	i32.const	$push8=, 624
	i32.lt_u	$push2=, $pop9, $pop8
	br_if   	0, $pop2        # 0: up to label5
# BB#5:                                 # %for.end8
	end_loop                        # label6:
	i32.const	$push3=, 0
	return  	$pop3
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
	.p2align	4
c:
	.skip	2496
	.size	c, 2496


	.ident	"clang version 3.9.0 "
	.functype	abort, void
