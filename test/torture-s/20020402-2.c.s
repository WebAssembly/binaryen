	.text
	.file	"20020402-2.c"
	.section	.text.InitCache,"ax",@progbits
	.hidden	InitCache               # -- Begin function InitCache
	.globl	InitCache
	.type	InitCache,@function
InitCache:                              # @InitCache
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	MyPte+4($pop0), $0
	i32.const	$push74=, 0
	i64.const	$push1=, 21474836480
	i64.store	MyPte+8($pop74):p2align=2, $pop1
	i32.const	$push73=, 0
	i32.const	$push2=, MyPte+16
	i32.store	Local1($pop73), $pop2
	i32.const	$push72=, 0
	i32.const	$push3=, MyPte+20
	i32.store	Local2($pop72), $pop3
	i32.const	$push71=, 0
	i32.const	$push4=, MyPte+24
	i32.store	Local3($pop71), $pop4
	i32.const	$push70=, 0
	i32.const	$push5=, MyPte+28
	i32.store	RDbf1($pop70), $pop5
	i32.const	$push69=, 0
	i32.const	$push6=, MyPte+32
	i32.store	RDbf2($pop69), $pop6
	i32.const	$push68=, 0
	i32.const	$push7=, MyPte+36
	i32.store	RDbf3($pop68), $pop7
	i32.const	$push67=, 0
	i32.const	$push8=, 1
	i32.store	MyPte+36($pop67), $pop8
	i32.const	$push66=, 0
	i32.const	$push9=, MyPte+156
	i32.store	IntVc1($pop66), $pop9
	i32.const	$push65=, 0
	i32.const	$push10=, MyPte+160
	i32.store	IntVc2($pop65), $pop10
	i32.const	$push64=, 0
	i32.const	$push11=, MyPte+164
	i32.store	IntCode3($pop64), $pop11
	i32.const	$push63=, 0
	i32.const	$push12=, MyPte+168
	i32.store	IntCode4($pop63), $pop12
	i32.const	$push62=, 0
	i32.const	$push13=, MyPte+172
	i32.store	IntCode5($pop62), $pop13
	i32.const	$push61=, 0
	i32.const	$push14=, MyPte+176
	i32.store	IntCode6($pop61), $pop14
	i32.const	$push60=, 0
	i32.const	$push15=, MyPte+180
	i32.store	Workspace($pop60), $pop15
	i32.const	$push59=, 0
	i32.const	$push16=, MyPte+184
	i32.store	Workspace+4($pop59), $pop16
	i32.const	$push58=, 0
	i32.const	$push17=, MyPte+188
	i32.store	Workspace+8($pop58), $pop17
	i32.const	$push57=, 0
	i32.const	$push18=, MyPte+196
	i32.store	Workspace+16($pop57), $pop18
	i32.const	$push56=, 0
	i32.const	$push19=, MyPte+192
	i32.store	Workspace+12($pop56), $pop19
	i32.const	$push55=, 0
	i32.const	$push20=, MyPte+200
	i32.store	Workspace+20($pop55), $pop20
	i32.const	$push54=, 0
	i32.const	$push21=, MyPte+204
	i32.store	Workspace+24($pop54), $pop21
	i32.const	$push53=, 0
	i32.const	$push22=, MyPte+208
	i32.store	Workspace+28($pop53), $pop22
	i32.const	$push52=, 0
	i32.const	$push23=, MyPte+212
	i32.store	Workspace+32($pop52), $pop23
	i32.const	$push51=, 0
	i32.const	$push24=, MyPte+216
	i32.store	Workspace+36($pop51), $pop24
	i32.const	$push50=, 0
	i32.const	$push25=, MyPte+220
	i32.store	Workspace+40($pop50), $pop25
	i32.const	$push49=, 0
	i32.const	$push26=, MyPte+108
	i32.store	Lom1($pop49), $pop26
	i32.const	$push48=, 0
	i32.const	$push27=, MyPte+112
	i32.store	Lom2($pop48), $pop27
	i32.const	$push47=, 0
	i32.const	$push28=, MyPte+116
	i32.store	Lom3($pop47), $pop28
	i32.const	$push46=, 0
	i32.const	$push29=, MyPte+120
	i32.store	Lom4($pop46), $pop29
	i32.const	$push45=, 0
	i32.const	$push30=, MyPte+124
	i32.store	Lom5($pop45), $pop30
	i32.const	$push44=, 0
	i32.const	$push31=, MyPte+128
	i32.store	Lom6($pop44), $pop31
	i32.const	$push43=, 0
	i32.const	$push32=, MyPte+132
	i32.store	Lom7($pop43), $pop32
	i32.const	$push42=, 0
	i32.const	$push33=, MyPte+136
	i32.store	Lom8($pop42), $pop33
	i32.const	$push41=, 0
	i32.const	$push34=, MyPte+140
	i32.store	Lom9($pop41), $pop34
	i32.const	$push40=, 0
	i32.const	$push35=, MyPte+144
	i32.store	Lom10($pop40), $pop35
	i32.const	$push39=, 0
	i32.const	$push36=, MyPte+148
	i32.store	RDbf11($pop39), $pop36
	i32.const	$push38=, 0
	i32.const	$push37=, MyPte+152
	i32.store	RDbf12($pop38), $pop37
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	InitCache, .Lfunc_end0-InitCache
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 5
	i32.store	MyPte+12($pop1), $pop0
	i32.const	$push76=, 0
	i64.const	$push2=, 5
	i64.store	MyPte+4($pop76):p2align=2, $pop2
	i32.const	$push75=, 0
	i32.const	$push3=, MyPte+16
	i32.store	Local1($pop75), $pop3
	i32.const	$push74=, 0
	i32.const	$push4=, MyPte+20
	i32.store	Local2($pop74), $pop4
	i32.const	$push73=, 0
	i32.const	$push5=, MyPte+24
	i32.store	Local3($pop73), $pop5
	i32.const	$push72=, 0
	i32.const	$push6=, MyPte+28
	i32.store	RDbf1($pop72), $pop6
	i32.const	$push71=, 0
	i32.const	$push7=, MyPte+32
	i32.store	RDbf2($pop71), $pop7
	i32.const	$push70=, 0
	i32.const	$push8=, MyPte+36
	i32.store	RDbf3($pop70), $pop8
	i32.const	$push69=, 0
	i32.const	$push9=, 1
	i32.store	MyPte+36($pop69), $pop9
	i32.const	$push68=, 0
	i32.const	$push10=, MyPte+156
	i32.store	IntVc1($pop68), $pop10
	i32.const	$push67=, 0
	i32.const	$push11=, MyPte+160
	i32.store	IntVc2($pop67), $pop11
	i32.const	$push66=, 0
	i32.const	$push12=, MyPte+164
	i32.store	IntCode3($pop66), $pop12
	i32.const	$push65=, 0
	i32.const	$push13=, MyPte+168
	i32.store	IntCode4($pop65), $pop13
	i32.const	$push64=, 0
	i32.const	$push14=, MyPte+172
	i32.store	IntCode5($pop64), $pop14
	i32.const	$push63=, 0
	i32.const	$push15=, MyPte+176
	i32.store	IntCode6($pop63), $pop15
	i32.const	$push62=, 0
	i32.const	$push16=, MyPte+180
	i32.store	Workspace($pop62), $pop16
	i32.const	$push61=, 0
	i32.const	$push17=, MyPte+184
	i32.store	Workspace+4($pop61), $pop17
	i32.const	$push60=, 0
	i32.const	$push18=, MyPte+188
	i32.store	Workspace+8($pop60), $pop18
	i32.const	$push59=, 0
	i32.const	$push19=, MyPte+196
	i32.store	Workspace+16($pop59), $pop19
	i32.const	$push58=, 0
	i32.const	$push20=, MyPte+192
	i32.store	Workspace+12($pop58), $pop20
	i32.const	$push57=, 0
	i32.const	$push21=, MyPte+200
	i32.store	Workspace+20($pop57), $pop21
	i32.const	$push56=, 0
	i32.const	$push22=, MyPte+204
	i32.store	Workspace+24($pop56), $pop22
	i32.const	$push55=, 0
	i32.const	$push23=, MyPte+208
	i32.store	Workspace+28($pop55), $pop23
	i32.const	$push54=, 0
	i32.const	$push24=, MyPte+212
	i32.store	Workspace+32($pop54), $pop24
	i32.const	$push53=, 0
	i32.const	$push25=, MyPte+216
	i32.store	Workspace+36($pop53), $pop25
	i32.const	$push52=, 0
	i32.const	$push26=, MyPte+220
	i32.store	Workspace+40($pop52), $pop26
	i32.const	$push51=, 0
	i32.const	$push27=, MyPte+108
	i32.store	Lom1($pop51), $pop27
	i32.const	$push50=, 0
	i32.const	$push28=, MyPte+112
	i32.store	Lom2($pop50), $pop28
	i32.const	$push49=, 0
	i32.const	$push29=, MyPte+116
	i32.store	Lom3($pop49), $pop29
	i32.const	$push48=, 0
	i32.const	$push30=, MyPte+120
	i32.store	Lom4($pop48), $pop30
	i32.const	$push47=, 0
	i32.const	$push31=, MyPte+124
	i32.store	Lom5($pop47), $pop31
	i32.const	$push46=, 0
	i32.const	$push32=, MyPte+128
	i32.store	Lom6($pop46), $pop32
	i32.const	$push45=, 0
	i32.const	$push33=, MyPte+132
	i32.store	Lom7($pop45), $pop33
	i32.const	$push44=, 0
	i32.const	$push34=, MyPte+136
	i32.store	Lom8($pop44), $pop34
	i32.const	$push43=, 0
	i32.const	$push35=, MyPte+140
	i32.store	Lom9($pop43), $pop35
	i32.const	$push42=, 0
	i32.const	$push36=, MyPte+144
	i32.store	Lom10($pop42), $pop36
	i32.const	$push41=, 0
	i32.const	$push37=, MyPte+148
	i32.store	RDbf11($pop41), $pop37
	i32.const	$push40=, 0
	i32.const	$push38=, MyPte+152
	i32.store	RDbf12($pop40), $pop38
	i32.const	$push39=, 0
                                        # fallthrough-return: $pop39
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	Local1                  # @Local1
	.type	Local1,@object
	.section	.bss.Local1,"aw",@nobits
	.globl	Local1
	.p2align	2
