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
	i32.add 	$push0=, $0, $2
	tee_local	$push13=, $3=, $pop0
	i32.const	$push12=, -16
	i32.add 	$push7=, $pop13, $pop12
	i32.const	$push11=, -12
	i32.add 	$push5=, $3, $pop11
	i32.const	$push10=, -8
	i32.add 	$push3=, $3, $pop10
	i32.const	$push9=, -4
	i32.add 	$push1=, $3, $pop9
	i32.store	$push2=, 0($pop1), $1
	i32.store	$push4=, 0($pop3), $pop2
	i32.store	$push6=, 0($pop5), $pop4
	i32.store	$discard=, 0($pop7), $pop6
	i32.const	$push8=, -16
	i32.add 	$2=, $2, $pop8
	br_if   	$2, 0           # 0: up to label0
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
	i32.const	$push9=, 1024
	i32.call	$discard=, memset@FUNCTION, $5, $pop0, $pop9
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$push1=, $5, $0
	tee_local	$push14=, $1=, $pop1
	i32.const	$push13=, -16
	i32.add 	$push4=, $pop14, $pop13
	i32.const	$push12=, -8
	i32.add 	$push2=, $1, $pop12
	i64.const	$push11=, 25769803782
	i64.store	$push3=, 0($pop2):p2align=2, $pop11
	i64.store	$discard=, 0($pop4):p2align=2, $pop3
	i32.const	$push10=, -16
	i32.add 	$0=, $0, $pop10
	br_if   	$0, 0           # 0: up to label2
# BB#2:                                 # %foo.exit
	end_loop                        # label3:
	block
	i32.load	$push5=, 0($5):p2align=4
	i32.const	$push6=, 6
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push8=, 0
	i32.const	$4=, 1024
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop8
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
