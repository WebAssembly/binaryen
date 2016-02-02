	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31448-2.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
# BB#0:                                 # %entry
	unreachable
	unreachable
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$0=, next($pop0)
	i32.load	$push1=, 0($0)
	i32.const	$push2=, -16777216
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16711422
	i32.or  	$push5=, $pop3, $pop4
	i32.store	$discard=, 0($0), $pop5
	i32.const	$push11=, 0
	i32.load	$0=, next($pop11)
	i32.load	$push6=, 4($0)
	i32.const	$push10=, -16777216
	i32.and 	$push7=, $pop6, $pop10
	i32.const	$push9=, 16711422
	i32.or  	$push8=, $pop7, $pop9
	i32.store	$discard=, 4($0), $pop8
	return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %if.end6
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push0=, 0
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	i32.store	$discard=, next($pop0), $3
	i32.const	$push1=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	next                    # @next
	.type	next,@object
	.section	.bss.next,"aw",@nobits
	.globl	next
	.p2align	2
next:
	.int32	0
	.size	next, 4


	.ident	"clang version 3.9.0 "
