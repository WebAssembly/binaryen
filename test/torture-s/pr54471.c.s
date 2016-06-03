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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 32
	i32.sub 	$push19=, $pop9, $pop10
	i32.store	$4=, __stack_pointer($pop11), $pop19
	block
	i32.eqz 	$push27=, $3
	br_if   	0, $pop27       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i64.const	$6=, 0
	i64.const	$5=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	call    	__multi3@FUNCTION, $4, $1, $2, $5, $6
	i32.const	$push15=, 16
	i32.add 	$push16=, $4, $pop15
	call    	__multi3@FUNCTION, $pop16, $1, $2, $1, $2
	i32.const	$push17=, 16
	i32.add 	$push18=, $4, $pop17
	i32.const	$push24=, 8
	i32.add 	$push0=, $pop18, $pop24
	i64.load	$2=, 0($pop0)
	i32.const	$push23=, 8
	i32.add 	$push1=, $4, $pop23
	i64.load	$6=, 0($pop1)
	i64.load	$1=, 16($4)
	i64.load	$5=, 0($4)
	i32.const	$push22=, -1
	i32.add 	$push21=, $3, $pop22
	tee_local	$push20=, $3=, $pop21
	br_if   	0, $pop20       # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i64.const	$push25=, 14348907
	i64.xor 	$push2=, $5, $pop25
	i64.or  	$push3=, $pop2, $6
	i64.eqz 	$push4=, $pop3
	i32.eqz 	$push28=, $pop4
	br_if   	0, $pop28       # 0: down to label0
# BB#4:                                 # %if.end
	i64.const	$push26=, 14348907
	i64.store	$drop=, 0($0), $pop26
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push7=, 0
	i64.store	$drop=, 0($pop6), $pop7
	i32.const	$push14=, 0
	i32.const	$push12=, 32
	i32.add 	$push13=, $4, $pop12
	i32.store	$drop=, __stack_pointer($pop14), $pop13
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
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push11=, $pop5, $pop6
	i32.store	$push13=, __stack_pointer($pop7), $pop11
	tee_local	$push12=, $0=, $pop13
	i64.const	$push2=, 3
	i64.const	$push1=, 0
	i32.const	$push0=, 4
	call    	foo@FUNCTION, $pop12, $pop2, $pop1, $pop0
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
