	.text
	.file	"20071213-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h                       # -- Begin function h
	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %entry
	i32.const	$push2=, 1
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label1
# %bb.2:                                # %sw.bb
	i32.load	$push10=, 0($1)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# %bb.3:                                # %lor.lhs.false
	i32.load	$push13=, 4($1)
	i32.const	$push14=, 4
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	1, $pop15       # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_4:                                # %sw.bb4
	end_block                       # label2:
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# %bb.5:                                # %lor.lhs.false8
	i32.load	$push7=, 4($1)
	i32.const	$push8=, 10
	i32.eq  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label0
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %return
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	h, .Lfunc_end0-h
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i64, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 16
	i32.sub 	$3=, $pop17, $pop19
	i32.const	$push20=, 0
	i32.store	__stack_pointer($pop20), $3
	i32.store	12($3), $2
	block   	
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# %bb.1:                                # %sw.bb.i
	i32.load	$push9=, 0($2)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label3
# %bb.2:                                # %lor.lhs.false.i
	i32.load	$push12=, 4($2)
	i32.const	$push13=, 4
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label3
# %bb.3:                                # %h.exit
	i64.const	$push15=, 2
	i64.ne  	$push16=, $1, $pop15
	br_if   	1, $pop16       # 1: down to label3
# %bb.4:                                # %if.end
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $3, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB1_5:                                # %entry
	end_block                       # label4:
	i32.const	$push2=, 5
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label3
# %bb.6:                                # %sw.bb4.i
	i32.load	$push4=, 0($2)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label3
# %bb.7:                                # %lor.lhs.false8.i
	i32.load	$push7=, 4($2)
	i32.const	$push8=, 10
	i32.eq  	$drop=, $pop7, $pop8
.LBB1_8:                                # %if.then.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i64, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 16
	i32.sub 	$5=, $pop24, $pop26
	i32.const	$push27=, 0
	i32.store	__stack_pointer($pop27), $5
	i32.store	12($5), $4
	block   	
	block   	
	block   	
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# %bb.1:                                # %entry
	i32.const	$push2=, 1
	i32.ne  	$push3=, $0, $pop2
	br_if   	2, $pop3        # 2: down to label5
# %bb.2:                                # %sw.bb.i
	i32.load	$push10=, 0($4)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	2, $pop12       # 2: down to label5
# %bb.3:                                # %lor.lhs.false.i
	i32.load	$push13=, 4($4)
	i32.const	$push14=, 4
	i32.eq  	$push15=, $pop13, $pop14
	br_if   	1, $pop15       # 1: down to label6
	br      	2               # 2: down to label5
.LBB2_4:                                # %sw.bb4.i
	end_block                       # label7:
	i32.load	$push4=, 0($4)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label5
# %bb.5:                                # %lor.lhs.false8.i
	i32.load	$push7=, 4($4)
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label5
.LBB2_6:                                # %h.exit
	end_block                       # label6:
	i32.const	$push16=, 5
	i32.ne  	$push17=, $0, $pop16
	br_if   	0, $pop17       # 0: down to label5
# %bb.7:                                # %h.exit
	i32.const	$push18=, 6
	i32.ne  	$push19=, $1, $pop18
	br_if   	0, $pop19       # 0: down to label5
# %bb.8:                                # %h.exit
	i32.const	$push20=, 7
	i32.ne  	$push21=, $2, $pop20
	br_if   	0, $pop21       # 0: down to label5
# %bb.9:                                # %h.exit
	i64.const	$push22=, 8
	i64.ne  	$push23=, $3, $pop22
	br_if   	0, $pop23       # 0: down to label5
# %bb.10:                               # %if.end
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $5, $pop28
	i32.store	__stack_pointer($pop30), $pop29
	return
.LBB2_11:                               # %if.then.i
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 32
	i32.sub 	$0=, $pop9, $pop11
	i32.const	$push12=, 0
	i32.store	__stack_pointer($pop12), $0
	i64.const	$push0=, 17179869187
	i64.store	16($0), $pop0
	i32.const	$push2=, 1
	i64.const	$push1=, 2
	i32.const	$push16=, 16
	i32.add 	$push17=, $0, $pop16
	call    	f1@FUNCTION, $pop2, $pop1, $pop17
	i64.const	$push3=, 42949672969
	i64.store	0($0), $pop3
	i32.const	$push7=, 5
	i32.const	$push6=, 6
	i32.const	$push5=, 7
	i64.const	$push4=, 8
	call    	f2@FUNCTION, $pop7, $pop6, $pop5, $pop4, $0
	i32.const	$push15=, 0
	i32.const	$push13=, 32
	i32.add 	$push14=, $0, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
