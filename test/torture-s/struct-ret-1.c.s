	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ret-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f64, i32
	.local  	f64, i64, i32, f64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 64
	i32.sub 	$10=, $pop29, $pop30
	i32.const	$push31=, __stack_pointer
	i32.store	$discard=, 0($pop31), $10
	i32.const	$push2=, 16
	i32.add 	$push3=, $1, $pop2
	i32.load	$7=, 0($pop3)
	i64.load	$6=, 8($1)
	i64.load	$9=, 8($4)
	f64.load	$5=, 0($1)
	f64.load	$8=, 0($4)
	i32.const	$push7=, 48
	i32.add 	$push8=, $10, $pop7
	i32.const	$push27=, 16
	i32.add 	$push5=, $4, $pop27
	i32.load	$push6=, 0($pop5)
	i32.store	$discard=, 0($pop8), $pop6
	i32.const	$push9=, 44
	i32.add 	$push10=, $10, $pop9
	i64.const	$push0=, 32
	i64.shr_u	$push4=, $9, $pop0
	i64.store32	$discard=, 0($pop10), $pop4
	i32.const	$push11=, 40
	i32.add 	$push12=, $10, $pop11
	i64.store32	$discard=, 0($pop12), $9
	i32.const	$push13=, 32
	i32.add 	$push14=, $10, $pop13
	f64.store	$discard=, 0($pop14), $8
	i32.const	$push15=, 24
	i32.add 	$push16=, $10, $pop15
	f64.store	$discard=, 0($pop16), $3
	i32.const	$push17=, 20
	i32.add 	$push18=, $10, $pop17
	i32.store	$4=, 0($pop18), $2
	i32.const	$push26=, 16
	i32.add 	$push19=, $10, $pop26
	i32.store	$discard=, 0($pop19), $7
	i64.const	$push25=, 32
	i64.shr_u	$push1=, $6, $pop25
	i64.store32	$discard=, 12($10), $pop1
	i64.store32	$discard=, 8($10), $6
	f64.store	$discard=, 0($10), $5
	i32.const	$push21=, out
	i32.const	$push20=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop21, $pop20, $10
	i32.const	$push22=, f.xr
	i32.const	$push23=, 33
	i32.call	$push24=, memcpy@FUNCTION, $0, $pop22, $pop23
	i32.store8	$discard=, 33($pop24), $4
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 64
	i32.add 	$push33=, $10, $pop32
	i32.store	$discard=, 0($pop34), $pop33
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f64, i64, f64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push66=, __stack_pointer
	i32.load	$push67=, 0($pop66)
	i32.const	$push68=, 256
	i32.sub 	$7=, $pop67, $pop68
	i32.const	$push69=, __stack_pointer
	i32.store	$discard=, 0($pop69), $7
	i32.const	$push64=, 0
	f64.load	$0=, d3($pop64)
	i32.const	$push63=, 0
	i64.load	$2=, B2+8($pop63)
	i32.const	$push62=, 0
	i64.load	$4=, B1+8($pop62)
	i32.const	$push61=, 0
	i32.load	$5=, B1+16($pop61)
	i32.const	$push60=, 0
	i32.load8_s	$6=, c2($pop60)
	i32.const	$push59=, 0
	f64.load	$1=, B2($pop59)
	i32.const	$push58=, 0
	f64.load	$3=, B1($pop58)
	i32.const	$push70=, 48
	i32.add 	$push71=, $7, $pop70
	i32.const	$push4=, 48
	i32.add 	$push5=, $pop71, $pop4
	i32.const	$push57=, 0
	i32.load	$push0=, B2+16($pop57)
	i32.store	$discard=, 0($pop5), $pop0
	i32.const	$push72=, 48
	i32.add 	$push73=, $7, $pop72
	i32.const	$push6=, 40
	i32.add 	$push7=, $pop73, $pop6
	i64.store32	$discard=, 0($pop7), $2
	i32.const	$push74=, 48
	i32.add 	$push75=, $7, $pop74
	i32.const	$push8=, 32
	i32.add 	$push9=, $pop75, $pop8
	f64.store	$discard=, 0($pop9), $1
	i32.const	$push76=, 48
	i32.add 	$push77=, $7, $pop76
	i32.const	$push10=, 24
	i32.add 	$push11=, $pop77, $pop10
	f64.store	$discard=, 0($pop11), $0
	i32.const	$push78=, 48
	i32.add 	$push79=, $7, $pop78
	i32.const	$push12=, 20
	i32.add 	$push13=, $pop79, $pop12
	i32.store	$discard=, 0($pop13), $6
	i32.const	$push80=, 48
	i32.add 	$push81=, $7, $pop80
	i32.const	$push14=, 16
	i32.add 	$push15=, $pop81, $pop14
	i32.store	$discard=, 0($pop15), $5
	i32.const	$push82=, 48
	i32.add 	$push83=, $7, $pop82
	i32.const	$push16=, 44
	i32.add 	$push17=, $pop83, $pop16
	i64.const	$push1=, 32
	i64.shr_u	$push3=, $2, $pop1
	i64.store32	$discard=, 0($pop17), $pop3
	i64.store32	$discard=, 56($7), $4
	f64.store	$discard=, 48($7), $3
	i64.const	$push56=, 32
	i64.shr_u	$push2=, $4, $pop56
	i64.store32	$discard=, 60($7), $pop2
	i32.const	$push19=, out
	i32.const	$push18=, .L.str
	i32.const	$push84=, 48
	i32.add 	$push85=, $7, $pop84
	i32.call	$discard=, sprintf@FUNCTION, $pop19, $pop18, $pop85
	i32.const	$push86=, 144
	i32.add 	$push87=, $7, $pop86
	i32.const	$push55=, out
	i32.call	$discard=, strcpy@FUNCTION, $pop87, $pop55
	i32.const	$push54=, 0
	f64.load	$0=, d3($pop54)
	i32.const	$push53=, 0
	i32.load	$5=, fp($pop53)
	i32.const	$push88=, 24
	i32.add 	$push89=, $7, $pop88
	i32.const	$push52=, 20
	i32.add 	$push20=, $pop89, $pop52
	i32.const	$push51=, 0
	i32.load	$push21=, B1+20($pop51)
	i32.store	$discard=, 0($pop20), $pop21
	i32.const	$push90=, 24
	i32.add 	$push91=, $7, $pop90
	i32.const	$push50=, 16
	i32.add 	$push22=, $pop91, $pop50
	i32.const	$push49=, 0
	i32.load	$push23=, B1+16($pop49)
	i32.store	$discard=, 0($pop22), $pop23
	i32.const	$push92=, 24
	i32.add 	$push93=, $7, $pop92
	i32.const	$push24=, 12
	i32.add 	$push25=, $pop93, $pop24
	i32.const	$push48=, 0
	i32.load	$push26=, B1+12($pop48)
	i32.store	$discard=, 0($pop25), $pop26
	i32.const	$push94=, 24
	i32.add 	$push95=, $7, $pop94
	i32.const	$push27=, 8
	i32.add 	$push28=, $pop95, $pop27
	i32.const	$push47=, 0
	i32.load	$push29=, B1+8($pop47)
	i32.store	$discard=, 0($pop28), $pop29
	i32.const	$push46=, 0
	i32.load	$push30=, B1+4($pop46)
	i32.store	$discard=, 28($7), $pop30
	i32.const	$push45=, 0
	i32.load	$push31=, B1($pop45)
	i32.store	$discard=, 24($7), $pop31
	i32.const	$push44=, 0
	i32.load8_s	$6=, c2($pop44)
	i32.const	$push43=, 16
	i32.add 	$push32=, $7, $pop43
	i32.const	$push42=, 0
	i64.load	$push33=, B2+16($pop42)
	i64.store	$discard=, 0($pop32), $pop33
	i32.const	$push41=, 8
	i32.add 	$push34=, $7, $pop41
	i32.const	$push40=, 0
	i64.load	$push35=, B2+8($pop40)
	i64.store	$discard=, 0($pop34), $pop35
	i32.const	$push39=, 0
	i64.load	$push36=, B2($pop39)
	i64.store	$discard=, 0($7), $pop36
	i32.const	$push96=, 104
	i32.add 	$push97=, $7, $pop96
	i32.const	$push98=, 24
	i32.add 	$push99=, $7, $pop98
	call_indirect	$5, $pop97, $pop99, $6, $0, $7
	block
	i32.const	$push100=, 144
	i32.add 	$push101=, $7, $pop100
	i32.const	$push38=, out
	i32.call	$push37=, strcmp@FUNCTION, $pop101, $pop38
	br_if   	0, $pop37       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push65=, 0
	call    	exit@FUNCTION, $pop65
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	c1                      # @c1
	.type	c1,@object
	.section	.data.c1,"aw",@progbits
	.globl	c1
