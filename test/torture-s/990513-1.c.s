	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990513-1.c"
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
	loop    	                # label0:
	i32.add 	$push12=, $0, $3
	tee_local	$push11=, $2=, $pop12
	i32.const	$push10=, -8
	i32.add 	$push0=, $pop11, $pop10
	i32.store	0($pop0), $1
	i32.const	$push9=, -4
	i32.add 	$push1=, $2, $pop9
	i32.store	0($pop1), $1
	i32.const	$push8=, -12
	i32.add 	$push2=, $2, $pop8
	i32.store	0($pop2), $1
	i32.const	$push7=, -16
	i32.add 	$push3=, $2, $pop7
	i32.store	0($pop3), $1
	i32.const	$push6=, -16
	i32.add 	$push5=, $3, $pop6
	tee_local	$push4=, $3=, $pop5
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %while.end
	end_loop
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 1024
	i32.sub 	$push16=, $pop8, $pop9
	tee_local	$push15=, $1=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.const	$2=, 1024
	i32.const	$push0=, 0
	i32.const	$push14=, 1024
	i32.call	$0=, memset@FUNCTION, $1, $pop0, $pop14
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.add 	$push25=, $0, $2
	tee_local	$push24=, $1=, $pop25
	i32.const	$push23=, -8
	i32.add 	$push1=, $pop24, $pop23
	i64.const	$push22=, 25769803782
	i64.store	0($pop1):p2align=2, $pop22
	i32.const	$push21=, -16
	i32.add 	$push2=, $1, $pop21
	i64.const	$push20=, 25769803782
	i64.store	0($pop2):p2align=2, $pop20
	i32.const	$push19=, -16
	i32.add 	$push18=, $2, $pop19
	tee_local	$push17=, $2=, $pop18
	br_if   	0, $pop17       # 0: up to label1
# BB#2:                                 # %foo.exit
	end_loop
	block   	
	i32.load	$push4=, 0($0)
	i32.const	$push3=, 6
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 1024
	i32.add 	$push12=, $0, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
