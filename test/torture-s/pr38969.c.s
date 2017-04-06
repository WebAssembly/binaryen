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
	i64.store	0($0):p2align=2, $pop0
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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 32
	i32.sub 	$push15=, $pop1, $pop3
	tee_local	$push14=, $3=, $pop15
	i32.store	__stack_pointer($pop4), $pop14
	i64.load	$push13=, 0($1):p2align=2
	tee_local	$push12=, $2=, $pop13
	i64.store	16($3), $pop12
	i64.store	8($3):p2align=2, $2
	i32.const	$push8=, 24
	i32.add 	$push9=, $3, $pop8
	i32.const	$push10=, 8
	i32.add 	$push11=, $3, $pop10
	call    	foo@FUNCTION, $pop9, $pop11
	i64.load	$push0=, 24($3)
	i64.store	0($0):p2align=2, $pop0
	i32.const	$push7=, 0
	i32.const	$push5=, 32
	i32.add 	$push6=, $3, $pop5
	i32.store	__stack_pointer($pop7), $pop6
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
	i32.const	$push11=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 32
	i32.sub 	$push21=, $pop8, $pop10
	tee_local	$push20=, $0=, $pop21
	i32.store	__stack_pointer($pop11), $pop20
	i64.const	$push1=, 4767060206663237632
	i64.store	16($0), $pop1
	i64.const	$push19=, 4767060206663237632
	i64.store	8($0):p2align=2, $pop19
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i32.const	$push17=, 8
	i32.add 	$push18=, $0, $pop17
	call    	bar@FUNCTION, $pop16, $pop18
	block   	
	f32.load	$push3=, 24($0)
	f32.const	$push2=, 0x1.2p3
	f32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %entry
	f32.load	$push0=, 28($0)
	f32.const	$push5=, 0x1.5p5
	f32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push14=, 0
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push7=, 0
	return  	$pop7
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
