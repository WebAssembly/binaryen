	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020402-2.c"
	.globl	InitCache
	.type	InitCache,@function
InitCache:                              # @InitCache
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$discard=, MyPte+4($1), $0
	i32.store	$discard=, MyPte+8($1), $1
	i32.const	$push0=, 5
	i32.store	$discard=, MyPte+12($1), $pop0
	i32.const	$push1=, MyPte+16
	i32.store	$discard=, Local1($1), $pop1
	i32.const	$push2=, MyPte+20
	i32.store	$discard=, Local2($1), $pop2
	i32.const	$push3=, MyPte+24
	i32.store	$discard=, Local3($1), $pop3
	i32.const	$push4=, MyPte+28
	i32.store	$discard=, RDbf1($1), $pop4
	i32.const	$push5=, MyPte+32
	i32.store	$discard=, RDbf2($1), $pop5
	i32.const	$push6=, MyPte+36
	i32.store	$discard=, RDbf3($1), $pop6
	i32.const	$push7=, 1
	i32.store	$discard=, MyPte+36($1), $pop7
	i32.const	$push8=, MyPte+156
	i32.store	$discard=, IntVc1($1), $pop8
	i32.const	$push9=, MyPte+160
	i32.store	$discard=, IntVc2($1), $pop9
	i32.const	$push10=, MyPte+164
	i32.store	$discard=, IntCode3($1), $pop10
	i32.const	$push11=, MyPte+168
	i32.store	$discard=, IntCode4($1), $pop11
	i32.const	$push12=, MyPte+172
	i32.store	$discard=, IntCode5($1), $pop12
	i32.const	$push13=, MyPte+176
	i32.store	$discard=, IntCode6($1), $pop13
	i32.const	$push14=, MyPte+180
	i32.store	$discard=, Workspace($1), $pop14
	i32.const	$push15=, MyPte+184
	i32.store	$discard=, Workspace+4($1), $pop15
	i32.const	$push16=, MyPte+188
	i32.store	$discard=, Workspace+8($1), $pop16
	i32.const	$push17=, MyPte+192
	i32.store	$discard=, Workspace+12($1), $pop17
	i32.const	$push18=, MyPte+196
	i32.store	$discard=, Workspace+16($1), $pop18
	i32.const	$push19=, MyPte+200
	i32.store	$discard=, Workspace+20($1), $pop19
	i32.const	$push20=, MyPte+204
	i32.store	$discard=, Workspace+24($1), $pop20
	i32.const	$push21=, MyPte+208
	i32.store	$discard=, Workspace+28($1), $pop21
	i32.const	$push22=, MyPte+212
	i32.store	$discard=, Workspace+32($1), $pop22
	i32.const	$push23=, MyPte+216
	i32.store	$discard=, Workspace+36($1), $pop23
	i32.const	$push24=, MyPte+220
	i32.store	$discard=, Workspace+40($1), $pop24
	i32.const	$push25=, MyPte+108
	i32.store	$discard=, Lom1($1), $pop25
	i32.const	$push26=, MyPte+112
	i32.store	$discard=, Lom2($1), $pop26
	i32.const	$push27=, MyPte+116
	i32.store	$discard=, Lom3($1), $pop27
	i32.const	$push28=, MyPte+120
	i32.store	$discard=, Lom4($1), $pop28
	i32.const	$push29=, MyPte+124
	i32.store	$discard=, Lom5($1), $pop29
	i32.const	$push30=, MyPte+128
	i32.store	$discard=, Lom6($1), $pop30
	i32.const	$push31=, MyPte+132
	i32.store	$discard=, Lom7($1), $pop31
	i32.const	$push32=, MyPte+136
	i32.store	$discard=, Lom8($1), $pop32
	i32.const	$push33=, MyPte+140
	i32.store	$discard=, Lom9($1), $pop33
	i32.const	$push34=, MyPte+144
	i32.store	$discard=, Lom10($1), $pop34
	i32.const	$push35=, MyPte+148
	i32.store	$discard=, RDbf11($1), $pop35
	i32.const	$push36=, MyPte+152
	i32.store	$discard=, RDbf12($1), $pop36
	return