c1:
	.int8	97                      # 0x61
	.size	c1, 1

	.hidden	c2                      # @c2
	.type	c2,@object
	.section	.data.c2,"aw",@progbits
	.globl	c2
c2:
	.int8	127                     # 0x7f
	.size	c2, 1

	.hidden	c3                      # @c3
	.type	c3,@object
	.section	.data.c3,"aw",@progbits
	.globl	c3
c3:
	.int8	128                     # 0x80
	.size	c3, 1

	.hidden	c4                      # @c4
	.type	c4,@object
	.section	.data.c4,"aw",@progbits
	.globl	c4
c4:
	.int8	255                     # 0xff
	.size	c4, 1

	.hidden	c5                      # @c5
	.type	c5,@object
	.section	.data.c5,"aw",@progbits
	.globl	c5
c5:
	.int8	255                     # 0xff
	.size	c5, 1

	.hidden	d1                      # @d1
	.type	d1,@object
	.section	.data.d1,"aw",@progbits
	.globl	d1
	.p2align	3
d1:
	.int64	4591870180066957722     # double 0.10000000000000001
	.size	d1, 8

	.hidden	d2                      # @d2
	.type	d2,@object
	.section	.data.d2,"aw",@progbits
	.globl	d2
	.p2align	3
d2:
	.int64	4596373779694328218     # double 0.20000000000000001
	.size	d2, 8

	.hidden	d3                      # @d3
	.type	d3,@object
	.section	.data.d3,"aw",@progbits
	.globl	d3
	.p2align	3
