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
	i64.store	$drop=, 0($0):p2align=2, $pop0
                                        # fallthrough-return
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
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 32
	i32.sub 	$push16=, $pop6, $pop7
	i32.store	$push18=, __stack_pointer($pop8), $pop16
	tee_local	$push17=, $3=, $pop18
	i32.load	$push1=, 4($1)
	i32.store	$2=, 20($pop17), $pop1
	i32.load	$1=, 0($1)
	i32.const	$push2=, 12
	i32.add 	$push3=, $3, $pop2
	i32.store	$drop=, 0($pop3), $2
	i32.store	$push0=, 16($3), $1
	i32.store	$drop=, 8($3), $pop0
	i32.const	$push12=, 24
	i32.add 	$push13=, $3, $pop12
	i32.const	$push14=, 8
	i32.add 	$push15=, $3, $pop14
	call    	foo@FUNCTION, $pop13, $pop15
	i64.load	$push4=, 24($3)
	i64.store	$drop=, 0($0):p2align=2, $pop4
	i32.const	$push11=, 0
	i32.const	$push9=, 32
	i32.add 	$push10=, $3, $pop9
	i32.store	$drop=, __stack_pointer($pop11), $pop10
                                        # fallthrough-return
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
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 32
	i32.sub 	$push20=, $pop10, $pop11
	i32.store	$push22=, __stack_pointer($pop12), $pop20
	tee_local	$push21=, $0=, $pop22
	i64.const	$push2=, 4767060206663237632
	i64.store	$push0=, 16($0), $pop2
	i64.store	$drop=, 8($pop21):p2align=2, $pop0
	i32.const	$push16=, 24
	i32.add 	$push17=, $0, $pop16
	i32.const	$push18=, 8
	i32.add 	$push19=, $0, $pop18
	call    	bar@FUNCTION, $pop17, $pop19
	block
	f32.load	$push4=, 24($0)
	f32.const	$push3=, 0x1.2p3
	f32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	f32.load	$push1=, 28($0)
	f32.const	$push6=, 0x1.5p5
	f32.ne  	$push7=, $pop1, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push15=, 0
	i32.const	$push13=, 32
	i32.add 	$push14=, $0, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
	return  	$pop8
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
