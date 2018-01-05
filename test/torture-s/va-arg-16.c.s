	.text
	.file	"va-arg-16.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction              # -- Begin function vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	f64, f64, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push46=, 0
	i32.load	$push45=, __stack_pointer($pop46)
	i32.const	$push47=, 16
	i32.sub 	$5=, $pop45, $pop47
	i32.const	$push48=, 0
	i32.store	__stack_pointer($pop48), $5
	i32.store	12($5), $2
	block   	
	f64.const	$push0=, 0x1.bcp9
	f64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	f64.const	$push2=, 0x1.f38p9
	f64.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end4
	i32.load	$push5=, 12($5)
	i32.const	$push4=, 7
	i32.add 	$push6=, $pop5, $pop4
	i32.const	$push7=, -8
	i32.and 	$2=, $pop6, $pop7
	i32.const	$push8=, 8
	i32.add 	$3=, $2, $pop8
	i32.store	12($5), $3
	f64.load	$push9=, 0($2)
	f64.const	$push10=, 0x1p0
	f64.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.3:                                # %if.end7
	i32.const	$push12=, 16
	i32.add 	$4=, $2, $pop12
	i32.store	12($5), $4
	f64.load	$push13=, 0($3)
	f64.const	$push14=, 0x1p1
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# %bb.4:                                # %if.end12
	i32.const	$push16=, 24
	i32.add 	$3=, $2, $pop16
	i32.store	12($5), $3
	f64.load	$push17=, 0($4)
	f64.const	$push18=, 0x1.8p1
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.5:                                # %if.end17
	i32.const	$push20=, 32
	i32.add 	$4=, $2, $pop20
	i32.store	12($5), $4
	f64.load	$push21=, 0($3)
	f64.const	$push22=, 0x1p2
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.6:                                # %if.end22
	i32.const	$push24=, 40
	i32.add 	$3=, $2, $pop24
	i32.store	12($5), $3
	f64.load	$push25=, 0($4)
	f64.const	$push26=, 0x1.4p2
	f64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.7:                                # %if.end27
	i32.const	$push28=, 48
	i32.add 	$4=, $2, $pop28
	i32.store	12($5), $4
	f64.load	$push29=, 0($3)
	f64.const	$push30=, 0x1.8p2
	f64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# %bb.8:                                # %if.end32
	i32.const	$push32=, 56
	i32.add 	$3=, $2, $pop32
	i32.store	12($5), $3
	f64.load	$push33=, 0($4)
	f64.const	$push34=, 0x1.cp2
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# %bb.9:                                # %if.end37
	i32.const	$push36=, 64
	i32.add 	$4=, $2, $pop36
	i32.store	12($5), $4
	f64.load	$push37=, 0($3)
	f64.const	$push38=, 0x1p3
	f64.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# %bb.10:                               # %if.end42
	i32.const	$push40=, 72
	i32.add 	$push41=, $2, $pop40
	i32.store	12($5), $pop41
	f64.load	$push42=, 0($4)
	f64.const	$push43=, 0x1.2p3
	f64.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label0
# %bb.11:                               # %if.end47
	i32.const	$push51=, 0
	i32.const	$push49=, 16
	i32.add 	$push50=, $5, $pop49
	i32.store	__stack_pointer($pop51), $pop50
	return
.LBB0_12:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vafunction, .Lfunc_end0-vafunction
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push27=, 0
	i32.load	$push26=, __stack_pointer($pop27)
	i32.const	$push28=, 80
	i32.sub 	$0=, $pop26, $pop28
	i32.const	$push29=, 0
	i32.store	__stack_pointer($pop29), $0
	i32.const	$push0=, 64
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	0($pop13), $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	0($pop19), $pop20
	i64.const	$push21=, 4611686018427387904
	i64.store	8($0), $pop21
	i64.const	$push22=, 4607182418800017408
	i64.store	0($0), $pop22
	f64.const	$push24=, 0x1.bcp9
	f64.const	$push23=, 0x1.f38p9
	call    	vafunction@FUNCTION, $pop24, $pop23, $0
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
