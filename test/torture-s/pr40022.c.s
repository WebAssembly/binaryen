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
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.store	$discard=, 12($5), $0
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	#APP
	#NO_APP
	i32.const	$3=, 16
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, foo@FUNCTION, $1
	i32.store	$push4=, 0($0), $pop0
	tee_local	$push3=, $1=, $pop4
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop3, $pop7
	br_if   	0, $pop8        # 0: down to label0
.LBB1_1:                                # %while.cond.while.cond_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$0=, $1
	i32.load	$1=, 0($1)
	br_if   	0, $1           # 0: up to label1
.LBB1_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	block
	i32.call	$push1=, foo@FUNCTION, $2
	i32.store	$push6=, 0($0), $pop1
	tee_local	$push5=, $1=, $pop6
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop5, $pop9
	br_if   	0, $pop10       # 0: down to label3
.LBB1_3:                                # %while.cond2.while.cond2_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	copy_local	$0=, $1
	i32.load	$1=, 0($1)
	br_if   	0, $1           # 0: up to label4
.LBB1_4:                                # %while.end6
	end_loop                        # label5:
	end_block                       # label3:
	i32.call	$push2=, foo@FUNCTION, $3
	i32.store	$discard=, 0($0), $pop2
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, g
	i32.store	$discard=, f($pop1), $pop0
	i32.const	$push4=, d
	i32.const	$push3=, e
	i32.const	$push2=, f
	i32.const	$push10=, 0
	call    	bar@FUNCTION, $pop4, $pop3, $pop2, $pop10
	block
	i32.const	$push9=, 0
	i32.load	$push8=, d($pop9)
	tee_local	$push7=, $0=, $pop8
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop7, $pop15
	br_if   	0, $pop16       # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	i32.load	$push12=, 0($0)
	tee_local	$push11=, $0=, $pop12
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop11, $pop17
	br_if   	0, $pop18       # 0: down to label6
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push14=, 0($0)
	tee_local	$push13=, $0=, $pop14
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop13, $pop19
	br_if   	0, $pop20       # 0: down to label6
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push5=, 0($0)
	br_if   	0, $pop5        # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB2_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
	.p2align	2
g:
	.skip	4
	.size	g, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	4
	.size	f, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.skip	4
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.skip	4
	.size	e, 4


	.ident	"clang version 3.9.0 "
