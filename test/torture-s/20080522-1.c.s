	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080522-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, i($pop0), $pop1
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push4=, 0
	i32.load	$push3=, i($pop4)
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.const	$push2=, 1
	i32.store	$discard=, i($pop1), $pop2
	i32.load	$push3=, 0($0)
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push22=, __stack_pointer
	i32.load	$push23=, 0($pop22)
	i32.const	$push24=, 16
	i32.sub 	$0=, $pop23, $pop24
	i32.const	$push25=, __stack_pointer
	i32.store	$discard=, 0($pop25), $0
	i32.const	$push0=, 0
	i32.store	$discard=, 12($0), $pop0
	block
	i32.const	$push16=, i
	i32.call	$push1=, foo@FUNCTION, $pop16
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push18=, i
	i32.call	$push4=, bar@FUNCTION, $pop18
	i32.const	$push17=, 1
	i32.ne  	$push5=, $pop4, $pop17
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push29=, 12
	i32.add 	$push30=, $0, $pop29
	i32.call	$push6=, foo@FUNCTION, $pop30
	i32.const	$push19=, 1
	i32.ne  	$push7=, $pop6, $pop19
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %if.end8
	i32.load	$push8=, 12($0)
	i32.const	$push20=, 2
	i32.ne  	$push9=, $pop8, $pop20
	br_if   	0, $pop9        # 0: down to label0
# BB#4:                                 # %if.end11
	i32.const	$push31=, 12
	i32.add 	$push32=, $0, $pop31
	i32.call	$push10=, bar@FUNCTION, $pop32
	i32.const	$push21=, 2
	i32.ne  	$push11=, $pop10, $pop21
	br_if   	0, $pop11       # 0: down to label0
# BB#5:                                 # %if.end15
	i32.load	$push12=, 12($0)
	i32.const	$push13=, 2
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#6:                                 # %if.end18
	i32.const	$push15=, 0
	i32.const	$push28=, __stack_pointer
	i32.const	$push26=, 16
	i32.add 	$push27=, $0, $pop26
	i32.store	$discard=, 0($pop28), $pop27
	return  	$pop15
.LBB2_7:                                # %if.then17
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	i,@object               # @i
	.lcomm	i,4,2

	.ident	"clang version 3.9.0 "
