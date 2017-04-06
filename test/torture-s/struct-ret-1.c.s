	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ret-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f64, i32
	.local  	i32, i32, f64, i64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push21=, 0
	i32.load	$push20=, __stack_pointer($pop21)
	i32.const	$push22=, 64
	i32.sub 	$push30=, $pop20, $pop22
	tee_local	$push29=, $10=, $pop30
	i32.store	__stack_pointer($pop23), $pop29
	i32.const	$push1=, 16
	i32.add 	$push2=, $4, $pop1
	i32.load	$5=, 0($pop2)
	i32.const	$push28=, 16
	i32.add 	$push3=, $1, $pop28
	i32.load	$6=, 0($pop3)
	f64.load	$7=, 0($1)
	i64.load	$8=, 8($1)
	f64.load	$9=, 0($4)
	i32.const	$push5=, 40
	i32.add 	$push6=, $10, $pop5
	i64.load	$push4=, 8($4)
	i64.store	0($pop6), $pop4
	i32.const	$push7=, 32
	i32.add 	$push8=, $10, $pop7
	f64.store	0($pop8), $9
	i32.const	$push9=, 24
	i32.add 	$push10=, $10, $pop9
	f64.store	0($pop10), $3
	i32.const	$push11=, 20
	i32.add 	$push12=, $10, $pop11
	i32.store	0($pop12), $2
	i32.const	$push27=, 16
	i32.add 	$push13=, $10, $pop27
	i32.store	0($pop13), $6
	i32.const	$push14=, 48
	i32.add 	$push15=, $10, $pop14
	i32.store	0($pop15), $5
	i64.store	8($10), $8
	f64.store	0($10), $7
	i32.const	$push17=, out
	i32.const	$push16=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop17, $pop16, $10
	i32.const	$push19=, f.xr
	i32.const	$push18=, 33
	i32.call	$push0=, memcpy@FUNCTION, $0, $pop19, $pop18
	i32.store8	33($pop0), $2
	i32.const	$push26=, 0
	i32.const	$push24=, 64
	i32.add 	$push25=, $10, $pop24
	i32.store	__stack_pointer($pop26), $pop25
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
	.local  	f64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push47=, 0
	i32.const	$push45=, 0
	i32.load	$push44=, __stack_pointer($pop45)
	i32.const	$push46=, 256
	i32.sub 	$push99=, $pop44, $pop46
	tee_local	$push98=, $3=, $pop99
	i32.store	__stack_pointer($pop47), $pop98
	i32.const	$push1=, 92
	i32.add 	$push2=, $3, $pop1
	i32.const	$push97=, 0
	i64.load	$push0=, B2+12($pop97):p2align=2
	i64.store	0($pop2):p2align=2, $pop0
	i32.const	$push4=, 88
	i32.add 	$push5=, $3, $pop4
	i32.const	$push96=, 0
	i32.load	$push3=, B2+8($pop96)
	i32.store	0($pop5), $pop3
	i32.const	$push7=, 80
	i32.add 	$push8=, $3, $pop7
	i32.const	$push95=, 0
	f64.load	$push6=, B2($pop95)
	f64.store	0($pop8), $pop6
	i32.const	$push10=, 72
	i32.add 	$push11=, $3, $pop10
	i32.const	$push94=, 0
	f64.load	$push9=, d3($pop94)
	f64.store	0($pop11), $pop9
	i32.const	$push48=, 48
	i32.add 	$push49=, $3, $pop48
	i32.const	$push13=, 20
	i32.add 	$push14=, $pop49, $pop13
	i32.const	$push93=, 0
	i32.load8_s	$push12=, c2($pop93)
	i32.store	0($pop14), $pop12
	i32.const	$push92=, 0
	i64.load	$push15=, B1+12($pop92):p2align=2
	i64.store	60($3):p2align=2, $pop15
	i32.const	$push91=, 0
	i32.load	$push16=, B1+8($pop91)
	i32.store	56($3), $pop16
	i32.const	$push90=, 0
	f64.load	$push17=, B1($pop90)
	f64.store	48($3), $pop17
	i32.const	$push19=, out
	i32.const	$push18=, .L.str
	i32.const	$push50=, 48
	i32.add 	$push51=, $3, $pop50
	i32.call	$drop=, sprintf@FUNCTION, $pop19, $pop18, $pop51
	i32.const	$push52=, 144
	i32.add 	$push53=, $3, $pop52
	i32.const	$push89=, out
	i32.call	$drop=, strcpy@FUNCTION, $pop53, $pop89
	i32.const	$push54=, 24
	i32.add 	$push55=, $3, $pop54
	i32.const	$push88=, 20
	i32.add 	$push20=, $pop55, $pop88
	i32.const	$push87=, 0
	i32.load	$push21=, B1+20($pop87)
	i32.store	0($pop20), $pop21
	i32.const	$push56=, 24
	i32.add 	$push57=, $3, $pop56
	i32.const	$push22=, 16
	i32.add 	$push23=, $pop57, $pop22
	i32.const	$push86=, 0
	i32.load	$push24=, B1+16($pop86)
	i32.store	0($pop23), $pop24
	i32.const	$push58=, 24
	i32.add 	$push59=, $3, $pop58
	i32.const	$push25=, 12
	i32.add 	$push26=, $pop59, $pop25
	i32.const	$push85=, 0
	i32.load	$push27=, B1+12($pop85)
	i32.store	0($pop26), $pop27
	i32.const	$push60=, 24
	i32.add 	$push61=, $3, $pop60
	i32.const	$push28=, 8
	i32.add 	$push29=, $pop61, $pop28
	i32.const	$push84=, 0
	i32.load	$push30=, B1+8($pop84)
	i32.store	0($pop29), $pop30
	i32.const	$push83=, 20
	i32.add 	$push31=, $3, $pop83
	i32.const	$push82=, 0
	i32.load	$push32=, B2+20($pop82)
	i32.store	0($pop31), $pop32
	i32.const	$push81=, 16
	i32.add 	$push33=, $3, $pop81
	i32.const	$push80=, 0
	i32.load	$push34=, B2+16($pop80)
	i32.store	0($pop33), $pop34
	i32.const	$push79=, 12
	i32.add 	$push35=, $3, $pop79
	i32.const	$push78=, 0
	i32.load	$push36=, B2+12($pop78)
	i32.store	0($pop35), $pop36
	i32.const	$push77=, 8
	i32.add 	$push37=, $3, $pop77
	i32.const	$push76=, 0
	i32.load	$push38=, B2+8($pop76)
	i32.store	0($pop37), $pop38
	i32.const	$push75=, 0
	i32.load	$push39=, B1+4($pop75)
	i32.store	28($3), $pop39
	i32.const	$push74=, 0
	i32.load	$push40=, B1($pop74)
	i32.store	24($3), $pop40
	i32.const	$push73=, 0
	f64.load	$0=, d3($pop73)
	i32.const	$push72=, 0
	i32.load8_s	$1=, c2($pop72)
	i32.const	$push71=, 0
	i32.load	$2=, fp($pop71)
	i32.const	$push70=, 0
	i32.load	$push41=, B2+4($pop70)
	i32.store	4($3), $pop41
	i32.const	$push69=, 0
	i32.load	$push42=, B2($pop69)
	i32.store	0($3), $pop42
	i32.const	$push62=, 104
	i32.add 	$push63=, $3, $pop62
	i32.const	$push64=, 24
	i32.add 	$push65=, $3, $pop64
	call_indirect	$pop63, $pop65, $1, $0, $3, $2
	block   	
	i32.const	$push66=, 144
	i32.add 	$push67=, $3, $pop66
	i32.const	$push68=, out
	i32.call	$push43=, strcmp@FUNCTION, $pop67, $pop68
	br_if   	0, $pop43       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push100=, 0
	call    	exit@FUNCTION, $pop100
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	sprintf, i32, i32, i32
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
