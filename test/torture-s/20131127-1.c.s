	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20131127-1.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, c
	i32.const	$push1=, 14
	call    	memcpy@FUNCTION, $0, $pop0, $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.fn2,"ax",@progbits
	.hidden	fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$16=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$16=, 0($11), $16
	i32.const	$0=, 1
	i32.const	$1=, 0
	i32.const	$7=, 8
	i32.const	$2=, 3
	i32.const	$3=, c+8
	i32.add 	$push8=, $3, $2
	i32.load8_u	$4=, 0($pop8)
	i32.const	$5=, 2
	i32.add 	$push10=, $3, $5
	i32.load8_u	$6=, 0($pop10)
	i32.const	$push6=, 12
	i32.const	$13=, 0
	i32.add 	$13=, $16, $13
	i32.add 	$push7=, $13, $pop6
	i32.const	$push0=, c+12
	i32.add 	$push1=, $pop0, $0
	i32.load8_u	$push2=, 0($pop1)
	i32.shl 	$push3=, $pop2, $7
	i32.load8_u	$push4=, c+12($1)
	i32.or  	$push5=, $pop3, $pop4
	i32.store16	$discard=, 0($pop7), $pop5
	i32.const	$14=, 0
	i32.add 	$14=, $16, $14
	i32.add 	$push20=, $14, $7
	i32.shl 	$push9=, $4, $7
	i32.or  	$push11=, $pop9, $6
	i32.const	$push12=, 16
	i32.shl 	$push13=, $pop11, $pop12
	i32.add 	$push14=, $3, $0
	i32.load8_u	$push15=, 0($pop14)
	i32.shl 	$push16=, $pop15, $7
	i32.load8_u	$push17=, c+8($1)
	i32.or  	$push18=, $pop16, $pop17
	i32.or  	$push19=, $pop13, $pop18
	i32.store	$discard=, 0($pop20), $pop19
	i32.const	$7=, c
	i64.const	$8=, 8
	i64.const	$9=, 16
	i32.const	$3=, 14
	i32.const	$push29=, 7
	i32.add 	$push30=, $7, $pop29
	i64.load8_u	$push31=, 0($pop30)
	i64.shl 	$push32=, $pop31, $8
	i32.const	$push33=, 6
	i32.add 	$push34=, $7, $pop33
	i64.load8_u	$push35=, 0($pop34)
	i64.or  	$push36=, $pop32, $pop35
	i64.shl 	$push37=, $pop36, $9
	i32.const	$push21=, 5
	i32.add 	$push22=, $7, $pop21
	i64.load8_u	$push23=, 0($pop22)
	i64.shl 	$push24=, $pop23, $8
	i32.const	$push25=, 4
	i32.add 	$push26=, $7, $pop25
	i64.load8_u	$push27=, 0($pop26)
	i64.or  	$push28=, $pop24, $pop27
	i64.or  	$push38=, $pop37, $pop28
	i64.const	$push39=, 32
	i64.shl 	$push40=, $pop38, $pop39
	i32.add 	$push41=, $7, $2
	i64.load8_u	$push42=, 0($pop41)
	i64.shl 	$push43=, $pop42, $8
	i32.add 	$push44=, $7, $5
	i64.load8_u	$push45=, 0($pop44)
	i64.or  	$push46=, $pop43, $pop45
	i64.shl 	$push47=, $pop46, $9
	i32.add 	$push48=, $7, $0
	i64.load8_u	$push49=, 0($pop48)
	i64.shl 	$push50=, $pop49, $8
	i64.load8_u	$push51=, c($1)
	i64.or  	$push52=, $pop50, $pop51
	i64.or  	$push53=, $pop47, $pop52
	i64.or  	$push54=, $pop40, $pop53
	i64.store	$discard=, 0($16), $pop54
	i32.const	$push55=, b
	i32.const	$15=, 0
	i32.add 	$15=, $16, $15
	call    	memcpy@FUNCTION, $pop55, $15, $3
	i32.store16	$discard=, a($1), $1
	i32.const	$push57=, d
	i32.const	$push56=, e
	call    	memcpy@FUNCTION, $pop57, $pop56, $3
	i32.const	$12=, 16
	i32.add 	$16=, $16, $12
	i32.const	$12=, __stack_pointer
	i32.store	$16=, 0($12), $16
	return
	.endfunc
