	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54985.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	block   	
	i32.eqz 	$push8=, $1
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push1=, 4
	i32.add 	$4=, $0, $pop1
	i32.load	$0=, 0($0)
.LBB0_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push4=, -1
	i32.add 	$push3=, $1, $pop4
	tee_local	$push2=, $1=, $pop3
	i32.eqz 	$push9=, $pop2
	br_if   	1, $pop9        # 1: down to label0
# BB#3:                                 # %while.cond.while.body_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push7=, 0($4)
	tee_local	$push6=, $2=, $pop7
	i32.lt_s	$3=, $pop6, $0
	i32.const	$push5=, 4
	i32.add 	$push0=, $4, $pop5
	copy_local	$4=, $pop0
	copy_local	$0=, $2
	br_if   	0, $3           # 0: up to label1
# BB#4:
	end_loop
	i32.const	$5=, 1
.LBB0_5:                                # %cleanup
	end_block                       # label0:
	copy_local	$push10=, $5
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push14=, $pop5, $pop6
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop7), $pop13
	i64.const	$push0=, 4294967298
	i64.store	8($0), $pop0
	block   	
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push1=, 2
	i32.call	$push2=, foo@FUNCTION, $pop12, $pop1
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
