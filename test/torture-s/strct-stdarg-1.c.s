	.text
	.file	"strct-stdarg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push27=, 0
	i32.load	$push26=, __stack_pointer($pop27)
	i32.const	$push28=, 16
	i32.sub 	$4=, $pop26, $pop28
	i32.const	$push29=, 0
	i32.store	__stack_pointer($pop29), $4
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push33=, 1
	i32.lt_s	$push3=, $0, $pop33
	br_if   	0, $pop3        # 0: down to label2
# %bb.1:                                # %for.body.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push35=, 8
	i32.add 	$3=, $1, $pop35
	i32.store	12($4), $3
	i32.const	$push34=, 10
	i32.add 	$push4=, $2, $pop34
	i32.load8_s	$push5=, 0($1)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	3, $pop6        # 3: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push37=, 20
	i32.add 	$push10=, $2, $pop37
	i32.const	$push36=, 1
	i32.add 	$push11=, $1, $pop36
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push13=, $pop10, $pop12
	br_if   	3, $pop13       # 3: down to label0
# %bb.4:                                # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push39=, 30
	i32.add 	$push14=, $2, $pop39
	i32.const	$push38=, 2
	i32.add 	$push9=, $1, $pop38
	i32.load8_s	$push0=, 0($pop9)
	i32.ne  	$push15=, $pop14, $pop0
	br_if   	3, $pop15       # 3: down to label0
# %bb.5:                                # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push41=, 40
	i32.add 	$push16=, $2, $pop41
	i32.const	$push40=, 3
	i32.add 	$push8=, $1, $pop40
	i32.load8_s	$push1=, 0($pop8)
	i32.ne  	$push17=, $pop16, $pop1
	br_if   	3, $pop17       # 3: down to label0
# %bb.6:                                # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push43=, 50
	i32.add 	$push18=, $2, $pop43
	i32.const	$push42=, 4
	i32.add 	$push7=, $1, $pop42
	i32.load8_s	$push2=, 0($pop7)
	i32.ne  	$push19=, $pop18, $pop2
	br_if   	3, $pop19       # 3: down to label0
# %bb.7:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push44=, 1
	i32.add 	$2=, $2, $pop44
	copy_local	$1=, $3
	i32.lt_s	$push20=, $2, $0
	br_if   	0, $pop20       # 0: up to label3
	br      	2               # 2: down to label1
.LBB0_8:
	end_loop
	end_block                       # label2:
	copy_local	$3=, $1
.LBB0_9:                                # %for.end
	end_block                       # label1:
	i32.const	$push21=, 4
	i32.add 	$push22=, $3, $pop21
	i32.store	12($4), $pop22
	i32.load	$push23=, 0($3)
	i32.const	$push24=, 123
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label0
# %bb.10:                               # %if.end34
	i32.const	$push32=, 0
	i32.const	$push30=, 16
	i32.add 	$push31=, $4, $pop30
	i32.store	__stack_pointer($pop32), $pop31
	return  	$2
.LBB0_11:                               # %if.then
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
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 64
	i32.sub 	$0=, $pop27, $pop29
	i32.const	$push30=, 0
	i32.store	__stack_pointer($pop30), $0
	i32.const	$push0=, 56
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 369898281
	i32.store	0($pop1), $pop2
	i32.const	$push3=, 61
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 13354
	i32.store16	0($pop4):p2align=0, $pop5
	i32.const	$push6=, 60
	i32.add 	$push7=, $0, $pop6
	i32.const	$push8=, 32
	i32.store8	0($pop7), $pop8
	i64.const	$push9=, 2239708699736019978
	i64.store	48($0), $pop9
	i32.const	$push31=, 40
	i32.add 	$push32=, $0, $pop31
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop32, $pop10
	i32.load8_u	$push12=, 52($0)
	i32.store8	0($pop11), $pop12
	i32.const	$push33=, 32
	i32.add 	$push34=, $0, $pop33
	i32.const	$push44=, 4
	i32.add 	$push13=, $pop34, $pop44
	i32.const	$push14=, 57
	i32.add 	$push15=, $0, $pop14
	i32.load8_u	$push16=, 0($pop15)
	i32.store8	0($pop13), $pop16
	i32.const	$push35=, 24
	i32.add 	$push36=, $0, $pop35
	i32.const	$push43=, 4
	i32.add 	$push17=, $pop36, $pop43
	i32.const	$push18=, 62
	i32.add 	$push19=, $0, $pop18
	i32.load8_u	$push20=, 0($pop19)
	i32.store8	0($pop17), $pop20
	i32.load	$push21=, 48($0)
	i32.store	40($0), $pop21
	i32.load	$push22=, 53($0):p2align=0
	i32.store	32($0), $pop22
	i32.load	$push23=, 58($0):p2align=1
	i32.store	24($0), $pop23
	i32.const	$push24=, 123
	i32.store	12($0), $pop24
	i32.const	$push37=, 24
	i32.add 	$push38=, $0, $pop37
	i32.store	8($0), $pop38
	i32.const	$push39=, 32
	i32.add 	$push40=, $0, $pop39
	i32.store	4($0), $pop40
	i32.const	$push41=, 40
	i32.add 	$push42=, $0, $pop41
	i32.store	0($0), $pop42
	i32.const	$push25=, 3
	i32.call	$drop=, f@FUNCTION, $pop25, $0
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
