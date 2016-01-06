	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960312-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$3=, 8($0)
	i32.const	$5=, 16
	i32.add 	$5=, $0, $5
	i32.load	$1=, 4($3)
	i32.load	$2=, 8($3)
	i32.load	$6=, 0($5)
	i32.load	$4=, 12($0)
	#APP
	#NO_APP
	i32.load	$push0=, 0($3)
	i32.store	$discard=, 8($3), $pop0
	i32.store	$discard=, 0($3), $6
	i32.store	$discard=, 0($5), $4
	i32.store	$discard=, 12($0), $2
	i32.store	$discard=, 4($0), $1
	i32.store	$discard=, 0($0), $3
	return  	$0
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$0=, main.sc+4($2)
	i32.load	$1=, main.sc+8($2)
	i32.load	$3=, main.sc($2)
	#APP
	#NO_APP
	block   	BB1_2
	i32.const	$push1=, 11
	i32.store	$discard=, main.sc($2), $pop1
	i32.store	$push0=, main.sc+8($2), $3
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.end
	call    	exit, $2
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	main.sc,@object         # @main.sc
	.data
	.align	2
main.sc:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	main.sc, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
