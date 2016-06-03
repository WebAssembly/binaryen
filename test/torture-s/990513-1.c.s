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
	i32.const	$3=, 1024
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push15=, $0, $3
	tee_local	$push14=, $2=, $pop15
	i32.const	$push13=, -16
	i32.add 	$push6=, $pop14, $pop13
	i32.const	$push12=, -12
	i32.add 	$push5=, $2, $pop12
	i32.const	$push11=, -4
	i32.add 	$push4=, $2, $pop11
	i32.const	$push10=, -8
	i32.add 	$push3=, $2, $pop10
	i32.store	$push0=, 0($pop3), $1
	i32.store	$push1=, 0($pop4), $pop0
	i32.store	$push2=, 0($pop5), $pop1
	i32.store	$drop=, 0($pop6), $pop2
	i32.const	$push9=, -16
	i32.add 	$push8=, $3, $pop9
	tee_local	$push7=, $3=, $pop8
	br_if   	0, $pop7        # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 1024
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 1024
	i32.sub 	$push16=, $pop10, $pop11
	i32.store	$push1=, __stack_pointer($pop12), $pop16
	i32.const	$push2=, 0
	i32.const	$push17=, 1024
	i32.call	$0=, memset@FUNCTION, $pop1, $pop2, $pop17
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$push25=, $0, $2
	tee_local	$push24=, $1=, $pop25
	i32.const	$push23=, -16
	i32.add 	$push4=, $pop24, $pop23
	i32.const	$push22=, -8
	i32.add 	$push3=, $1, $pop22
	i64.const	$push21=, 25769803782
	i64.store	$push0=, 0($pop3):p2align=2, $pop21
	i64.store	$drop=, 0($pop4):p2align=2, $pop0
	i32.const	$push20=, -16
	i32.add 	$push19=, $2, $pop20
	tee_local	$push18=, $2=, $pop19
	br_if   	0, $pop18       # 0: up to label2
# BB#2:                                 # %foo.exit
	end_loop                        # label3:
	block
	i32.load	$push6=, 0($0)
	i32.const	$push5=, 6
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push15=, 0
	i32.const	$push13=, 1024
	i32.add 	$push14=, $0, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
