	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40022.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$4=, 12
	i32.add 	$4=, $4, $4
	#APP
	#NO_APP
	i32.store	$push0=, 12($4), $0
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$pop0
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.call	$push0=, foo@FUNCTION, $1
	i32.store	$1=, 0($0), $pop0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, .LBB1_2
.LBB1_1:                                # %while.cond.while.cond_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	copy_local	$0=, $1
	i32.load	$1=, 0($1)
	br_if   	$1, .LBB1_1
.LBB1_2:                                # %while.end
	block   	.LBB1_4
	i32.call	$push1=, foo@FUNCTION, $2
	i32.store	$1=, 0($0), $pop1
	i32.const	$push5=, 0
	i32.eq  	$push6=, $1, $pop5
	br_if   	$pop6, .LBB1_4
.LBB1_3:                                # %while.cond2.while.cond2_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_4
	copy_local	$0=, $1
	i32.load	$1=, 0($1)
	br_if   	$1, .LBB1_3
.LBB1_4:                                # %while.end6
	i32.call	$push2=, foo@FUNCTION, $3
	i32.store	$discard=, 0($0), $pop2
	return
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, g
	i32.store	$discard=, f($1), $pop0
	i32.const	$push3=, d
	i32.const	$push2=, e
	i32.const	$push1=, f
	call    	bar@FUNCTION, $pop3, $pop2, $pop1, $1
	i32.load	$0=, d($1)
	block   	.LBB2_5
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, .LBB2_5
# BB#1:                                 # %lor.lhs.false
	i32.load	$0=, 0($0)
	i32.const	$push7=, 0
	i32.eq  	$push8=, $0, $pop7
	br_if   	$pop8, .LBB2_5
# BB#2:                                 # %lor.lhs.false2
	i32.load	$0=, 0($0)
	i32.const	$push9=, 0
	i32.eq  	$push10=, $0, $pop9
	br_if   	$pop10, .LBB2_5
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push4=, 0($0)
	br_if   	$pop4, .LBB2_5
# BB#4:                                 # %if.end
	return  	$1
.LBB2_5:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.align	2
g:
	.skip	4
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	2
f:
	.skip	4
	.size	f, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.align	2
d:
	.skip	4
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.align	2
e:
	.skip	4
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