Local1:
	.int32	0
	.size	Local1, 4

	.hidden	Local2                  # @Local2
	.type	Local2,@object
	.section	.bss.Local2,"aw",@nobits
	.globl	Local2
	.p2align	2
Local2:
	.int32	0
	.size	Local2, 4

	.hidden	Local3                  # @Local3
	.type	Local3,@object
	.section	.bss.Local3,"aw",@nobits
	.globl	Local3
	.p2align	2
Local3:
	.int32	0
	.size	Local3, 4

	.hidden	RDbf1                   # @RDbf1
	.type	RDbf1,@object
	.section	.bss.RDbf1,"aw",@nobits
	.globl	RDbf1
	.p2align	2
RDbf1:
	.int32	0
	.size	RDbf1, 4

	.hidden	RDbf2                   # @RDbf2
	.type	RDbf2,@object
	.section	.bss.RDbf2,"aw",@nobits
	.globl	RDbf2
	.p2align	2
RDbf2:
	.int32	0
	.size	RDbf2, 4

	.hidden	RDbf3                   # @RDbf3
	.type	RDbf3,@object
	.section	.bss.RDbf3,"aw",@nobits
	.globl	RDbf3
	.p2align	2
RDbf3:
	.int32	0
	.size	RDbf3, 4

	.hidden	IntVc1                  # @IntVc1
	.type	IntVc1,@object
	.section	.bss.IntVc1,"aw",@nobits
	.globl	IntVc1
	.p2align	2
