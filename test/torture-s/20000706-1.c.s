	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000706-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %lor.lhs.false4
	i32.load	$push9=, 12($0)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %lor.lhs.false6
	i32.const	$push13=, 10
	i32.ne  	$push14=, $5, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %lor.lhs.false6
	i32.const	$push15=, 9
	i32.ne  	$push16=, $4, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#6:                                 # %lor.lhs.false6
	i32.const	$push17=, 8
	i32.ne  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#7:                                 # %lor.lhs.false6
	i32.const	$push19=, 7
	i32.ne  	$push20=, $2, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#8:                                 # %lor.lhs.false6
	i32.const	$push21=, 6
	i32.ne  	$push22=, $1, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#9:                                 # %lor.lhs.false6
	i32.load	$push12=, 16($0)
	i32.const	$push23=, 5
	i32.ne  	$push24=, $pop12, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#10:                                # %if.end
	return
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %lor.lhs.false2.i
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#3:                                 # %lor.lhs.false4.i
	i32.load	$push9=, 12($0)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#4:                                 # %lor.lhs.false6.i
	i32.load	$push12=, 16($0)
	i32.const	$push13=, 5
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#5:                                 # %bar.exit
	return
.LBB1_6:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 48
	i32.sub 	$push22=, $pop15, $pop16
	i32.store	$push24=, 0($pop17), $pop22
	tee_local	$push23=, $3=, $pop24
	i64.const	$push0=, 8589934593
	i64.store	$discard=, 24($pop23), $pop0
	i32.const	$push1=, 3
	i32.store	$0=, 32($3), $pop1
	i32.const	$push2=, 4
	i32.store	$1=, 36($3), $pop2
	i32.const	$push3=, 5
	i32.store	$2=, 40($3), $pop3
	i32.const	$push4=, 16
	i32.add 	$push5=, $3, $pop4
	i32.store	$discard=, 0($pop5), $1
	i32.const	$push6=, 12
	i32.add 	$push7=, $3, $pop6
	i32.store	$discard=, 0($pop7), $0
	i32.const	$push8=, 20
	i32.add 	$push9=, $3, $pop8
	i32.store	$discard=, 0($pop9), $2
	i32.const	$push18=, 4
	i32.add 	$push19=, $3, $pop18
	i32.add 	$push10=, $1, $pop19
	i32.load	$push11=, 28($3)
	i32.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 1
	i32.store	$discard=, 4($3), $pop12
	i32.const	$push20=, 4
	i32.add 	$push21=, $3, $pop20
	call    	foo@FUNCTION, $pop21, $3
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
