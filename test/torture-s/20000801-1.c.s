	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000801-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push4=, 1
	i32.lt_s	$push0=, $1, $pop4
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.add 	$2=, $0, $1
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push16=, 3
	i32.add 	$push15=, $0, $pop16
	tee_local	$push14=, $1=, $pop15
	i32.load8_u	$3=, 0($pop14)
	i32.load8_u	$push1=, 0($0)
	i32.store8	$drop=, 0($1), $pop1
	i32.store8	$drop=, 0($0), $3
	i32.const	$push13=, 2
	i32.add 	$push12=, $0, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.load8_u	$3=, 0($pop11)
	i32.const	$push10=, 1
	i32.add 	$push9=, $0, $pop10
	tee_local	$push8=, $4=, $pop9
	i32.load8_u	$push2=, 0($pop8)
	i32.store8	$drop=, 0($1), $pop2
	i32.store8	$drop=, 0($4), $3
	i32.const	$push7=, 4
	i32.add 	$push6=, $0, $pop7
	tee_local	$push5=, $0=, $pop6
	i32.lt_u	$push3=, $pop5, $2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push10=, $pop7, $pop8
	i32.store	$push12=, __stack_pointer($pop9), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.const	$push2=, 0
	i32.store	$push0=, 12($1), $pop2
	i32.store8	$0=, 14($pop11), $pop0
	block
	i32.const	$push3=, 1
	i32.store16	$push1=, 12($1), $pop3
	i32.load	$push4=, 12($1)
	i32.ne  	$push5=, $pop1, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