IntVc1:
	.int32	0
	.size	IntVc1, 4

	.hidden	IntVc2                  # @IntVc2
	.type	IntVc2,@object
	.section	.bss.IntVc2,"aw",@nobits
	.globl	IntVc2
	.p2align	2
IntVc2:
	.int32	0
	.size	IntVc2, 4

	.hidden	IntCode3                # @IntCode3
	.type	IntCode3,@object
	.section	.bss.IntCode3,"aw",@nobits
	.globl	IntCode3
	.p2align	2
IntCode3:
	.int32	0
	.size	IntCode3, 4

	.hidden	IntCode4                # @IntCode4
	.type	IntCode4,@object
	.section	.bss.IntCode4,"aw",@nobits
	.globl	IntCode4
	.p2align	2
IntCode4:
	.int32	0
	.size	IntCode4, 4

	.hidden	IntCode5                # @IntCode5
	.type	IntCode5,@object
	.section	.bss.IntCode5,"aw",@nobits
	.globl	IntCode5
	.p2align	2
IntCode5:
	.int32	0
	.size	IntCode5, 4

	.hidden	IntCode6                # @IntCode6
	.type	IntCode6,@object
	.section	.bss.IntCode6,"aw",@nobits
	.globl	IntCode6
	.p2align	2
IntCode6:
	.int32	0
	.size	IntCode6, 4

	.hidden	Lom1                    # @Lom1
	.type	Lom1,@object
	.section	.bss.Lom1,"aw",@nobits
	.globl	Lom1
	.p2align	2
