	.text
	.file	"va-arg-17.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction              # -- Begin function vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push41=, 0
	i32.load	$push40=, __stack_pointer($pop41)
	i32.const	$push42=, 16
	i32.sub 	$4=, $pop40, $pop42
	i32.const	$push43=, 0
	i32.store	__stack_pointer($pop43), $4
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, -8
	i32.and 	$1=, $pop1, $pop2
	i32.const	$push3=, 8
	i32.add 	$2=, $1, $pop3
	i32.store	12($4), $2
	block   	
	f64.load	$push4=, 0($1)
	f64.const	$push5=, 0x1p0
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push7=, 16
	i32.add 	$3=, $1, $pop7
	i32.store	12($4), $3
	f64.load	$push8=, 0($2)
	f64.const	$push9=, 0x1p1
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push11=, 24
	i32.add 	$2=, $1, $pop11
	i32.store	12($4), $2
	f64.load	$push12=, 0($3)
	f64.const	$push13=, 0x1.8p1
	f64.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push15=, 32
	i32.add 	$3=, $1, $pop15
	i32.store	12($4), $3
	f64.load	$push16=, 0($2)
	f64.const	$push17=, 0x1p2
	f64.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# %bb.4:                                # %if.end16
	i32.const	$push19=, 40
	i32.add 	$2=, $1, $pop19
	i32.store	12($4), $2
	f64.load	$push20=, 0($3)
	f64.const	$push21=, 0x1.4p2
	f64.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# %bb.5:                                # %if.end21
	i32.const	$push23=, 48
	i32.add 	$3=, $1, $pop23
	i32.store	12($4), $3
	f64.load	$push24=, 0($2)
	f64.const	$push25=, 0x1.8p2
	f64.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# %bb.6:                                # %if.end26
	i32.const	$push27=, 56
	i32.add 	$2=, $1, $pop27
	i32.store	12($4), $2
	f64.load	$push28=, 0($3)
	f64.const	$push29=, 0x1.cp2
	f64.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label0
# %bb.7:                                # %if.end31
	i32.const	$push31=, 64
	i32.add 	$3=, $1, $pop31
	i32.store	12($4), $3
	f64.load	$push32=, 0($2)
	f64.const	$push33=, 0x1p3
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# %bb.8:                                # %if.end36
	i32.const	$push35=, 72
	i32.add 	$push36=, $1, $pop35
	i32.store	12($4), $pop36
	f64.load	$push37=, 0($3)
	f64.const	$push38=, 0x1.2p3
	f64.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# %bb.9:                                # %if.end41
	i32.const	$push46=, 0
	i32.const	$push44=, 16
	i32.add 	$push45=, $4, $pop44
	i32.store	__stack_pointer($pop46), $pop45
	return
.LBB0_10:                               # %if.then
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
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 80
	i32.sub 	$0=, $pop24, $pop26
	i32.const	$push27=, 0
	i32.store	__stack_pointer($pop27), $0
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
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
