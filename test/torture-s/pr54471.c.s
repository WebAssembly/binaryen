	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54471.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 32
	i32.sub 	$6=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $6
	block
	i32.const	$push24=, 0
	i32.eq  	$push25=, $3, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#1:
	i64.const	$5=, 0
	i64.const	$4=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	call    	__multi3@FUNCTION, $6, $1, $2, $4, $5
	i32.const	$push10=, 8
	i32.add 	$push0=, $6, $pop10
	i64.load	$5=, 0($pop0)
	i64.load	$4=, 0($6)
	i32.const	$push20=, 16
	i32.add 	$push21=, $6, $pop20
	call    	__multi3@FUNCTION, $pop21, $1, $2, $1, $2
	i32.const	$push22=, 16
	i32.add 	$push23=, $6, $pop22
	i32.const	$push9=, 8
	i32.add 	$push1=, $pop23, $pop9
	i64.load	$2=, 0($pop1)
	i64.load	$1=, 16($6)
	i32.const	$push8=, -1
	i32.add 	$3=, $3, $pop8
	br_if   	0, $3           # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i64.const	$push11=, 14348907
	i64.xor 	$push2=, $4, $pop11
	i64.or  	$push3=, $pop2, $5
	i64.eqz 	$push4=, $pop3
	i32.const	$push26=, 0
	i32.eq  	$push27=, $pop4, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#4:                                 # %if.end
	i64.const	$push12=, 14348907
	i64.store	$discard=, 0($0), $pop12
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push7=, 0
	i64.store	$discard=, 0($pop6), $pop7
	i32.const	$push19=, __stack_pointer
	i32.const	$push17=, 32
	i32.add 	$push18=, $6, $pop17
	i32.store	$discard=, 0($pop19), $pop18
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
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