Lom1:
	.int32	0
	.size	Lom1, 4

	.hidden	Lom2                    # @Lom2
	.type	Lom2,@object
	.section	.bss.Lom2,"aw",@nobits
	.globl	Lom2
	.p2align	2
Lom2:
	.int32	0
	.size	Lom2, 4

	.hidden	Lom3                    # @Lom3
	.type	Lom3,@object
	.section	.bss.Lom3,"aw",@nobits
	.globl	Lom3
	.p2align	2
Lom3:
	.int32	0
	.size	Lom3, 4

	.hidden	Lom4                    # @Lom4
	.type	Lom4,@object
	.section	.bss.Lom4,"aw",@nobits
	.globl	Lom4
	.p2align	2
Lom4:
	.int32	0
	.size	Lom4, 4

	.hidden	Lom5                    # @Lom5
	.type	Lom5,@object
	.section	.bss.Lom5,"aw",@nobits
	.globl	Lom5
	.p2align	2
Lom5:
	.int32	0
	.size	Lom5, 4

	.hidden	Lom6                    # @Lom6
	.type	Lom6,@object
	.section	.bss.Lom6,"aw",@nobits
	.globl	Lom6
	.p2align	2
Lom6:
	.int32	0
	.size	Lom6, 4

	.hidden	Lom7                    # @Lom7
	.type	Lom7,@object
	.section	.bss.Lom7,"aw",@nobits
	.globl	Lom7
	.p2align	2
Lom7:
	.int32	0
	.size	Lom7, 4

	.hidden	Lom8                    # @Lom8
	.type	Lom8,@object
	.section	.bss.Lom8,"aw",@nobits
	.globl	Lom8
	.p2align	2
Lom8:
	.int32	0
	.size	Lom8, 4

	.hidden	Lom9                    # @Lom9
	.type	Lom9,@object
	.section	.bss.Lom9,"aw",@nobits
	.globl	Lom9
	.p2align	2
Lom9:
	.int32	0
	.size	Lom9, 4

	.hidden	Lom10                   # @Lom10
	.type	Lom10,@object
	.section	.bss.Lom10,"aw",@nobits
	.globl	Lom10
	.p2align	2
Lom10:
	.int32	0
	.size	Lom10, 4

	.hidden	RDbf11                  # @RDbf11
	.type	RDbf11,@object
	.section	.bss.RDbf11,"aw",@nobits
	.globl	RDbf11
	.p2align	2
RDbf11:
	.int32	0
	.size	RDbf11, 4

	.hidden	RDbf12                  # @RDbf12
	.type	RDbf12,@object
	.section	.bss.RDbf12,"aw",@nobits
	.globl	RDbf12
	.p2align	2
RDbf12:
	.int32	0
	.size	RDbf12, 4

	.hidden	Workspace               # @Workspace
	.type	Workspace,@object
	.section	.bss.Workspace,"aw",@nobits
	.globl	Workspace
	.p2align	2
Workspace:
	.skip	44
	.size	Workspace, 44

	.hidden	MyPte                   # @MyPte
	.type	MyPte,@object
	.section	.bss.MyPte,"aw",@nobits
	.globl	MyPte
	.p2align	2
MyPte:
	.skip	392
	.size	MyPte, 392


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
