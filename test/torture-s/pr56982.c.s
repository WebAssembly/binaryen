	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56982.c"
	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	baz, .Lfunc_end0-baz

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.eqz 	$push6=, $pop0
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push1=, 1
	return  	$pop1
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push4=, env
	i32.call	$1=, setjmp@FUNCTION, $pop4
	#APP
	#NO_APP
	block   	
	br_if   	0, $1           # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push5=, env
	i32.const	$push3=, 42
	call    	longjmp@FUNCTION, $pop5, $pop3
	unreachable
.LBB1_4:                                # %if.then2
	end_block                       # label1:
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$push12=, $pop2, $pop4
	tee_local	$push11=, $2=, $pop12
	i32.store	__stack_pointer($pop5), $pop11
	i32.const	$push0=, 0
	i32.store	12($2), $pop0
	i32.const	$push9=, 12
	i32.add 	$push10=, $2, $pop9
	i32.call	$drop=, f@FUNCTION, $pop10
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $2, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push1=, 1
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	env,@object             # @env
	.section	.bss.env,"aw",@nobits
	.p2align	4
env:
	.skip	156
	.size	env, 156


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	setjmp, i32, i32
	.functype	exit, void, i32
	.functype	longjmp, void, i32, i32
