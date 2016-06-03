	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ret-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f64, i32
	.local  	i32, i32, f64, i64, f64, i64
# BB#0:                                 # %entry
	i32.const	$push28=, 0
	i32.const	$push25=, 0
	i32.load	$push26=, __stack_pointer($pop25)
	i32.const	$push27=, 64
	i32.sub 	$push32=, $pop26, $pop27
	i32.store	$5=, __stack_pointer($pop28), $pop32
	i32.const	$push1=, 16
	i32.add 	$push2=, $1, $pop1
	i32.load	$6=, 0($pop2)
	f64.load	$7=, 0($1)
	i64.load	$8=, 8($1)
	f64.load	$9=, 0($4)
	i64.load	$10=, 8($4)
	i32.const	$push5=, 48
	i32.add 	$push6=, $5, $pop5
	i32.const	$push35=, 16
	i32.add 	$push3=, $4, $pop35
	i32.load	$push4=, 0($pop3)
	i32.store	$drop=, 0($pop6), $pop4
	i32.const	$push9=, 44
	i32.add 	$push10=, $5, $pop9
	i64.const	$push7=, 32
	i64.shr_u	$push8=, $10, $pop7
	i64.store32	$drop=, 0($pop10), $pop8
	i32.const	$push11=, 40
	i32.add 	$push12=, $5, $pop11
	i64.store32	$drop=, 0($pop12), $10
	i32.const	$push13=, 32
	i32.add 	$push14=, $5, $pop13
	f64.store	$drop=, 0($pop14), $9
	i32.const	$push15=, 24
	i32.add 	$push16=, $5, $pop15
	f64.store	$drop=, 0($pop16), $3
	i32.const	$push17=, 20
	i32.add 	$push18=, $5, $pop17
	i32.store	$4=, 0($pop18), $2
	i32.const	$push34=, 16
	i32.add 	$push19=, $5, $pop34
	i32.store	$drop=, 0($pop19), $6
	i64.const	$push33=, 32
	i64.shr_u	$push20=, $8, $pop33
	i64.store32	$drop=, 12($5), $pop20
	i64.store32	$drop=, 8($5), $8
	f64.store	$drop=, 0($5), $7
	i32.const	$push22=, out
	i32.const	$push21=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop22, $pop21, $5
	i32.const	$push24=, f.xr
	i32.const	$push23=, 33
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop24, $pop23
	i32.store8	$drop=, 33($pop0), $4
	i32.const	$push31=, 0
	i32.const	$push29=, 64
	i32.add 	$push30=, $5, $pop29
	i32.store	$drop=, __stack_pointer($pop31), $pop30
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, i64, i32, i32, f64, f64, i64
# BB#0:                                 # %entry
	i32.const	$push41=, 0
	i32.const	$push38=, 0
	i32.load	$push39=, __stack_pointer($pop38)
	i32.const	$push40=, 256
	i32.sub 	$push62=, $pop39, $pop40
	i32.store	$0=, __stack_pointer($pop41), $pop62
	i32.const	$push89=, 0
	f64.load	$1=, B1($pop89)
	i32.const	$push88=, 0
	i64.load	$2=, B1+8($pop88)
	i32.const	$push87=, 0
	i32.load	$3=, B1+16($pop87)
	i32.const	$push86=, 0
	i32.load8_s	$4=, c2($pop86)
	i32.const	$push85=, 0
	f64.load	$5=, d3($pop85)
	i32.const	$push84=, 0
	f64.load	$6=, B2($pop84)
	i32.const	$push83=, 0
	i64.load	$7=, B2+8($pop83)
	i32.const	$push1=, 96
	i32.add 	$push2=, $0, $pop1
	i32.const	$push82=, 0
	i32.load	$push0=, B2+16($pop82)
	i32.store	$drop=, 0($pop2), $pop0
	i32.const	$push3=, 88
	i32.add 	$push4=, $0, $pop3
	i64.store32	$drop=, 0($pop4), $7
	i32.const	$push5=, 80
	i32.add 	$push6=, $0, $pop5
	f64.store	$drop=, 0($pop6), $6
	i32.const	$push7=, 72
	i32.add 	$push8=, $0, $pop7
	f64.store	$drop=, 0($pop8), $5
	i32.const	$push42=, 48
	i32.add 	$push43=, $0, $pop42
	i32.const	$push9=, 20
	i32.add 	$push10=, $pop43, $pop9
	i32.store	$drop=, 0($pop10), $4
	i32.const	$push44=, 48
	i32.add 	$push45=, $0, $pop44
	i32.const	$push11=, 16
	i32.add 	$push12=, $pop45, $pop11
	i32.store	$drop=, 0($pop12), $3
	i32.const	$push15=, 92
	i32.add 	$push16=, $0, $pop15
	i64.const	$push13=, 32
	i64.shr_u	$push14=, $7, $pop13
	i64.store32	$drop=, 0($pop16), $pop14
	i64.store32	$drop=, 56($0), $2
	f64.store	$drop=, 48($0), $1
	i64.const	$push81=, 32
	i64.shr_u	$push17=, $2, $pop81
	i64.store32	$drop=, 60($0), $pop17
	i32.const	$push19=, out
	i32.const	$push18=, .L.str
	i32.const	$push46=, 48
	i32.add 	$push47=, $0, $pop46
	i32.call	$drop=, sprintf@FUNCTION, $pop19, $pop18, $pop47
	i32.const	$push48=, 144
	i32.add 	$push49=, $0, $pop48
	i32.const	$push80=, out
	i32.call	$drop=, strcpy@FUNCTION, $pop49, $pop80
	i32.const	$push50=, 24
	i32.add 	$push51=, $0, $pop50
	i32.const	$push79=, 20
	i32.add 	$push20=, $pop51, $pop79
	i32.const	$push78=, 0
	i32.load	$push21=, B1+20($pop78)
	i32.store	$drop=, 0($pop20), $pop21
	i32.const	$push52=, 24
	i32.add 	$push53=, $0, $pop52
	i32.const	$push77=, 16
	i32.add 	$push22=, $pop53, $pop77
	i32.const	$push76=, 0
	i32.load	$push23=, B1+16($pop76)
	i32.store	$drop=, 0($pop22), $pop23
	i32.const	$push24=, 36
	i32.add 	$push25=, $0, $pop24
	i32.const	$push75=, 0
	i32.load	$push26=, B1+12($pop75)
	i32.store	$drop=, 0($pop25), $pop26
	i32.const	$push54=, 24
	i32.add 	$push55=, $0, $pop54
	i32.const	$push27=, 8
	i32.add 	$push28=, $pop55, $pop27
	i32.const	$push74=, 0
	i32.load	$push29=, B1+8($pop74)
	i32.store	$drop=, 0($pop28), $pop29
	i32.const	$push73=, 0
	i32.load	$push30=, B1+4($pop73)
	i32.store	$drop=, 28($0), $pop30
	i32.const	$push72=, 0
	i32.load	$push31=, B1($pop72)
	i32.store	$drop=, 24($0), $pop31
	i32.const	$push71=, 0
	f64.load	$1=, d3($pop71)
	i32.const	$push70=, 0
	i32.load8_s	$3=, c2($pop70)
	i32.const	$push69=, 0
	i32.load	$4=, fp($pop69)
	i32.const	$push68=, 16
	i32.add 	$push32=, $0, $pop68
	i32.const	$push67=, 0
	i64.load	$push33=, B2+16($pop67)
	i64.store	$drop=, 0($pop32), $pop33
	i32.const	$push66=, 8
	i32.add 	$push34=, $0, $pop66
	i32.const	$push65=, 0
	i64.load	$push35=, B2+8($pop65)
	i64.store	$drop=, 0($pop34), $pop35
	i32.const	$push64=, 0
	i64.load	$push36=, B2($pop64)
	i64.store	$drop=, 0($0), $pop36
	i32.const	$push56=, 104
	i32.add 	$push57=, $0, $pop56
	i32.const	$push58=, 24
	i32.add 	$push59=, $0, $pop58
	call_indirect	$4, $pop57, $pop59, $3, $1, $0
	block
	i32.const	$push60=, 144
	i32.add 	$push61=, $0, $pop60
	i32.const	$push63=, out
	i32.call	$push37=, strcmp@FUNCTION, $pop61, $pop63
	br_if   	0, $pop37       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push90=, 0
	call    	exit@FUNCTION, $pop90
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
	.functype	sprintf, i32, i32, i32
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
