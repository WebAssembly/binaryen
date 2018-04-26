	.text
	.file	"931004-13.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.load8_u	$push6=, 2($1)
	i32.const	$push7=, 30
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %if.end11
	i32.load8_u	$push9=, 3($1)
	i32.const	$push10=, 40
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %if.end16
	i32.load8_u	$push12=, 0($2)
	i32.const	$push13=, 11
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %if.end22
	i32.load8_u	$push15=, 1($2)
	i32.const	$push16=, 21
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# %bb.6:                                # %if.end28
	i32.load8_u	$push18=, 2($2)
	i32.const	$push19=, 31
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.7:                                # %if.end34
	i32.load8_u	$push21=, 3($2)
	i32.const	$push22=, 41
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.8:                                # %if.end40
	i32.load8_u	$push24=, 0($3)
	i32.const	$push25=, 12
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# %bb.9:                                # %if.end46
	i32.load8_u	$push27=, 1($3)
	i32.const	$push28=, 22
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# %bb.10:                               # %if.end52
	i32.load8_u	$push30=, 2($3)
	i32.const	$push31=, 32
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# %bb.11:                               # %if.end58
	i32.load8_u	$push33=, 3($3)
	i32.const	$push34=, 42
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# %bb.12:                               # %if.end64
	i32.const	$push36=, 123
	i32.ne  	$push37=, $4, $pop36
	br_if   	0, $pop37       # 0: down to label0
# %bb.13:                               # %if.end68
	return  	$2
.LBB0_14:                               # %if.then
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
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$0=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $0
	i64.const	$push0=, 2963110217494959114
	i64.store	16($0), $pop0
	i32.const	$push1=, 706745868
	i32.store	24($0), $pop1
	i32.const	$push16=, 706745868
	i32.store	4($0), $pop16
	i32.load	$push2=, 16($0)
	i32.store	12($0), $pop2
	i32.load	$push3=, 20($0)
	i32.store	8($0), $pop3
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.const	$push4=, 123
	i32.call	$drop=, f@FUNCTION, $0, $pop11, $pop13, $pop15, $pop4
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