.Lfunc_end0:
	.size	InitCache, .Lfunc_end0-InitCache

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.store	$3=, MyPte+8($2), $2
	i32.const	$push0=, 5
	i32.store	$push1=, MyPte+4($2), $pop0
	i32.store	$discard=, MyPte+12($3), $pop1
	i32.const	$push2=, MyPte+16
	i32.store	$discard=, Local1($3), $pop2
	i32.const	$push3=, MyPte+20
	i32.store	$discard=, Local2($3), $pop3
	i32.const	$push4=, MyPte+24
	i32.store	$discard=, Local3($3), $pop4
	i32.const	$push5=, MyPte+28
	i32.store	$discard=, RDbf1($3), $pop5
	i32.const	$push6=, MyPte+32
	i32.store	$discard=, RDbf2($3), $pop6
	i32.const	$push7=, MyPte+36
	i32.store	$discard=, RDbf3($3), $pop7
	i32.const	$push8=, 1
	i32.store	$discard=, MyPte+36($3), $pop8
	i32.const	$push9=, MyPte+156
	i32.store	$discard=, IntVc1($3), $pop9
	i32.const	$push10=, MyPte+160
	i32.store	$discard=, IntVc2($3), $pop10
	i32.const	$push11=, MyPte+164
	i32.store	$discard=, IntCode3($3), $pop11
	i32.const	$push12=, MyPte+168
	i32.store	$discard=, IntCode4($3), $pop12
	i32.const	$push13=, MyPte+172
	i32.store	$discard=, IntCode5($3), $pop13
	i32.const	$push14=, MyPte+176
	i32.store	$discard=, IntCode6($3), $pop14
	i32.const	$push15=, MyPte+180
	i32.store	$discard=, Workspace($3), $pop15
	i32.const	$push16=, MyPte+184
	i32.store	$discard=, Workspace+4($3), $pop16
	i32.const	$push17=, MyPte+188
	i32.store	$discard=, Workspace+8($3), $pop17
	i32.const	$push18=, MyPte+192
	i32.store	$discard=, Workspace+12($3), $pop18
	i32.const	$push19=, MyPte+196
	i32.store	$discard=, Workspace+16($3), $pop19
	i32.const	$push20=, MyPte+200
	i32.store	$discard=, Workspace+20($3), $pop20
	i32.const	$push21=, MyPte+204
	i32.store	$discard=, Workspace+24($3), $pop21
	i32.const	$push22=, MyPte+208
	i32.store	$discard=, Workspace+28($3), $pop22
	i32.const	$push23=, MyPte+212
	i32.store	$discard=, Workspace+32($3), $pop23
	i32.const	$push24=, MyPte+216
	i32.store	$discard=, Workspace+36($3), $pop24
	i32.const	$push25=, MyPte+220
	i32.store	$discard=, Workspace+40($3), $pop25
	i32.const	$push26=, MyPte+108
	i32.store	$discard=, Lom1($3), $pop26
	i32.const	$push27=, MyPte+112
	i32.store	$discard=, Lom2($3), $pop27
	i32.const	$push28=, MyPte+116
	i32.store	$discard=, Lom3($3), $pop28
	i32.const	$push29=, MyPte+120
	i32.store	$discard=, Lom4($3), $pop29
	i32.const	$push30=, MyPte+124
	i32.store	$discard=, Lom5($3), $pop30
	i32.const	$push31=, MyPte+128
	i32.store	$discard=, Lom6($3), $pop31
	i32.const	$push32=, MyPte+132
	i32.store	$discard=, Lom7($3), $pop32
	i32.const	$push33=, MyPte+136
	i32.store	$discard=, Lom8($3), $pop33
	i32.const	$push34=, MyPte+140
	i32.store	$discard=, Lom9($3), $pop34
	i32.const	$push35=, MyPte+144
	i32.store	$discard=, Lom10($3), $pop35
	i32.const	$push36=, MyPte+148
	i32.store	$discard=, RDbf11($3), $pop36
	i32.const	$push37=, MyPte+152
	i32.store	$discard=, RDbf12($3), $pop37
	return  	$3
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	Local1,@object          # @Local1
	.bss
	.globl	Local1
	.align	2
