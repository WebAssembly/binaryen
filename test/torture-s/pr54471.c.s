	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54471.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 32
	i32.sub 	$8=, $pop15, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $8
	block
	i32.const	$push20=, 0
	i32.eq  	$push21=, $3, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#1:
	i64.const	$5=, 0
	i64.const	$4=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	call    	__multi3@FUNCTION, $8, $1, $2, $4, $5
	i32.const	$push9=, 8
	i32.add 	$push0=, $8, $pop9
	i64.load	$5=, 0($pop0)
	i64.load	$4=, 0($8)
	i32.const	$6=, 16
	i32.add 	$6=, $8, $6
	call    	__multi3@FUNCTION, $6, $1, $2, $1, $2
	i32.const	$push8=, 8
	i32.const	$7=, 16
	i32.add 	$7=, $8, $7
	i32.add 	$push1=, $7, $pop8
	i64.load	$2=, 0($pop1)
	i64.load	$1=, 16($8)
	i32.const	$push7=, -1
	i32.add 	$3=, $3, $pop7
	br_if   	0, $3           # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i64.const	$push11=, 14348907
	i64.xor 	$push2=, $4, $pop11
	i64.or  	$push3=, $pop2, $5
	i64.const	$push10=, 0
	i64.ne  	$push4=, $pop3, $pop10
	br_if   	0, $pop4        # 0: down to label0
# BB#4:                                 # %if.end
	i64.const	$push13=, 14348907
	i64.store	$discard=, 0($0), $pop13
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push12=, 0
	i64.store	$discard=, 0($pop6), $pop12
	i32.const	$push18=, 32
	i32.add 	$8=, $8, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $8
	return
.LBB0_5:                                # %if.then
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $0
	i64.const	$push2=, 3
	i64.const	$push1=, 0
	i32.const	$push0=, 4
	call    	foo@FUNCTION, $0, $pop2, $pop1, $pop0
	i32.const	$push3=, 0
	i32.const	$push8=, 16
	i32.add 	$0=, $0, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $0
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
