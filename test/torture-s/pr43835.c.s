	.text
	.file	"pr43835.c"
	.section	.text.Parrot_gc_mark_PMC_alive_fun,"ax",@progbits
	.hidden	Parrot_gc_mark_PMC_alive_fun # -- Begin function Parrot_gc_mark_PMC_alive_fun
	.globl	Parrot_gc_mark_PMC_alive_fun
	.type	Parrot_gc_mark_PMC_alive_fun,@function
Parrot_gc_mark_PMC_alive_fun:           # @Parrot_gc_mark_PMC_alive_fun
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	Parrot_gc_mark_PMC_alive_fun, .Lfunc_end0-Parrot_gc_mark_PMC_alive_fun
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	mark_cell@FUNCTION, $0, $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.mark_cell,"ax",@progbits
	.type	mark_cell,@function     # -- Begin function mark_cell
mark_cell:                              # @mark_cell
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.load	$push0=, 8($1)
	i32.const	$push1=, 4
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %land.lhs.true
	i32.load	$push9=, 0($1)
	tee_local	$push8=, $1=, $pop9
	i32.eqz 	$push10=, $pop8
	br_if   	0, $pop10       # 0: down to label1
# BB#2:                                 # %land.lhs.true1
	i32.const	$push3=, 2
	i32.add 	$push4=, $1, $pop3
	i32.load8_u	$push5=, 0($pop4)
	i32.const	$push6=, 4
	i32.and 	$push7=, $pop5, $pop6
	i32.eqz 	$push11=, $pop7
	br_if   	1, $pop11       # 1: down to label0
.LBB2_3:                                # %if.end
	end_block                       # label1:
	return
.LBB2_4:                                # %if.then
	end_block                       # label0:
	call    	Parrot_gc_mark_PMC_alive_fun@FUNCTION, $1, $1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	mark_cell, .Lfunc_end2-mark_cell
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$push13=, $pop3, $pop5
	tee_local	$push12=, $0=, $pop13
	i32.store	__stack_pointer($pop6), $pop12
	i32.const	$push0=, 4
	i32.store	8($0), $pop0
	i64.const	$push1=, 180388626432
	i64.store	0($0), $pop1
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	call    	mark_cell@FUNCTION, $pop11, $0
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
