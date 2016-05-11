	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54471.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64, i32
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 32
	i32.sub 	$push19=, $pop9, $pop10
	i32.store	$4=, 0($pop11), $pop19
	block
	i32.const	$push25=, 0
	i32.eq  	$push26=, $3, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i64.const	$6=, 0
	i64.const	$5=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	call    	__multi3@FUNCTION, $4, $1, $2, $5, $6
	i32.const	$push22=, 8
	i32.add 	$push0=, $4, $pop22
	i64.load	$6=, 0($pop0)
	i64.load	$5=, 0($4)
	i32.const	$push15=, 16
	i32.add 	$push16=, $4, $pop15
	call    	__multi3@FUNCTION, $pop16, $1, $2, $1, $2
	i32.const	$push17=, 16
	i32.add 	$push18=, $4, $pop17
	i32.const	$push21=, 8
	i32.add 	$push1=, $pop18, $pop21
	i64.load	$2=, 0($pop1)
	i64.load	$1=, 16($4)
	i32.const	$push20=, -1
	i32.add 	$3=, $3, $pop20
	br_if   	0, $3           # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i64.const	$push23=, 14348907
	i64.xor 	$push2=, $5, $pop23
	i64.or  	$push3=, $pop2, $6
	i64.eqz 	$push4=, $pop3
	i32.const	$push27=, 0
	i32.eq  	$push28=, $pop4, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#4:                                 # %if.end
	i64.const	$push24=, 14348907
	i64.store	$discard=, 0($0), $pop24
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push7=, 0
	i64.store	$discard=, 0($pop6), $pop7
	i32.const	$push14=, __stack_pointer
	i32.const	$push12=, 32
	i32.add 	$push13=, $4, $pop12
	i32.store	$discard=, 0($pop14), $pop13
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
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push11=, $pop5, $pop6
	i32.store	$push13=, 0($pop7), $pop11
	tee_local	$push12=, $0=, $pop13
	i64.const	$push2=, 3
	i64.const	$push1=, 0
	i32.const	$push0=, 4
	call    	foo@FUNCTION, $pop12, $pop2, $pop1, $pop0
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$discard=, 0($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
