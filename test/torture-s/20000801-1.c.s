	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000801-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.add 	$2=, $0, $1
	i32.const	$3=, 1
	block   	BB0_2
	i32.lt_s	$push0=, $1, $3
	br_if   	$pop0, BB0_2
BB0_1:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$push1=, 3
	i32.add 	$1=, $0, $pop1
	i32.load8_u	$5=, 0($1)
	i32.load8_u	$push2=, 0($0)
	i32.store8	$discard=, 0($1), $pop2
	i32.store8	$discard=, 0($0), $5
	i32.const	$push3=, 2
	i32.add 	$1=, $0, $pop3
	i32.add 	$5=, $0, $3
	i32.load8_u	$4=, 0($1)
	i32.load8_u	$push4=, 0($5)
	i32.store8	$discard=, 0($1), $pop4
	i32.store8	$discard=, 0($5), $4
	i32.const	$push5=, 4
	i32.add 	$0=, $0, $pop5
	i32.lt_u	$push6=, $0, $2
	br_if   	$pop6, BB0_1
BB0_2:                                  # %while.end
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	block   	BB1_2
	i32.const	$push0=, 1
	i32.store	$push1=, 12($2), $pop0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit, $pop2
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
