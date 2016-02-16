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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$5=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$5=, 0($1), $5
	i32.const	$push0=, 0
	i32.store	$discard=, 12($5), $pop0
	block
	block
	block
	block
	block
	block
	i32.const	$push16=, i
	i32.call	$push1=, foo@FUNCTION, $pop16
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push18=, i
	i32.call	$push4=, bar@FUNCTION, $pop18
	i32.const	$push17=, 1
	i32.ne  	$push5=, $pop4, $pop17
	br_if   	1, $pop5        # 1: down to label4
# BB#2:                                 # %if.end4
	i32.const	$3=, 12
	i32.add 	$3=, $5, $3
	i32.call	$push6=, foo@FUNCTION, $3
	i32.const	$push19=, 1
	i32.ne  	$push7=, $pop6, $pop19
	br_if   	2, $pop7        # 2: down to label3
# BB#3:                                 # %if.end8
	i32.load	$push8=, 12($5)
	i32.const	$push20=, 2
	i32.ne  	$push9=, $pop8, $pop20
	br_if   	3, $pop9        # 3: down to label2
# BB#4:                                 # %if.end11
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	i32.call	$push10=, bar@FUNCTION, $4
	i32.const	$push21=, 2
	i32.ne  	$push11=, $pop10, $pop21
	br_if   	4, $pop11       # 4: down to label1
# BB#5:                                 # %if.end15
	i32.load	$push12=, 12($5)
	i32.const	$push13=, 2
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	5, $pop14       # 5: down to label0
# BB#6:                                 # %if.end18
	i32.const	$push15=, 0
	i32.const	$2=, 16
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	return  	$pop15
.LBB2_7:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB2_8:                                # %if.then3
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB2_9:                                # %if.then7
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_10:                               # %if.then10
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_11:                               # %if.then14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %if.then17
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	i,@object               # @i
	.lcomm	i,4,2

	.ident	"clang version 3.9.0 "
