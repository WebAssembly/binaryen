	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33992.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
# BB#0:                                 # %entry
	block
	i64.eqz 	$push0=, $0
	i32.const	$push1=, 0
	i32.eq  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.do_test,"ax",@progbits
	.hidden	do_test
	.globl	do_test
	.type	do_test,@function
do_test:                                # @do_test
	.param  	i32
	.local  	i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.load	$1=, 0($0)
	i64.const	$3=, 63
	i64.const	$4=, -1
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.const	$push15=, 4294967295
	i64.and 	$2=, $3, $pop15
	i64.const	$push14=, 1
	i64.add 	$4=, $4, $pop14
	i64.const	$push13=, -1
	i64.add 	$3=, $3, $pop13
	i64.const	$push12=, 1
	i64.shl 	$push0=, $pop12, $2
	i64.and 	$push1=, $pop0, $1
	i64.eqz 	$push2=, $pop1
	br_if   	0, $pop2        # 0: up to label1
# BB#2:                                 # %foo.exit
	end_loop                        # label2:
	i64.const	$push3=, 32
	i64.shl 	$push4=, $4, $pop3
	i64.const	$push16=, 32
	i64.shr_s	$push5=, $pop4, $pop16
	call    	bar@FUNCTION, $pop5
	i64.load	$1=, 0($0)
	i64.const	$3=, 63
	i64.const	$4=, -1
.LBB1_3:                                # %for.cond.i.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i64.const	$push20=, 4294967295
	i64.and 	$2=, $3, $pop20
	i64.const	$push19=, 1
	i64.add 	$4=, $4, $pop19
	i64.const	$push18=, -1
	i64.add 	$3=, $3, $pop18
	i64.const	$push17=, 1
	i64.shl 	$push6=, $pop17, $2
	i64.and 	$push7=, $pop6, $1
	i64.eqz 	$push8=, $pop7
	br_if   	0, $pop8        # 0: up to label3
# BB#4:                                 # %foo.exit.1
	end_loop                        # label4:
	i64.const	$push9=, 32
	i64.shl 	$push10=, $4, $pop9
	i64.const	$push21=, 32
	i64.shr_s	$push11=, $pop10, $pop21
	call    	bar@FUNCTION, $pop11
	return
	.endfunc
.Lfunc_end1:
	.size	do_test, .Lfunc_end1-do_test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push11=, $pop3, $pop4
	i32.store	$push13=, 0($pop5), $pop11
	tee_local	$push12=, $0=, $pop13
	i64.const	$push0=, -9223372036854775807
	i64.store	$discard=, 8($pop12), $pop0
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	call    	do_test@FUNCTION, $pop10
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	$discard=, 0($pop8), $pop7
	i32.const	$push1=, 0
	return  	$pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
