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
	i32.call	$push0=, bar@FUNCTION
	tee_local	$push9=, $0=, $pop0
	i32.const	$push1=, -4095
	i32.lt_u	$push2=, $pop9, $pop1
	i32.const	$push3=, -38
	i32.eq  	$push4=, $0, $pop3
	i32.const	$push6=, -37
	i32.const	$push5=, -1
	i32.select	$push7=, $pop4, $pop6, $pop5
	i32.select	$push8=, $pop2, $0, $pop7
	return  	$pop8
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
	block
	i32.const	$push30=, 0
	i32.const	$push0=, 26
	i32.store	$push1=, x($pop30), $pop0
	i32.call	$push2=, bar@FUNCTION
	tee_local	$push29=, $1=, $pop2
	i32.const	$push28=, -4095
	i32.lt_u	$push3=, $pop29, $pop28
	i32.const	$push27=, -38
	i32.eq  	$push4=, $1, $pop27
	i32.const	$push26=, -37
	i32.const	$push25=, -1
	i32.select	$push5=, $pop4, $pop26, $pop25
	i32.select	$push6=, $pop3, $1, $pop5
	i32.ne  	$push7=, $pop1, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push37=, 0
	i32.const	$push8=, -39
	i32.store	$discard=, x($pop37), $pop8
	block
	i32.call	$push9=, bar@FUNCTION
	tee_local	$push36=, $1=, $pop9
	i32.const	$push35=, -4095
	i32.lt_u	$push10=, $pop36, $pop35
	i32.const	$push34=, -38
	i32.eq  	$push11=, $1, $pop34
	i32.const	$push33=, -37
	i32.const	$push32=, -1
	i32.select	$push12=, $pop11, $pop33, $pop32
	i32.select	$push13=, $pop10, $1, $pop12
	i32.const	$push31=, -1
	i32.ne  	$push14=, $pop13, $pop31
	br_if   	$pop14, 0       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.const	$push40=, 0
	i32.const	$push15=, -38
	i32.store	$0=, x($pop40), $pop15
	block
	i32.call	$push16=, bar@FUNCTION
	tee_local	$push39=, $1=, $pop16
	i32.const	$push17=, -4095
	i32.lt_u	$push18=, $pop39, $pop17
	i32.eq  	$push19=, $1, $0
	i32.const	$push21=, -37
	i32.const	$push20=, -1
	i32.select	$push22=, $pop19, $pop21, $pop20
	i32.select	$push23=, $pop18, $1, $pop22
	i32.const	$push38=, -37
	i32.ne  	$push24=, $pop23, $pop38
	br_if   	$pop24, 0       # 0: down to label2
# BB#3:                                 # %if.end8
	i32.const	$push41=, 0
	return  	$pop41
.LBB2_4:                                # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	x,@object               # @x
	.lcomm	x,4,2

	.ident	"clang version 3.9.0 "
