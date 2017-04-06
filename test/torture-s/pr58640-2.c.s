	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640-2.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.cond4.preheader.split
	i32.const	$push0=, 0
	i32.const	$push18=, 0
	i32.load	$push17=, a+36($pop18)
	tee_local	$push16=, $0=, $pop17
	i32.store	a($pop0), $pop16
	i32.const	$push15=, 0
	i32.store	a+4($pop15), $0
	i32.const	$push14=, 0
	i32.const	$push1=, 1
	i32.store	a($pop14), $pop1
	i32.const	$push13=, 0
	i32.const	$push12=, 1
	i32.store	a+4($pop13), $pop12
	i32.const	$push11=, 0
	i32.const	$push10=, 1
	i32.store	a+48($pop11), $pop10
	i32.const	$push9=, 0
	i32.const	$push8=, 1
	i32.store	c($pop9), $pop8
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, a+60($pop6)
	tee_local	$push4=, $0=, $pop5
	i32.store	a($pop7), $pop4
	i32.const	$push3=, 0
	i32.store	a+4($pop3), $0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push0=, 1
	i32.store	a+48($pop8), $pop0
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.store	c($pop7), $pop6
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, a+60($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.store	a($pop5), $pop2
	i32.const	$push1=, 0
	i32.store	a+4($pop1), $0
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	80
	.size	a, 80

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
