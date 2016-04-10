	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38969.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop0
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 32
	i32.sub 	$3=, $pop6, $pop7
	i32.const	$push8=, __stack_pointer
	i32.store	$discard=, 0($pop8), $3
	i32.load	$2=, 4($1)
	i32.load	$push0=, 0($1)
	i32.store	$1=, 16($3):p2align=3, $pop0
	i32.const	$push12=, 8
	i32.add 	$push13=, $3, $pop12
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop13, $pop2
	i32.store	$push1=, 20($3), $2
	i32.store	$discard=, 0($pop3), $pop1
	i32.store	$discard=, 8($3), $1
	i32.const	$push14=, 24
	i32.add 	$push15=, $3, $pop14
	i32.const	$push16=, 8
	i32.add 	$push17=, $3, $pop16
	call    	foo@FUNCTION, $pop15, $pop17
	i64.load	$push4=, 24($3)
	i64.store	$discard=, 0($0):p2align=2, $pop4
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 32
	i32.add 	$push10=, $3, $pop9
	i32.store	$discard=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 32
	i32.sub 	$0=, $pop10, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $0
	i64.const	$push1=, 4767060206663237632
	i64.store	$push2=, 16($0), $pop1
	i64.store	$discard=, 8($0):p2align=2, $pop2
	i32.const	$push16=, 24
	i32.add 	$push17=, $0, $pop16
	i32.const	$push18=, 8
	i32.add 	$push19=, $0, $pop18
	call    	bar@FUNCTION, $pop17, $pop19
	block
	f32.load	$push3=, 24($0):p2align=3
	f32.const	$push4=, 0x1.2p3
	f32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	f32.load	$push0=, 28($0)
	f32.const	$push6=, 0x1.5p5
	f32.ne  	$push7=, $pop0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push8=, 0
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 32
	i32.add 	$push14=, $0, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	return  	$pop8
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
