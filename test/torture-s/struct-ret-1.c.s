	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ret-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f64, i32
	.local  	i64, i32, f64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 64
	i32.sub 	$17=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$17=, 0($15), $17
	i32.const	$push3=, 16
	i32.add 	$push4=, $1, $pop3
	i32.load	$6=, 0($pop4):p2align=3
	i32.const	$push21=, 16
	i32.add 	$push6=, $4, $pop21
	i32.load	$9=, 0($pop6):p2align=3
	i64.load	$5=, 8($1)
	i64.load	$8=, 8($4)
	f64.load	$7=, 0($4)
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 56
	i32.sub 	$17=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$17=, 0($11), $17
	f64.load	$push0=, 0($1)
	f64.store	$discard=, 0($17), $pop0
	i32.const	$push7=, 48
	i32.add 	$4=, $17, $pop7
	i32.store	$discard=, 0($4), $9
	i32.const	$push8=, 44
	i32.add 	$4=, $17, $pop8
	i64.const	$push1=, 32
	i64.shr_u	$push5=, $8, $pop1
	i64.store32	$discard=, 0($4), $pop5
	i32.const	$push9=, 40
	i32.add 	$4=, $17, $pop9
	i64.store32	$discard=, 0($4), $8
	i32.const	$push10=, 32
	i32.add 	$4=, $17, $pop10
	f64.store	$discard=, 0($4), $7
	i32.const	$push11=, 24
	i32.add 	$4=, $17, $pop11
	f64.store	$discard=, 0($4), $3
	i32.const	$push12=, 20
	i32.add 	$4=, $17, $pop12
	i32.store	$4=, 0($4), $2
	i32.const	$push20=, 16
	i32.add 	$1=, $17, $pop20
	i32.store	$discard=, 0($1), $6
	i32.const	$push13=, 12
	i32.add 	$1=, $17, $pop13
	i64.const	$push19=, 32
	i64.shr_u	$push2=, $5, $pop19
	i64.store32	$discard=, 0($1), $pop2
	i32.const	$push14=, 8
	i32.add 	$1=, $17, $pop14
	i64.store32	$discard=, 0($1), $5
	i32.const	$push16=, out
	i32.const	$push15=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop16, $pop15
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 56
	i32.add 	$17=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$17=, 0($13), $17
	i32.const	$push17=, f.xr
	i32.const	$push18=, 33
	i32.call	$1=, memcpy@FUNCTION, $0, $pop17, $pop18
	i32.store8	$discard=, 33($1), $4
	i32.const	$16=, 64
	i32.add 	$17=, $17, $16
	i32.const	$16=, __stack_pointer
	i32.store	$17=, 0($16), $17
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
	.local  	f64, f64, i64, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 256
	i32.sub 	$24=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$24=, 0($13), $24
	i32.const	$push52=, 0
	f64.load	$0=, d3($pop52)
	i32.const	$push51=, 0
	i64.load	$2=, B2+8($pop51)
	i32.const	$push50=, 0
	i64.load	$4=, B1+8($pop50)
	i32.const	$push49=, 0
	i32.load	$3=, B2+16($pop49):p2align=3
	i32.const	$push48=, 0
	i32.load	$5=, B1+16($pop48):p2align=3
	i32.const	$push47=, 0
	i32.load8_s	$6=, c2($pop47)
	i32.const	$push46=, 0
	f64.load	$1=, B2($pop46)
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 56
	i32.sub 	$24=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$24=, 0($9), $24
	i32.const	$push45=, 0
	f64.load	$push0=, B1($pop45)
	f64.store	$discard=, 0($24), $pop0
	i32.const	$push4=, 48
	i32.add 	$7=, $24, $pop4
	i32.store	$discard=, 0($7), $3
	i32.const	$push5=, 44
	i32.add 	$3=, $24, $pop5
	i64.const	$push1=, 32
	i64.shr_u	$push3=, $2, $pop1
	i64.store32	$discard=, 0($3), $pop3
	i32.const	$push6=, 40
	i32.add 	$3=, $24, $pop6
	i64.store32	$discard=, 0($3), $2
	i32.const	$push7=, 32
	i32.add 	$3=, $24, $pop7
	f64.store	$discard=, 0($3), $1
	i32.const	$push8=, 24
	i32.add 	$3=, $24, $pop8
	f64.store	$discard=, 0($3), $0
	i32.const	$push9=, 20
	i32.add 	$3=, $24, $pop9
	i32.store	$discard=, 0($3), $6
	i32.const	$push10=, 16
	i32.add 	$3=, $24, $pop10
	i32.store	$discard=, 0($3), $5
	i32.const	$push11=, 12
	i32.add 	$3=, $24, $pop11
	i64.const	$push44=, 32
	i64.shr_u	$push2=, $4, $pop44
	i64.store32	$discard=, 0($3), $pop2
	i32.const	$push12=, 8
	i32.add 	$3=, $24, $pop12
	i64.store32	$discard=, 0($3), $4
	i32.const	$push14=, out
	i32.const	$push13=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop14, $pop13
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 56
	i32.add 	$24=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$24=, 0($11), $24
	i32.const	$push43=, out
	i32.const	$14=, 144
	i32.add 	$14=, $24, $14
	i32.call	$discard=, strcpy@FUNCTION, $14, $pop43
	i32.const	$push42=, 0
	f64.load	$0=, d3($pop42)
	i32.const	$push41=, 0
	i32.load	$3=, fp($pop41)
	i32.const	$push40=, 0
	i32.load8_s	$5=, c2($pop40)
	i32.const	$push39=, 20
	i32.const	$15=, 80
	i32.add 	$15=, $24, $15
	i32.add 	$push15=, $15, $pop39
	i32.const	$push38=, 0
	i32.load	$push16=, B1+20($pop38)
	i32.store	$discard=, 0($pop15), $pop16
	i32.const	$push37=, 16
	i32.const	$16=, 80
	i32.add 	$16=, $24, $16
	i32.add 	$push17=, $16, $pop37
	i32.const	$push36=, 0
	i32.load	$push18=, B1+16($pop36):p2align=3
	i32.store	$discard=, 0($pop17):p2align=3, $pop18
	i32.const	$push35=, 8
	i32.const	$17=, 80
	i32.add 	$17=, $24, $17
	i32.add 	$push19=, $17, $pop35
	i32.const	$push34=, 0
	i64.load	$push20=, B1+8($pop34)
	i64.store	$discard=, 0($pop19), $pop20
	i32.const	$push33=, 0
	i64.load	$push21=, B1($pop33)
	i64.store	$discard=, 80($24), $pop21
	i32.const	$push32=, 16
	i32.const	$18=, 56
	i32.add 	$18=, $24, $18
	i32.add 	$push22=, $18, $pop32
	i32.const	$push31=, 0
	i64.load	$push23=, B2+16($pop31)
	i64.store	$discard=, 0($pop22), $pop23
	i32.const	$push30=, 8
	i32.const	$19=, 56
	i32.add 	$19=, $24, $19
	i32.add 	$push24=, $19, $pop30
	i32.const	$push29=, 0
	i64.load	$push25=, B2+8($pop29)
	i64.store	$discard=, 0($pop24), $pop25
	i32.const	$push28=, 0
	i64.load	$push26=, B2($pop28)
	i64.store	$discard=, 56($24), $pop26
	i32.const	$20=, 104
	i32.add 	$20=, $24, $20
	i32.const	$21=, 80
	i32.add 	$21=, $24, $21
	i32.const	$22=, 56
	i32.add 	$22=, $24, $22
	call_indirect	$3, $20, $21, $5, $0, $22
	i32.const	$push27=, out
	i32.const	$23=, 144
	i32.add 	$23=, $24, $23
	i32.call	$3=, strcmp@FUNCTION, $23, $pop27
	block
	br_if   	0, $3           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push53=, 0
	call    	exit@FUNCTION, $pop53
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
