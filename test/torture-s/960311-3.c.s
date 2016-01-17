	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960311-3.c"
	.section	.text.a1,"ax",@progbits
	.hidden	a1
	.globl	a1
	.type	a1,@function
a1:                                     # @a1
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, count($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, count($0), $pop2
	return
	.endfunc
.Lfunc_end0:
	.size	a1, .Lfunc_end0-a1

	.section	.text.b,"ax",@progbits
	.hidden	b
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$1=, 0
	i32.load	$push2=, count($1)
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$discard=, count($1), $pop4
.LBB1_2:                                # %if.end
	end_block                       # label0:
	block
	i32.const	$push5=, 1073741824
	i32.and 	$push6=, $0, $pop5
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop6, $pop15
	br_if   	$pop16, 0       # 0: down to label1
# BB#3:                                 # %if.then3
	i32.const	$1=, 0
	i32.load	$push7=, count($1)
	i32.const	$push8=, 1
	i32.add 	$push9=, $pop7, $pop8
	i32.store	$discard=, count($1), $pop9
.LBB1_4:                                # %if.end4
	end_block                       # label1:
	block
	i32.const	$push10=, 536870912
	i32.and 	$push11=, $0, $pop10
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop11, $pop17
	br_if   	$pop18, 0       # 0: down to label2
# BB#5:                                 # %if.then8
	i32.const	$0=, 0
	i32.load	$push12=, count($0)
	i32.const	$push13=, 1
	i32.add 	$push14=, $pop12, $pop13
	i32.store	$discard=, count($0), $pop14
.LBB1_6:                                # %if.end9
	end_block                       # label2:
	return
	.endfunc
.Lfunc_end1:
	.size	b, .Lfunc_end1-b

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end21
	i32.const	$0=, 0
	i32.const	$push0=, 3
	i32.store	$discard=, count($0), $pop0
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 3.9.0 "
