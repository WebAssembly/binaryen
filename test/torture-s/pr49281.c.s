	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49281.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 4
	i32.or  	$push3=, $pop1, $pop2
	return  	$pop3
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
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 3
	i32.or  	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 43
	block
	i32.call	$push0=, foo@FUNCTION, $0
	i32.const	$push1=, 172
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$1=, 1
	i32.call	$push3=, foo@FUNCTION, $1
	i32.const	$push4=, 4
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#2:                                 # %lor.lhs.false3
	i32.const	$2=, 2
	i32.call	$push6=, foo@FUNCTION, $2
	i32.const	$push7=, 12
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label0
# BB#3:                                 # %if.end
	block
	i32.call	$push9=, bar@FUNCTION, $0
	i32.const	$push10=, 175
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, 0       # 0: down to label1
# BB#4:                                 # %lor.lhs.false8
	i32.call	$push12=, bar@FUNCTION, $1
	i32.const	$push13=, 7
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label1
# BB#5:                                 # %lor.lhs.false11
	i32.call	$push15=, bar@FUNCTION, $2
	i32.const	$push16=, 11
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, 0       # 0: down to label1
# BB#6:                                 # %if.end15
	i32.const	$push18=, 0
	return  	$pop18
.LBB2_7:                                # %if.then14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
