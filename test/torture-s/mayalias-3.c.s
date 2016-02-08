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
	i32.store	$discard=, p($pop0), $0
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$push1=, 10
	i32.store	$discard=, 12($5), $pop1
	i32.const	$push2=, 1
	i32.store16	$discard=, 12($5):p2align=2, $pop2
	i32.load	$0=, 12($5)
	i32.const	$push0=, 0
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	i32.store	$discard=, p($pop0), $4
	i32.const	$3=, 16
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$6=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	i32.const	$push0=, 10
	i32.store	$0=, 12($6), $pop0
	i32.const	$push1=, 1
	i32.store16	$discard=, 12($6):p2align=2, $pop1
	i32.load	$1=, 12($6)
	i32.const	$push3=, 0
	i32.const	$5=, 12
	i32.add 	$5=, $6, $5
	i32.store	$discard=, p($pop3), $5
	block
	i32.eq  	$push2=, $1, $0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$4=, 16
	i32.add 	$6=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	return  	$pop4
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
