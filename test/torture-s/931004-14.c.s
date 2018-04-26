	.text
	.file	"931004-14.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push23=, 0
	i32.load	$push22=, __stack_pointer($pop23)
	i32.const	$push24=, 16
	i32.sub 	$3=, $pop22, $pop24
	i32.const	$push25=, 0
	i32.store	__stack_pointer($pop25), $3
	i32.const	$push30=, 4
	i32.add 	$push2=, $1, $pop30
	i32.store	12($3), $pop2
	block   	
	block   	
	i32.const	$push29=, 1
	i32.lt_s	$push3=, $0, $pop29
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push31=, 10
	i32.add 	$push4=, $2, $pop31
	i32.load8_s	$push5=, 0($1)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	2, $pop6        # 2: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push33=, 20
	i32.add 	$push9=, $2, $pop33
	i32.const	$push32=, 1
	i32.add 	$push10=, $1, $pop32
	i32.load8_s	$push11=, 0($pop10)
	i32.ne  	$push12=, $pop9, $pop11
	br_if   	2, $pop12       # 2: down to label0
# %bb.4:                                # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push35=, 30
	i32.add 	$push13=, $2, $pop35
	i32.const	$push34=, 2
	i32.add 	$push8=, $1, $pop34
	i32.load8_s	$push0=, 0($pop8)
	i32.ne  	$push14=, $pop13, $pop0
	br_if   	2, $pop14       # 2: down to label0
# %bb.5:                                # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push37=, 40
	i32.add 	$push15=, $2, $pop37
	i32.const	$push36=, 3
	i32.add 	$push7=, $1, $pop36
	i32.load8_s	$push1=, 0($pop7)
	i32.ne  	$push16=, $pop15, $pop1
	br_if   	2, $pop16       # 2: down to label0
# %bb.6:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push40=, 1
	i32.add 	$2=, $2, $pop40
	i32.const	$push39=, 8
	i32.add 	$push17=, $1, $pop39
	i32.store	12($3), $pop17
	i32.const	$push38=, 4
	i32.add 	$1=, $1, $pop38
	i32.lt_s	$push18=, $2, $0
	br_if   	0, $pop18       # 0: up to label2
.LBB0_7:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push19=, 0($1)
	i32.const	$push20=, 123
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# %bb.8:                                # %if.end28
	i32.const	$push28=, 0
	i32.const	$push26=, 16
	i32.add 	$push27=, $3, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	return  	$1
.LBB0_9:                                # %if.then
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
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 48
	i32.sub 	$0=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $0
	i64.const	$push0=, 2963110217494959114
	i64.store	32($0), $pop0
	i32.const	$push1=, 706745868
	i32.store	40($0), $pop1
	i32.const	$push17=, 706745868
	i32.store	20($0), $pop17
	i32.const	$push2=, 123
	i32.store	12($0), $pop2
	i32.load	$push3=, 32($0)
	i32.store	28($0), $pop3
	i32.load	$push4=, 36($0)
	i32.store	24($0), $pop4
	i32.const	$push11=, 20
	i32.add 	$push12=, $0, $pop11
	i32.store	8($0), $pop12
	i32.const	$push13=, 24
	i32.add 	$push14=, $0, $pop13
	i32.store	4($0), $pop14
	i32.const	$push15=, 28
	i32.add 	$push16=, $0, $pop15
	i32.store	0($0), $pop16
	i32.const	$push5=, 3
	i32.call	$drop=, f@FUNCTION, $pop5, $0
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
