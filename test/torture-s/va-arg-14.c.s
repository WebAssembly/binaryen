	.text
	.file	"va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat                     # -- Begin function vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 16
	i32.sub 	$2=, $pop24, $pop26
	i32.const	$push27=, 0
	i32.store	__stack_pointer($pop27), $2
	i32.store	12($2), $0
	i32.const	$push33=, 0
	i32.store	global($pop33), $1
	i32.store	12($2), $1
	i32.const	$push32=, 4
	i32.add 	$push0=, $1, $pop32
	i32.store	8($2), $pop0
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push31=, 1
	i32.ne  	$push2=, $pop1, $pop31
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push37=, 0
	i32.load	$0=, global($pop37)
	i32.const	$push36=, 0
	i32.const	$push35=, 4
	i32.add 	$push3=, $0, $pop35
	i32.store	global($pop36), $pop3
	i32.load	$push4=, 0($0)
	i32.const	$push34=, 1
	i32.ne  	$push5=, $pop4, $pop34
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end7
	i32.load	$0=, 12($2)
	i32.const	$push39=, 4
	i32.add 	$push6=, $0, $pop39
	i32.store	12($2), $pop6
	i32.load	$push7=, 0($0)
	i32.const	$push38=, 1
	i32.ne  	$push8=, $pop7, $pop38
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end12
	i32.const	$push42=, 0
	i32.store	global($pop42), $1
	i32.store	12($2), $1
	i32.const	$push41=, 4
	i32.add 	$push9=, $1, $pop41
	i32.store	8($2), $pop9
	i32.load	$push10=, 0($1)
	i32.const	$push40=, 1
	i32.ne  	$push11=, $pop10, $pop40
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %if.end19
	i32.const	$push45=, 0
	i32.load	$1=, global($pop45)
	i32.const	$push44=, 4
	i32.add 	$push12=, $1, $pop44
	i32.store	8($2), $pop12
	i32.load	$push13=, 0($1)
	i32.const	$push43=, 1
	i32.ne  	$push14=, $pop13, $pop43
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %if.end25
	i32.const	$push15=, 0
	i32.load	$1=, global($pop15)
	i32.const	$push48=, 0
	i32.const	$push47=, 4
	i32.add 	$push16=, $1, $pop47
	i32.store	global($pop48), $pop16
	i32.load	$push17=, 0($1)
	i32.const	$push46=, 1
	i32.ne  	$push18=, $pop17, $pop46
	br_if   	0, $pop18       # 0: down to label0
# %bb.6:                                # %if.end31
	i32.load	$1=, 12($2)
	i32.const	$push19=, 4
	i32.add 	$push20=, $1, $pop19
	i32.store	12($2), $pop20
	i32.load	$push21=, 0($1)
	i32.const	$push22=, 1
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.7:                                # %if.end36
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $2, $pop28
	i32.store	__stack_pointer($pop30), $pop29
	return
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vat, .Lfunc_end0-vat
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i32.const	$push0=, 1
	i32.store	0($0), $pop0
	call    	vat@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0
	.size	global, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
