	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980605-1.c"
	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	f64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, x($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push1=, 10
	i32.add 	$push2=, $pop9, $pop1
	i32.store	$discard=, x($pop0), $pop2
	i32.trunc_u/f64	$push3=, $0
	i32.const	$push8=, 10
	i32.mul 	$push4=, $1, $pop8
	i32.add 	$push5=, $pop3, $pop4
	i32.const	$push6=, 45
	i32.add 	$push7=, $pop5, $pop6
	return  	$pop7
	.endfunc
.Lfunc_end0:
	.size	f2, .Lfunc_end0-f2

	.section	.text.getval,"ax",@progbits
	.hidden	getval
	.globl	getval
	.type	getval,@function
getval:                                 # @getval
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, x($pop5)
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop3, $pop1
	i32.store	$discard=, x($pop0), $pop2
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	getval, .Lfunc_end1-getval

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, x($pop15)
	tee_local	$push13=, $0=, $pop14
	i32.const	$push1=, 20
	i32.add 	$push2=, $pop13, $pop1
	i32.store	$discard=, x($pop0), $pop2
	i32.const	$push3=, 10
	i32.mul 	$push12=, $0, $pop3
	tee_local	$push11=, $0=, $pop12
	i32.add 	$push4=, $pop11, $0
	i32.const	$push5=, 207
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$0=, 0($4):p2align=4, $pop6
	i32.const	$push8=, buf
	i32.const	$push7=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop8, $pop7, $4
	block
	i32.const	$push9=, 227
	i32.ne  	$push10=, $0, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	1                       # 0x1
	.size	x, 4

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
buf:
	.skip	10
	.size	buf, 10

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4


	.ident	"clang version 3.9.0 "
