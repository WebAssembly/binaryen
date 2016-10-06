	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000717-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push5=, 0($1)
	tee_local	$push4=, $2=, $pop5
	i32.load	$push0=, 4($1)
	i32.eq  	$push1=, $pop4, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push2=, 8($1)
	i32.eq  	$push3=, $2, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	return  	$1
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push5=, 0($0)
	tee_local	$push4=, $2=, $pop5
	i32.load	$push1=, 4($0)
	i32.eq  	$push2=, $pop4, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %entry
	i32.load	$push0=, 8($0)
	i32.eq  	$push3=, $2, $pop0
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %bar.exit
	return  	$0
.LBB1_3:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop6, $pop7
	tee_local	$push13=, $0=, $pop14
	i32.store	__stack_pointer($pop8), $pop13
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.t+8($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push12=, 0
	i64.load	$push4=, .Lmain.t($pop12):p2align=2
	i64.store	4($0):p2align=2, $pop4
	i32.const	$push9=, 4
	i32.add 	$push10=, $0, $pop9
	i32.call	$drop=, foo@FUNCTION, $pop10, $0
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lmain.t,@object        # @main.t
	.section	.rodata..Lmain.t,"a",@progbits
	.p2align	2
.Lmain.t:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	.Lmain.t, 12


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
