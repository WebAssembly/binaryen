	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001024-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($1)
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$3=, 250000
	i32.load	$push1=, 4($1)
	i32.ne  	$push2=, $pop1, $3
	br_if   	$pop2, 0        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push3=, 8($1)
	br_if   	$pop3, 0        # 0: down to label0
# BB#3:                                 # %lor.lhs.false5
	i32.const	$push4=, 12
	i32.add 	$push5=, $1, $pop4
	i32.load	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop6, $3
	br_if   	$pop7, 0        # 0: down to label0
# BB#4:                                 # %if.end
	return  	$1
.LBB0_5:                                # %if.then
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
# BB#0:                                 # %bar.exit
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
