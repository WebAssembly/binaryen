	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pending-4.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 8
	i32.const	$2=, 0
	i32.const	$3=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.const	$push6=, 1
	i32.eq  	$push0=, $4, $pop6
	br_if   	$pop0, 0        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push10=, 0
	i32.eq  	$push11=, $4, $pop10
	br_if   	$pop11, 0       # 0: down to label4
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$3=, $3, $pop8
	br      	2               # 2: down to label2
.LBB1_4:                                # %for.end
	end_block                       # label4:
	block
	i32.const	$push1=, 1
	i32.ne  	$push2=, $2, $pop1
	br_if   	$pop2, 0        # 0: down to label5
# BB#5:                                 # %for.end
	i32.const	$push3=, 7
	i32.ne  	$push4=, $3, $pop3
	br_if   	$pop4, 0        # 0: down to label5
# BB#6:                                 # %if.end7
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_7:                                # %if.then6
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
.LBB1_9:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push9=, -1
	i32.add 	$4=, $4, $pop9
	br      	0               # 0: up to label0
.LBB1_10:
	end_loop                        # label1:
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
