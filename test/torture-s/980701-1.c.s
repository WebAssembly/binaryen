	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980701-1.c"
	.globl	ns_name_skip
	.type	ns_name_skip,@function
ns_name_skip:                           # @ns_name_skip
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	return  	$pop1
func_end0:
	.size	ns_name_skip, func_end0-ns_name_skip

	.globl	dn_skipname
	.type	dn_skipname,@function
dn_skipname:                            # @dn_skipname
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
	return  	$pop1
func_end1:
	.size	dn_skipname, func_end1-dn_skipname

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB2_2
	i32.const	$push0=, a
	br_if   	$pop0, BB2_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB2_2:                                  # %if.end
	i32.const	$push1=, 0
	call    	exit, $pop1
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	a,@object               # @a
	.bss
	.globl	a
a:
	.zero	2
	.size	a, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
