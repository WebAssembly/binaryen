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
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$5=, 8
	copy_local	$3=, $2
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$4=, 1
	block
	block
	i32.eq  	$push0=, $5, $4
	br_if   	$pop0, 0        # 0: down to label3
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push6=, 0
	i32.eq  	$push7=, $5, $pop6
	br_if   	$pop7, 0        # 0: down to label4
# BB#3:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$3=, $3, $4
	br      	2               # 2: down to label2
.LBB1_4:                                # %for.end
	end_block                       # label4:
	block
	i32.ne  	$push1=, $2, $4
	br_if   	$pop1, 0        # 0: down to label5
# BB#5:                                 # %for.end
	i32.const	$push2=, 7
	i32.ne  	$push3=, $3, $pop2
	br_if   	$pop3, 0        # 0: down to label5
# BB#6:                                 # %if.end7
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_7:                                # %if.then6
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.add 	$2=, $2, $4
.LBB1_9:                                # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push5=, -1
	i32.add 	$5=, $5, $pop5
	br      	0               # 0: up to label0
.LBB1_10:
	end_loop                        # label1:
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
