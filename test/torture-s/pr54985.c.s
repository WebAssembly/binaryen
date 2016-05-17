	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54985.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.eqz 	$push9=, $1
	br_if   	0, $pop9        # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.load	$3=, 0($0)
	i32.const	$push3=, 4
	i32.add 	$0=, $0, $pop3
.LBB0_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push4=, -1
	i32.add 	$1=, $1, $pop4
	i32.eqz 	$push10=, $1
	br_if   	3, $pop10       # 3: down to label0
# BB#3:                                 # %while.cond.while.body_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push7=, 0($0)
	tee_local	$push6=, $4=, $pop7
	i32.lt_s	$2=, $pop6, $3
	i32.const	$push5=, 4
	i32.add 	$push0=, $0, $pop5
	copy_local	$0=, $pop0
	copy_local	$3=, $4
	br_if   	0, $2           # 0: up to label2
# BB#4:                                 # %cleanup
	end_loop                        # label3:
	i32.const	$push8=, 1
	return  	$pop8
.LBB0_5:
	end_block                       # label1:
	i32.const	$push2=, 0
	return  	$pop2
.LBB0_6:
	end_block                       # label0:
	i32.const	$push1=, 0
	return  	$pop1
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
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$push15=, 0($pop7), $pop13
	tee_local	$push14=, $0=, $pop15
	i64.const	$push0=, 4294967298
	i64.store	$discard=, 8($pop14), $pop0
	block
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push1=, 2
	i32.call	$push2=, foo@FUNCTION, $pop12, $pop1
	br_if   	0, $pop2        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
