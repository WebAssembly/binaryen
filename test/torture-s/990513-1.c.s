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
	i32.add 	$push5=, $3, $pop10
	i32.const	$push9=, -8
	i32.add 	$push4=, $3, $pop9
	i32.const	$push8=, -4
	i32.add 	$push3=, $3, $pop8
	i32.store	$push0=, 0($pop3), $1
	i32.store	$push1=, 0($pop4), $pop0
	i32.store	$push2=, 0($pop5), $pop1
	i32.store	$discard=, 0($pop6), $pop2
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 1024
	i32.const	$push12=, __stack_pointer
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 1024
	i32.sub 	$push16=, $pop10, $pop11
	i32.store	$push1=, 0($pop12), $pop16
	i32.const	$push2=, 0
	i32.const	$push17=, 1024
	i32.call	$0=, memset@FUNCTION, $pop1, $pop2, $pop17
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.add 	$push23=, $0, $1
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, -16
	i32.add 	$push4=, $pop22, $pop21
	i32.const	$push20=, -8
	i32.add 	$push3=, $2, $pop20
	i64.const	$push19=, 25769803782
	i64.store	$push0=, 0($pop3):p2align=2, $pop19
	i64.store	$discard=, 0($pop4):p2align=2, $pop0
	i32.const	$push18=, -16
	i32.add 	$1=, $1, $pop18
	br_if   	0, $1           # 0: up to label2
# BB#2:                                 # %foo.exit
	end_loop                        # label3:
	block
	i32.load	$push5=, 0($0)
	i32.const	$push6=, 6
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 1024
	i32.add 	$push14=, $0, $pop13
	i32.store	$discard=, 0($pop15), $pop14
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
