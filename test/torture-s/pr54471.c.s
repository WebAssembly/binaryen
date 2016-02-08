	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54471.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 32
	i32.sub 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i64.const	$5=, 0
	i64.const	$4=, 1
	block
	i32.const	$push14=, 0
	i32.eq  	$push15=, $3, $pop14
	br_if   	0, $pop15       # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	call    	__multi3@FUNCTION, $11, $1, $2, $4, $5
	i32.const	$push0=, 8
	i32.add 	$push1=, $11, $pop0
	i64.load	$5=, 0($pop1)
	i64.load	$4=, 0($11)
	i32.const	$9=, 16
	i32.add 	$9=, $11, $9
	call    	__multi3@FUNCTION, $9, $1, $2, $1, $2
	i32.const	$push9=, 8
	i32.const	$10=, 16
	i32.add 	$10=, $11, $10
	i32.add 	$push2=, $10, $pop9
	i64.load	$2=, 0($pop2)
	i64.load	$1=, 16($11)
	i32.const	$push3=, -1
	i32.add 	$3=, $3, $pop3
	br_if   	0, $3           # 0: up to label1
# BB#2:                                 # %for.end
	end_loop                        # label2:
	i64.const	$push11=, 14348907
	i64.xor 	$push4=, $4, $pop11
	i64.or  	$push5=, $pop4, $5
	i64.const	$push10=, 0
	i64.ne  	$push6=, $pop5, $pop10
	br_if   	0, $pop6        # 0: down to label0
# BB#3:                                 # %if.end
	i64.const	$push13=, 14348907
	i64.store	$discard=, 0($0), $pop13
	i32.const	$push7=, 8
	i32.add 	$push8=, $0, $pop7
	i64.const	$push12=, 0
	i64.store	$discard=, 0($pop8), $pop12
	i32.const	$8=, 32
	i32.add 	$11=, $11, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i64.const	$push2=, 3
	i64.const	$push1=, 0
	i32.const	$push0=, 4
	call    	foo@FUNCTION, $3, $pop2, $pop1, $pop0
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
