	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041213-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	i32.const	$2=, 0
	block
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label1
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	block
	i32.ge_s	$push0=, $2, $3
	br_if   	0, $pop0        # 0: down to label5
# BB#2:                                 # %for.end.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push2=, 1
	i32.shl 	$push3=, $3, $pop2
	i32.sub 	$1=, $pop3, $2
	br      	1               # 1: down to label4
.LBB0_3:                                # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label5:
	copy_local	$1=, $3
	i32.ne  	$push1=, $2, $3
	br_if   	4, $pop1        # 4: down to label0
.LBB0_4:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push4=, -1
	i32.add 	$0=, $0, $pop4
	copy_local	$2=, $3
	copy_local	$3=, $1
	br_if   	0, $0           # 0: up to label2
.LBB0_5:                                # %for.end7
	end_loop                        # label3:
	end_block                       # label1:
	return
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
