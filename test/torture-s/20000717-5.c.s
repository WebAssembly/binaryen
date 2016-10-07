	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000717-5.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($3)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 4($3)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.const	$push7=, 6
	i32.ne  	$push8=, $2, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %lor.lhs.false2
	i32.const	$push9=, 5
	i32.ne  	$push10=, $1, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#4:                                 # %lor.lhs.false2
	i32.const	$push11=, 4
	i32.ne  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#5:                                 # %lor.lhs.false2
	i32.load	$push6=, 8($3)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop6, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#6:                                 # %if.end
	return  	$3
.LBB0_7:                                # %if.then
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
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push1=, 0($0)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop0, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %lor.lhs.false2.i
	i32.const	$push7=, 6
	i32.ne  	$push8=, $3, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#3:                                 # %lor.lhs.false2.i
	i32.const	$push9=, 5
	i32.ne  	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#4:                                 # %lor.lhs.false2.i
	i32.const	$push11=, 4
	i32.ne  	$push12=, $1, $pop11
	br_if   	0, $pop12       # 0: down to label1
# BB#5:                                 # %lor.lhs.false2.i
	i32.load	$push6=, 8($0)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop6, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#6:                                 # %bar.exit
	return  	$0
.LBB1_7:                                # %if.then.i
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
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push17=, $pop9, $pop10
	tee_local	$push16=, $0=, $pop17
	i32.store	__stack_pointer($pop11), $pop16
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.t+8($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push15=, 0
	i64.load	$push4=, .Lmain.t($pop15):p2align=2
	i64.store	4($0):p2align=2, $pop4
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	i32.const	$push7=, 4
	i32.const	$push6=, 5
	i32.const	$push5=, 6
	i32.call	$drop=, foo@FUNCTION, $pop13, $pop7, $pop6, $pop5
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
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
