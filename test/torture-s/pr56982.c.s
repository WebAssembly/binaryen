	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56982.c"
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return
func_end0:
	.size	baz, func_end0-baz

	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.load	$push0=, 0($0)
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop0, $pop5
	br_if   	$pop6, BB1_2
# BB#1:                                 # %if.then
	i32.const	$push1=, 1
	return  	$pop1
BB1_2:                                  # %if.end
	i32.const	$1=, env
	#APP
	#NO_APP
	block   	BB1_4
	i32.call	$push2=, _setjmp, $1
	br_if   	$pop2, BB1_4
# BB#3:                                 # %if.end6
	i32.const	$push4=, 42
	call    	longjmp, $1, $pop4
	unreachable
BB1_4:                                  # %if.then2
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
func_end1:
	.size	f, func_end1-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$4=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	i32.const	$push0=, 0
	i32.store	$discard=, 12($4), $pop0
	i32.const	$5=, 12
	i32.add 	$5=, $4, $5
	i32.call	$discard=, f, $5
	i32.const	$push1=, 1
	i32.const	$4=, 16
	i32.add 	$4=, $4, $4
	i32.const	$4=, __stack_pointer
	i32.store	$4=, 0($4), $4
	return  	$pop1
func_end2:
	.size	main, func_end2-main

	.type	env,@object             # @env
	.lcomm	env,156,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
