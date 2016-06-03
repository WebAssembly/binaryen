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
                                        # fallthrough-return: $pop1
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
	i32.call	$push9=, bar@FUNCTION
	tee_local	$push8=, $0=, $pop9
	i32.const	$push3=, -37
	i32.const	$push2=, -1
	i32.const	$push0=, -38
	i32.eq  	$push1=, $0, $pop0
	i32.select	$push4=, $pop3, $pop2, $pop1
	i32.const	$push5=, -4095
	i32.lt_u	$push6=, $0, $pop5
	i32.select	$push7=, $pop8, $pop4, $pop6
                                        # fallthrough-return: $pop7
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
	i32.const	$push28=, 0
	i32.const	$push1=, 26
	i32.store	$push0=, x($pop28), $pop1
	i32.call	$push27=, bar@FUNCTION
	tee_local	$push26=, $1=, $pop27
	i32.const	$push25=, -37
	i32.const	$push24=, -1
	i32.const	$push23=, -38
	i32.eq  	$push2=, $1, $pop23
	i32.select	$push3=, $pop25, $pop24, $pop2
	i32.const	$push22=, -4095
	i32.lt_u	$push4=, $1, $pop22
	i32.select	$push5=, $pop26, $pop3, $pop4
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$push7=, -39
	i32.store	$drop=, x($pop36), $pop7
	i32.call	$push35=, bar@FUNCTION
	tee_local	$push34=, $1=, $pop35
	i32.const	$push33=, -37
	i32.const	$push32=, -1
	i32.const	$push31=, -38
	i32.eq  	$push8=, $1, $pop31
	i32.select	$push9=, $pop33, $pop32, $pop8
	i32.const	$push30=, -4095
	i32.lt_u	$push10=, $1, $pop30
	i32.select	$push11=, $pop34, $pop9, $pop10
	i32.const	$push29=, -1
	i32.ne  	$push12=, $pop11, $pop29
	br_if   	0, $pop12       # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push40=, 0
	i32.const	$push13=, -38
	i32.store	$0=, x($pop40), $pop13
	i32.call	$push39=, bar@FUNCTION
	tee_local	$push38=, $1=, $pop39
	i32.const	$push16=, -37
	i32.const	$push15=, -1
	i32.eq  	$push14=, $1, $0
	i32.select	$push17=, $pop16, $pop15, $pop14
	i32.const	$push18=, -4095
	i32.lt_u	$push19=, $1, $pop18
	i32.select	$push20=, $pop38, $pop17, $pop19
	i32.const	$push37=, -37
	i32.ne  	$push21=, $pop20, $pop37
	br_if   	0, $pop21       # 0: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push41=, 0
	return  	$pop41
.LBB2_4:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	x,@object               # @x
	.lcomm	x,4,2

	.ident	"clang version 3.9.0 "
	.functype	abort, void
