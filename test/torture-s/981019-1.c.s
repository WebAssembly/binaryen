	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/981019-1.c"
	.section	.text.ff,"ax",@progbits
	.hidden	ff
	.globl	ff
	.type	ff,@function
ff:                                     # @ff
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push6=, 0
	i32.eq  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#1:                                 # %entry
	br_if   	1, $2           # 1: down to label1
.LBB0_2:                                # %while.cond.preheader
	end_block                       # label2:
	i32.const	$push2=, 0
	i32.load	$0=, f3.x($pop2)
.LBB0_3:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label4:
	copy_local	$push5=, $0
	tee_local	$push4=, $3=, $pop5
	i32.const	$push3=, 0
	i32.eq  	$0=, $pop4, $pop3
	br_if   	2, $3           # 2: down to label3
# BB#4:                                 # %while.body
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	0, $pop9        # 0: up to label4
# BB#5:                                 # %land.lhs.true
	end_loop                        # label5:
	i32.const	$push1=, 0
	i32.store	$discard=, f3.x($pop1), $0
	i32.call	$discard=, f2@FUNCTION
	unreachable
.LBB0_6:                                # %while.end
	end_block                       # label3:
	i32.const	$push0=, 0
	i32.store	$discard=, f3.x($pop0), $0
	br_if   	1, $2           # 1: down to label0
# BB#7:                                 # %if.end16
	return
.LBB0_8:                                # %if.then2
	end_block                       # label1:
	call    	f1@FUNCTION
	unreachable
.LBB0_9:                                # %if.then15
	end_block                       # label0:
	call    	f1@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	ff, .Lfunc_end0-ff

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, f3.x($pop5)
	i32.const	$push4=, 0
	i32.eq  	$push2=, $pop1, $pop4
	i32.store	$push3=, f3.x($pop0), $pop2
	return  	$pop3
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$0=, f3.x($pop1)
.LBB4_1:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	copy_local	$push4=, $0
	tee_local	$push3=, $1=, $pop4
	i32.const	$push2=, 0
	i32.eq  	$0=, $pop3, $pop2
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	0, $pop7        # 0: up to label6
# BB#2:                                 # %ff.exit
	end_loop                        # label7:
	i32.const	$push0=, 0
	i32.store	$discard=, f3.x($pop0), $0
	i32.const	$push5=, 0
	return  	$pop5
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	f3.x,@object            # @f3.x
	.lcomm	f3.x,4,2

	.ident	"clang version 3.9.0 "
