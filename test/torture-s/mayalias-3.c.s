	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/mayalias-3.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$drop=, p($pop0), $0
	copy_local	$push1=, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push10=, $pop5, $pop6
	tee_local	$push9=, $0=, $pop10
	i32.const	$push0=, 10
	i32.store	$drop=, 12($pop9), $pop0
	i32.const	$push1=, 1
	i32.store16	$drop=, 12($0), $pop1
	i32.const	$push2=, 0
	i32.const	$push7=, 12
	i32.add 	$push8=, $0, $pop7
	i32.store	$drop=, p($pop2), $pop8
	i32.load	$push3=, 12($0)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$push16=, __stack_pointer($pop7), $pop13
	tee_local	$push15=, $1=, $pop16
	i32.const	$push0=, 10
	i32.store	$0=, 12($pop15), $pop0
	i32.const	$push1=, 1
	i32.store16	$drop=, 12($1), $pop1
	i32.const	$push14=, 0
	i32.const	$push11=, 12
	i32.add 	$push12=, $1, $pop11
	i32.store	$drop=, p($pop14), $pop12
	block
	i32.load	$push2=, 12($1)
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	i32.const	$push17=, 0
	return  	$pop17
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
