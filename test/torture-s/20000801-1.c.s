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
	i32.add 	$2=, $0, $1
	block
	i32.const	$push10=, 1
	i32.lt_s	$push0=, $1, $pop10
	br_if   	$pop0, 0        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push1=, 3
	i32.add 	$push2=, $0, $pop1
	tee_local	$push14=, $1=, $pop2
	i32.load8_u	$3=, 0($pop14)
	i32.load8_u	$push3=, 0($0)
	i32.store8	$discard=, 0($1), $pop3
	i32.store8	$discard=, 0($0), $3
	i32.const	$push4=, 2
	i32.add 	$push5=, $0, $pop4
	tee_local	$push13=, $1=, $pop5
	i32.load8_u	$3=, 0($pop13)
	i32.const	$push12=, 1
	i32.add 	$push6=, $0, $pop12
	tee_local	$push11=, $4=, $pop6
	i32.load8_u	$push7=, 0($pop11)
	i32.store8	$discard=, 0($1), $pop7
	i32.store8	$discard=, 0($4), $3
	i32.const	$push8=, 4
	i32.add 	$0=, $0, $pop8
	i32.lt_u	$push9=, $0, $2
	br_if   	$pop9, 0        # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 2
	i32.const	$3=, 12
	i32.add 	$3=, $4, $3
	i32.or  	$push1=, $3, $pop0
	i32.const	$push2=, 0
	i32.store	$push3=, 12($4), $pop2
	i32.store8	$0=, 0($pop1):p2align=1, $pop3
	block
	i32.load	$push6=, 12($4)
	i32.const	$push4=, 1
	i32.store16	$push5=, 12($4):p2align=2, $pop4
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	$pop7, 0        # 0: down to label3
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
