	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ret-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f64, i32
	.local  	i32, i32, i32, f64, f64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push28=, 0
	i32.const	$push25=, 0
	i32.load	$push26=, __stack_pointer($pop25)
	i32.const	$push27=, 64
	i32.sub 	$push36=, $pop26, $pop27
	tee_local	$push35=, $11=, $pop36
	i32.store	__stack_pointer($pop28), $pop35
	i32.const	$push1=, 12
	i32.add 	$push2=, $1, $pop1
	i32.load	$5=, 0($pop2)
	i32.const	$push3=, 16
	i32.add 	$push4=, $1, $pop3
	i32.load	$6=, 0($pop4)
	i32.const	$push34=, 12
	i32.add 	$push5=, $4, $pop34
	i32.load	$7=, 0($pop5)
	f64.load	$8=, 0($1)
	i32.load	$1=, 8($1)
	f64.load	$9=, 0($4)
	i32.load	$10=, 8($4)
	i32.const	$push8=, 48
	i32.add 	$push9=, $11, $pop8
	i32.const	$push33=, 16
	i32.add 	$push6=, $4, $pop33
	i32.load	$push7=, 0($pop6)
	i32.store	0($pop9), $pop7
	i32.const	$push10=, 44
	i32.add 	$push11=, $11, $pop10
	i32.store	0($pop11), $7
	i32.const	$push12=, 40
	i32.add 	$push13=, $11, $pop12
	i32.store	0($pop13), $10
	i32.const	$push14=, 32
	i32.add 	$push15=, $11, $pop14
	f64.store	0($pop15), $9
	i32.const	$push16=, 24
	i32.add 	$push17=, $11, $pop16
	f64.store	0($pop17), $3
	i32.const	$push18=, 20
	i32.add 	$push19=, $11, $pop18
	i32.store	0($pop19), $2
	i32.const	$push32=, 16
	i32.add 	$push20=, $11, $pop32
	i32.store	0($pop20), $6
	i32.store	12($11), $5
	i32.store	8($11), $1
	f64.store	0($11), $8
	i32.const	$push22=, out
	i32.const	$push21=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop22, $pop21, $11
	i32.const	$push24=, f.xr
	i32.const	$push23=, 33
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop24, $pop23
	i32.store8	33($pop0), $2
	i32.const	$push31=, 0
	i32.const	$push29=, 64
	i32.add 	$push30=, $11, $pop29
	i32.store	__stack_pointer($pop31), $pop30
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
	.local  	f64, i64, i32, i32, f64, f64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push38=, 0
	i32.const	$push35=, 0
	i32.load	$push36=, __stack_pointer($pop35)
	i32.const	$push37=, 256
	i32.sub 	$push87=, $pop36, $pop37
	tee_local	$push86=, $8=, $pop87
	i32.store	__stack_pointer($pop38), $pop86
	i32.const	$push85=, 0
	f64.load	$0=, B1($pop85)
	i32.const	$push84=, 0
	i64.load	$1=, B1+8($pop84)
	i32.const	$push83=, 0
	i32.load	$2=, B1+16($pop83)
	i32.const	$push82=, 0
	i32.load8_s	$3=, c2($pop82)
	i32.const	$push81=, 0
	f64.load	$4=, d3($pop81)
	i32.const	$push80=, 0
	f64.load	$5=, B2($pop80)
	i32.const	$push79=, 0
	i32.load	$6=, B2+8($pop79)
	i32.const	$push78=, 0
	i32.load	$7=, B2+12($pop78)
	i32.const	$push1=, 96
	i32.add 	$push2=, $8, $pop1
	i32.const	$push77=, 0
	i32.load	$push0=, B2+16($pop77)
	i32.store	0($pop2), $pop0
	i32.const	$push3=, 92
	i32.add 	$push4=, $8, $pop3
	i32.store	0($pop4), $7
	i32.const	$push5=, 88
	i32.add 	$push6=, $8, $pop5
	i32.store	0($pop6), $6
	i32.const	$push7=, 80
	i32.add 	$push8=, $8, $pop7
	f64.store	0($pop8), $5
	i32.const	$push9=, 72
	i32.add 	$push10=, $8, $pop9
	f64.store	0($pop10), $4
	i32.const	$push39=, 48
	i32.add 	$push40=, $8, $pop39
	i32.const	$push11=, 20
	i32.add 	$push12=, $pop40, $pop11
	i32.store	0($pop12), $3
	i32.const	$push41=, 48
	i32.add 	$push42=, $8, $pop41
	i32.const	$push13=, 16
	i32.add 	$push14=, $pop42, $pop13
	i32.store	0($pop14), $2
	i64.store	56($8), $1
	f64.store	48($8), $0
	i32.const	$push16=, out
	i32.const	$push15=, .L.str
	i32.const	$push43=, 48
	i32.add 	$push44=, $8, $pop43
	i32.call	$drop=, sprintf@FUNCTION, $pop16, $pop15, $pop44
	i32.const	$push45=, 144
	i32.add 	$push46=, $8, $pop45
	i32.const	$push76=, out
	i32.call	$drop=, strcpy@FUNCTION, $pop46, $pop76
	i32.const	$push47=, 24
	i32.add 	$push48=, $8, $pop47
	i32.const	$push75=, 20
	i32.add 	$push17=, $pop48, $pop75
	i32.const	$push74=, 0
	i32.load	$push18=, B1+20($pop74)
	i32.store	0($pop17), $pop18
	i32.const	$push49=, 24
	i32.add 	$push50=, $8, $pop49
	i32.const	$push73=, 16
	i32.add 	$push19=, $pop50, $pop73
	i32.const	$push72=, 0
	i32.load	$push20=, B1+16($pop72)
	i32.store	0($pop19), $pop20
	i32.const	$push21=, 36
	i32.add 	$push22=, $8, $pop21
	i32.const	$push71=, 0
	i32.load	$push23=, B1+12($pop71)
	i32.store	0($pop22), $pop23
	i32.const	$push51=, 24
	i32.add 	$push52=, $8, $pop51
	i32.const	$push24=, 8
	i32.add 	$push25=, $pop52, $pop24
	i32.const	$push70=, 0
	i32.load	$push26=, B1+8($pop70)
	i32.store	0($pop25), $pop26
	i32.const	$push69=, 0
	i32.load	$push27=, B1+4($pop69)
	i32.store	28($8), $pop27
	i32.const	$push68=, 0
	i32.load	$push28=, B1($pop68)
	i32.store	24($8), $pop28
	i32.const	$push67=, 0
	f64.load	$0=, d3($pop67)
	i32.const	$push66=, 0
	i32.load8_s	$2=, c2($pop66)
	i32.const	$push65=, 0
	i32.load	$3=, fp($pop65)
	i32.const	$push64=, 16
	i32.add 	$push29=, $8, $pop64
	i32.const	$push63=, 0
	i64.load	$push30=, B2+16($pop63)
	i64.store	0($pop29), $pop30
	i32.const	$push62=, 8
	i32.add 	$push31=, $8, $pop62
	i32.const	$push61=, 0
	i64.load	$push32=, B2+8($pop61)
	i64.store	0($pop31), $pop32
	i32.const	$push60=, 0
	i64.load	$push33=, B2($pop60)
	i64.store	0($8), $pop33
	i32.const	$push53=, 104
	i32.add 	$push54=, $8, $pop53
	i32.const	$push55=, 24
	i32.add 	$push56=, $8, $pop55
	call_indirect	$pop54, $pop56, $2, $0, $8, $3
	block   	
	i32.const	$push57=, 144
	i32.add 	$push58=, $8, $pop57
	i32.const	$push59=, out
	i32.call	$push34=, strcmp@FUNCTION, $pop58, $pop59
	br_if   	0, $pop34       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push88=, 0
	call    	exit@FUNCTION, $pop88
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


	.ident	"clang version 4.0.0 "
	.functype	sprintf, i32, i32, i32
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
