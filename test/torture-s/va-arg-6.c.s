	.text
	.file	"va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push49=, 0
	i32.load	$push48=, __stack_pointer($pop49)
	i32.const	$push50=, 16
	i32.sub 	$4=, $pop48, $pop50
	i32.const	$push51=, 0
	i32.store	__stack_pointer($pop51), $4
	i32.const	$push0=, 4
	i32.add 	$2=, $1, $pop0
	i32.store	12($4), $2
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 7
	i32.add 	$push5=, $2, $pop4
	i32.const	$push6=, -8
	i32.and 	$1=, $pop5, $pop6
	i32.const	$push7=, 8
	i32.add 	$2=, $1, $pop7
	i32.store	12($4), $2
	i64.load	$push8=, 0($1)
	i64.const	$push9=, 10000000000
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push11=, 12
	i32.add 	$1=, $1, $pop11
	i32.store	12($4), $1
	i32.load	$push12=, 0($2)
	i32.const	$push13=, 11
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push15=, 15
	i32.add 	$push16=, $1, $pop15
	i32.const	$push17=, -16
	i32.and 	$1=, $pop16, $pop17
	i32.const	$push18=, 16
	i32.add 	$2=, $1, $pop18
	i32.store	12($4), $2
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, -1475739525896764129
	i64.const	$push21=, 4611846459164112977
	i32.call	$push23=, __eqtf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label0
# %bb.4:                                # %if.end16
	i32.const	$push24=, 20
	i32.add 	$3=, $1, $pop24
	i32.store	12($4), $3
	i32.load	$push25=, 0($2)
	i32.const	$push26=, 12
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.5:                                # %if.end21
	i32.const	$push28=, 24
	i32.add 	$2=, $1, $pop28
	i32.store	12($4), $2
	i32.load	$push29=, 0($3)
	i32.const	$push30=, 13
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# %bb.6:                                # %if.end26
	i32.const	$push32=, 32
	i32.add 	$3=, $1, $pop32
	i32.store	12($4), $3
	i64.load	$push33=, 0($2)
	i64.const	$push34=, 20000000000
	i64.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# %bb.7:                                # %if.end31
	i32.const	$push36=, 36
	i32.add 	$1=, $1, $pop36
	i32.store	12($4), $1
	i32.load	$push37=, 0($3)
	i32.const	$push38=, 14
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# %bb.8:                                # %if.end36
	i32.const	$push40=, 7
	i32.add 	$push41=, $1, $pop40
	i32.const	$push42=, -8
	i32.and 	$1=, $pop41, $pop42
	i32.const	$push43=, 8
	i32.add 	$push44=, $1, $pop43
	i32.store	12($4), $pop44
	f64.load	$push45=, 0($1)
	f64.const	$push46=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label0
# %bb.9:                                # %if.end41
	i32.const	$push54=, 0
	i32.const	$push52=, 16
	i32.add 	$push53=, $4, $pop52
	i32.store	__stack_pointer($pop54), $pop53
	return  	$4
.LBB0_10:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 80
	i32.sub 	$0=, $pop24, $pop26
	i32.const	$push27=, 0
	i32.store	__stack_pointer($pop27), $0
	i32.const	$push0=, 64
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 4613307314293241283
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 14
	i32.store	0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 20000000000
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 55834574860
	i64.store	0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4611846459164112977
	i64.store	0($pop13), $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, -1475739525896764129
	i64.store	0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i32.const	$push20=, 11
	i32.store	0($pop19), $pop20
	i64.const	$push21=, 10000000000
	i64.store	8($0), $pop21
	i32.const	$push22=, 10
	i32.store	0($0), $pop22
	i32.call	$drop=, f@FUNCTION, $0, $0
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
