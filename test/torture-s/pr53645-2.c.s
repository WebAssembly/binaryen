	.text
	.file	"pr53645-2.c"
	.section	.text.uq44444444,"ax",@progbits
	.hidden	uq44444444              # -- Begin function uq44444444
	.globl	uq44444444
	.type	uq44444444,@function
uq44444444:                             # @uq44444444
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 2
	i32.shr_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 2
	i32.shr_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 2
	i32.shr_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 2
	i32.shr_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_u	$push12=, 0($pop11)
	i32.const	$push35=, 2
	i32.shr_u	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_u	$push17=, 0($pop16)
	i32.const	$push33=, 2
	i32.shr_u	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_u	$push22=, 0($pop21)
	i32.const	$push31=, 2
	i32.shr_u	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 2
	i32.shr_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	uq44444444, .Lfunc_end0-uq44444444
                                        # -- End function
	.section	.text.ur44444444,"ax",@progbits
	.hidden	ur44444444              # -- Begin function ur44444444
	.globl	ur44444444
	.type	ur44444444,@function
ur44444444:                             # @ur44444444
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 3
	i32.and 	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 3
	i32.and 	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 3
	i32.and 	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 3
	i32.and 	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_u	$push12=, 0($pop11)
	i32.const	$push35=, 3
	i32.and 	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_u	$push17=, 0($pop16)
	i32.const	$push33=, 3
	i32.and 	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_u	$push22=, 0($pop21)
	i32.const	$push31=, 3
	i32.and 	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 3
	i32.and 	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	ur44444444, .Lfunc_end1-ur44444444
                                        # -- End function
	.section	.text.sq44444444,"ax",@progbits
	.hidden	sq44444444              # -- Begin function sq44444444
	.globl	sq44444444
	.type	sq44444444,@function
sq44444444:                             # @sq44444444
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 4
	i32.div_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 4
	i32.div_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 4
	i32.div_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 4
	i32.div_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_s	$push12=, 0($pop11)
	i32.const	$push35=, 4
	i32.div_s	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_s	$push17=, 0($pop16)
	i32.const	$push33=, 4
	i32.div_s	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_s	$push22=, 0($pop21)
	i32.const	$push31=, 4
	i32.div_s	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 4
	i32.div_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	sq44444444, .Lfunc_end2-sq44444444
                                        # -- End function
	.section	.text.sr44444444,"ax",@progbits
	.hidden	sr44444444              # -- Begin function sr44444444
	.globl	sr44444444
	.type	sr44444444,@function
sr44444444:                             # @sr44444444
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 4
	i32.rem_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 4
	i32.rem_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 4
	i32.rem_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 4
	i32.rem_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_s	$push12=, 0($pop11)
	i32.const	$push35=, 4
	i32.rem_s	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_s	$push17=, 0($pop16)
	i32.const	$push33=, 4
	i32.rem_s	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_s	$push22=, 0($pop21)
	i32.const	$push31=, 4
	i32.rem_s	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 4
	i32.rem_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	sr44444444, .Lfunc_end3-sr44444444
                                        # -- End function
	.section	.text.uq1428166432128,"ax",@progbits
	.hidden	uq1428166432128         # -- Begin function uq1428166432128
	.globl	uq1428166432128
	.type	uq1428166432128,@function
