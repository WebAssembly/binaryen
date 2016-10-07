	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080604-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	i32.eqz 	$push2=, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push15=, $pop3, $pop4
	tee_local	$push14=, $1=, $pop15
	i32.store	__stack_pointer($pop5), $pop14
	i32.const	$push9=, 12
	i32.add 	$push10=, $1, $pop9
	i32.const	$push0=, x
	i32.select	$push13=, $pop10, $pop0, $0
	tee_local	$push12=, $0=, $pop13
	i32.const	$push1=, .L.str
	i32.store	0($pop12), $pop1
	call    	foo@FUNCTION
	i32.const	$push11=, .L.str
	i32.store	0($0), $pop11
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.store	__stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, .L.str
	i32.store	x($pop1), $pop0
	call    	foo@FUNCTION
	i32.const	$push4=, 0
	i32.const	$push3=, .L.str
	i32.store	x($pop4), $pop3
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.skip	4
	.size	x, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Everything OK"
	.size	.L.str, 14


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
