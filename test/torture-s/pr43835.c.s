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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 4
	block
	i32.load	$push0=, 8($1)
	i32.ne  	$push1=, $pop0, $2
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %land.lhs.true
	i32.load	$1=, 0($1)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#2:                                 # %land.lhs.true1
	i32.const	$push2=, 2
	i32.add 	$push3=, $1, $pop2
	i32.load8_u	$push4=, 0($pop3)
	i32.and 	$push5=, $pop4, $2
	br_if   	$pop5, 0        # 0: down to label0
# BB#3:                                 # %if.then
	call    	Parrot_gc_mark_PMC_alive_fun@FUNCTION, $1, $1
	unreachable
.LBB2_4:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end2:
	.size	mark_cell, .Lfunc_end2-mark_cell

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$0=, 4
	i32.const	$4=, 0
	i32.add 	$4=, $7, $4
	i32.or  	$push2=, $4, $0
	i32.const	$push3=, 42
	i32.store	$discard=, 0($pop2), $pop3
	i32.store	$discard=, 8($7), $0
	i32.const	$5=, 12
	i32.add 	$5=, $7, $5
	i32.const	$6=, 0
	i32.add 	$6=, $7, $6
	call    	mark_cell@FUNCTION, $5, $6
	i32.const	$push0=, 0
	i32.store	$push1=, 0($7), $pop0
	i32.const	$3=, 16
	i32.add 	$7=, $7, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	return  	$pop1
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