d3:
	.int64	4599075939470750515     # double 0.29999999999999999
	.size	d3, 8

	.hidden	d4                      # @d4
	.type	d4,@object
	.section	.data.d4,"aw",@progbits
	.globl	d4
	.p2align	3
d4:
	.int64	4600877379321698714     # double 0.40000000000000002
	.size	d4, 8

	.hidden	d5                      # @d5
	.type	d5,@object
	.section	.data.d5,"aw",@progbits
	.globl	d5
	.p2align	3
d5:
	.int64	4602678819172646912     # double 0.5
	.size	d5, 8

	.hidden	d6                      # @d6
	.type	d6,@object
	.section	.data.d6,"aw",@progbits
	.globl	d6
	.p2align	3
d6:
	.int64	4603579539098121011     # double 0.59999999999999998
	.size	d6, 8

	.hidden	d7                      # @d7
	.type	d7,@object
	.section	.data.d7,"aw",@progbits
	.globl	d7
	.p2align	3
d7:
	.int64	4604480259023595110     # double 0.69999999999999996
	.size	d7, 8

	.hidden	d8                      # @d8
	.type	d8,@object
	.section	.data.d8,"aw",@progbits
	.globl	d8
	.p2align	3
d8:
	.int64	4605380978949069210     # double 0.80000000000000004
	.size	d8, 8

	.hidden	d9                      # @d9
	.type	d9,@object
	.section	.data.d9,"aw",@progbits
	.globl	d9
	.p2align	3
d9:
	.int64	4606281698874543309     # double 0.90000000000000002
	.size	d9, 8

	.hidden	B1                      # @B1
	.type	B1,@object
	.section	.data.B1,"aw",@progbits
	.globl	B1
	.p2align	3
B1:
	.int64	4591870180066957722     # double 0.10000000000000001
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.skip	4
	.size	B1, 24

	.hidden	B2                      # @B2
	.type	B2,@object
	.section	.data.B2,"aw",@progbits
	.globl	B2
	.p2align	3
B2:
	.int64	4596373779694328218     # double 0.20000000000000001
	.int32	5                       # 0x5
	.int32	4                       # 0x4
	.int32	3                       # 0x3
	.skip	4
	.size	B2, 24

	.hidden	X1                      # @X1
	.type	X1,@object
	.section	.data.X1,"aw",@progbits
	.globl	X1
X1:
	.asciz	"abcdefghijklmnopqrstuvwxyzABCDEF"
	.int8	71                      # 0x47
	.size	X1, 34

	.hidden	X2                      # @X2
	.type	X2,@object
	.section	.data.X2,"aw",@progbits
	.globl	X2
X2:
	.asciz	"123\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.int8	57                      # 0x39
	.size	X2, 34

	.hidden	X3                      # @X3
	.type	X3,@object
	.section	.data.X3,"aw",@progbits
	.globl	X3
X3:
	.asciz	"return-return-return\000\000\000\000\000\000\000\000\000\000\000\000"
	.int8	82                      # 0x52
	.size	X3, 34

	.type	f.xr,@object            # @f.xr
	.section	.rodata.f.xr,"a",@progbits
f.xr:
	.asciz	"return val\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.int8	82                      # 0x52
	.size	f.xr, 34

	.hidden	out                     # @out
	.type	out,@object
	.section	.bss.out,"aw",@nobits
	.globl	out
	.p2align	4
out:
	.skip	100
	.size	out, 100

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"X f(B,char,double,B):({%g,{%d,%d,%d}},'%c',%g,{%g,{%d,%d,%d}})"
	.size	.L.str, 63

	.hidden	fp                      # @fp
	.type	fp,@object
	.section	.data.fp,"aw",@progbits
	.globl	fp
	.p2align	2
fp:
	.int32	f@FUNCTION
	.size	fp, 4


	.ident	"clang version 3.9.0 "
