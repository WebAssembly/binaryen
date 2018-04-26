	.text
	.file	"pr60960.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 254
	i32.and 	$push3=, $4, $pop2
	i32.const	$push4=, 1
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	0($pop1), $pop5
	i32.const	$push17=, 254
	i32.and 	$push6=, $3, $pop17
	i32.const	$push16=, 1
	i32.shr_u	$push7=, $pop6, $pop16
	i32.store8	2($0), $pop7
	i32.const	$push15=, 254
	i32.and 	$push8=, $2, $pop15
	i32.const	$push14=, 1
	i32.shr_u	$push9=, $pop8, $pop14
	i32.store8	1($0), $pop9
	i32.const	$push13=, 254
	i32.and 	$push10=, $1, $pop13
	i32.const	$push12=, 1
	i32.shr_u	$push11=, $pop10, $pop12
	i32.store8	0($0), $pop11
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 254
	i32.and 	$push3=, $4, $pop2
	i32.const	$push4=, 1
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	0($pop1), $pop5
	i32.const	$push17=, 254
	i32.and 	$push6=, $3, $pop17
	i32.const	$push16=, 1
	i32.shr_u	$push7=, $pop6, $pop16
	i32.store8	2($0), $pop7
	i32.const	$push15=, 254
	i32.and 	$push8=, $2, $pop15
	i32.const	$push14=, 1
	i32.shr_u	$push9=, $pop8, $pop14
	i32.store8	1($0), $pop9
	i32.const	$push13=, 254
	i32.and 	$push10=, $1, $pop13
	i32.const	$push12=, 1
	i32.shr_u	$push11=, $pop10, $pop12
	i32.store8	0($0), $pop11
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push4=, 3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push0=, 255
	i32.and 	$push2=, $4, $pop0
	i32.const	$push21=, 255
	i32.and 	$push1=, $8, $pop21
	i32.div_u	$push3=, $pop2, $pop1
	i32.store8	0($pop5), $pop3
	i32.const	$push20=, 255
	i32.and 	$push7=, $3, $pop20
	i32.const	$push19=, 255
	i32.and 	$push6=, $7, $pop19
	i32.div_u	$push8=, $pop7, $pop6
	i32.store8	2($0), $pop8
	i32.const	$push18=, 255
	i32.and 	$push10=, $2, $pop18
	i32.const	$push17=, 255
	i32.and 	$push9=, $6, $pop17
	i32.div_u	$push11=, $pop10, $pop9
	i32.store8	1($0), $pop11
	i32.const	$push16=, 255
	i32.and 	$push13=, $1, $pop16
	i32.const	$push15=, 255
	i32.and 	$push12=, $5, $pop15
	i32.div_u	$push14=, $pop13, $pop12
	i32.store8	0($0), $pop14
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$0=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $0
	i32.const	$push17=, 12
	i32.add 	$push18=, $0, $pop17
	i32.const	$push27=, 5
	i32.const	$push26=, 5
	i32.const	$push25=, 5
	i32.const	$push24=, 5
	call    	f1@FUNCTION, $pop18, $pop27, $pop26, $pop25, $pop24
	block   	
	i32.load	$push0=, 12($0)
	i32.const	$push23=, 33686018
	i32.ne  	$push1=, $pop0, $pop23
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push19=, 8
	i32.add 	$push20=, $0, $pop19
	i32.const	$push32=, 5
	i32.const	$push31=, 5
	i32.const	$push30=, 5
	i32.const	$push29=, 5
	call    	f2@FUNCTION, $pop20, $pop32, $pop31, $pop30, $pop29
	i32.load	$push2=, 8($0)
	i32.const	$push28=, 33686018
	i32.ne  	$push3=, $pop2, $pop28
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push21=, 4
	i32.add 	$push22=, $0, $pop21
	i32.const	$push5=, 5
	i32.const	$push38=, 5
	i32.const	$push37=, 5
	i32.const	$push36=, 5
	i32.const	$push4=, 2
	i32.const	$push35=, 2
	i32.const	$push34=, 2
	i32.const	$push33=, 2
	call    	f3@FUNCTION, $pop22, $pop5, $pop38, $pop37, $pop36, $pop4, $pop35, $pop34, $pop33
	i32.load	$push7=, 4($0)
	i32.const	$push6=, 33686018
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $0, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	i32.const	$push9=, 0
	return  	$pop9
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