Local1:
	.int32	0
	.size	Local1, 4

	.type	Local2,@object          # @Local2
	.globl	Local2
	.align	2
Local2:
	.int32	0
	.size	Local2, 4

	.type	Local3,@object          # @Local3
	.globl	Local3
	.align	2
Local3:
	.int32	0
	.size	Local3, 4

	.type	RDbf1,@object           # @RDbf1
	.globl	RDbf1
	.align	2
RDbf1:
	.int32	0
	.size	RDbf1, 4

	.type	RDbf2,@object           # @RDbf2
	.globl	RDbf2
	.align	2
RDbf2:
	.int32	0
	.size	RDbf2, 4

	.type	RDbf3,@object           # @RDbf3
	.globl	RDbf3
	.align	2
RDbf3:
	.int32	0
	.size	RDbf3, 4

	.type	IntVc1,@object          # @IntVc1
	.globl	IntVc1
	.align	2
IntVc1:
	.int32	0
	.size	IntVc1, 4

	.type	IntVc2,@object          # @IntVc2
	.globl	IntVc2
	.align	2
IntVc2:
	.int32	0
	.size	IntVc2, 4

	.type	IntCode3,@object        # @IntCode3
	.globl	IntCode3
	.align	2
IntCode3:
	.int32	0
	.size	IntCode3, 4

	.type	IntCode4,@object        # @IntCode4
	.globl	IntCode4
	.align	2
IntCode4:
	.int32	0
	.size	IntCode4, 4

	.type	IntCode5,@object        # @IntCode5
	.globl	IntCode5
	.align	2
IntCode5:
	.int32	0
	.size	IntCode5, 4

	.type	IntCode6,@object        # @IntCode6
	.globl	IntCode6
	.align	2
IntCode6:
	.int32	0
	.size	IntCode6, 4

	.type	Lom1,@object            # @Lom1
	.globl	Lom1
	.align	2
Lom1:
	.int32	0
	.size	Lom1, 4

	.type	Lom2,@object            # @Lom2
	.globl	Lom2
	.align	2
Lom2:
	.int32	0
	.size	Lom2, 4

	.type	Lom3,@object            # @Lom3
	.globl	Lom3
	.align	2
Lom3:
	.int32	0
	.size	Lom3, 4

	.type	Lom4,@object            # @Lom4
	.globl	Lom4
	.align	2
Lom4:
	.int32	0
	.size	Lom4, 4

	.type	Lom5,@object            # @Lom5
	.globl	Lom5
	.align	2
Lom5:
	.int32	0
	.size	Lom5, 4

	.type	Lom6,@object            # @Lom6
	.globl	Lom6
	.align	2
Lom6:
	.int32	0
	.size	Lom6, 4

	.type	Lom7,@object            # @Lom7
	.globl	Lom7
	.align	2
Lom7:
	.int32	0
	.size	Lom7, 4

	.type	Lom8,@object            # @Lom8
	.globl	Lom8
	.align	2
Lom8:
	.int32	0
	.size	Lom8, 4

	.type	Lom9,@object            # @Lom9
	.globl	Lom9
	.align	2
Lom9:
	.int32	0
	.size	Lom9, 4

	.type	Lom10,@object           # @Lom10
	.globl	Lom10
	.align	2
Lom10:
	.int32	0
	.size	Lom10, 4

	.type	RDbf11,@object          # @RDbf11
	.globl	RDbf11
	.align	2
RDbf11:
	.int32	0
	.size	RDbf11, 4

	.type	RDbf12,@object          # @RDbf12
	.globl	RDbf12
	.align	2
RDbf12:
	.int32	0
	.size	RDbf12, 4

	.type	Workspace,@object       # @Workspace
	.globl	Workspace
	.align	2
Workspace:
	.zero	44
	.size	Workspace, 44

	.type	MyPte,@object           # @MyPte
	.globl	MyPte
	.align	2
MyPte:
	.zero	392
	.size	MyPte, 392


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