uq1428166432128:                        # @uq1428166432128
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 0($1)
	i32.store16	0($0), $pop0
	i32.load16_u	$push1=, 8($1)
	i32.const	$push2=, 4
	i32.shr_u	$push3=, $pop1, $pop2
	i32.store16	8($0), $pop3
	i32.load16_u	$push4=, 4($1)
	i32.const	$push5=, 1
	i32.shr_u	$push6=, $pop4, $pop5
	i32.store16	4($0), $pop6
	i32.load16_u	$push7=, 2($1)
	i32.const	$push8=, 2
	i32.shr_u	$push9=, $pop7, $pop8
	i32.store16	2($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_u	$push13=, 0($pop12)
	i32.const	$push14=, 7
	i32.shr_u	$push15=, $pop13, $pop14
	i32.store16	0($pop11), $pop15
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	i32.const	$push36=, 12
	i32.add 	$push18=, $1, $pop36
	i32.load16_u	$push19=, 0($pop18)
	i32.const	$push20=, 5
	i32.shr_u	$push21=, $pop19, $pop20
	i32.store16	0($pop17), $pop21
	i32.const	$push22=, 10
	i32.add 	$push23=, $0, $pop22
	i32.const	$push35=, 10
	i32.add 	$push24=, $1, $pop35
	i32.load16_u	$push25=, 0($pop24)
	i32.const	$push26=, 6
	i32.shr_u	$push27=, $pop25, $pop26
	i32.store16	0($pop23), $pop27
	i32.const	$push34=, 6
	i32.add 	$push28=, $0, $pop34
	i32.const	$push33=, 6
	i32.add 	$push29=, $1, $pop33
	i32.load16_u	$push30=, 0($pop29)
	i32.const	$push31=, 3
	i32.shr_u	$push32=, $pop30, $pop31
	i32.store16	0($pop28), $pop32
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	uq1428166432128, .Lfunc_end4-uq1428166432128
                                        # -- End function
	.section	.text.ur1428166432128,"ax",@progbits
	.hidden	ur1428166432128         # -- Begin function ur1428166432128
	.globl	ur1428166432128
	.type	ur1428166432128,@function
ur1428166432128:                        # @ur1428166432128
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store16	0($0), $pop0
	i32.load16_u	$push1=, 8($1)
	i32.const	$push2=, 15
	i32.and 	$push3=, $pop1, $pop2
	i32.store16	8($0), $pop3
	i32.load16_u	$push4=, 4($1)
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.store16	4($0), $pop6
	i32.load16_u	$push7=, 2($1)
	i32.const	$push8=, 3
	i32.and 	$push9=, $pop7, $pop8
	i32.store16	2($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_u	$push13=, 0($pop12)
	i32.const	$push14=, 127
	i32.and 	$push15=, $pop13, $pop14
	i32.store16	0($pop11), $pop15
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	i32.const	$push36=, 12
	i32.add 	$push18=, $1, $pop36
	i32.load16_u	$push19=, 0($pop18)
	i32.const	$push20=, 31
	i32.and 	$push21=, $pop19, $pop20
	i32.store16	0($pop17), $pop21
	i32.const	$push22=, 10
	i32.add 	$push23=, $0, $pop22
	i32.const	$push35=, 10
	i32.add 	$push24=, $1, $pop35
	i32.load16_u	$push25=, 0($pop24)
	i32.const	$push26=, 63
	i32.and 	$push27=, $pop25, $pop26
	i32.store16	0($pop23), $pop27
	i32.const	$push28=, 6
	i32.add 	$push29=, $0, $pop28
	i32.const	$push34=, 6
	i32.add 	$push30=, $1, $pop34
	i32.load16_u	$push31=, 0($pop30)
	i32.const	$push32=, 7
	i32.and 	$push33=, $pop31, $pop32
	i32.store16	0($pop29), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	ur1428166432128, .Lfunc_end5-ur1428166432128
                                        # -- End function
	.section	.text.sq1428166432128,"ax",@progbits
	.hidden	sq1428166432128         # -- Begin function sq1428166432128
	.globl	sq1428166432128
	.type	sq1428166432128,@function
sq1428166432128:                        # @sq1428166432128
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 0($1)
	i32.store16	0($0), $pop0
	i32.load16_s	$push1=, 8($1)
	i32.const	$push2=, 16
	i32.div_s	$push3=, $pop1, $pop2
	i32.store16	8($0), $pop3
	i32.load16_s	$push4=, 4($1)
	i32.const	$push5=, 2
	i32.div_s	$push6=, $pop4, $pop5
	i32.store16	4($0), $pop6
	i32.load16_s	$push7=, 2($1)
	i32.const	$push8=, 4
	i32.div_s	$push9=, $pop7, $pop8
	i32.store16	2($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_s	$push13=, 0($pop12)
	i32.const	$push14=, 128
	i32.div_s	$push15=, $pop13, $pop14
	i32.store16	0($pop11), $pop15
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	i32.const	$push36=, 12
	i32.add 	$push18=, $1, $pop36
	i32.load16_s	$push19=, 0($pop18)
	i32.const	$push20=, 32
	i32.div_s	$push21=, $pop19, $pop20
	i32.store16	0($pop17), $pop21
	i32.const	$push22=, 10
	i32.add 	$push23=, $0, $pop22
	i32.const	$push35=, 10
	i32.add 	$push24=, $1, $pop35
	i32.load16_s	$push25=, 0($pop24)
	i32.const	$push26=, 64
	i32.div_s	$push27=, $pop25, $pop26
	i32.store16	0($pop23), $pop27
	i32.const	$push28=, 6
	i32.add 	$push29=, $0, $pop28
	i32.const	$push34=, 6
	i32.add 	$push30=, $1, $pop34
	i32.load16_s	$push31=, 0($pop30)
	i32.const	$push32=, 8
	i32.div_s	$push33=, $pop31, $pop32
	i32.store16	0($pop29), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	sq1428166432128, .Lfunc_end6-sq1428166432128
                                        # -- End function
	.section	.text.sr1428166432128,"ax",@progbits
	.hidden	sr1428166432128         # -- Begin function sr1428166432128
	.globl	sr1428166432128
	.type	sr1428166432128,@function
sr1428166432128:                        # @sr1428166432128
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store16	0($0), $pop0
	i32.load16_s	$push1=, 8($1)
	i32.const	$push2=, 16
	i32.rem_s	$push3=, $pop1, $pop2
	i32.store16	8($0), $pop3
	i32.load16_s	$push4=, 4($1)
	i32.const	$push5=, 2
	i32.rem_s	$push6=, $pop4, $pop5
	i32.store16	4($0), $pop6
	i32.load16_s	$push7=, 2($1)
	i32.const	$push8=, 4
	i32.rem_s	$push9=, $pop7, $pop8
	i32.store16	2($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_s	$push13=, 0($pop12)
	i32.const	$push14=, 128
	i32.rem_s	$push15=, $pop13, $pop14
	i32.store16	0($pop11), $pop15
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	i32.const	$push36=, 12
	i32.add 	$push18=, $1, $pop36
	i32.load16_s	$push19=, 0($pop18)
	i32.const	$push20=, 32
	i32.rem_s	$push21=, $pop19, $pop20
	i32.store16	0($pop17), $pop21
	i32.const	$push22=, 10
	i32.add 	$push23=, $0, $pop22
	i32.const	$push35=, 10
	i32.add 	$push24=, $1, $pop35
	i32.load16_s	$push25=, 0($pop24)
	i32.const	$push26=, 64
	i32.rem_s	$push27=, $pop25, $pop26
	i32.store16	0($pop23), $pop27
	i32.const	$push28=, 6
	i32.add 	$push29=, $0, $pop28
	i32.const	$push34=, 6
	i32.add 	$push30=, $1, $pop34
	i32.load16_s	$push31=, 0($pop30)
	i32.const	$push32=, 8
	i32.rem_s	$push33=, $pop31, $pop32
	i32.store16	0($pop29), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	sr1428166432128, .Lfunc_end7-sr1428166432128
                                        # -- End function
	.section	.text.uq33333333,"ax",@progbits
	.hidden	uq33333333              # -- Begin function uq33333333
	.globl	uq33333333
	.type	uq33333333,@function
uq33333333:                             # @uq33333333
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 3
	i32.div_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 3
	i32.div_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 3
	i32.div_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 3
	i32.div_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_u	$push12=, 0($pop11)
	i32.const	$push35=, 3
	i32.div_u	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_u	$push17=, 0($pop16)
	i32.const	$push33=, 3
	i32.div_u	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_u	$push22=, 0($pop21)
	i32.const	$push31=, 3
	i32.div_u	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 3
	i32.div_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	uq33333333, .Lfunc_end8-uq33333333
                                        # -- End function
	.section	.text.ur33333333,"ax",@progbits
	.hidden	ur33333333              # -- Begin function ur33333333
	.globl	ur33333333
	.type	ur33333333,@function
ur33333333:                             # @ur33333333
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 3
	i32.rem_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 3
	i32.rem_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 3
	i32.rem_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 3
	i32.rem_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_u	$push12=, 0($pop11)
	i32.const	$push35=, 3
	i32.rem_u	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_u	$push17=, 0($pop16)
	i32.const	$push33=, 3
	i32.rem_u	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_u	$push22=, 0($pop21)
	i32.const	$push31=, 3
	i32.rem_u	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 3
	i32.rem_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	ur33333333, .Lfunc_end9-ur33333333
                                        # -- End function
	.section	.text.sq33333333,"ax",@progbits
	.hidden	sq33333333              # -- Begin function sq33333333
	.globl	sq33333333
	.type	sq33333333,@function
sq33333333:                             # @sq33333333
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 3
	i32.div_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 3
	i32.div_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 3
	i32.div_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 3
	i32.div_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_s	$push12=, 0($pop11)
	i32.const	$push35=, 3
	i32.div_s	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_s	$push17=, 0($pop16)
	i32.const	$push33=, 3
	i32.div_s	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_s	$push22=, 0($pop21)
	i32.const	$push31=, 3
	i32.div_s	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 3
	i32.div_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	sq33333333, .Lfunc_end10-sq33333333
                                        # -- End function
	.section	.text.sr33333333,"ax",@progbits
	.hidden	sr33333333              # -- Begin function sr33333333
	.globl	sr33333333
	.type	sr33333333,@function
sr33333333:                             # @sr33333333
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 3
	i32.rem_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 3
	i32.rem_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 3
	i32.rem_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 3
	i32.rem_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_s	$push12=, 0($pop11)
	i32.const	$push35=, 3
	i32.rem_s	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_s	$push17=, 0($pop16)
	i32.const	$push33=, 3
	i32.rem_s	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_s	$push22=, 0($pop21)
	i32.const	$push31=, 3
	i32.rem_s	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 3
	i32.rem_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end11:
	.size	sr33333333, .Lfunc_end11-sr33333333
                                        # -- End function
	.section	.text.uq65656565,"ax",@progbits
	.hidden	uq65656565              # -- Begin function uq65656565
	.globl	uq65656565
	.type	uq65656565,@function
uq65656565:                             # @uq65656565
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 6
	i32.div_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 6
	i32.div_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push6=, 5
	i32.div_u	$push7=, $pop5, $pop6
	i32.store16	2($0), $pop7
	i32.load16_u	$push8=, 0($1)
	i32.const	$push38=, 6
	i32.div_u	$push9=, $pop8, $pop38
	i32.store16	0($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_u	$push13=, 0($pop12)
	i32.const	$push36=, 5
	i32.div_u	$push14=, $pop13, $pop36
	i32.store16	0($pop11), $pop14
	i32.const	$push15=, 12
	i32.add 	$push16=, $0, $pop15
	i32.const	$push35=, 12
	i32.add 	$push17=, $1, $pop35
	i32.load16_u	$push18=, 0($pop17)
	i32.const	$push34=, 6
	i32.div_u	$push19=, $pop18, $pop34
	i32.store16	0($pop16), $pop19
	i32.const	$push20=, 10
	i32.add 	$push21=, $0, $pop20
	i32.const	$push33=, 10
	i32.add 	$push22=, $1, $pop33
	i32.load16_u	$push23=, 0($pop22)
	i32.const	$push32=, 5
	i32.div_u	$push24=, $pop23, $pop32
	i32.store16	0($pop21), $pop24
	i32.const	$push31=, 6
	i32.add 	$push25=, $0, $pop31
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 5
	i32.div_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end12:
	.size	uq65656565, .Lfunc_end12-uq65656565
                                        # -- End function
	.section	.text.ur65656565,"ax",@progbits
	.hidden	ur65656565              # -- Begin function ur65656565
	.globl	ur65656565
	.type	ur65656565,@function
ur65656565:                             # @ur65656565
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 6
	i32.rem_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 6
	i32.rem_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push6=, 5
	i32.rem_u	$push7=, $pop5, $pop6
	i32.store16	2($0), $pop7
	i32.load16_u	$push8=, 0($1)
	i32.const	$push38=, 6
	i32.rem_u	$push9=, $pop8, $pop38
	i32.store16	0($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_u	$push13=, 0($pop12)
	i32.const	$push36=, 5
	i32.rem_u	$push14=, $pop13, $pop36
	i32.store16	0($pop11), $pop14
	i32.const	$push15=, 12
	i32.add 	$push16=, $0, $pop15
	i32.const	$push35=, 12
	i32.add 	$push17=, $1, $pop35
	i32.load16_u	$push18=, 0($pop17)
	i32.const	$push34=, 6
	i32.rem_u	$push19=, $pop18, $pop34
	i32.store16	0($pop16), $pop19
	i32.const	$push20=, 10
	i32.add 	$push21=, $0, $pop20
	i32.const	$push33=, 10
	i32.add 	$push22=, $1, $pop33
	i32.load16_u	$push23=, 0($pop22)
	i32.const	$push32=, 5
	i32.rem_u	$push24=, $pop23, $pop32
	i32.store16	0($pop21), $pop24
	i32.const	$push31=, 6
	i32.add 	$push25=, $0, $pop31
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 5
	i32.rem_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end13:
	.size	ur65656565, .Lfunc_end13-ur65656565
                                        # -- End function
	.section	.text.sq65656565,"ax",@progbits
	.hidden	sq65656565              # -- Begin function sq65656565
	.globl	sq65656565
	.type	sq65656565,@function
sq65656565:                             # @sq65656565
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 6
	i32.div_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 6
	i32.div_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push6=, 5
	i32.div_s	$push7=, $pop5, $pop6
	i32.store16	2($0), $pop7
	i32.load16_s	$push8=, 0($1)
	i32.const	$push38=, 6
	i32.div_s	$push9=, $pop8, $pop38
	i32.store16	0($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_s	$push13=, 0($pop12)
	i32.const	$push36=, 5
	i32.div_s	$push14=, $pop13, $pop36
	i32.store16	0($pop11), $pop14
	i32.const	$push15=, 12
	i32.add 	$push16=, $0, $pop15
	i32.const	$push35=, 12
	i32.add 	$push17=, $1, $pop35
	i32.load16_s	$push18=, 0($pop17)
	i32.const	$push34=, 6
	i32.div_s	$push19=, $pop18, $pop34
	i32.store16	0($pop16), $pop19
	i32.const	$push20=, 10
	i32.add 	$push21=, $0, $pop20
	i32.const	$push33=, 10
	i32.add 	$push22=, $1, $pop33
	i32.load16_s	$push23=, 0($pop22)
	i32.const	$push32=, 5
	i32.div_s	$push24=, $pop23, $pop32
	i32.store16	0($pop21), $pop24
	i32.const	$push31=, 6
	i32.add 	$push25=, $0, $pop31
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 5
	i32.div_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end14:
	.size	sq65656565, .Lfunc_end14-sq65656565
                                        # -- End function
	.section	.text.sr65656565,"ax",@progbits
	.hidden	sr65656565              # -- Begin function sr65656565
	.globl	sr65656565
	.type	sr65656565,@function
sr65656565:                             # @sr65656565
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 6
	i32.rem_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 6
	i32.rem_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push6=, 5
	i32.rem_s	$push7=, $pop5, $pop6
	i32.store16	2($0), $pop7
	i32.load16_s	$push8=, 0($1)
	i32.const	$push38=, 6
	i32.rem_s	$push9=, $pop8, $pop38
	i32.store16	0($0), $pop9
	i32.const	$push10=, 14
	i32.add 	$push11=, $0, $pop10
	i32.const	$push37=, 14
	i32.add 	$push12=, $1, $pop37
	i32.load16_s	$push13=, 0($pop12)
	i32.const	$push36=, 5
	i32.rem_s	$push14=, $pop13, $pop36
	i32.store16	0($pop11), $pop14
	i32.const	$push15=, 12
	i32.add 	$push16=, $0, $pop15
	i32.const	$push35=, 12
	i32.add 	$push17=, $1, $pop35
	i32.load16_s	$push18=, 0($pop17)
	i32.const	$push34=, 6
	i32.rem_s	$push19=, $pop18, $pop34
	i32.store16	0($pop16), $pop19
	i32.const	$push20=, 10
	i32.add 	$push21=, $0, $pop20
	i32.const	$push33=, 10
	i32.add 	$push22=, $1, $pop33
	i32.load16_s	$push23=, 0($pop22)
	i32.const	$push32=, 5
	i32.rem_s	$push24=, $pop23, $pop32
	i32.store16	0($pop21), $pop24
	i32.const	$push31=, 6
	i32.add 	$push25=, $0, $pop31
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 5
	i32.rem_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end15:
	.size	sr65656565, .Lfunc_end15-sr65656565
                                        # -- End function
	.section	.text.uq14141461461414,"ax",@progbits
	.hidden	uq14141461461414        # -- Begin function uq14141461461414
	.globl	uq14141461461414
	.type	uq14141461461414,@function
uq14141461461414:                       # @uq14141461461414
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 14
	i32.div_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 14
	i32.div_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 14
	i32.div_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 14
	i32.div_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push36=, 14
	i32.add 	$push9=, $0, $pop36
	i32.const	$push35=, 14
	i32.add 	$push10=, $1, $pop35
	i32.load16_u	$push11=, 0($pop10)
	i32.const	$push34=, 14
	i32.div_u	$push12=, $pop11, $pop34
	i32.store16	0($pop9), $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	i32.const	$push33=, 12
	i32.add 	$push15=, $1, $pop33
	i32.load16_u	$push16=, 0($pop15)
	i32.const	$push32=, 14
	i32.div_u	$push17=, $pop16, $pop32
	i32.store16	0($pop14), $pop17
	i32.const	$push18=, 10
	i32.add 	$push19=, $0, $pop18
	i32.const	$push31=, 10
	i32.add 	$push20=, $1, $pop31
	i32.load16_u	$push21=, 0($pop20)
	i32.const	$push22=, 6
	i32.div_u	$push23=, $pop21, $pop22
	i32.store16	0($pop19), $pop23
	i32.const	$push30=, 6
	i32.add 	$push24=, $0, $pop30
	i32.const	$push29=, 6
	i32.add 	$push25=, $1, $pop29
	i32.load16_u	$push26=, 0($pop25)
	i32.const	$push28=, 6
	i32.div_u	$push27=, $pop26, $pop28
	i32.store16	0($pop24), $pop27
                                        # fallthrough-return
	.endfunc
.Lfunc_end16:
	.size	uq14141461461414, .Lfunc_end16-uq14141461461414
                                        # -- End function
	.section	.text.ur14141461461414,"ax",@progbits
	.hidden	ur14141461461414        # -- Begin function ur14141461461414
	.globl	ur14141461461414
	.type	ur14141461461414,@function
ur14141461461414:                       # @ur14141461461414
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 14
	i32.rem_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 14
	i32.rem_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 14
	i32.rem_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 14
	i32.rem_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push36=, 14
	i32.add 	$push9=, $0, $pop36
	i32.const	$push35=, 14
	i32.add 	$push10=, $1, $pop35
	i32.load16_u	$push11=, 0($pop10)
	i32.const	$push34=, 14
	i32.rem_u	$push12=, $pop11, $pop34
	i32.store16	0($pop9), $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	i32.const	$push33=, 12
	i32.add 	$push15=, $1, $pop33
	i32.load16_u	$push16=, 0($pop15)
	i32.const	$push32=, 14
	i32.rem_u	$push17=, $pop16, $pop32
	i32.store16	0($pop14), $pop17
	i32.const	$push18=, 10
	i32.add 	$push19=, $0, $pop18
	i32.const	$push31=, 10
	i32.add 	$push20=, $1, $pop31
	i32.load16_u	$push21=, 0($pop20)
	i32.const	$push22=, 6
	i32.rem_u	$push23=, $pop21, $pop22
	i32.store16	0($pop19), $pop23
	i32.const	$push30=, 6
	i32.add 	$push24=, $0, $pop30
	i32.const	$push29=, 6
	i32.add 	$push25=, $1, $pop29
	i32.load16_u	$push26=, 0($pop25)
	i32.const	$push28=, 6
	i32.rem_u	$push27=, $pop26, $pop28
	i32.store16	0($pop24), $pop27
                                        # fallthrough-return
	.endfunc
.Lfunc_end17:
	.size	ur14141461461414, .Lfunc_end17-ur14141461461414
                                        # -- End function
	.section	.text.sq14141461461414,"ax",@progbits
	.hidden	sq14141461461414        # -- Begin function sq14141461461414
	.globl	sq14141461461414
	.type	sq14141461461414,@function
sq14141461461414:                       # @sq14141461461414
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 14
	i32.div_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 14
	i32.div_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 14
	i32.div_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 14
	i32.div_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push36=, 14
	i32.add 	$push9=, $0, $pop36
	i32.const	$push35=, 14
	i32.add 	$push10=, $1, $pop35
	i32.load16_s	$push11=, 0($pop10)
	i32.const	$push34=, 14
	i32.div_s	$push12=, $pop11, $pop34
	i32.store16	0($pop9), $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	i32.const	$push33=, 12
	i32.add 	$push15=, $1, $pop33
	i32.load16_s	$push16=, 0($pop15)
	i32.const	$push32=, 14
	i32.div_s	$push17=, $pop16, $pop32
	i32.store16	0($pop14), $pop17
	i32.const	$push18=, 10
	i32.add 	$push19=, $0, $pop18
	i32.const	$push31=, 10
	i32.add 	$push20=, $1, $pop31
	i32.load16_s	$push21=, 0($pop20)
	i32.const	$push22=, 6
	i32.div_s	$push23=, $pop21, $pop22
	i32.store16	0($pop19), $pop23
	i32.const	$push30=, 6
	i32.add 	$push24=, $0, $pop30
	i32.const	$push29=, 6
	i32.add 	$push25=, $1, $pop29
	i32.load16_s	$push26=, 0($pop25)
	i32.const	$push28=, 6
	i32.div_s	$push27=, $pop26, $pop28
	i32.store16	0($pop24), $pop27
                                        # fallthrough-return
	.endfunc
.Lfunc_end18:
	.size	sq14141461461414, .Lfunc_end18-sq14141461461414
                                        # -- End function
	.section	.text.sr14141461461414,"ax",@progbits
	.hidden	sr14141461461414        # -- Begin function sr14141461461414
	.globl	sr14141461461414
	.type	sr14141461461414,@function
sr14141461461414:                       # @sr14141461461414
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 14
	i32.rem_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 14
	i32.rem_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 14
	i32.rem_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 14
	i32.rem_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push36=, 14
	i32.add 	$push9=, $0, $pop36
	i32.const	$push35=, 14
	i32.add 	$push10=, $1, $pop35
	i32.load16_s	$push11=, 0($pop10)
	i32.const	$push34=, 14
	i32.rem_s	$push12=, $pop11, $pop34
	i32.store16	0($pop9), $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $0, $pop13
	i32.const	$push33=, 12
	i32.add 	$push15=, $1, $pop33
	i32.load16_s	$push16=, 0($pop15)
	i32.const	$push32=, 14
	i32.rem_s	$push17=, $pop16, $pop32
	i32.store16	0($pop14), $pop17
	i32.const	$push18=, 10
	i32.add 	$push19=, $0, $pop18
	i32.const	$push31=, 10
	i32.add 	$push20=, $1, $pop31
	i32.load16_s	$push21=, 0($pop20)
	i32.const	$push22=, 6
	i32.rem_s	$push23=, $pop21, $pop22
	i32.store16	0($pop19), $pop23
	i32.const	$push30=, 6
	i32.add 	$push24=, $0, $pop30
	i32.const	$push29=, 6
	i32.add 	$push25=, $1, $pop29
	i32.load16_s	$push26=, 0($pop25)
	i32.const	$push28=, 6
	i32.rem_s	$push27=, $pop26, $pop28
	i32.store16	0($pop24), $pop27
                                        # fallthrough-return
	.endfunc
.Lfunc_end19:
	.size	sr14141461461414, .Lfunc_end19-sr14141461461414
                                        # -- End function
	.section	.text.uq77777777,"ax",@progbits
	.hidden	uq77777777              # -- Begin function uq77777777
	.globl	uq77777777
	.type	uq77777777,@function
uq77777777:                             # @uq77777777
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.div_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 7
	i32.div_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 7
	i32.div_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 7
	i32.div_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_u	$push12=, 0($pop11)
	i32.const	$push35=, 7
	i32.div_u	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_u	$push17=, 0($pop16)
	i32.const	$push33=, 7
	i32.div_u	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_u	$push22=, 0($pop21)
	i32.const	$push31=, 7
	i32.div_u	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 7
	i32.div_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end20:
	.size	uq77777777, .Lfunc_end20-uq77777777
                                        # -- End function
	.section	.text.ur77777777,"ax",@progbits
	.hidden	ur77777777              # -- Begin function ur77777777
	.globl	ur77777777
	.type	ur77777777,@function
ur77777777:                             # @ur77777777
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_u	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.rem_u	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_u	$push3=, 4($1)
	i32.const	$push39=, 7
	i32.rem_u	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_u	$push5=, 2($1)
	i32.const	$push38=, 7
	i32.rem_u	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_u	$push7=, 0($1)
	i32.const	$push37=, 7
	i32.rem_u	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_u	$push12=, 0($pop11)
	i32.const	$push35=, 7
	i32.rem_u	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_u	$push17=, 0($pop16)
	i32.const	$push33=, 7
	i32.rem_u	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_u	$push22=, 0($pop21)
	i32.const	$push31=, 7
	i32.rem_u	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_u	$push27=, 0($pop26)
	i32.const	$push29=, 7
	i32.rem_u	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end21:
	.size	ur77777777, .Lfunc_end21-ur77777777
                                        # -- End function
	.section	.text.sq77777777,"ax",@progbits
	.hidden	sq77777777              # -- Begin function sq77777777
	.globl	sq77777777
	.type	sq77777777,@function
sq77777777:                             # @sq77777777
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.div_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 7
	i32.div_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 7
	i32.div_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 7
	i32.div_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_s	$push12=, 0($pop11)
	i32.const	$push35=, 7
	i32.div_s	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_s	$push17=, 0($pop16)
	i32.const	$push33=, 7
	i32.div_s	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_s	$push22=, 0($pop21)
	i32.const	$push31=, 7
	i32.div_s	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 7
	i32.div_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end22:
	.size	sq77777777, .Lfunc_end22-sq77777777
                                        # -- End function
	.section	.text.sr77777777,"ax",@progbits
	.hidden	sr77777777              # -- Begin function sr77777777
	.globl	sr77777777
	.type	sr77777777,@function
sr77777777:                             # @sr77777777
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load16_s	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.rem_s	$push2=, $pop0, $pop1
	i32.store16	8($0), $pop2
	i32.load16_s	$push3=, 4($1)
	i32.const	$push39=, 7
	i32.rem_s	$push4=, $pop3, $pop39
	i32.store16	4($0), $pop4
	i32.load16_s	$push5=, 2($1)
	i32.const	$push38=, 7
	i32.rem_s	$push6=, $pop5, $pop38
	i32.store16	2($0), $pop6
	i32.load16_s	$push7=, 0($1)
	i32.const	$push37=, 7
	i32.rem_s	$push8=, $pop7, $pop37
	i32.store16	0($0), $pop8
	i32.const	$push9=, 14
	i32.add 	$push10=, $0, $pop9
	i32.const	$push36=, 14
	i32.add 	$push11=, $1, $pop36
	i32.load16_s	$push12=, 0($pop11)
	i32.const	$push35=, 7
	i32.rem_s	$push13=, $pop12, $pop35
	i32.store16	0($pop10), $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.const	$push34=, 12
	i32.add 	$push16=, $1, $pop34
	i32.load16_s	$push17=, 0($pop16)
	i32.const	$push33=, 7
	i32.rem_s	$push18=, $pop17, $pop33
	i32.store16	0($pop15), $pop18
	i32.const	$push19=, 10
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 10
	i32.add 	$push21=, $1, $pop32
	i32.load16_s	$push22=, 0($pop21)
	i32.const	$push31=, 7
	i32.rem_s	$push23=, $pop22, $pop31
	i32.store16	0($pop20), $pop23
	i32.const	$push24=, 6
	i32.add 	$push25=, $0, $pop24
	i32.const	$push30=, 6
	i32.add 	$push26=, $1, $pop30
	i32.load16_s	$push27=, 0($pop26)
	i32.const	$push29=, 7
	i32.rem_s	$push28=, $pop27, $pop29
	i32.store16	0($pop25), $pop28
                                        # fallthrough-return
	.endfunc
.Lfunc_end23:
	.size	sr77777777, .Lfunc_end23-sr77777777
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push1069=, 0
	i32.load	$push1068=, __stack_pointer($pop1069)
	i32.const	$push1070=, 32
	i32.sub 	$7=, $pop1068, $pop1070
	i32.const	$push1071=, 0
	i32.store	__stack_pointer($pop1071), $7
	i32.const	$0=, 0
.LBB24_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push1197=, 4
	i32.shl 	$2=, $0, $pop1197
	i32.const	$push1196=, u
	i32.add 	$1=, $2, $pop1196
	i32.const	$push1075=, 16
	i32.add 	$push1076=, $7, $pop1075
	call    	uq44444444@FUNCTION, $pop1076, $1
	i32.load16_u	$push0=, 16($7)
	i32.load16_u	$push2=, 0($1)
	i32.const	$push1195=, 2
	i32.shr_u	$push380=, $pop2, $pop1195
	i32.ne  	$push381=, $pop0, $pop380
	br_if   	1, $pop381      # 1: down to label0
# %bb.2:                                # %lor.lhs.false
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push1=, 22($7)
	i32.const	$push1201=, 65535
	i32.and 	$push383=, $pop1, $pop1201
	i32.const	$push1200=, u+6
	i32.add 	$push382=, $2, $pop1200
	i32.load16_u	$push3=, 0($pop382)
	i32.const	$push1199=, 65532
	i32.and 	$push384=, $pop3, $pop1199
	i32.const	$push1198=, 2
	i32.shr_u	$push385=, $pop384, $pop1198
	i32.ne  	$push386=, $pop383, $pop385
	br_if   	1, $pop386      # 1: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1077=, 16
	i32.add 	$push1078=, $7, $pop1077
	copy_local	$2=, $pop1078
	#APP
	#NO_APP
	i32.load16_u	$push5=, 20($7)
	i32.load16_u	$push7=, 4($1)
	i32.const	$push1202=, 2
	i32.shr_u	$push387=, $pop7, $pop1202
	i32.ne  	$push388=, $pop5, $pop387
	br_if   	1, $pop388      # 1: down to label0
# %bb.4:                                # %lor.lhs.false21
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push4=, 18($7)
	i32.const	$push1205=, 65535
	i32.and 	$push389=, $pop4, $pop1205
	i32.load16_u	$push6=, 2($1)
	i32.const	$push1204=, 65532
	i32.and 	$push390=, $pop6, $pop1204
	i32.const	$push1203=, 2
	i32.shr_u	$push391=, $pop390, $pop1203
	i32.ne  	$push392=, $pop389, $pop391
	br_if   	1, $pop392      # 1: down to label0
# %bb.5:                                # %if.end31
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1079=, 16
	i32.add 	$push1080=, $7, $pop1079
	copy_local	$2=, $pop1080
	#APP
	#NO_APP
	i32.load16_u	$push8=, 24($7)
	i32.load16_u	$push10=, 8($1)
	i32.const	$push1206=, 2
	i32.shr_u	$push393=, $pop10, $pop1206
	i32.ne  	$push394=, $pop8, $pop393
	br_if   	1, $pop394      # 1: down to label0
# %bb.6:                                # %lor.lhs.false40
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1210=, 14
	i32.add 	$2=, $1, $pop1210
	i32.load16_u	$push9=, 30($7)
	i32.const	$push1209=, 65535
	i32.and 	$push395=, $pop9, $pop1209
	i32.load16_u	$push11=, 0($2)
	i32.const	$push1208=, 65532
	i32.and 	$push396=, $pop11, $pop1208
	i32.const	$push1207=, 2
	i32.shr_u	$push397=, $pop396, $pop1207
	i32.ne  	$push398=, $pop395, $pop397
	br_if   	1, $pop398      # 1: down to label0
# %bb.7:                                # %if.end50
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1081=, 16
	i32.add 	$push1082=, $7, $pop1081
	copy_local	$3=, $pop1082
	#APP
	#NO_APP
	i32.const	$push1212=, 12
	i32.add 	$3=, $1, $pop1212
	i32.load16_u	$push13=, 28($7)
	i32.load16_u	$push15=, 0($3)
	i32.const	$push1211=, 2
	i32.shr_u	$push399=, $pop15, $pop1211
	i32.ne  	$push400=, $pop13, $pop399
	br_if   	1, $pop400      # 1: down to label0
# %bb.8:                                # %lor.lhs.false59
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1216=, 10
	i32.add 	$4=, $1, $pop1216
	i32.load16_u	$push12=, 26($7)
	i32.const	$push1215=, 65535
	i32.and 	$push401=, $pop12, $pop1215
	i32.load16_u	$push14=, 0($4)
	i32.const	$push1214=, 65532
	i32.and 	$push402=, $pop14, $pop1214
	i32.const	$push1213=, 2
	i32.shr_u	$push403=, $pop402, $pop1213
	i32.ne  	$push404=, $pop401, $pop403
	br_if   	1, $pop404      # 1: down to label0
# %bb.9:                                # %if.end69
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1083=, 16
	i32.add 	$push1084=, $7, $pop1083
	copy_local	$5=, $pop1084
	#APP
	#NO_APP
	i32.const	$push1085=, 16
	i32.add 	$push1086=, $7, $pop1085
	call    	ur44444444@FUNCTION, $pop1086, $1
	i32.load16_u	$push16=, 16($7)
	i32.load16_u	$push18=, 0($1)
	i32.const	$push1217=, 3
	i32.and 	$push405=, $pop18, $pop1217
	i32.ne  	$push406=, $pop16, $pop405
	br_if   	1, $pop406      # 1: down to label0
# %bb.10:                               # %lor.lhs.false78
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1220=, 6
	i32.add 	$5=, $1, $pop1220
	i32.load16_u	$push17=, 22($7)
	i32.const	$push1219=, 65535
	i32.and 	$push408=, $pop17, $pop1219
	i32.load16_u	$push19=, 0($5)
	i32.const	$push1218=, 3
	i32.and 	$push407=, $pop19, $pop1218
	i32.ne  	$push409=, $pop408, $pop407
	br_if   	1, $pop409      # 1: down to label0
# %bb.11:                               # %if.end88
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1087=, 16
	i32.add 	$push1088=, $7, $pop1087
	copy_local	$6=, $pop1088
	#APP
	#NO_APP
	i32.load16_u	$push21=, 20($7)
	i32.load16_u	$push23=, 4($1)
	i32.const	$push1221=, 3
	i32.and 	$push410=, $pop23, $pop1221
	i32.ne  	$push411=, $pop21, $pop410
	br_if   	1, $pop411      # 1: down to label0
# %bb.12:                               # %lor.lhs.false97
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push20=, 18($7)
	i32.const	$push1223=, 65535
	i32.and 	$push413=, $pop20, $pop1223
	i32.load16_u	$push22=, 2($1)
	i32.const	$push1222=, 3
	i32.and 	$push412=, $pop22, $pop1222
	i32.ne  	$push414=, $pop413, $pop412
	br_if   	1, $pop414      # 1: down to label0
# %bb.13:                               # %if.end107
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1089=, 16
	i32.add 	$push1090=, $7, $pop1089
	copy_local	$6=, $pop1090
	#APP
	#NO_APP
	i32.load16_u	$push24=, 24($7)
	i32.load16_u	$push26=, 8($1)
	i32.const	$push1224=, 3
	i32.and 	$push415=, $pop26, $pop1224
	i32.ne  	$push416=, $pop24, $pop415
	br_if   	1, $pop416      # 1: down to label0
# %bb.14:                               # %lor.lhs.false116
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push25=, 30($7)
	i32.const	$push1226=, 65535
	i32.and 	$push418=, $pop25, $pop1226
	i32.load16_u	$push27=, 0($2)
	i32.const	$push1225=, 3
	i32.and 	$push417=, $pop27, $pop1225
	i32.ne  	$push419=, $pop418, $pop417
	br_if   	1, $pop419      # 1: down to label0
# %bb.15:                               # %if.end126
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1091=, 16
	i32.add 	$push1092=, $7, $pop1091
	copy_local	$6=, $pop1092
	#APP
	#NO_APP
	i32.load16_u	$push29=, 28($7)
	i32.load16_u	$push31=, 0($3)
	i32.const	$push1227=, 3
	i32.and 	$push420=, $pop31, $pop1227
	i32.ne  	$push421=, $pop29, $pop420
	br_if   	1, $pop421      # 1: down to label0
# %bb.16:                               # %lor.lhs.false135
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push28=, 26($7)
	i32.const	$push1229=, 65535
	i32.and 	$push423=, $pop28, $pop1229
	i32.load16_u	$push30=, 0($4)
	i32.const	$push1228=, 3
	i32.and 	$push422=, $pop30, $pop1228
	i32.ne  	$push424=, $pop423, $pop422
	br_if   	1, $pop424      # 1: down to label0
# %bb.17:                               # %if.end145
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1093=, 16
	i32.add 	$push1094=, $7, $pop1093
	copy_local	$6=, $pop1094
	#APP
	#NO_APP
	i32.const	$push1095=, 16
	i32.add 	$push1096=, $7, $pop1095
	call    	uq1428166432128@FUNCTION, $pop1096, $1
	i32.load16_u	$push32=, 16($7)
	i32.load16_u	$push34=, 0($1)
	i32.ne  	$push425=, $pop32, $pop34
	br_if   	1, $pop425      # 1: down to label0
# %bb.18:                               # %lor.lhs.false155
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push33=, 22($7)
	i32.const	$push1232=, 65535
	i32.and 	$push426=, $pop33, $pop1232
	i32.load16_u	$push35=, 0($5)
	i32.const	$push1231=, 65528
	i32.and 	$push427=, $pop35, $pop1231
	i32.const	$push1230=, 3
	i32.shr_u	$push428=, $pop427, $pop1230
	i32.ne  	$push429=, $pop426, $pop428
	br_if   	1, $pop429      # 1: down to label0
# %bb.19:                               # %if.end165
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1097=, 16
	i32.add 	$push1098=, $7, $pop1097
	copy_local	$6=, $pop1098
	#APP
	#NO_APP
	i32.load16_u	$push37=, 20($7)
	i32.load16_u	$push39=, 4($1)
	i32.const	$push1233=, 1
	i32.shr_u	$push430=, $pop39, $pop1233
	i32.ne  	$push431=, $pop37, $pop430
	br_if   	1, $pop431      # 1: down to label0
# %bb.20:                               # %lor.lhs.false174
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push36=, 18($7)
	i32.const	$push1236=, 65535
	i32.and 	$push432=, $pop36, $pop1236
	i32.load16_u	$push38=, 2($1)
	i32.const	$push1235=, 65532
	i32.and 	$push433=, $pop38, $pop1235
	i32.const	$push1234=, 2
	i32.shr_u	$push434=, $pop433, $pop1234
	i32.ne  	$push435=, $pop432, $pop434
	br_if   	1, $pop435      # 1: down to label0
# %bb.21:                               # %if.end184
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1099=, 16
	i32.add 	$push1100=, $7, $pop1099
	copy_local	$6=, $pop1100
	#APP
	#NO_APP
	i32.load16_u	$push40=, 24($7)
	i32.load16_u	$push42=, 8($1)
	i32.const	$push1237=, 4
	i32.shr_u	$push436=, $pop42, $pop1237
	i32.ne  	$push437=, $pop40, $pop436
	br_if   	1, $pop437      # 1: down to label0
# %bb.22:                               # %lor.lhs.false193
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push41=, 30($7)
	i32.const	$push1240=, 65535
	i32.and 	$push438=, $pop41, $pop1240
	i32.load16_u	$push43=, 0($2)
	i32.const	$push1239=, 65408
	i32.and 	$push439=, $pop43, $pop1239
	i32.const	$push1238=, 7
	i32.shr_u	$push440=, $pop439, $pop1238
	i32.ne  	$push441=, $pop438, $pop440
	br_if   	1, $pop441      # 1: down to label0
# %bb.23:                               # %if.end203
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1101=, 16
	i32.add 	$push1102=, $7, $pop1101
	copy_local	$6=, $pop1102
	#APP
	#NO_APP
	i32.load16_u	$push45=, 28($7)
	i32.load16_u	$push47=, 0($3)
	i32.const	$push1241=, 5
	i32.shr_u	$push442=, $pop47, $pop1241
	i32.ne  	$push443=, $pop45, $pop442
	br_if   	1, $pop443      # 1: down to label0
# %bb.24:                               # %lor.lhs.false212
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push44=, 26($7)
	i32.const	$push1244=, 65535
	i32.and 	$push444=, $pop44, $pop1244
	i32.load16_u	$push46=, 0($4)
	i32.const	$push1243=, 65472
	i32.and 	$push445=, $pop46, $pop1243
	i32.const	$push1242=, 6
	i32.shr_u	$push446=, $pop445, $pop1242
	i32.ne  	$push447=, $pop444, $pop446
	br_if   	1, $pop447      # 1: down to label0
# %bb.25:                               # %if.end222
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1103=, 16
	i32.add 	$push1104=, $7, $pop1103
	copy_local	$6=, $pop1104
	#APP
	#NO_APP
	i32.const	$push1105=, 16
	i32.add 	$push1106=, $7, $pop1105
	call    	ur1428166432128@FUNCTION, $pop1106, $1
	i32.load16_u	$push48=, 16($7)
	br_if   	1, $pop48       # 1: down to label0
# %bb.26:                               # %lor.lhs.false232
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push49=, 22($7)
	i32.const	$push1246=, 65535
	i32.and 	$push450=, $pop49, $pop1246
	i32.load16_u	$push448=, 0($5)
	i32.const	$push1245=, 7
	i32.and 	$push449=, $pop448, $pop1245
	i32.ne  	$push451=, $pop450, $pop449
	br_if   	1, $pop451      # 1: down to label0
# %bb.27:                               # %if.end242
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1107=, 16
	i32.add 	$push1108=, $7, $pop1107
	copy_local	$6=, $pop1108
	#APP
	#NO_APP
	i32.load16_u	$push51=, 20($7)
	i32.load16_u	$push53=, 4($1)
	i32.const	$push1247=, 1
	i32.and 	$push452=, $pop53, $pop1247
	i32.ne  	$push453=, $pop51, $pop452
	br_if   	1, $pop453      # 1: down to label0
# %bb.28:                               # %lor.lhs.false251
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push50=, 18($7)
	i32.const	$push1249=, 65535
	i32.and 	$push455=, $pop50, $pop1249
	i32.load16_u	$push52=, 2($1)
	i32.const	$push1248=, 3
	i32.and 	$push454=, $pop52, $pop1248
	i32.ne  	$push456=, $pop455, $pop454
	br_if   	1, $pop456      # 1: down to label0
# %bb.29:                               # %if.end261
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1109=, 16
	i32.add 	$push1110=, $7, $pop1109
	copy_local	$6=, $pop1110
	#APP
	#NO_APP
	i32.load16_u	$push54=, 24($7)
	i32.load16_u	$push56=, 8($1)
	i32.const	$push1250=, 15
	i32.and 	$push457=, $pop56, $pop1250
	i32.ne  	$push458=, $pop54, $pop457
	br_if   	1, $pop458      # 1: down to label0
# %bb.30:                               # %lor.lhs.false270
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push55=, 30($7)
	i32.const	$push1252=, 65535
	i32.and 	$push460=, $pop55, $pop1252
	i32.load16_u	$push57=, 0($2)
	i32.const	$push1251=, 127
	i32.and 	$push459=, $pop57, $pop1251
	i32.ne  	$push461=, $pop460, $pop459
	br_if   	1, $pop461      # 1: down to label0
# %bb.31:                               # %if.end280
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1111=, 16
	i32.add 	$push1112=, $7, $pop1111
	copy_local	$6=, $pop1112
	#APP
	#NO_APP
	i32.load16_u	$push59=, 28($7)
	i32.load16_u	$push61=, 0($3)
	i32.const	$push1253=, 31
	i32.and 	$push462=, $pop61, $pop1253
	i32.ne  	$push463=, $pop59, $pop462
	br_if   	1, $pop463      # 1: down to label0
# %bb.32:                               # %lor.lhs.false289
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push58=, 26($7)
	i32.const	$push1255=, 65535
	i32.and 	$push465=, $pop58, $pop1255
	i32.load16_u	$push60=, 0($4)
	i32.const	$push1254=, 63
	i32.and 	$push464=, $pop60, $pop1254
	i32.ne  	$push466=, $pop465, $pop464
	br_if   	1, $pop466      # 1: down to label0
# %bb.33:                               # %if.end299
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1113=, 16
	i32.add 	$push1114=, $7, $pop1113
	copy_local	$6=, $pop1114
	#APP
	#NO_APP
	i32.const	$push1115=, 16
	i32.add 	$push1116=, $7, $pop1115
	call    	uq33333333@FUNCTION, $pop1116, $1
	i32.load16_u	$push62=, 16($7)
	i32.load16_u	$push64=, 0($1)
	i32.const	$push1256=, 3
	i32.div_u	$push467=, $pop64, $pop1256
	i32.ne  	$push468=, $pop62, $pop467
	br_if   	1, $pop468      # 1: down to label0
# %bb.34:                               # %lor.lhs.false309
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push63=, 22($7)
	i32.const	$push1259=, 65535
	i32.and 	$push469=, $pop63, $pop1259
	i32.load16_u	$push65=, 0($5)
	i32.const	$push1258=, 65535
	i32.and 	$push470=, $pop65, $pop1258
	i32.const	$push1257=, 3
	i32.div_u	$push471=, $pop470, $pop1257
	i32.ne  	$push472=, $pop469, $pop471
	br_if   	1, $pop472      # 1: down to label0
# %bb.35:                               # %if.end319
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1117=, 16
	i32.add 	$push1118=, $7, $pop1117
	copy_local	$6=, $pop1118
	#APP
	#NO_APP
	i32.load16_u	$push67=, 20($7)
	i32.load16_u	$push69=, 4($1)
	i32.const	$push1260=, 3
	i32.div_u	$push473=, $pop69, $pop1260
	i32.ne  	$push474=, $pop67, $pop473
	br_if   	1, $pop474      # 1: down to label0
# %bb.36:                               # %lor.lhs.false328
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push66=, 18($7)
	i32.const	$push1263=, 65535
	i32.and 	$push475=, $pop66, $pop1263
	i32.load16_u	$push68=, 2($1)
	i32.const	$push1262=, 65535
	i32.and 	$push476=, $pop68, $pop1262
	i32.const	$push1261=, 3
	i32.div_u	$push477=, $pop476, $pop1261
	i32.ne  	$push478=, $pop475, $pop477
	br_if   	1, $pop478      # 1: down to label0
# %bb.37:                               # %if.end338
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1119=, 16
	i32.add 	$push1120=, $7, $pop1119
	copy_local	$6=, $pop1120
	#APP
	#NO_APP
	i32.load16_u	$push70=, 24($7)
	i32.load16_u	$push72=, 8($1)
	i32.const	$push1264=, 3
	i32.div_u	$push479=, $pop72, $pop1264
	i32.ne  	$push480=, $pop70, $pop479
	br_if   	1, $pop480      # 1: down to label0
# %bb.38:                               # %lor.lhs.false347
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push71=, 30($7)
	i32.const	$push1267=, 65535
	i32.and 	$push481=, $pop71, $pop1267
	i32.load16_u	$push73=, 0($2)
	i32.const	$push1266=, 65535
	i32.and 	$push482=, $pop73, $pop1266
	i32.const	$push1265=, 3
	i32.div_u	$push483=, $pop482, $pop1265
	i32.ne  	$push484=, $pop481, $pop483
	br_if   	1, $pop484      # 1: down to label0
# %bb.39:                               # %if.end357
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1121=, 16
	i32.add 	$push1122=, $7, $pop1121
	copy_local	$6=, $pop1122
	#APP
	#NO_APP
	i32.load16_u	$push75=, 28($7)
	i32.load16_u	$push77=, 0($3)
	i32.const	$push1268=, 3
	i32.div_u	$push485=, $pop77, $pop1268
	i32.ne  	$push486=, $pop75, $pop485
	br_if   	1, $pop486      # 1: down to label0
# %bb.40:                               # %lor.lhs.false366
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push74=, 26($7)
	i32.const	$push1271=, 65535
	i32.and 	$push487=, $pop74, $pop1271
	i32.load16_u	$push76=, 0($4)
	i32.const	$push1270=, 65535
	i32.and 	$push488=, $pop76, $pop1270
	i32.const	$push1269=, 3
	i32.div_u	$push489=, $pop488, $pop1269
	i32.ne  	$push490=, $pop487, $pop489
	br_if   	1, $pop490      # 1: down to label0
# %bb.41:                               # %if.end376
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1123=, 16
	i32.add 	$push1124=, $7, $pop1123
	copy_local	$6=, $pop1124
	#APP
	#NO_APP
	i32.const	$push1125=, 16
	i32.add 	$push1126=, $7, $pop1125
	call    	ur33333333@FUNCTION, $pop1126, $1
	i32.load16_u	$push78=, 16($7)
	i32.load16_u	$push80=, 0($1)
	i32.const	$push1272=, 3
	i32.rem_u	$push491=, $pop80, $pop1272
	i32.ne  	$push492=, $pop78, $pop491
	br_if   	1, $pop492      # 1: down to label0
# %bb.42:                               # %lor.lhs.false386
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push79=, 22($7)
	i32.const	$push1275=, 65535
	i32.and 	$push493=, $pop79, $pop1275
	i32.load16_u	$push81=, 0($5)
	i32.const	$push1274=, 65535
	i32.and 	$push494=, $pop81, $pop1274
	i32.const	$push1273=, 3
	i32.rem_u	$push495=, $pop494, $pop1273
	i32.ne  	$push496=, $pop493, $pop495
	br_if   	1, $pop496      # 1: down to label0
# %bb.43:                               # %if.end396
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1127=, 16
	i32.add 	$push1128=, $7, $pop1127
	copy_local	$6=, $pop1128
	#APP
	#NO_APP
	i32.load16_u	$push83=, 20($7)
	i32.load16_u	$push85=, 4($1)
	i32.const	$push1276=, 3
	i32.rem_u	$push497=, $pop85, $pop1276
	i32.ne  	$push498=, $pop83, $pop497
	br_if   	1, $pop498      # 1: down to label0
# %bb.44:                               # %lor.lhs.false405
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push82=, 18($7)
	i32.const	$push1279=, 65535
	i32.and 	$push499=, $pop82, $pop1279
	i32.load16_u	$push84=, 2($1)
	i32.const	$push1278=, 65535
	i32.and 	$push500=, $pop84, $pop1278
	i32.const	$push1277=, 3
	i32.rem_u	$push501=, $pop500, $pop1277
	i32.ne  	$push502=, $pop499, $pop501
	br_if   	1, $pop502      # 1: down to label0
# %bb.45:                               # %if.end415
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1129=, 16
	i32.add 	$push1130=, $7, $pop1129
	copy_local	$6=, $pop1130
	#APP
	#NO_APP
	i32.load16_u	$push86=, 24($7)
	i32.load16_u	$push88=, 8($1)
	i32.const	$push1280=, 3
	i32.rem_u	$push503=, $pop88, $pop1280
	i32.ne  	$push504=, $pop86, $pop503
	br_if   	1, $pop504      # 1: down to label0
# %bb.46:                               # %lor.lhs.false424
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push87=, 30($7)
	i32.const	$push1283=, 65535
	i32.and 	$push505=, $pop87, $pop1283
	i32.load16_u	$push89=, 0($2)
	i32.const	$push1282=, 65535
	i32.and 	$push506=, $pop89, $pop1282
	i32.const	$push1281=, 3
	i32.rem_u	$push507=, $pop506, $pop1281
	i32.ne  	$push508=, $pop505, $pop507
	br_if   	1, $pop508      # 1: down to label0
# %bb.47:                               # %if.end434
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1131=, 16
	i32.add 	$push1132=, $7, $pop1131
	copy_local	$6=, $pop1132
	#APP
	#NO_APP
	i32.load16_u	$push91=, 28($7)
	i32.load16_u	$push93=, 0($3)
	i32.const	$push1284=, 3
	i32.rem_u	$push509=, $pop93, $pop1284
	i32.ne  	$push510=, $pop91, $pop509
	br_if   	1, $pop510      # 1: down to label0
# %bb.48:                               # %lor.lhs.false443
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push90=, 26($7)
	i32.const	$push1287=, 65535
	i32.and 	$push511=, $pop90, $pop1287
	i32.load16_u	$push92=, 0($4)
	i32.const	$push1286=, 65535
	i32.and 	$push512=, $pop92, $pop1286
	i32.const	$push1285=, 3
	i32.rem_u	$push513=, $pop512, $pop1285
	i32.ne  	$push514=, $pop511, $pop513
	br_if   	1, $pop514      # 1: down to label0
# %bb.49:                               # %if.end453
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1133=, 16
	i32.add 	$push1134=, $7, $pop1133
	copy_local	$6=, $pop1134
	#APP
	#NO_APP
	i32.const	$push1135=, 16
	i32.add 	$push1136=, $7, $pop1135
	call    	uq65656565@FUNCTION, $pop1136, $1
	i32.load16_u	$push94=, 16($7)
	i32.load16_u	$push96=, 0($1)
	i32.const	$push1288=, 6
	i32.div_u	$push515=, $pop96, $pop1288
	i32.ne  	$push516=, $pop94, $pop515
	br_if   	1, $pop516      # 1: down to label0
# %bb.50:                               # %lor.lhs.false463
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push95=, 22($7)
	i32.const	$push1291=, 65535
	i32.and 	$push517=, $pop95, $pop1291
	i32.load16_u	$push97=, 0($5)
	i32.const	$push1290=, 65535
	i32.and 	$push518=, $pop97, $pop1290
	i32.const	$push1289=, 5
	i32.div_u	$push519=, $pop518, $pop1289
	i32.ne  	$push520=, $pop517, $pop519
	br_if   	1, $pop520      # 1: down to label0
# %bb.51:                               # %if.end473
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1137=, 16
	i32.add 	$push1138=, $7, $pop1137
	copy_local	$6=, $pop1138
	#APP
	#NO_APP
	i32.load16_u	$push99=, 20($7)
	i32.load16_u	$push101=, 4($1)
	i32.const	$push1292=, 6
	i32.div_u	$push521=, $pop101, $pop1292
	i32.ne  	$push522=, $pop99, $pop521
	br_if   	1, $pop522      # 1: down to label0
# %bb.52:                               # %lor.lhs.false482
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push98=, 18($7)
	i32.const	$push1295=, 65535
	i32.and 	$push523=, $pop98, $pop1295
	i32.load16_u	$push100=, 2($1)
	i32.const	$push1294=, 65535
	i32.and 	$push524=, $pop100, $pop1294
	i32.const	$push1293=, 5
	i32.div_u	$push525=, $pop524, $pop1293
	i32.ne  	$push526=, $pop523, $pop525
	br_if   	1, $pop526      # 1: down to label0
# %bb.53:                               # %if.end492
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1139=, 16
	i32.add 	$push1140=, $7, $pop1139
	copy_local	$6=, $pop1140
	#APP
	#NO_APP
	i32.load16_u	$push102=, 24($7)
	i32.load16_u	$push104=, 8($1)
	i32.const	$push1296=, 6
	i32.div_u	$push527=, $pop104, $pop1296
	i32.ne  	$push528=, $pop102, $pop527
	br_if   	1, $pop528      # 1: down to label0
# %bb.54:                               # %lor.lhs.false501
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push103=, 30($7)
	i32.const	$push1299=, 65535
	i32.and 	$push529=, $pop103, $pop1299
	i32.load16_u	$push105=, 0($2)
	i32.const	$push1298=, 65535
	i32.and 	$push530=, $pop105, $pop1298
	i32.const	$push1297=, 5
	i32.div_u	$push531=, $pop530, $pop1297
	i32.ne  	$push532=, $pop529, $pop531
	br_if   	1, $pop532      # 1: down to label0
# %bb.55:                               # %if.end511
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1141=, 16
	i32.add 	$push1142=, $7, $pop1141
	copy_local	$6=, $pop1142
	#APP
	#NO_APP
	i32.load16_u	$push107=, 28($7)
	i32.load16_u	$push109=, 0($3)
	i32.const	$push1300=, 6
	i32.div_u	$push533=, $pop109, $pop1300
	i32.ne  	$push534=, $pop107, $pop533
	br_if   	1, $pop534      # 1: down to label0
# %bb.56:                               # %lor.lhs.false520
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push106=, 26($7)
	i32.const	$push1303=, 65535
	i32.and 	$push535=, $pop106, $pop1303
	i32.load16_u	$push108=, 0($4)
	i32.const	$push1302=, 65535
	i32.and 	$push536=, $pop108, $pop1302
	i32.const	$push1301=, 5
	i32.div_u	$push537=, $pop536, $pop1301
	i32.ne  	$push538=, $pop535, $pop537
	br_if   	1, $pop538      # 1: down to label0
# %bb.57:                               # %if.end530
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1143=, 16
	i32.add 	$push1144=, $7, $pop1143
	copy_local	$6=, $pop1144
	#APP
	#NO_APP
	i32.const	$push1145=, 16
	i32.add 	$push1146=, $7, $pop1145
	call    	ur65656565@FUNCTION, $pop1146, $1
	i32.load16_u	$push110=, 16($7)
	i32.load16_u	$push112=, 0($1)
	i32.const	$push1304=, 6
	i32.rem_u	$push539=, $pop112, $pop1304
	i32.ne  	$push540=, $pop110, $pop539
	br_if   	1, $pop540      # 1: down to label0
# %bb.58:                               # %lor.lhs.false540
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push111=, 22($7)
	i32.const	$push1307=, 65535
	i32.and 	$push541=, $pop111, $pop1307
	i32.load16_u	$push113=, 0($5)
	i32.const	$push1306=, 65535
	i32.and 	$push542=, $pop113, $pop1306
	i32.const	$push1305=, 5
	i32.rem_u	$push543=, $pop542, $pop1305
	i32.ne  	$push544=, $pop541, $pop543
	br_if   	1, $pop544      # 1: down to label0
# %bb.59:                               # %if.end550
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1147=, 16
	i32.add 	$push1148=, $7, $pop1147
	copy_local	$6=, $pop1148
	#APP
	#NO_APP
	i32.load16_u	$push115=, 20($7)
	i32.load16_u	$push117=, 4($1)
	i32.const	$push1308=, 6
	i32.rem_u	$push545=, $pop117, $pop1308
	i32.ne  	$push546=, $pop115, $pop545
	br_if   	1, $pop546      # 1: down to label0
# %bb.60:                               # %lor.lhs.false559
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push114=, 18($7)
	i32.const	$push1311=, 65535
	i32.and 	$push547=, $pop114, $pop1311
	i32.load16_u	$push116=, 2($1)
	i32.const	$push1310=, 65535
	i32.and 	$push548=, $pop116, $pop1310
	i32.const	$push1309=, 5
	i32.rem_u	$push549=, $pop548, $pop1309
	i32.ne  	$push550=, $pop547, $pop549
	br_if   	1, $pop550      # 1: down to label0
# %bb.61:                               # %if.end569
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1149=, 16
	i32.add 	$push1150=, $7, $pop1149
	copy_local	$6=, $pop1150
	#APP
	#NO_APP
	i32.load16_u	$push118=, 24($7)
	i32.load16_u	$push120=, 8($1)
	i32.const	$push1312=, 6
	i32.rem_u	$push551=, $pop120, $pop1312
	i32.ne  	$push552=, $pop118, $pop551
	br_if   	1, $pop552      # 1: down to label0
# %bb.62:                               # %lor.lhs.false578
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push119=, 30($7)
	i32.const	$push1315=, 65535
	i32.and 	$push553=, $pop119, $pop1315
	i32.load16_u	$push121=, 0($2)
	i32.const	$push1314=, 65535
	i32.and 	$push554=, $pop121, $pop1314
	i32.const	$push1313=, 5
	i32.rem_u	$push555=, $pop554, $pop1313
	i32.ne  	$push556=, $pop553, $pop555
	br_if   	1, $pop556      # 1: down to label0
# %bb.63:                               # %if.end588
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1151=, 16
	i32.add 	$push1152=, $7, $pop1151
	copy_local	$6=, $pop1152
	#APP
	#NO_APP
	i32.load16_u	$push123=, 28($7)
	i32.load16_u	$push125=, 0($3)
	i32.const	$push1316=, 6
	i32.rem_u	$push557=, $pop125, $pop1316
	i32.ne  	$push558=, $pop123, $pop557
	br_if   	1, $pop558      # 1: down to label0
# %bb.64:                               # %lor.lhs.false597
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push122=, 26($7)
	i32.const	$push1319=, 65535
	i32.and 	$push559=, $pop122, $pop1319
	i32.load16_u	$push124=, 0($4)
	i32.const	$push1318=, 65535
	i32.and 	$push560=, $pop124, $pop1318
	i32.const	$push1317=, 5
	i32.rem_u	$push561=, $pop560, $pop1317
	i32.ne  	$push562=, $pop559, $pop561
	br_if   	1, $pop562      # 1: down to label0
# %bb.65:                               # %if.end607
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1153=, 16
	i32.add 	$push1154=, $7, $pop1153
	copy_local	$6=, $pop1154
	#APP
	#NO_APP
	i32.const	$push1155=, 16
	i32.add 	$push1156=, $7, $pop1155
	call    	uq14141461461414@FUNCTION, $pop1156, $1
	i32.load16_u	$push126=, 16($7)
	i32.load16_u	$push128=, 0($1)
	i32.const	$push1320=, 14
	i32.div_u	$push563=, $pop128, $pop1320
	i32.ne  	$push564=, $pop126, $pop563
	br_if   	1, $pop564      # 1: down to label0
# %bb.66:                               # %lor.lhs.false617
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push127=, 22($7)
	i32.const	$push1323=, 65535
	i32.and 	$push565=, $pop127, $pop1323
	i32.load16_u	$push129=, 0($5)
	i32.const	$push1322=, 65535
	i32.and 	$push566=, $pop129, $pop1322
	i32.const	$push1321=, 6
	i32.div_u	$push567=, $pop566, $pop1321
	i32.ne  	$push568=, $pop565, $pop567
	br_if   	1, $pop568      # 1: down to label0
# %bb.67:                               # %if.end627
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1157=, 16
	i32.add 	$push1158=, $7, $pop1157
	copy_local	$6=, $pop1158
	#APP
	#NO_APP
	i32.load16_u	$push131=, 20($7)
	i32.load16_u	$push133=, 4($1)
	i32.const	$push1324=, 14
	i32.div_u	$push569=, $pop133, $pop1324
	i32.ne  	$push570=, $pop131, $pop569
	br_if   	1, $pop570      # 1: down to label0
# %bb.68:                               # %lor.lhs.false636
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push130=, 18($7)
	i32.const	$push1327=, 65535
	i32.and 	$push571=, $pop130, $pop1327
	i32.load16_u	$push132=, 2($1)
	i32.const	$push1326=, 65535
	i32.and 	$push572=, $pop132, $pop1326
	i32.const	$push1325=, 14
	i32.div_u	$push573=, $pop572, $pop1325
	i32.ne  	$push574=, $pop571, $pop573
	br_if   	1, $pop574      # 1: down to label0
# %bb.69:                               # %if.end646
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1159=, 16
	i32.add 	$push1160=, $7, $pop1159
	copy_local	$6=, $pop1160
	#APP
	#NO_APP
	i32.load16_u	$push134=, 24($7)
	i32.load16_u	$push136=, 8($1)
	i32.const	$push1328=, 14
	i32.div_u	$push575=, $pop136, $pop1328
	i32.ne  	$push576=, $pop134, $pop575
	br_if   	1, $pop576      # 1: down to label0
# %bb.70:                               # %lor.lhs.false655
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push135=, 30($7)
	i32.const	$push1331=, 65535
	i32.and 	$push577=, $pop135, $pop1331
	i32.load16_u	$push137=, 0($2)
	i32.const	$push1330=, 65535
	i32.and 	$push578=, $pop137, $pop1330
	i32.const	$push1329=, 14
	i32.div_u	$push579=, $pop578, $pop1329
	i32.ne  	$push580=, $pop577, $pop579
	br_if   	1, $pop580      # 1: down to label0
# %bb.71:                               # %if.end665
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1161=, 16
	i32.add 	$push1162=, $7, $pop1161
	copy_local	$6=, $pop1162
	#APP
	#NO_APP
	i32.load16_u	$push139=, 28($7)
	i32.load16_u	$push141=, 0($3)
	i32.const	$push1332=, 14
	i32.div_u	$push581=, $pop141, $pop1332
	i32.ne  	$push582=, $pop139, $pop581
	br_if   	1, $pop582      # 1: down to label0
# %bb.72:                               # %lor.lhs.false674
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push138=, 26($7)
	i32.const	$push1335=, 65535
	i32.and 	$push583=, $pop138, $pop1335
	i32.load16_u	$push140=, 0($4)
	i32.const	$push1334=, 65535
	i32.and 	$push584=, $pop140, $pop1334
	i32.const	$push1333=, 6
	i32.div_u	$push585=, $pop584, $pop1333
	i32.ne  	$push586=, $pop583, $pop585
	br_if   	1, $pop586      # 1: down to label0
# %bb.73:                               # %if.end684
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1163=, 16
	i32.add 	$push1164=, $7, $pop1163
	copy_local	$6=, $pop1164
	#APP
	#NO_APP
	i32.const	$push1165=, 16
	i32.add 	$push1166=, $7, $pop1165
	call    	ur14141461461414@FUNCTION, $pop1166, $1
	i32.load16_u	$push142=, 16($7)
	i32.load16_u	$push144=, 0($1)
	i32.const	$push1336=, 14
	i32.rem_u	$push587=, $pop144, $pop1336
	i32.ne  	$push588=, $pop142, $pop587
	br_if   	1, $pop588      # 1: down to label0
# %bb.74:                               # %lor.lhs.false694
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push143=, 22($7)
	i32.const	$push1339=, 65535
	i32.and 	$push589=, $pop143, $pop1339
	i32.load16_u	$push145=, 0($5)
	i32.const	$push1338=, 65535
	i32.and 	$push590=, $pop145, $pop1338
	i32.const	$push1337=, 6
	i32.rem_u	$push591=, $pop590, $pop1337
	i32.ne  	$push592=, $pop589, $pop591
	br_if   	1, $pop592      # 1: down to label0
# %bb.75:                               # %if.end704
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1167=, 16
	i32.add 	$push1168=, $7, $pop1167
	copy_local	$6=, $pop1168
	#APP
	#NO_APP
	i32.load16_u	$push147=, 20($7)
	i32.load16_u	$push149=, 4($1)
	i32.const	$push1340=, 14
	i32.rem_u	$push593=, $pop149, $pop1340
	i32.ne  	$push594=, $pop147, $pop593
	br_if   	1, $pop594      # 1: down to label0
# %bb.76:                               # %lor.lhs.false713
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push146=, 18($7)
	i32.const	$push1343=, 65535
	i32.and 	$push595=, $pop146, $pop1343
	i32.load16_u	$push148=, 2($1)
	i32.const	$push1342=, 65535
	i32.and 	$push596=, $pop148, $pop1342
	i32.const	$push1341=, 14
	i32.rem_u	$push597=, $pop596, $pop1341
	i32.ne  	$push598=, $pop595, $pop597
	br_if   	1, $pop598      # 1: down to label0
# %bb.77:                               # %if.end723
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1169=, 16
	i32.add 	$push1170=, $7, $pop1169
	copy_local	$6=, $pop1170
	#APP
	#NO_APP
	i32.load16_u	$push150=, 24($7)
	i32.load16_u	$push152=, 8($1)
	i32.const	$push1344=, 14
	i32.rem_u	$push599=, $pop152, $pop1344
	i32.ne  	$push600=, $pop150, $pop599
	br_if   	1, $pop600      # 1: down to label0
# %bb.78:                               # %lor.lhs.false732
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push151=, 30($7)
	i32.const	$push1347=, 65535
	i32.and 	$push601=, $pop151, $pop1347
	i32.load16_u	$push153=, 0($2)
	i32.const	$push1346=, 65535
	i32.and 	$push602=, $pop153, $pop1346
	i32.const	$push1345=, 14
	i32.rem_u	$push603=, $pop602, $pop1345
	i32.ne  	$push604=, $pop601, $pop603
	br_if   	1, $pop604      # 1: down to label0
# %bb.79:                               # %if.end742
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1171=, 16
	i32.add 	$push1172=, $7, $pop1171
	copy_local	$6=, $pop1172
	#APP
	#NO_APP
	i32.load16_u	$push155=, 28($7)
	i32.load16_u	$push157=, 0($3)
	i32.const	$push1348=, 14
	i32.rem_u	$push605=, $pop157, $pop1348
	i32.ne  	$push606=, $pop155, $pop605
	br_if   	1, $pop606      # 1: down to label0
# %bb.80:                               # %lor.lhs.false751
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push154=, 26($7)
	i32.const	$push1351=, 65535
	i32.and 	$push607=, $pop154, $pop1351
	i32.load16_u	$push156=, 0($4)
	i32.const	$push1350=, 65535
	i32.and 	$push608=, $pop156, $pop1350
	i32.const	$push1349=, 6
	i32.rem_u	$push609=, $pop608, $pop1349
	i32.ne  	$push610=, $pop607, $pop609
	br_if   	1, $pop610      # 1: down to label0
# %bb.81:                               # %if.end761
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1173=, 16
	i32.add 	$push1174=, $7, $pop1173
	copy_local	$6=, $pop1174
	#APP
	#NO_APP
	i32.const	$push1175=, 16
	i32.add 	$push1176=, $7, $pop1175
	call    	uq77777777@FUNCTION, $pop1176, $1
	i32.load16_u	$push158=, 16($7)
	i32.load16_u	$push160=, 0($1)
	i32.const	$push1352=, 7
	i32.div_u	$push611=, $pop160, $pop1352
	i32.ne  	$push612=, $pop158, $pop611
	br_if   	1, $pop612      # 1: down to label0
# %bb.82:                               # %lor.lhs.false771
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push159=, 22($7)
	i32.const	$push1355=, 65535
	i32.and 	$push613=, $pop159, $pop1355
	i32.load16_u	$push161=, 0($5)
	i32.const	$push1354=, 65535
	i32.and 	$push614=, $pop161, $pop1354
	i32.const	$push1353=, 7
	i32.div_u	$push615=, $pop614, $pop1353
	i32.ne  	$push616=, $pop613, $pop615
	br_if   	1, $pop616      # 1: down to label0
# %bb.83:                               # %if.end781
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1177=, 16
	i32.add 	$push1178=, $7, $pop1177
	copy_local	$6=, $pop1178
	#APP
	#NO_APP
	i32.load16_u	$push163=, 20($7)
	i32.load16_u	$push165=, 4($1)
	i32.const	$push1356=, 7
	i32.div_u	$push617=, $pop165, $pop1356
	i32.ne  	$push618=, $pop163, $pop617
	br_if   	1, $pop618      # 1: down to label0
# %bb.84:                               # %lor.lhs.false790
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push162=, 18($7)
	i32.const	$push1359=, 65535
	i32.and 	$push619=, $pop162, $pop1359
	i32.load16_u	$push164=, 2($1)
	i32.const	$push1358=, 65535
	i32.and 	$push620=, $pop164, $pop1358
	i32.const	$push1357=, 7
	i32.div_u	$push621=, $pop620, $pop1357
	i32.ne  	$push622=, $pop619, $pop621
	br_if   	1, $pop622      # 1: down to label0
# %bb.85:                               # %if.end800
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1179=, 16
	i32.add 	$push1180=, $7, $pop1179
	copy_local	$6=, $pop1180
	#APP
	#NO_APP
	i32.load16_u	$push166=, 24($7)
	i32.load16_u	$push168=, 8($1)
	i32.const	$push1360=, 7
	i32.div_u	$push623=, $pop168, $pop1360
	i32.ne  	$push624=, $pop166, $pop623
	br_if   	1, $pop624      # 1: down to label0
# %bb.86:                               # %lor.lhs.false809
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push167=, 30($7)
	i32.const	$push1363=, 65535
	i32.and 	$push625=, $pop167, $pop1363
	i32.load16_u	$push169=, 0($2)
	i32.const	$push1362=, 65535
	i32.and 	$push626=, $pop169, $pop1362
	i32.const	$push1361=, 7
	i32.div_u	$push627=, $pop626, $pop1361
	i32.ne  	$push628=, $pop625, $pop627
	br_if   	1, $pop628      # 1: down to label0
# %bb.87:                               # %if.end819
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1181=, 16
	i32.add 	$push1182=, $7, $pop1181
	copy_local	$6=, $pop1182
	#APP
	#NO_APP
	i32.load16_u	$push171=, 28($7)
	i32.load16_u	$push173=, 0($3)
	i32.const	$push1364=, 7
	i32.div_u	$push629=, $pop173, $pop1364
	i32.ne  	$push630=, $pop171, $pop629
	br_if   	1, $pop630      # 1: down to label0
# %bb.88:                               # %lor.lhs.false828
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push170=, 26($7)
	i32.const	$push1367=, 65535
	i32.and 	$push631=, $pop170, $pop1367
	i32.load16_u	$push172=, 0($4)
	i32.const	$push1366=, 65535
	i32.and 	$push632=, $pop172, $pop1366
	i32.const	$push1365=, 7
	i32.div_u	$push633=, $pop632, $pop1365
	i32.ne  	$push634=, $pop631, $pop633
	br_if   	1, $pop634      # 1: down to label0
# %bb.89:                               # %if.end838
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1183=, 16
	i32.add 	$push1184=, $7, $pop1183
	copy_local	$6=, $pop1184
	#APP
	#NO_APP
	i32.const	$push1185=, 16
	i32.add 	$push1186=, $7, $pop1185
	call    	ur77777777@FUNCTION, $pop1186, $1
	i32.load16_u	$push174=, 16($7)
	i32.load16_u	$push176=, 0($1)
	i32.const	$push1368=, 7
	i32.rem_u	$push635=, $pop176, $pop1368
	i32.ne  	$push636=, $pop174, $pop635
	br_if   	1, $pop636      # 1: down to label0
# %bb.90:                               # %lor.lhs.false848
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push175=, 22($7)
	i32.const	$push1371=, 65535
	i32.and 	$push637=, $pop175, $pop1371
	i32.load16_u	$push177=, 0($5)
	i32.const	$push1370=, 65535
	i32.and 	$push638=, $pop177, $pop1370
	i32.const	$push1369=, 7
	i32.rem_u	$push639=, $pop638, $pop1369
	i32.ne  	$push640=, $pop637, $pop639
	br_if   	1, $pop640      # 1: down to label0
# %bb.91:                               # %if.end858
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1187=, 16
	i32.add 	$push1188=, $7, $pop1187
	copy_local	$5=, $pop1188
	#APP
	#NO_APP
	i32.load16_u	$push179=, 20($7)
	i32.load16_u	$push181=, 4($1)
	i32.const	$push1372=, 7
	i32.rem_u	$push641=, $pop181, $pop1372
	i32.ne  	$push642=, $pop179, $pop641
	br_if   	1, $pop642      # 1: down to label0
# %bb.92:                               # %lor.lhs.false867
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push178=, 18($7)
	i32.const	$push1375=, 65535
	i32.and 	$push643=, $pop178, $pop1375
	i32.load16_u	$push180=, 2($1)
	i32.const	$push1374=, 65535
	i32.and 	$push644=, $pop180, $pop1374
	i32.const	$push1373=, 7
	i32.rem_u	$push645=, $pop644, $pop1373
	i32.ne  	$push646=, $pop643, $pop645
	br_if   	1, $pop646      # 1: down to label0
# %bb.93:                               # %if.end877
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1189=, 16
	i32.add 	$push1190=, $7, $pop1189
	copy_local	$5=, $pop1190
	#APP
	#NO_APP
	i32.load16_u	$push182=, 24($7)
	i32.load16_u	$push184=, 8($1)
	i32.const	$push1376=, 7
	i32.rem_u	$push647=, $pop184, $pop1376
	i32.ne  	$push648=, $pop182, $pop647
	br_if   	1, $pop648      # 1: down to label0
# %bb.94:                               # %lor.lhs.false886
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push183=, 30($7)
	i32.const	$push1379=, 65535
	i32.and 	$push649=, $pop183, $pop1379
	i32.load16_u	$push185=, 0($2)
	i32.const	$push1378=, 65535
	i32.and 	$push650=, $pop185, $pop1378
	i32.const	$push1377=, 7
	i32.rem_u	$push651=, $pop650, $pop1377
	i32.ne  	$push652=, $pop649, $pop651
	br_if   	1, $pop652      # 1: down to label0
# %bb.95:                               # %if.end896
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1191=, 16
	i32.add 	$push1192=, $7, $pop1191
	copy_local	$1=, $pop1192
	#APP
	#NO_APP
	i32.load16_u	$push187=, 28($7)
	i32.load16_u	$push189=, 0($3)
	i32.const	$push1380=, 7
	i32.rem_u	$push653=, $pop189, $pop1380
	i32.ne  	$push654=, $pop187, $pop653
	br_if   	1, $pop654      # 1: down to label0
# %bb.96:                               # %lor.lhs.false905
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.load16_u	$push186=, 26($7)
	i32.const	$push1383=, 65535
	i32.and 	$push655=, $pop186, $pop1383
	i32.load16_u	$push188=, 0($4)
	i32.const	$push1382=, 65535
	i32.and 	$push656=, $pop188, $pop1382
	i32.const	$push1381=, 7
	i32.rem_u	$push657=, $pop656, $pop1381
	i32.ne  	$push658=, $pop655, $pop657
	br_if   	1, $pop658      # 1: down to label0
# %bb.97:                               # %if.end915
                                        #   in Loop: Header=BB24_1 Depth=1
	i32.const	$push1193=, 16
	i32.add 	$push1194=, $7, $pop1193
	copy_local	$1=, $pop1194
	#APP
	#NO_APP
	i32.const	$push659=, 1
	i32.add 	$1=, $0, $pop659
	i32.const	$0=, 1
	i32.const	$push1384=, 2
	i32.lt_u	$push660=, $1, $pop1384
	br_if   	0, $pop660      # 0: up to label1
# %bb.98:                               # %for.body919.preheader
	end_loop
	i32.const	$0=, 0
.LBB24_99:                              # %for.body919
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push1388=, 4
	i32.shl 	$2=, $0, $pop1388
	i32.const	$push1387=, s
	i32.add 	$1=, $2, $pop1387
	call    	sq44444444@FUNCTION, $7, $1
	i32.load16_u	$push190=, 0($7)
	i32.load16_s	$push192=, 0($1)
	i32.const	$push1386=, 4
	i32.div_s	$push661=, $pop192, $pop1386
	i32.const	$push1385=, 65535
	i32.and 	$push662=, $pop661, $pop1385
	i32.ne  	$push663=, $pop190, $pop662
	br_if   	1, $pop663      # 1: down to label0
# %bb.100:                              # %lor.lhs.false929
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push191=, 6($7)
	i32.const	$push1394=, 65535
	i32.and 	$push665=, $pop191, $pop1394
	i32.const	$push1393=, s+6
	i32.add 	$push664=, $2, $pop1393
	i32.load16_u	$push193=, 0($pop664)
	i32.const	$push1392=, 16
	i32.shl 	$push666=, $pop193, $pop1392
	i32.const	$push1391=, 16
	i32.shr_s	$push667=, $pop666, $pop1391
	i32.const	$push1390=, 4
	i32.div_s	$push668=, $pop667, $pop1390
	i32.const	$push1389=, 65535
	i32.and 	$push669=, $pop668, $pop1389
	i32.ne  	$push670=, $pop665, $pop669
	br_if   	1, $pop670      # 1: down to label0
# %bb.101:                              # %if.end939
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$2=, $7
	#APP
	#NO_APP
	i32.load16_u	$push195=, 4($7)
	i32.load16_s	$push197=, 4($1)
	i32.const	$push1396=, 4
	i32.div_s	$push671=, $pop197, $pop1396
	i32.const	$push1395=, 65535
	i32.and 	$push672=, $pop671, $pop1395
	i32.ne  	$push673=, $pop195, $pop672
	br_if   	1, $pop673      # 1: down to label0
# %bb.102:                              # %lor.lhs.false948
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push194=, 2($7)
	i32.const	$push1401=, 65535
	i32.and 	$push674=, $pop194, $pop1401
	i32.load16_u	$push196=, 2($1)
	i32.const	$push1400=, 16
	i32.shl 	$push675=, $pop196, $pop1400
	i32.const	$push1399=, 16
	i32.shr_s	$push676=, $pop675, $pop1399
	i32.const	$push1398=, 4
	i32.div_s	$push677=, $pop676, $pop1398
	i32.const	$push1397=, 65535
	i32.and 	$push678=, $pop677, $pop1397
	i32.ne  	$push679=, $pop674, $pop678
	br_if   	1, $pop679      # 1: down to label0
# %bb.103:                              # %if.end958
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$2=, $7
	#APP
	#NO_APP
	i32.load16_u	$push198=, 8($7)
	i32.load16_s	$push200=, 8($1)
	i32.const	$push1403=, 4
	i32.div_s	$push680=, $pop200, $pop1403
	i32.const	$push1402=, 65535
	i32.and 	$push681=, $pop680, $pop1402
	i32.ne  	$push682=, $pop198, $pop681
	br_if   	1, $pop682      # 1: down to label0
# %bb.104:                              # %lor.lhs.false967
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.const	$push1409=, 14
	i32.add 	$2=, $1, $pop1409
	i32.load16_u	$push199=, 14($7)
	i32.const	$push1408=, 65535
	i32.and 	$push683=, $pop199, $pop1408
	i32.load16_u	$push201=, 0($2)
	i32.const	$push1407=, 16
	i32.shl 	$push684=, $pop201, $pop1407
	i32.const	$push1406=, 16
	i32.shr_s	$push685=, $pop684, $pop1406
	i32.const	$push1405=, 4
	i32.div_s	$push686=, $pop685, $pop1405
	i32.const	$push1404=, 65535
	i32.and 	$push687=, $pop686, $pop1404
	i32.ne  	$push688=, $pop683, $pop687
	br_if   	1, $pop688      # 1: down to label0
# %bb.105:                              # %if.end977
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$3=, $7
	#APP
	#NO_APP
	i32.const	$push1412=, 12
	i32.add 	$3=, $1, $pop1412
	i32.load16_u	$push203=, 12($7)
	i32.load16_s	$push205=, 0($3)
	i32.const	$push1411=, 4
	i32.div_s	$push689=, $pop205, $pop1411
	i32.const	$push1410=, 65535
	i32.and 	$push690=, $pop689, $pop1410
	i32.ne  	$push691=, $pop203, $pop690
	br_if   	1, $pop691      # 1: down to label0
# %bb.106:                              # %lor.lhs.false986
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.const	$push1418=, 10
	i32.add 	$4=, $1, $pop1418
	i32.load16_u	$push202=, 10($7)
	i32.const	$push1417=, 65535
	i32.and 	$push692=, $pop202, $pop1417
	i32.load16_u	$push204=, 0($4)
	i32.const	$push1416=, 16
	i32.shl 	$push693=, $pop204, $pop1416
	i32.const	$push1415=, 16
	i32.shr_s	$push694=, $pop693, $pop1415
	i32.const	$push1414=, 4
	i32.div_s	$push695=, $pop694, $pop1414
	i32.const	$push1413=, 65535
	i32.and 	$push696=, $pop695, $pop1413
	i32.ne  	$push697=, $pop692, $pop696
	br_if   	1, $pop697      # 1: down to label0
# %bb.107:                              # %if.end996
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$5=, $7
	#APP
	#NO_APP
	call    	sr44444444@FUNCTION, $7, $1
	i32.load16_s	$push208=, 0($1)
	i32.const	$push1419=, 4
	i32.rem_s	$push698=, $pop208, $pop1419
	i32.load16_s	$push206=, 0($7)
	i32.ne  	$push699=, $pop698, $pop206
	br_if   	1, $pop699      # 1: down to label0
# %bb.108:                              # %lor.lhs.false1006
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.const	$push1425=, 6
	i32.add 	$5=, $1, $pop1425
	i32.load16_u	$push209=, 0($5)
	i32.const	$push1424=, 16
	i32.shl 	$push702=, $pop209, $pop1424
	i32.const	$push1423=, 16
	i32.shr_s	$push703=, $pop702, $pop1423
	i32.const	$push1422=, 4
	i32.rem_s	$push704=, $pop703, $pop1422
	i32.load16_u	$push207=, 6($7)
	i32.const	$push1421=, 16
	i32.shl 	$push700=, $pop207, $pop1421
	i32.const	$push1420=, 16
	i32.shr_s	$push701=, $pop700, $pop1420
	i32.ne  	$push705=, $pop704, $pop701
	br_if   	1, $pop705      # 1: down to label0
# %bb.109:                              # %if.end1016
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push213=, 4($1)
	i32.const	$push1426=, 4
	i32.rem_s	$push706=, $pop213, $pop1426
	i32.load16_s	$push211=, 4($7)
	i32.ne  	$push707=, $pop706, $pop211
	br_if   	1, $pop707      # 1: down to label0
# %bb.110:                              # %lor.lhs.false1025
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push212=, 2($1)
	i32.const	$push1431=, 16
	i32.shl 	$push710=, $pop212, $pop1431
	i32.const	$push1430=, 16
	i32.shr_s	$push711=, $pop710, $pop1430
	i32.const	$push1429=, 4
	i32.rem_s	$push712=, $pop711, $pop1429
	i32.load16_u	$push210=, 2($7)
	i32.const	$push1428=, 16
	i32.shl 	$push708=, $pop210, $pop1428
	i32.const	$push1427=, 16
	i32.shr_s	$push709=, $pop708, $pop1427
	i32.ne  	$push713=, $pop712, $pop709
	br_if   	1, $pop713      # 1: down to label0
# %bb.111:                              # %if.end1035
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push216=, 8($1)
	i32.const	$push1432=, 4
	i32.rem_s	$push714=, $pop216, $pop1432
	i32.load16_s	$push214=, 8($7)
	i32.ne  	$push715=, $pop714, $pop214
	br_if   	1, $pop715      # 1: down to label0
# %bb.112:                              # %lor.lhs.false1044
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push217=, 0($2)
	i32.const	$push1437=, 16
	i32.shl 	$push718=, $pop217, $pop1437
	i32.const	$push1436=, 16
	i32.shr_s	$push719=, $pop718, $pop1436
	i32.const	$push1435=, 4
	i32.rem_s	$push720=, $pop719, $pop1435
	i32.load16_u	$push215=, 14($7)
	i32.const	$push1434=, 16
	i32.shl 	$push716=, $pop215, $pop1434
	i32.const	$push1433=, 16
	i32.shr_s	$push717=, $pop716, $pop1433
	i32.ne  	$push721=, $pop720, $pop717
	br_if   	1, $pop721      # 1: down to label0
# %bb.113:                              # %if.end1054
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push221=, 0($3)
	i32.const	$push1438=, 4
	i32.rem_s	$push722=, $pop221, $pop1438
	i32.load16_s	$push219=, 12($7)
	i32.ne  	$push723=, $pop722, $pop219
	br_if   	1, $pop723      # 1: down to label0
# %bb.114:                              # %lor.lhs.false1063
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push220=, 0($4)
	i32.const	$push1443=, 16
	i32.shl 	$push726=, $pop220, $pop1443
	i32.const	$push1442=, 16
	i32.shr_s	$push727=, $pop726, $pop1442
	i32.const	$push1441=, 4
	i32.rem_s	$push728=, $pop727, $pop1441
	i32.load16_u	$push218=, 10($7)
	i32.const	$push1440=, 16
	i32.shl 	$push724=, $pop218, $pop1440
	i32.const	$push1439=, 16
	i32.shr_s	$push725=, $pop724, $pop1439
	i32.ne  	$push729=, $pop728, $pop725
	br_if   	1, $pop729      # 1: down to label0
# %bb.115:                              # %if.end1073
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sq1428166432128@FUNCTION, $7, $1
	i32.load16_u	$push222=, 0($7)
	i32.load16_u	$push224=, 0($1)
	i32.ne  	$push730=, $pop222, $pop224
	br_if   	1, $pop730      # 1: down to label0
# %bb.116:                              # %lor.lhs.false1083
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push223=, 6($7)
	i32.const	$push1448=, 65535
	i32.and 	$push731=, $pop223, $pop1448
	i32.load16_u	$push225=, 0($5)
	i32.const	$push1447=, 16
	i32.shl 	$push732=, $pop225, $pop1447
	i32.const	$push1446=, 16
	i32.shr_s	$push733=, $pop732, $pop1446
	i32.const	$push1445=, 8
	i32.div_s	$push734=, $pop733, $pop1445
	i32.const	$push1444=, 65535
	i32.and 	$push735=, $pop734, $pop1444
	i32.ne  	$push736=, $pop731, $pop735
	br_if   	1, $pop736      # 1: down to label0
# %bb.117:                              # %if.end1093
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push227=, 4($7)
	i32.load16_s	$push229=, 4($1)
	i32.const	$push1450=, 2
	i32.div_s	$push737=, $pop229, $pop1450
	i32.const	$push1449=, 65535
	i32.and 	$push738=, $pop737, $pop1449
	i32.ne  	$push739=, $pop227, $pop738
	br_if   	1, $pop739      # 1: down to label0
# %bb.118:                              # %lor.lhs.false1102
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push226=, 2($7)
	i32.const	$push1455=, 65535
	i32.and 	$push740=, $pop226, $pop1455
	i32.load16_u	$push228=, 2($1)
	i32.const	$push1454=, 16
	i32.shl 	$push741=, $pop228, $pop1454
	i32.const	$push1453=, 16
	i32.shr_s	$push742=, $pop741, $pop1453
	i32.const	$push1452=, 4
	i32.div_s	$push743=, $pop742, $pop1452
	i32.const	$push1451=, 65535
	i32.and 	$push744=, $pop743, $pop1451
	i32.ne  	$push745=, $pop740, $pop744
	br_if   	1, $pop745      # 1: down to label0
# %bb.119:                              # %if.end1112
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push230=, 8($7)
	i32.load16_s	$push232=, 8($1)
	i32.const	$push1457=, 16
	i32.div_s	$push746=, $pop232, $pop1457
	i32.const	$push1456=, 65535
	i32.and 	$push747=, $pop746, $pop1456
	i32.ne  	$push748=, $pop230, $pop747
	br_if   	1, $pop748      # 1: down to label0
# %bb.120:                              # %lor.lhs.false1121
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push231=, 14($7)
	i32.const	$push1462=, 65535
	i32.and 	$push749=, $pop231, $pop1462
	i32.load16_u	$push233=, 0($2)
	i32.const	$push1461=, 16
	i32.shl 	$push750=, $pop233, $pop1461
	i32.const	$push1460=, 16
	i32.shr_s	$push751=, $pop750, $pop1460
	i32.const	$push1459=, 128
	i32.div_s	$push752=, $pop751, $pop1459
	i32.const	$push1458=, 65535
	i32.and 	$push753=, $pop752, $pop1458
	i32.ne  	$push754=, $pop749, $pop753
	br_if   	1, $pop754      # 1: down to label0
# %bb.121:                              # %if.end1131
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push235=, 12($7)
	i32.load16_s	$push237=, 0($3)
	i32.const	$push1464=, 32
	i32.div_s	$push755=, $pop237, $pop1464
	i32.const	$push1463=, 65535
	i32.and 	$push756=, $pop755, $pop1463
	i32.ne  	$push757=, $pop235, $pop756
	br_if   	1, $pop757      # 1: down to label0
# %bb.122:                              # %lor.lhs.false1140
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push234=, 10($7)
	i32.const	$push1469=, 65535
	i32.and 	$push758=, $pop234, $pop1469
	i32.load16_u	$push236=, 0($4)
	i32.const	$push1468=, 16
	i32.shl 	$push759=, $pop236, $pop1468
	i32.const	$push1467=, 16
	i32.shr_s	$push760=, $pop759, $pop1467
	i32.const	$push1466=, 64
	i32.div_s	$push761=, $pop760, $pop1466
	i32.const	$push1465=, 65535
	i32.and 	$push762=, $pop761, $pop1465
	i32.ne  	$push763=, $pop758, $pop762
	br_if   	1, $pop763      # 1: down to label0
# %bb.123:                              # %if.end1150
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sr1428166432128@FUNCTION, $7, $1
	i32.load16_u	$push238=, 0($7)
	br_if   	1, $pop238      # 1: down to label0
# %bb.124:                              # %lor.lhs.false1160
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_s	$push764=, 0($5)
	i32.const	$push1472=, 8
	i32.rem_s	$push765=, $pop764, $pop1472
	i32.load16_u	$push239=, 6($7)
	i32.const	$push1471=, 16
	i32.shl 	$push766=, $pop239, $pop1471
	i32.const	$push1470=, 16
	i32.shr_s	$push767=, $pop766, $pop1470
	i32.ne  	$push768=, $pop765, $pop767
	br_if   	1, $pop768      # 1: down to label0
# %bb.125:                              # %if.end1170
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push243=, 4($1)
	i32.const	$push1473=, 2
	i32.rem_s	$push769=, $pop243, $pop1473
	i32.load16_s	$push241=, 4($7)
	i32.ne  	$push770=, $pop769, $pop241
	br_if   	1, $pop770      # 1: down to label0
# %bb.126:                              # %lor.lhs.false1179
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push242=, 2($1)
	i32.const	$push1478=, 16
	i32.shl 	$push773=, $pop242, $pop1478
	i32.const	$push1477=, 16
	i32.shr_s	$push774=, $pop773, $pop1477
	i32.const	$push1476=, 4
	i32.rem_s	$push775=, $pop774, $pop1476
	i32.load16_u	$push240=, 2($7)
	i32.const	$push1475=, 16
	i32.shl 	$push771=, $pop240, $pop1475
	i32.const	$push1474=, 16
	i32.shr_s	$push772=, $pop771, $pop1474
	i32.ne  	$push776=, $pop775, $pop772
	br_if   	1, $pop776      # 1: down to label0
# %bb.127:                              # %if.end1189
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push246=, 8($1)
	i32.const	$push1479=, 16
	i32.rem_s	$push777=, $pop246, $pop1479
	i32.load16_s	$push244=, 8($7)
	i32.ne  	$push778=, $pop777, $pop244
	br_if   	1, $pop778      # 1: down to label0
# %bb.128:                              # %lor.lhs.false1198
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push247=, 0($2)
	i32.const	$push1484=, 16
	i32.shl 	$push781=, $pop247, $pop1484
	i32.const	$push1483=, 16
	i32.shr_s	$push782=, $pop781, $pop1483
	i32.const	$push1482=, 128
	i32.rem_s	$push783=, $pop782, $pop1482
	i32.load16_u	$push245=, 14($7)
	i32.const	$push1481=, 16
	i32.shl 	$push779=, $pop245, $pop1481
	i32.const	$push1480=, 16
	i32.shr_s	$push780=, $pop779, $pop1480
	i32.ne  	$push784=, $pop783, $pop780
	br_if   	1, $pop784      # 1: down to label0
# %bb.129:                              # %if.end1208
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push251=, 0($3)
	i32.const	$push1485=, 32
	i32.rem_s	$push785=, $pop251, $pop1485
	i32.load16_s	$push249=, 12($7)
	i32.ne  	$push786=, $pop785, $pop249
	br_if   	1, $pop786      # 1: down to label0
# %bb.130:                              # %lor.lhs.false1217
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push250=, 0($4)
	i32.const	$push1490=, 16
	i32.shl 	$push789=, $pop250, $pop1490
	i32.const	$push1489=, 16
	i32.shr_s	$push790=, $pop789, $pop1489
	i32.const	$push1488=, 64
	i32.rem_s	$push791=, $pop790, $pop1488
	i32.load16_u	$push248=, 10($7)
	i32.const	$push1487=, 16
	i32.shl 	$push787=, $pop248, $pop1487
	i32.const	$push1486=, 16
	i32.shr_s	$push788=, $pop787, $pop1486
	i32.ne  	$push792=, $pop791, $pop788
	br_if   	1, $pop792      # 1: down to label0
# %bb.131:                              # %if.end1227
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sq33333333@FUNCTION, $7, $1
	i32.load16_u	$push252=, 0($7)
	i32.load16_s	$push254=, 0($1)
	i32.const	$push1492=, 3
	i32.div_s	$push793=, $pop254, $pop1492
	i32.const	$push1491=, 65535
	i32.and 	$push794=, $pop793, $pop1491
	i32.ne  	$push795=, $pop252, $pop794
	br_if   	1, $pop795      # 1: down to label0
# %bb.132:                              # %lor.lhs.false1237
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push253=, 6($7)
	i32.const	$push1497=, 65535
	i32.and 	$push796=, $pop253, $pop1497
	i32.load16_u	$push255=, 0($5)
	i32.const	$push1496=, 16
	i32.shl 	$push797=, $pop255, $pop1496
	i32.const	$push1495=, 16
	i32.shr_s	$push798=, $pop797, $pop1495
	i32.const	$push1494=, 3
	i32.div_s	$push799=, $pop798, $pop1494
	i32.const	$push1493=, 65535
	i32.and 	$push800=, $pop799, $pop1493
	i32.ne  	$push801=, $pop796, $pop800
	br_if   	1, $pop801      # 1: down to label0
# %bb.133:                              # %if.end1247
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push257=, 4($7)
	i32.load16_s	$push259=, 4($1)
	i32.const	$push1499=, 3
	i32.div_s	$push802=, $pop259, $pop1499
	i32.const	$push1498=, 65535
	i32.and 	$push803=, $pop802, $pop1498
	i32.ne  	$push804=, $pop257, $pop803
	br_if   	1, $pop804      # 1: down to label0
# %bb.134:                              # %lor.lhs.false1256
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push256=, 2($7)
	i32.const	$push1504=, 65535
	i32.and 	$push805=, $pop256, $pop1504
	i32.load16_u	$push258=, 2($1)
	i32.const	$push1503=, 16
	i32.shl 	$push806=, $pop258, $pop1503
	i32.const	$push1502=, 16
	i32.shr_s	$push807=, $pop806, $pop1502
	i32.const	$push1501=, 3
	i32.div_s	$push808=, $pop807, $pop1501
	i32.const	$push1500=, 65535
	i32.and 	$push809=, $pop808, $pop1500
	i32.ne  	$push810=, $pop805, $pop809
	br_if   	1, $pop810      # 1: down to label0
# %bb.135:                              # %if.end1266
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push260=, 8($7)
	i32.load16_s	$push262=, 8($1)
	i32.const	$push1506=, 3
	i32.div_s	$push811=, $pop262, $pop1506
	i32.const	$push1505=, 65535
	i32.and 	$push812=, $pop811, $pop1505
	i32.ne  	$push813=, $pop260, $pop812
	br_if   	1, $pop813      # 1: down to label0
# %bb.136:                              # %lor.lhs.false1275
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push261=, 14($7)
	i32.const	$push1511=, 65535
	i32.and 	$push814=, $pop261, $pop1511
	i32.load16_u	$push263=, 0($2)
	i32.const	$push1510=, 16
	i32.shl 	$push815=, $pop263, $pop1510
	i32.const	$push1509=, 16
	i32.shr_s	$push816=, $pop815, $pop1509
	i32.const	$push1508=, 3
	i32.div_s	$push817=, $pop816, $pop1508
	i32.const	$push1507=, 65535
	i32.and 	$push818=, $pop817, $pop1507
	i32.ne  	$push819=, $pop814, $pop818
	br_if   	1, $pop819      # 1: down to label0
# %bb.137:                              # %if.end1285
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push265=, 12($7)
	i32.load16_s	$push267=, 0($3)
	i32.const	$push1513=, 3
	i32.div_s	$push820=, $pop267, $pop1513
	i32.const	$push1512=, 65535
	i32.and 	$push821=, $pop820, $pop1512
	i32.ne  	$push822=, $pop265, $pop821
	br_if   	1, $pop822      # 1: down to label0
# %bb.138:                              # %lor.lhs.false1294
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push264=, 10($7)
	i32.const	$push1518=, 65535
	i32.and 	$push823=, $pop264, $pop1518
	i32.load16_u	$push266=, 0($4)
	i32.const	$push1517=, 16
	i32.shl 	$push824=, $pop266, $pop1517
	i32.const	$push1516=, 16
	i32.shr_s	$push825=, $pop824, $pop1516
	i32.const	$push1515=, 3
	i32.div_s	$push826=, $pop825, $pop1515
	i32.const	$push1514=, 65535
	i32.and 	$push827=, $pop826, $pop1514
	i32.ne  	$push828=, $pop823, $pop827
	br_if   	1, $pop828      # 1: down to label0
# %bb.139:                              # %if.end1304
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sr33333333@FUNCTION, $7, $1
	i32.load16_s	$push270=, 0($1)
	i32.const	$push1519=, 3
	i32.rem_s	$push829=, $pop270, $pop1519
	i32.load16_s	$push268=, 0($7)
	i32.ne  	$push830=, $pop829, $pop268
	br_if   	1, $pop830      # 1: down to label0
# %bb.140:                              # %lor.lhs.false1314
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push271=, 0($5)
	i32.const	$push1524=, 16
	i32.shl 	$push833=, $pop271, $pop1524
	i32.const	$push1523=, 16
	i32.shr_s	$push834=, $pop833, $pop1523
	i32.const	$push1522=, 3
	i32.rem_s	$push835=, $pop834, $pop1522
	i32.load16_u	$push269=, 6($7)
	i32.const	$push1521=, 16
	i32.shl 	$push831=, $pop269, $pop1521
	i32.const	$push1520=, 16
	i32.shr_s	$push832=, $pop831, $pop1520
	i32.ne  	$push836=, $pop835, $pop832
	br_if   	1, $pop836      # 1: down to label0
# %bb.141:                              # %if.end1324
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push275=, 4($1)
	i32.const	$push1525=, 3
	i32.rem_s	$push837=, $pop275, $pop1525
	i32.load16_s	$push273=, 4($7)
	i32.ne  	$push838=, $pop837, $pop273
	br_if   	1, $pop838      # 1: down to label0
# %bb.142:                              # %lor.lhs.false1333
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push274=, 2($1)
	i32.const	$push1530=, 16
	i32.shl 	$push841=, $pop274, $pop1530
	i32.const	$push1529=, 16
	i32.shr_s	$push842=, $pop841, $pop1529
	i32.const	$push1528=, 3
	i32.rem_s	$push843=, $pop842, $pop1528
	i32.load16_u	$push272=, 2($7)
	i32.const	$push1527=, 16
	i32.shl 	$push839=, $pop272, $pop1527
	i32.const	$push1526=, 16
	i32.shr_s	$push840=, $pop839, $pop1526
	i32.ne  	$push844=, $pop843, $pop840
	br_if   	1, $pop844      # 1: down to label0
# %bb.143:                              # %if.end1343
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push278=, 8($1)
	i32.const	$push1531=, 3
	i32.rem_s	$push845=, $pop278, $pop1531
	i32.load16_s	$push276=, 8($7)
	i32.ne  	$push846=, $pop845, $pop276
	br_if   	1, $pop846      # 1: down to label0
# %bb.144:                              # %lor.lhs.false1352
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push279=, 0($2)
	i32.const	$push1536=, 16
	i32.shl 	$push849=, $pop279, $pop1536
	i32.const	$push1535=, 16
	i32.shr_s	$push850=, $pop849, $pop1535
	i32.const	$push1534=, 3
	i32.rem_s	$push851=, $pop850, $pop1534
	i32.load16_u	$push277=, 14($7)
	i32.const	$push1533=, 16
	i32.shl 	$push847=, $pop277, $pop1533
	i32.const	$push1532=, 16
	i32.shr_s	$push848=, $pop847, $pop1532
	i32.ne  	$push852=, $pop851, $pop848
	br_if   	1, $pop852      # 1: down to label0
# %bb.145:                              # %if.end1362
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push283=, 0($3)
	i32.const	$push1537=, 3
	i32.rem_s	$push853=, $pop283, $pop1537
	i32.load16_s	$push281=, 12($7)
	i32.ne  	$push854=, $pop853, $pop281
	br_if   	1, $pop854      # 1: down to label0
# %bb.146:                              # %lor.lhs.false1371
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push282=, 0($4)
	i32.const	$push1542=, 16
	i32.shl 	$push857=, $pop282, $pop1542
	i32.const	$push1541=, 16
	i32.shr_s	$push858=, $pop857, $pop1541
	i32.const	$push1540=, 3
	i32.rem_s	$push859=, $pop858, $pop1540
	i32.load16_u	$push280=, 10($7)
	i32.const	$push1539=, 16
	i32.shl 	$push855=, $pop280, $pop1539
	i32.const	$push1538=, 16
	i32.shr_s	$push856=, $pop855, $pop1538
	i32.ne  	$push860=, $pop859, $pop856
	br_if   	1, $pop860      # 1: down to label0
# %bb.147:                              # %if.end1381
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sq65656565@FUNCTION, $7, $1
	i32.load16_u	$push284=, 0($7)
	i32.load16_s	$push286=, 0($1)
	i32.const	$push1544=, 6
	i32.div_s	$push861=, $pop286, $pop1544
	i32.const	$push1543=, 65535
	i32.and 	$push862=, $pop861, $pop1543
	i32.ne  	$push863=, $pop284, $pop862
	br_if   	1, $pop863      # 1: down to label0
# %bb.148:                              # %lor.lhs.false1391
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push285=, 6($7)
	i32.const	$push1549=, 65535
	i32.and 	$push864=, $pop285, $pop1549
	i32.load16_u	$push287=, 0($5)
	i32.const	$push1548=, 16
	i32.shl 	$push865=, $pop287, $pop1548
	i32.const	$push1547=, 16
	i32.shr_s	$push866=, $pop865, $pop1547
	i32.const	$push1546=, 5
	i32.div_s	$push867=, $pop866, $pop1546
	i32.const	$push1545=, 65535
	i32.and 	$push868=, $pop867, $pop1545
	i32.ne  	$push869=, $pop864, $pop868
	br_if   	1, $pop869      # 1: down to label0
# %bb.149:                              # %if.end1401
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push289=, 4($7)
	i32.load16_s	$push291=, 4($1)
	i32.const	$push1551=, 6
	i32.div_s	$push870=, $pop291, $pop1551
	i32.const	$push1550=, 65535
	i32.and 	$push871=, $pop870, $pop1550
	i32.ne  	$push872=, $pop289, $pop871
	br_if   	1, $pop872      # 1: down to label0
# %bb.150:                              # %lor.lhs.false1410
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push288=, 2($7)
	i32.const	$push1556=, 65535
	i32.and 	$push873=, $pop288, $pop1556
	i32.load16_u	$push290=, 2($1)
	i32.const	$push1555=, 16
	i32.shl 	$push874=, $pop290, $pop1555
	i32.const	$push1554=, 16
	i32.shr_s	$push875=, $pop874, $pop1554
	i32.const	$push1553=, 5
	i32.div_s	$push876=, $pop875, $pop1553
	i32.const	$push1552=, 65535
	i32.and 	$push877=, $pop876, $pop1552
	i32.ne  	$push878=, $pop873, $pop877
	br_if   	1, $pop878      # 1: down to label0
# %bb.151:                              # %if.end1420
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push292=, 8($7)
	i32.load16_s	$push294=, 8($1)
	i32.const	$push1558=, 6
	i32.div_s	$push879=, $pop294, $pop1558
	i32.const	$push1557=, 65535
	i32.and 	$push880=, $pop879, $pop1557
	i32.ne  	$push881=, $pop292, $pop880
	br_if   	1, $pop881      # 1: down to label0
# %bb.152:                              # %lor.lhs.false1429
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push293=, 14($7)
	i32.const	$push1563=, 65535
	i32.and 	$push882=, $pop293, $pop1563
	i32.load16_u	$push295=, 0($2)
	i32.const	$push1562=, 16
	i32.shl 	$push883=, $pop295, $pop1562
	i32.const	$push1561=, 16
	i32.shr_s	$push884=, $pop883, $pop1561
	i32.const	$push1560=, 5
	i32.div_s	$push885=, $pop884, $pop1560
	i32.const	$push1559=, 65535
	i32.and 	$push886=, $pop885, $pop1559
	i32.ne  	$push887=, $pop882, $pop886
	br_if   	1, $pop887      # 1: down to label0
# %bb.153:                              # %if.end1439
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push297=, 12($7)
	i32.load16_s	$push299=, 0($3)
	i32.const	$push1565=, 6
	i32.div_s	$push888=, $pop299, $pop1565
	i32.const	$push1564=, 65535
	i32.and 	$push889=, $pop888, $pop1564
	i32.ne  	$push890=, $pop297, $pop889
	br_if   	1, $pop890      # 1: down to label0
# %bb.154:                              # %lor.lhs.false1448
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push296=, 10($7)
	i32.const	$push1570=, 65535
	i32.and 	$push891=, $pop296, $pop1570
	i32.load16_u	$push298=, 0($4)
	i32.const	$push1569=, 16
	i32.shl 	$push892=, $pop298, $pop1569
	i32.const	$push1568=, 16
	i32.shr_s	$push893=, $pop892, $pop1568
	i32.const	$push1567=, 5
	i32.div_s	$push894=, $pop893, $pop1567
	i32.const	$push1566=, 65535
	i32.and 	$push895=, $pop894, $pop1566
	i32.ne  	$push896=, $pop891, $pop895
	br_if   	1, $pop896      # 1: down to label0
# %bb.155:                              # %if.end1458
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sr65656565@FUNCTION, $7, $1
	i32.load16_s	$push302=, 0($1)
	i32.const	$push1571=, 6
	i32.rem_s	$push897=, $pop302, $pop1571
	i32.load16_s	$push300=, 0($7)
	i32.ne  	$push898=, $pop897, $pop300
	br_if   	1, $pop898      # 1: down to label0
# %bb.156:                              # %lor.lhs.false1468
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push303=, 0($5)
	i32.const	$push1576=, 16
	i32.shl 	$push901=, $pop303, $pop1576
	i32.const	$push1575=, 16
	i32.shr_s	$push902=, $pop901, $pop1575
	i32.const	$push1574=, 5
	i32.rem_s	$push903=, $pop902, $pop1574
	i32.load16_u	$push301=, 6($7)
	i32.const	$push1573=, 16
	i32.shl 	$push899=, $pop301, $pop1573
	i32.const	$push1572=, 16
	i32.shr_s	$push900=, $pop899, $pop1572
	i32.ne  	$push904=, $pop903, $pop900
	br_if   	1, $pop904      # 1: down to label0
# %bb.157:                              # %if.end1478
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push307=, 4($1)
	i32.const	$push1577=, 6
	i32.rem_s	$push905=, $pop307, $pop1577
	i32.load16_s	$push305=, 4($7)
	i32.ne  	$push906=, $pop905, $pop305
	br_if   	1, $pop906      # 1: down to label0
# %bb.158:                              # %lor.lhs.false1487
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push306=, 2($1)
	i32.const	$push1582=, 16
	i32.shl 	$push909=, $pop306, $pop1582
	i32.const	$push1581=, 16
	i32.shr_s	$push910=, $pop909, $pop1581
	i32.const	$push1580=, 5
	i32.rem_s	$push911=, $pop910, $pop1580
	i32.load16_u	$push304=, 2($7)
	i32.const	$push1579=, 16
	i32.shl 	$push907=, $pop304, $pop1579
	i32.const	$push1578=, 16
	i32.shr_s	$push908=, $pop907, $pop1578
	i32.ne  	$push912=, $pop911, $pop908
	br_if   	1, $pop912      # 1: down to label0
# %bb.159:                              # %if.end1497
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push310=, 8($1)
	i32.const	$push1583=, 6
	i32.rem_s	$push913=, $pop310, $pop1583
	i32.load16_s	$push308=, 8($7)
	i32.ne  	$push914=, $pop913, $pop308
	br_if   	1, $pop914      # 1: down to label0
# %bb.160:                              # %lor.lhs.false1506
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push311=, 0($2)
	i32.const	$push1588=, 16
	i32.shl 	$push917=, $pop311, $pop1588
	i32.const	$push1587=, 16
	i32.shr_s	$push918=, $pop917, $pop1587
	i32.const	$push1586=, 5
	i32.rem_s	$push919=, $pop918, $pop1586
	i32.load16_u	$push309=, 14($7)
	i32.const	$push1585=, 16
	i32.shl 	$push915=, $pop309, $pop1585
	i32.const	$push1584=, 16
	i32.shr_s	$push916=, $pop915, $pop1584
	i32.ne  	$push920=, $pop919, $pop916
	br_if   	1, $pop920      # 1: down to label0
# %bb.161:                              # %if.end1516
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push315=, 0($3)
	i32.const	$push1589=, 6
	i32.rem_s	$push921=, $pop315, $pop1589
	i32.load16_s	$push313=, 12($7)
	i32.ne  	$push922=, $pop921, $pop313
	br_if   	1, $pop922      # 1: down to label0
# %bb.162:                              # %lor.lhs.false1525
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push314=, 0($4)
	i32.const	$push1594=, 16
	i32.shl 	$push925=, $pop314, $pop1594
	i32.const	$push1593=, 16
	i32.shr_s	$push926=, $pop925, $pop1593
	i32.const	$push1592=, 5
	i32.rem_s	$push927=, $pop926, $pop1592
	i32.load16_u	$push312=, 10($7)
	i32.const	$push1591=, 16
	i32.shl 	$push923=, $pop312, $pop1591
	i32.const	$push1590=, 16
	i32.shr_s	$push924=, $pop923, $pop1590
	i32.ne  	$push928=, $pop927, $pop924
	br_if   	1, $pop928      # 1: down to label0
# %bb.163:                              # %if.end1535
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sq14141461461414@FUNCTION, $7, $1
	i32.load16_u	$push316=, 0($7)
	i32.load16_s	$push318=, 0($1)
	i32.const	$push1596=, 14
	i32.div_s	$push929=, $pop318, $pop1596
	i32.const	$push1595=, 65535
	i32.and 	$push930=, $pop929, $pop1595
	i32.ne  	$push931=, $pop316, $pop930
	br_if   	1, $pop931      # 1: down to label0
# %bb.164:                              # %lor.lhs.false1545
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push317=, 6($7)
	i32.const	$push1601=, 65535
	i32.and 	$push932=, $pop317, $pop1601
	i32.load16_u	$push319=, 0($5)
	i32.const	$push1600=, 16
	i32.shl 	$push933=, $pop319, $pop1600
	i32.const	$push1599=, 16
	i32.shr_s	$push934=, $pop933, $pop1599
	i32.const	$push1598=, 6
	i32.div_s	$push935=, $pop934, $pop1598
	i32.const	$push1597=, 65535
	i32.and 	$push936=, $pop935, $pop1597
	i32.ne  	$push937=, $pop932, $pop936
	br_if   	1, $pop937      # 1: down to label0
# %bb.165:                              # %if.end1555
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push321=, 4($7)
	i32.load16_s	$push323=, 4($1)
	i32.const	$push1603=, 14
	i32.div_s	$push938=, $pop323, $pop1603
	i32.const	$push1602=, 65535
	i32.and 	$push939=, $pop938, $pop1602
	i32.ne  	$push940=, $pop321, $pop939
	br_if   	1, $pop940      # 1: down to label0
# %bb.166:                              # %lor.lhs.false1564
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push320=, 2($7)
	i32.const	$push1608=, 65535
	i32.and 	$push941=, $pop320, $pop1608
	i32.load16_u	$push322=, 2($1)
	i32.const	$push1607=, 16
	i32.shl 	$push942=, $pop322, $pop1607
	i32.const	$push1606=, 16
	i32.shr_s	$push943=, $pop942, $pop1606
	i32.const	$push1605=, 14
	i32.div_s	$push944=, $pop943, $pop1605
	i32.const	$push1604=, 65535
	i32.and 	$push945=, $pop944, $pop1604
	i32.ne  	$push946=, $pop941, $pop945
	br_if   	1, $pop946      # 1: down to label0
# %bb.167:                              # %if.end1574
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push324=, 8($7)
	i32.load16_s	$push326=, 8($1)
	i32.const	$push1610=, 14
	i32.div_s	$push947=, $pop326, $pop1610
	i32.const	$push1609=, 65535
	i32.and 	$push948=, $pop947, $pop1609
	i32.ne  	$push949=, $pop324, $pop948
	br_if   	1, $pop949      # 1: down to label0
# %bb.168:                              # %lor.lhs.false1583
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push325=, 14($7)
	i32.const	$push1615=, 65535
	i32.and 	$push950=, $pop325, $pop1615
	i32.load16_u	$push327=, 0($2)
	i32.const	$push1614=, 16
	i32.shl 	$push951=, $pop327, $pop1614
	i32.const	$push1613=, 16
	i32.shr_s	$push952=, $pop951, $pop1613
	i32.const	$push1612=, 14
	i32.div_s	$push953=, $pop952, $pop1612
	i32.const	$push1611=, 65535
	i32.and 	$push954=, $pop953, $pop1611
	i32.ne  	$push955=, $pop950, $pop954
	br_if   	1, $pop955      # 1: down to label0
# %bb.169:                              # %if.end1593
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push329=, 12($7)
	i32.load16_s	$push331=, 0($3)
	i32.const	$push1617=, 14
	i32.div_s	$push956=, $pop331, $pop1617
	i32.const	$push1616=, 65535
	i32.and 	$push957=, $pop956, $pop1616
	i32.ne  	$push958=, $pop329, $pop957
	br_if   	1, $pop958      # 1: down to label0
# %bb.170:                              # %lor.lhs.false1602
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push328=, 10($7)
	i32.const	$push1622=, 65535
	i32.and 	$push959=, $pop328, $pop1622
	i32.load16_u	$push330=, 0($4)
	i32.const	$push1621=, 16
	i32.shl 	$push960=, $pop330, $pop1621
	i32.const	$push1620=, 16
	i32.shr_s	$push961=, $pop960, $pop1620
	i32.const	$push1619=, 6
	i32.div_s	$push962=, $pop961, $pop1619
	i32.const	$push1618=, 65535
	i32.and 	$push963=, $pop962, $pop1618
	i32.ne  	$push964=, $pop959, $pop963
	br_if   	1, $pop964      # 1: down to label0
# %bb.171:                              # %if.end1612
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sr14141461461414@FUNCTION, $7, $1
	i32.load16_s	$push334=, 0($1)
	i32.const	$push1623=, 14
	i32.rem_s	$push965=, $pop334, $pop1623
	i32.load16_s	$push332=, 0($7)
	i32.ne  	$push966=, $pop965, $pop332
	br_if   	1, $pop966      # 1: down to label0
# %bb.172:                              # %lor.lhs.false1622
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push335=, 0($5)
	i32.const	$push1628=, 16
	i32.shl 	$push969=, $pop335, $pop1628
	i32.const	$push1627=, 16
	i32.shr_s	$push970=, $pop969, $pop1627
	i32.const	$push1626=, 6
	i32.rem_s	$push971=, $pop970, $pop1626
	i32.load16_u	$push333=, 6($7)
	i32.const	$push1625=, 16
	i32.shl 	$push967=, $pop333, $pop1625
	i32.const	$push1624=, 16
	i32.shr_s	$push968=, $pop967, $pop1624
	i32.ne  	$push972=, $pop971, $pop968
	br_if   	1, $pop972      # 1: down to label0
# %bb.173:                              # %if.end1632
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push339=, 4($1)
	i32.const	$push1629=, 14
	i32.rem_s	$push973=, $pop339, $pop1629
	i32.load16_s	$push337=, 4($7)
	i32.ne  	$push974=, $pop973, $pop337
	br_if   	1, $pop974      # 1: down to label0
# %bb.174:                              # %lor.lhs.false1641
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push338=, 2($1)
	i32.const	$push1634=, 16
	i32.shl 	$push977=, $pop338, $pop1634
	i32.const	$push1633=, 16
	i32.shr_s	$push978=, $pop977, $pop1633
	i32.const	$push1632=, 14
	i32.rem_s	$push979=, $pop978, $pop1632
	i32.load16_u	$push336=, 2($7)
	i32.const	$push1631=, 16
	i32.shl 	$push975=, $pop336, $pop1631
	i32.const	$push1630=, 16
	i32.shr_s	$push976=, $pop975, $pop1630
	i32.ne  	$push980=, $pop979, $pop976
	br_if   	1, $pop980      # 1: down to label0
# %bb.175:                              # %if.end1651
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push342=, 8($1)
	i32.const	$push1635=, 14
	i32.rem_s	$push981=, $pop342, $pop1635
	i32.load16_s	$push340=, 8($7)
	i32.ne  	$push982=, $pop981, $pop340
	br_if   	1, $pop982      # 1: down to label0
# %bb.176:                              # %lor.lhs.false1660
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push343=, 0($2)
	i32.const	$push1640=, 16
	i32.shl 	$push985=, $pop343, $pop1640
	i32.const	$push1639=, 16
	i32.shr_s	$push986=, $pop985, $pop1639
	i32.const	$push1638=, 14
	i32.rem_s	$push987=, $pop986, $pop1638
	i32.load16_u	$push341=, 14($7)
	i32.const	$push1637=, 16
	i32.shl 	$push983=, $pop341, $pop1637
	i32.const	$push1636=, 16
	i32.shr_s	$push984=, $pop983, $pop1636
	i32.ne  	$push988=, $pop987, $pop984
	br_if   	1, $pop988      # 1: down to label0
# %bb.177:                              # %if.end1670
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_s	$push347=, 0($3)
	i32.const	$push1641=, 14
	i32.rem_s	$push989=, $pop347, $pop1641
	i32.load16_s	$push345=, 12($7)
	i32.ne  	$push990=, $pop989, $pop345
	br_if   	1, $pop990      # 1: down to label0
# %bb.178:                              # %lor.lhs.false1679
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push346=, 0($4)
	i32.const	$push1646=, 16
	i32.shl 	$push993=, $pop346, $pop1646
	i32.const	$push1645=, 16
	i32.shr_s	$push994=, $pop993, $pop1645
	i32.const	$push1644=, 6
	i32.rem_s	$push995=, $pop994, $pop1644
	i32.load16_u	$push344=, 10($7)
	i32.const	$push1643=, 16
	i32.shl 	$push991=, $pop344, $pop1643
	i32.const	$push1642=, 16
	i32.shr_s	$push992=, $pop991, $pop1642
	i32.ne  	$push996=, $pop995, $pop992
	br_if   	1, $pop996      # 1: down to label0
# %bb.179:                              # %if.end1689
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sq77777777@FUNCTION, $7, $1
	i32.load16_u	$push348=, 0($7)
	i32.load16_s	$push350=, 0($1)
	i32.const	$push1648=, 7
	i32.div_s	$push997=, $pop350, $pop1648
	i32.const	$push1647=, 65535
	i32.and 	$push998=, $pop997, $pop1647
	i32.ne  	$push999=, $pop348, $pop998
	br_if   	1, $pop999      # 1: down to label0
# %bb.180:                              # %lor.lhs.false1699
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push349=, 6($7)
	i32.const	$push1653=, 65535
	i32.and 	$push1000=, $pop349, $pop1653
	i32.load16_u	$push351=, 0($5)
	i32.const	$push1652=, 16
	i32.shl 	$push1001=, $pop351, $pop1652
	i32.const	$push1651=, 16
	i32.shr_s	$push1002=, $pop1001, $pop1651
	i32.const	$push1650=, 7
	i32.div_s	$push1003=, $pop1002, $pop1650
	i32.const	$push1649=, 65535
	i32.and 	$push1004=, $pop1003, $pop1649
	i32.ne  	$push1005=, $pop1000, $pop1004
	br_if   	1, $pop1005     # 1: down to label0
# %bb.181:                              # %if.end1709
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push353=, 4($7)
	i32.load16_s	$push355=, 4($1)
	i32.const	$push1655=, 7
	i32.div_s	$push1006=, $pop355, $pop1655
	i32.const	$push1654=, 65535
	i32.and 	$push1007=, $pop1006, $pop1654
	i32.ne  	$push1008=, $pop353, $pop1007
	br_if   	1, $pop1008     # 1: down to label0
# %bb.182:                              # %lor.lhs.false1718
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push352=, 2($7)
	i32.const	$push1660=, 65535
	i32.and 	$push1009=, $pop352, $pop1660
	i32.load16_u	$push354=, 2($1)
	i32.const	$push1659=, 16
	i32.shl 	$push1010=, $pop354, $pop1659
	i32.const	$push1658=, 16
	i32.shr_s	$push1011=, $pop1010, $pop1658
	i32.const	$push1657=, 7
	i32.div_s	$push1012=, $pop1011, $pop1657
	i32.const	$push1656=, 65535
	i32.and 	$push1013=, $pop1012, $pop1656
	i32.ne  	$push1014=, $pop1009, $pop1013
	br_if   	1, $pop1014     # 1: down to label0
# %bb.183:                              # %if.end1728
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push356=, 8($7)
	i32.load16_s	$push358=, 8($1)
	i32.const	$push1662=, 7
	i32.div_s	$push1015=, $pop358, $pop1662
	i32.const	$push1661=, 65535
	i32.and 	$push1016=, $pop1015, $pop1661
	i32.ne  	$push1017=, $pop356, $pop1016
	br_if   	1, $pop1017     # 1: down to label0
# %bb.184:                              # %lor.lhs.false1737
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push357=, 14($7)
	i32.const	$push1667=, 65535
	i32.and 	$push1018=, $pop357, $pop1667
	i32.load16_u	$push359=, 0($2)
	i32.const	$push1666=, 16
	i32.shl 	$push1019=, $pop359, $pop1666
	i32.const	$push1665=, 16
	i32.shr_s	$push1020=, $pop1019, $pop1665
	i32.const	$push1664=, 7
	i32.div_s	$push1021=, $pop1020, $pop1664
	i32.const	$push1663=, 65535
	i32.and 	$push1022=, $pop1021, $pop1663
	i32.ne  	$push1023=, $pop1018, $pop1022
	br_if   	1, $pop1023     # 1: down to label0
# %bb.185:                              # %if.end1747
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	i32.load16_u	$push361=, 12($7)
	i32.load16_s	$push363=, 0($3)
	i32.const	$push1669=, 7
	i32.div_s	$push1024=, $pop363, $pop1669
	i32.const	$push1668=, 65535
	i32.and 	$push1025=, $pop1024, $pop1668
	i32.ne  	$push1026=, $pop361, $pop1025
	br_if   	1, $pop1026     # 1: down to label0
# %bb.186:                              # %lor.lhs.false1756
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push360=, 10($7)
	i32.const	$push1674=, 65535
	i32.and 	$push1027=, $pop360, $pop1674
	i32.load16_u	$push362=, 0($4)
	i32.const	$push1673=, 16
	i32.shl 	$push1028=, $pop362, $pop1673
	i32.const	$push1672=, 16
	i32.shr_s	$push1029=, $pop1028, $pop1672
	i32.const	$push1671=, 7
	i32.div_s	$push1030=, $pop1029, $pop1671
	i32.const	$push1670=, 65535
	i32.and 	$push1031=, $pop1030, $pop1670
	i32.ne  	$push1032=, $pop1027, $pop1031
	br_if   	1, $pop1032     # 1: down to label0
# %bb.187:                              # %if.end1766
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$6=, $7
	#APP
	#NO_APP
	call    	sr77777777@FUNCTION, $7, $1
	i32.load16_s	$push366=, 0($1)
	i32.const	$push1675=, 7
	i32.rem_s	$push1033=, $pop366, $pop1675
	i32.load16_s	$push364=, 0($7)
	i32.ne  	$push1034=, $pop1033, $pop364
	br_if   	1, $pop1034     # 1: down to label0
# %bb.188:                              # %lor.lhs.false1776
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push367=, 0($5)
	i32.const	$push1680=, 16
	i32.shl 	$push1037=, $pop367, $pop1680
	i32.const	$push1679=, 16
	i32.shr_s	$push1038=, $pop1037, $pop1679
	i32.const	$push1678=, 7
	i32.rem_s	$push1039=, $pop1038, $pop1678
	i32.load16_u	$push365=, 6($7)
	i32.const	$push1677=, 16
	i32.shl 	$push1035=, $pop365, $pop1677
	i32.const	$push1676=, 16
	i32.shr_s	$push1036=, $pop1035, $pop1676
	i32.ne  	$push1040=, $pop1039, $pop1036
	br_if   	1, $pop1040     # 1: down to label0
# %bb.189:                              # %if.end1786
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$5=, $7
	#APP
	#NO_APP
	i32.load16_s	$push371=, 4($1)
	i32.const	$push1681=, 7
	i32.rem_s	$push1041=, $pop371, $pop1681
	i32.load16_s	$push369=, 4($7)
	i32.ne  	$push1042=, $pop1041, $pop369
	br_if   	1, $pop1042     # 1: down to label0
# %bb.190:                              # %lor.lhs.false1795
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push370=, 2($1)
	i32.const	$push1686=, 16
	i32.shl 	$push1045=, $pop370, $pop1686
	i32.const	$push1685=, 16
	i32.shr_s	$push1046=, $pop1045, $pop1685
	i32.const	$push1684=, 7
	i32.rem_s	$push1047=, $pop1046, $pop1684
	i32.load16_u	$push368=, 2($7)
	i32.const	$push1683=, 16
	i32.shl 	$push1043=, $pop368, $pop1683
	i32.const	$push1682=, 16
	i32.shr_s	$push1044=, $pop1043, $pop1682
	i32.ne  	$push1048=, $pop1047, $pop1044
	br_if   	1, $pop1048     # 1: down to label0
# %bb.191:                              # %if.end1805
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$5=, $7
	#APP
	#NO_APP
	i32.load16_s	$push374=, 8($1)
	i32.const	$push1687=, 7
	i32.rem_s	$push1049=, $pop374, $pop1687
	i32.load16_s	$push372=, 8($7)
	i32.ne  	$push1050=, $pop1049, $pop372
	br_if   	1, $pop1050     # 1: down to label0
# %bb.192:                              # %lor.lhs.false1814
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push375=, 0($2)
	i32.const	$push1692=, 16
	i32.shl 	$push1053=, $pop375, $pop1692
	i32.const	$push1691=, 16
	i32.shr_s	$push1054=, $pop1053, $pop1691
	i32.const	$push1690=, 7
	i32.rem_s	$push1055=, $pop1054, $pop1690
	i32.load16_u	$push373=, 14($7)
	i32.const	$push1689=, 16
	i32.shl 	$push1051=, $pop373, $pop1689
	i32.const	$push1688=, 16
	i32.shr_s	$push1052=, $pop1051, $pop1688
	i32.ne  	$push1056=, $pop1055, $pop1052
	br_if   	1, $pop1056     # 1: down to label0
# %bb.193:                              # %if.end1824
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$1=, $7
	#APP
	#NO_APP
	i32.load16_s	$push379=, 0($3)
	i32.const	$push1693=, 7
	i32.rem_s	$push1057=, $pop379, $pop1693
	i32.load16_s	$push377=, 12($7)
	i32.ne  	$push1058=, $pop1057, $pop377
	br_if   	1, $pop1058     # 1: down to label0
# %bb.194:                              # %lor.lhs.false1833
                                        #   in Loop: Header=BB24_99 Depth=1
	i32.load16_u	$push378=, 0($4)
	i32.const	$push1698=, 16
	i32.shl 	$push1061=, $pop378, $pop1698
	i32.const	$push1697=, 16
	i32.shr_s	$push1062=, $pop1061, $pop1697
	i32.const	$push1696=, 7
	i32.rem_s	$push1063=, $pop1062, $pop1696
	i32.load16_u	$push376=, 10($7)
	i32.const	$push1695=, 16
	i32.shl 	$push1059=, $pop376, $pop1695
	i32.const	$push1694=, 16
	i32.shr_s	$push1060=, $pop1059, $pop1694
	i32.ne  	$push1064=, $pop1063, $pop1060
	br_if   	1, $pop1064     # 1: down to label0
# %bb.195:                              # %if.end1843
                                        #   in Loop: Header=BB24_99 Depth=1
	copy_local	$1=, $7
	#APP
	#NO_APP
	i32.const	$push1065=, 1
	i32.add 	$1=, $0, $pop1065
	i32.const	$0=, 1
	i32.const	$push1699=, 2
	i32.lt_u	$push1066=, $1, $pop1699
	br_if   	0, $pop1066     # 0: up to label2
# %bb.196:                              # %for.end1846
	end_loop
	i32.const	$push1074=, 0
	i32.const	$push1072=, 32
	i32.add 	$push1073=, $7, $pop1072
	i32.store	__stack_pointer($pop1074), $pop1073
	i32.const	$push1067=, 0
	return  	$pop1067
.LBB24_197:                             # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end24:
	.size	main, .Lfunc_end24-main
                                        # -- End function
	.hidden	u                       # @u
	.type	u,@object
	.section	.data.u,"aw",@progbits
	.globl	u
	.p2align	4
u:
	.int16	73                      # 0x49
	.int16	65531                   # 0xfffb
	.int16	0                       # 0x0
	.int16	174                     # 0xae
	.int16	921                     # 0x399
	.int16	65535                   # 0xffff
	.int16	17                      # 0x11
	.int16	178                     # 0xb2
	.int16	1                       # 0x1
	.int16	8173                    # 0x1fed
	.int16	65535                   # 0xffff
	.int16	65472                   # 0xffc0
	.int16	12                      # 0xc
	.int16	29612                   # 0x73ac
	.int16	128                     # 0x80
	.int16	8912                    # 0x22d0
	.size	u, 32

	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.p2align	4
s:
	.int16	73                      # 0x49
	.int16	56413                   # 0xdc5d
	.int16	32761                   # 0x7ff9
	.int16	8191                    # 0x1fff
	.int16	16371                   # 0x3ff3
	.int16	1201                    # 0x4b1
	.int16	12701                   # 0x319d
	.int16	9999                    # 0x270f
	.int16	9903                    # 0x26af
	.int16	65535                   # 0xffff
	.int16	58213                   # 0xe365
	.int16	0                       # 0x0
	.int16	65529                   # 0xfff9
	.int16	65213                   # 0xfebd
	.int16	9124                    # 0x23a4
	.int16	56337                   # 0xdc11
	.size	s, 32


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
