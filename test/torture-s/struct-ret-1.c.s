	.text
	.file	"struct-ret-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, f64, i32
	.local  	i64, i32, f64, f64, i32
# %bb.0:                                # %entry
	i32.const	$push29=, 0
	i32.load	$push28=, __stack_pointer($pop29)
	i32.const	$push30=, 64
	i32.sub 	$9=, $pop28, $pop30
	i32.const	$push31=, 0
	i32.store	__stack_pointer($pop31), $9
	i32.const	$push0=, 12
	i32.add 	$push1=, $1, $pop0
	i64.load	$5=, 0($pop1):p2align=2
	i32.const	$push2=, 16
	i32.add 	$push3=, $4, $pop2
	i32.load	$6=, 0($pop3)
	f64.load	$7=, 0($1)
	i32.load	$1=, 8($1)
	f64.load	$8=, 0($4)
	i32.const	$push5=, 40
	i32.add 	$push6=, $9, $pop5
	i64.load	$push4=, 8($4)
	i64.store	0($pop6), $pop4
	i32.const	$push7=, 32
	i32.add 	$push8=, $9, $pop7
	f64.store	0($pop8), $8
	i32.const	$push9=, 24
	i32.add 	$push10=, $9, $pop9
	f64.store	0($pop10), $3
	i32.const	$push11=, 20
	i32.add 	$push12=, $9, $pop11
	i32.store	0($pop12), $2
	i32.const	$push13=, 48
	i32.add 	$push14=, $9, $pop13
	i32.store	0($pop14), $6
	i64.store	12($9):p2align=2, $5
	i32.store	8($9), $1
	f64.store	0($9), $7
	i32.const	$push16=, out
	i32.const	$push15=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop16, $pop15, $9
	i32.store8	33($0), $2
	i32.const	$push41=, 32
	i32.add 	$push17=, $0, $pop41
	i32.const	$push18=, 0
	i32.load8_u	$push19=, f.xr+32($pop18)
	i32.store8	0($pop17), $pop19
	i32.const	$push40=, 24
	i32.add 	$push20=, $0, $pop40
	i32.const	$push39=, 0
	i64.load	$push21=, f.xr+24($pop39):p2align=0
	i64.store	0($pop20):p2align=0, $pop21
	i32.const	$push38=, 16
	i32.add 	$push22=, $0, $pop38
	i32.const	$push37=, 0
	i64.load	$push23=, f.xr+16($pop37):p2align=0
	i64.store	0($pop22):p2align=0, $pop23
	i32.const	$push24=, 8
	i32.add 	$push25=, $0, $pop24
	i32.const	$push36=, 0
	i64.load	$push26=, f.xr+8($pop36):p2align=0
	i64.store	0($pop25):p2align=0, $pop26
	i32.const	$push35=, 0
	i64.load	$push27=, f.xr($pop35):p2align=0
	i64.store	0($0):p2align=0, $pop27
	i32.const	$push34=, 0
	i32.const	$push32=, 64
	i32.add 	$push33=, $9, $pop32
	i32.store	__stack_pointer($pop34), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push37=, 0
	i32.load	$push36=, __stack_pointer($pop37)
	i32.const	$push38=, 256
	i32.sub 	$0=, $pop36, $pop38
	i32.const	$push39=, 0
	i32.store	__stack_pointer($pop39), $0
	i32.const	$push1=, 92
	i32.add 	$push2=, $0, $pop1
	i32.const	$push74=, 0
	i64.load	$push0=, B2+12($pop74):p2align=2
	i64.store	0($pop2):p2align=2, $pop0
	i32.const	$push4=, 88
	i32.add 	$push5=, $0, $pop4
	i32.const	$push73=, 0
	i32.load	$push3=, B2+8($pop73)
	i32.store	0($pop5), $pop3
	i32.const	$push7=, 80
	i32.add 	$push8=, $0, $pop7
	i32.const	$push72=, 0
	f64.load	$push6=, B2($pop72)
	f64.store	0($pop8), $pop6
	i32.const	$push10=, 72
	i32.add 	$push11=, $0, $pop10
	i32.const	$push71=, 0
	f64.load	$push9=, d3($pop71)
	f64.store	0($pop11), $pop9
	i32.const	$push13=, 68
	i32.add 	$push14=, $0, $pop13
	i32.const	$push70=, 0
	i32.load8_s	$push12=, c2($pop70)
	i32.store	0($pop14), $pop12
	i32.const	$push69=, 0
	i64.load	$push15=, B1+12($pop69):p2align=2
	i64.store	60($0):p2align=2, $pop15
	i32.const	$push68=, 0
	i32.load	$push16=, B1+8($pop68)
	i32.store	56($0), $pop16
	i32.const	$push67=, 0
	f64.load	$push17=, B1($pop67)
	f64.store	48($0), $pop17
	i32.const	$push19=, out
	i32.const	$push18=, .L.str
	i32.const	$push40=, 48
	i32.add 	$push41=, $0, $pop40
	i32.call	$drop=, sprintf@FUNCTION, $pop19, $pop18, $pop41
	i32.const	$push42=, 144
	i32.add 	$push43=, $0, $pop42
	i32.const	$push66=, out
	i32.call	$drop=, strcpy@FUNCTION, $pop43, $pop66
	i32.const	$push44=, 24
	i32.add 	$push45=, $0, $pop44
	i32.const	$push20=, 8
	i32.add 	$push21=, $pop45, $pop20
	i32.const	$push65=, 0
	i64.load	$push22=, B1+8($pop65)
	i64.store	0($pop21), $pop22
	i32.const	$push46=, 24
	i32.add 	$push47=, $0, $pop46
	i32.const	$push23=, 16
	i32.add 	$push24=, $pop47, $pop23
	i32.const	$push64=, 0
	i64.load	$push25=, B1+16($pop64)
	i64.store	0($pop24), $pop25
	i32.const	$push63=, 8
	i32.add 	$push26=, $0, $pop63
	i32.const	$push62=, 0
	i64.load	$push27=, B2+8($pop62)
	i64.store	0($pop26), $pop27
	i32.const	$push61=, 16
	i32.add 	$push28=, $0, $pop61
	i32.const	$push60=, 0
	i64.load	$push29=, B2+16($pop60)
	i64.store	0($pop28), $pop29
	i32.const	$push59=, 0
	i64.load	$push30=, B1($pop59)
	i64.store	24($0), $pop30
	i32.const	$push58=, 0
	i64.load	$push31=, B2($pop58)
	i64.store	0($0), $pop31
	i32.const	$push48=, 104
	i32.add 	$push49=, $0, $pop48
	i32.const	$push50=, 24
	i32.add 	$push51=, $0, $pop50
	i32.const	$push57=, 0
	i32.load8_s	$push33=, c2($pop57)
	i32.const	$push56=, 0
	f64.load	$push32=, d3($pop56)
	i32.const	$push55=, 0
	i32.load	$push34=, fp($pop55)
	call_indirect	$pop49, $pop51, $pop33, $pop32, $0, $pop34
	block   	
	i32.const	$push52=, 144
	i32.add 	$push53=, $0, $pop52
	i32.const	$push54=, out
	i32.call	$push35=, strcmp@FUNCTION, $pop53, $pop54
	br_if   	0, $pop35       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push75=, 0
	call    	exit@FUNCTION, $pop75
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	sprintf, i32, i32, i32
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
