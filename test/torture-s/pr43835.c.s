	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43835.c"
	.section	.text.Parrot_gc_mark_PMC_alive_fun,"ax",@progbits
	.hidden	Parrot_gc_mark_PMC_alive_fun
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

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	mark_cell@FUNCTION, $0, $1
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.mark_cell,"ax",@progbits
	.type	mark_cell,@function
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
	i32.const	$push10=, 0
	i32.eq  	$push11=, $pop8, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#2:                                 # %land.lhs.true1
	i32.const	$push3=, 2
	i32.add 	$push4=, $1, $pop3
	i32.load8_u	$push5=, 0($pop4):p2align=1
	i32.const	$push6=, 4
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop7, $pop12
	br_if   	1, $pop13       # 1: down to label0
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push1=, 4
	i32.store	$discard=, 8($4):p2align=3, $pop1
	i64.const	$push0=, 180388626432
	i64.store	$discard=, 0($4), $pop0
	i32.const	$3=, 12
	i32.add 	$3=, $4, $3
	call    	mark_cell@FUNCTION, $3, $4
	i32.const	$push2=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop2
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
