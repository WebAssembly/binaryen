	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050203-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$3=, 15
	i32.add 	$3=, $4, $3
	call    	foo@FUNCTION, $3
	i32.load8_s	$0=, 15($4)
	call    	bar@FUNCTION
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 129
	i32.store8	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.bar,"ax",@progbits
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar


	.ident	"clang version 3.9.0 "
