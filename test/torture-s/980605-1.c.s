	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980605-1.c"
	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	f64
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, x($1)
	i32.const	$3=, 10
	i32.add 	$push0=, $2, $3
	i32.store	$discard=, x($1), $pop0
	i32.trunc_u/f64	$push1=, $0
	i32.mul 	$push2=, $2, $3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 45
	i32.add 	$push5=, $pop3, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end0:
	.size	f2, .Lfunc_end0-f2

	.section	.text.getval,"ax",@progbits
	.hidden	getval
	.globl	getval
	.type	getval,@function
getval:                                 # @getval
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, x($0)
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, x($0), $pop1
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	getval, .Lfunc_end1-getval

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$10=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.const	$0=, 0
	i32.load	$1=, x($0)
	i32.const	$2=, 20
	i32.add 	$push0=, $1, $2
	i32.store	$discard=, x($0), $pop0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$10=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$10=, 0($4), $10
	i32.mul 	$push1=, $1, $2
	i32.const	$push2=, 207
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$0=, 0($10), $pop3
	i32.const	$push5=, buf
	i32.const	$push4=, .L.str
	i32.call	$discard=, siprintf@FUNCTION, $pop5, $pop4
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$10=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$10=, 0($6), $10
	block
	i32.const	$push6=, 227
	i32.ne  	$push7=, $0, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$9=, 16
	i32.add 	$10=, $10, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$9=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
	i32.const	$0=, 0
	i32.load	$1=, x($0)
	i32.const	$2=, 20
	i32.add 	$push0=, $1, $2
	i32.store	$discard=, x($0), $pop0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$9=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$9=, 0($4), $9
	i32.mul 	$push1=, $1, $2
	i32.const	$push2=, 207
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$1=, 0($9), $pop3
	i32.const	$push5=, buf
	i32.const	$push4=, .L.str
	i32.call	$discard=, siprintf@FUNCTION, $pop5, $pop4
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$9=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	block
	i32.const	$push6=, 227
	i32.ne  	$push7=, $1, $pop6
	br_if   	$pop7, 0        # 0: down to label1
# BB#1:                                 # %f.exit
	call    	exit@FUNCTION, $0
	unreachable
.LBB3_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	2
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
