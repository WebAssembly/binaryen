	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071216-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$0=, bar@FUNCTION
	i32.const	$push5=, -37
	i32.const	$push4=, -1
	i32.const	$push2=, -38
	i32.eq  	$push3=, $0, $pop2
	i32.select	$push6=, $pop5, $pop4, $pop3
	i32.const	$push0=, -4095
	i32.lt_u	$push1=, $0, $pop0
	i32.select	$push7=, $0, $pop6, $pop1
	return  	$pop7
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push0=, 26
	i32.store	$0=, x($pop25), $pop0
	i32.call	$1=, bar@FUNCTION
	block
	block
	block
	i32.const	$push24=, -37
	i32.const	$push23=, -1
	i32.const	$push22=, -38
	i32.eq  	$push2=, $1, $pop22
	i32.select	$push3=, $pop24, $pop23, $pop2
	i32.const	$push21=, -4095
	i32.lt_u	$push1=, $1, $pop21
	i32.select	$push4=, $1, $pop3, $pop1
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push31=, 0
	i32.const	$push6=, -39
	i32.store	$discard=, x($pop31), $pop6
	i32.call	$1=, bar@FUNCTION
	i32.const	$push30=, -37
	i32.const	$push29=, -1
	i32.const	$push28=, -38
	i32.eq  	$push8=, $1, $pop28
	i32.select	$push9=, $pop30, $pop29, $pop8
	i32.const	$push27=, -4095
	i32.lt_u	$push7=, $1, $pop27
	i32.select	$push10=, $1, $pop9, $pop7
	i32.const	$push26=, -1
	i32.ne  	$push11=, $pop10, $pop26
	br_if   	1, $pop11       # 1: down to label1
# BB#2:                                 # %if.end4
	i32.const	$push33=, 0
	i32.const	$push12=, -38
	i32.store	$0=, x($pop33), $pop12
	i32.call	$1=, bar@FUNCTION
	i32.const	$push17=, -37
	i32.const	$push16=, -1
	i32.eq  	$push15=, $1, $0
	i32.select	$push18=, $pop17, $pop16, $pop15
	i32.const	$push13=, -4095
	i32.lt_u	$push14=, $1, $pop13
	i32.select	$push19=, $1, $pop18, $pop14
	i32.const	$push32=, -37
	i32.ne  	$push20=, $pop19, $pop32
	br_if   	2, $pop20       # 2: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push34=, 0
	return  	$pop34
.LBB2_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	x,@object               # @x
	.lcomm	x,4,2

	.ident	"clang version 3.9.0 "
