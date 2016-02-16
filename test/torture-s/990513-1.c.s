	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990513-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 1024
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push13=, $0, $2
	tee_local	$push12=, $3=, $pop13
	i32.const	$push11=, -16
	i32.add 	$push6=, $pop12, $pop11
	i32.const	$push10=, -12
	i32.add 	$push4=, $3, $pop10
	i32.const	$push9=, -8
	i32.add 	$push2=, $3, $pop9
	i32.const	$push8=, -4
	i32.add 	$push0=, $3, $pop8
	i32.store	$push1=, 0($pop0), $1
	i32.store	$push3=, 0($pop2), $pop1
	i32.store	$push5=, 0($pop4), $pop3
	i32.store	$discard=, 0($pop6), $pop5
	i32.const	$push7=, -16
	i32.add 	$2=, $2, $pop7
	br_if   	0, $2           # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 1024
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$0=, 1024
	i32.const	$push0=, 0
	i32.const	$push8=, 1024
	i32.call	$discard=, memset@FUNCTION, $5, $pop0, $pop8
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$push14=, $5, $0
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, -16
	i32.add 	$push3=, $pop13, $pop12
	i32.const	$push11=, -8
	i32.add 	$push1=, $1, $pop11
	i64.const	$push10=, 25769803782
	i64.store	$push2=, 0($pop1):p2align=2, $pop10
	i64.store	$discard=, 0($pop3):p2align=2, $pop2
	i32.const	$push9=, -16
	i32.add 	$0=, $0, $pop9
	br_if   	0, $0           # 0: up to label2
# BB#2:                                 # %foo.exit
	end_loop                        # label3:
	block
	i32.load	$push4=, 0($5):p2align=4
	i32.const	$push5=, 6
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$4=, 1024
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop7
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
