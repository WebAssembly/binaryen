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
	i32.load	$push1=, x($pop11)
	tee_local	$push10=, $1=, $pop1
	i32.const	$push2=, 10
	i32.add 	$push3=, $pop10, $pop2
	i32.store	$discard=, x($pop0), $pop3
	i32.trunc_u/f64	$push4=, $0
	i32.const	$push9=, 10
	i32.mul 	$push5=, $1, $pop9
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, 45
	i32.add 	$push8=, $pop6, $pop7
	return  	$pop8
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
	i32.load	$push1=, x($pop5)
	tee_local	$push4=, $0=, $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop4, $pop2
	i32.store	$discard=, x($pop0), $pop3
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	getval, .Lfunc_end1-getval

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.const	$push0=, 0
	i32.const	$push15=, 0
	i32.load	$push1=, x($pop15)
	tee_local	$push14=, $0=, $pop1
	i32.const	$push2=, 20
	i32.add 	$push3=, $pop14, $pop2
	i32.store	$discard=, x($pop0), $pop3
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 4
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i32.const	$push4=, 10
	i32.mul 	$push5=, $0, $pop4
	tee_local	$push13=, $0=, $pop5
	i32.add 	$push6=, $pop13, $0
	i32.const	$push7=, 207
	i32.add 	$push8=, $pop6, $pop7
	i32.store	$0=, 0($8), $pop8
	i32.const	$push10=, buf
	i32.const	$push9=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop10, $pop9
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.add 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	block
	i32.const	$push11=, 227
	i32.ne  	$push12=, $0, $pop11
	br_if   	$pop12, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$7=, 16
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
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