.Lfunc_end1:
	.size	fn2, .Lfunc_end1-fn2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$16=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$16=, 0($11), $16
	i32.const	$0=, 1
	i32.const	$1=, 0
	i32.const	$7=, 8
	i32.const	$2=, 3
	i32.const	$3=, c+8
	i32.add 	$push8=, $3, $2
	i32.load8_u	$4=, 0($pop8)
	i32.const	$5=, 2
	i32.add 	$push10=, $3, $5
	i32.load8_u	$6=, 0($pop10)
	i32.const	$push6=, 12
	i32.const	$13=, 0
	i32.add 	$13=, $16, $13
	i32.add 	$push7=, $13, $pop6
	i32.const	$push0=, c+12
	i32.add 	$push1=, $pop0, $0
	i32.load8_u	$push2=, 0($pop1)
	i32.shl 	$push3=, $pop2, $7
	i32.load8_u	$push4=, c+12($1)
	i32.or  	$push5=, $pop3, $pop4
	i32.store16	$discard=, 0($pop7), $pop5
	i32.const	$14=, 0
	i32.add 	$14=, $16, $14
	i32.add 	$push20=, $14, $7
	i32.shl 	$push9=, $4, $7
	i32.or  	$push11=, $pop9, $6
	i32.const	$push12=, 16
	i32.shl 	$push13=, $pop11, $pop12
	i32.add 	$push14=, $3, $0
	i32.load8_u	$push15=, 0($pop14)
	i32.shl 	$push16=, $pop15, $7
	i32.load8_u	$push17=, c+8($1)
	i32.or  	$push18=, $pop16, $pop17
	i32.or  	$push19=, $pop13, $pop18
	i32.store	$discard=, 0($pop20), $pop19
	i32.const	$7=, c
	i64.const	$8=, 8
	i64.const	$9=, 16
	i32.const	$3=, 14
	i32.const	$push29=, 7
	i32.add 	$push30=, $7, $pop29
	i64.load8_u	$push31=, 0($pop30)
	i64.shl 	$push32=, $pop31, $8
	i32.const	$push33=, 6
	i32.add 	$push34=, $7, $pop33
	i64.load8_u	$push35=, 0($pop34)
	i64.or  	$push36=, $pop32, $pop35
	i64.shl 	$push37=, $pop36, $9
	i32.const	$push21=, 5
	i32.add 	$push22=, $7, $pop21
	i64.load8_u	$push23=, 0($pop22)
	i64.shl 	$push24=, $pop23, $8
	i32.const	$push25=, 4
	i32.add 	$push26=, $7, $pop25
	i64.load8_u	$push27=, 0($pop26)
	i64.or  	$push28=, $pop24, $pop27
	i64.or  	$push38=, $pop37, $pop28
	i64.const	$push39=, 32
	i64.shl 	$push40=, $pop38, $pop39
	i32.add 	$push41=, $7, $2
	i64.load8_u	$push42=, 0($pop41)
	i64.shl 	$push43=, $pop42, $8
	i32.add 	$push44=, $7, $5
	i64.load8_u	$push45=, 0($pop44)
	i64.or  	$push46=, $pop43, $pop45
	i64.shl 	$push47=, $pop46, $9
	i32.add 	$push48=, $7, $0
	i64.load8_u	$push49=, 0($pop48)
	i64.shl 	$push50=, $pop49, $8
	i64.load8_u	$push51=, c($1)
	i64.or  	$push52=, $pop50, $pop51
	i64.or  	$push53=, $pop47, $pop52
	i64.or  	$push54=, $pop40, $pop53
	i64.store	$discard=, 0($16), $pop54
	i32.const	$push55=, b
	i32.const	$15=, 0
	i32.add 	$15=, $16, $15
	call    	memcpy@FUNCTION, $pop55, $15, $3
	i32.const	$push58=, d
	i32.const	$push57=, e
	call    	memcpy@FUNCTION, $pop58, $pop57, $3
	i32.store16	$push56=, a($1), $1
	i32.const	$12=, 16
	i32.add 	$16=, $16, $12
	i32.const	$12=, __stack_pointer
	i32.store	$16=, 0($12), $16
	return  	$pop56
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	1
a:
	.int16	1                       # 0x1
	.size	a, 2

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
b:
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int16	0                       # 0x0
	.size	b, 14

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.skip	14
	.size	c, 14

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
d:
	.skip	14
	.size	d, 14

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.skip	14
	.size	e, 14


	.ident	"clang version 3.9.0 "
