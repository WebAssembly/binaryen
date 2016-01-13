	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990513-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 1024
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$2=, $0, $5
	i32.const	$push0=, -4
	i32.add 	$push1=, $2, $pop0
	i32.store	$4=, 0($pop1), $1
	i32.const	$push2=, -8
	i32.add 	$push3=, $2, $pop2
	i32.store	$discard=, 0($pop3), $4
	i32.const	$push4=, -12
	i32.add 	$push5=, $2, $pop4
	i32.store	$3=, 0($pop5), $4
	i32.const	$4=, -16
	i32.add 	$push6=, $2, $4
	i32.store	$discard=, 0($pop6), $3
	i32.add 	$5=, $5, $4
	br_if   	$5, 0           # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 1024
	i32.sub 	$10=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$10=, 0($6), $10
	i32.const	$4=, 1024
	i32.const	$0=, 0
	i32.const	$8=, 0
	i32.add 	$8=, $10, $8
	call    	memset@FUNCTION, $8, $0, $4
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$9=, 0
	i32.add 	$9=, $10, $9
	i32.add 	$1=, $9, $4
	i32.const	$push0=, -4
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 6
	i32.store	$3=, 0($pop1), $pop2
	i32.const	$push3=, -8
	i32.add 	$push4=, $1, $pop3
	i32.store	$discard=, 0($pop4), $3
	i32.const	$push5=, -12
	i32.add 	$push6=, $1, $pop5
	i32.store	$2=, 0($pop6), $3
	i32.const	$3=, -16
	i32.add 	$push7=, $1, $3
	i32.store	$1=, 0($pop7), $2
	i32.add 	$4=, $4, $3
	br_if   	$4, 0           # 0: up to label2
# BB#2:                                 # %foo.exit
	end_loop                        # label3:
	block
	i32.load	$push8=, 0($10)
	i32.ne  	$push9=, $pop8, $1
	br_if   	$pop9, 0        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$7=, 1024
	i32.add 	$10=, $10, $7
	i32.const	$7=, __stack_pointer
	i32.store	$10=, 0($7), $10
	return  	$0
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
