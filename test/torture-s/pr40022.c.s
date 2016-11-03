	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40022.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 16
	i32.sub 	$push5=, $pop1, $pop2
	tee_local	$push4=, $1=, $pop5
	i32.store	12($pop4), $0
	i32.const	$push3=, 12
	i32.add 	$1=, $1, $pop3
	#APP
	#NO_APP
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
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
	i32.call	$push2=, foo@FUNCTION, $1
	tee_local	$push1=, $1=, $pop2
	i32.store	0($0), $pop1
	block   	
	i32.eqz 	$push13=, $1
	br_if   	0, $pop13       # 0: down to label0
.LBB1_1:                                # %while.cond.while.cond_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	copy_local	$push6=, $1
	tee_local	$push5=, $0=, $pop6
	i32.load	$push4=, 0($pop5)
	tee_local	$push3=, $1=, $pop4
	br_if   	0, $pop3        # 0: up to label1
.LBB1_2:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.call	$push8=, foo@FUNCTION, $2
	tee_local	$push7=, $1=, $pop8
	i32.store	0($0), $pop7
	block   	
	i32.eqz 	$push14=, $1
	br_if   	0, $pop14       # 0: down to label2
.LBB1_3:                                # %while.cond2.while.cond2_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	copy_local	$push12=, $1
	tee_local	$push11=, $0=, $pop12
	i32.load	$push10=, 0($pop11)
	tee_local	$push9=, $1=, $pop10
	br_if   	0, $pop9        # 0: up to label3
.LBB1_4:                                # %while.end6
	end_loop
	end_block                       # label2:
	i32.call	$push0=, foo@FUNCTION, $3
	i32.store	0($0), $pop0
                                        # fallthrough-return
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
	i32.store	f($pop1), $pop0
	i32.const	$push4=, d
	i32.const	$push3=, e
	i32.const	$push2=, f
	i32.const	$push10=, 0
	call    	bar@FUNCTION, $pop4, $pop3, $pop2, $pop10
	block   	
	i32.const	$push9=, 0
	i32.load	$push8=, d($pop9)
	tee_local	$push7=, $0=, $pop8
	i32.eqz 	$push15=, $pop7
	br_if   	0, $pop15       # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.load	$push12=, 0($0)
	tee_local	$push11=, $0=, $pop12
	i32.eqz 	$push16=, $pop11
	br_if   	0, $pop16       # 0: down to label4
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push14=, 0($0)
	tee_local	$push13=, $0=, $pop14
	i32.eqz 	$push17=, $pop13
	br_if   	0, $pop17       # 0: down to label4
# BB#3:                                 # %lor.lhs.false6
	i32.load	$push5=, 0($0)
	br_if   	0, $pop5        # 0: down to label4
# BB#4:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB2_5:                                # %if.then
	end_block                       # label4:
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
