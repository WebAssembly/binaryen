	.text
	.file	"20020413-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i64, i64, i32
	.local  	i64, i64, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push23=, 0
	i32.load	$push22=, __stack_pointer($pop23)
	i32.const	$push24=, 48
	i32.sub 	$7=, $pop22, $pop24
	i32.const	$push25=, 0
	i32.store	__stack_pointer($pop25), $7
	i32.const	$push29=, 32
	i32.add 	$push30=, $7, $pop29
	i64.const	$push39=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop30, $pop39, $pop0, $0, $1
	i32.const	$6=, 0
	i64.const	$push38=, 0
	i64.const	$push37=, 0
	i32.call	$push1=, __lttf2@FUNCTION, $0, $1, $pop38, $pop37
	i32.const	$push36=, 0
	i32.lt_s	$5=, $pop1, $pop36
	i32.const	$push2=, 40
	i32.add 	$push3=, $7, $pop2
	i64.load	$push4=, 0($pop3)
	i64.select	$4=, $pop4, $1, $5
	i64.load	$push5=, 32($7)
	i64.select	$3=, $pop5, $0, $5
	block   	
	block   	
	block   	
	i64.const	$push35=, 0
	i64.const	$push34=, 4611404543450677248
	i32.call	$push6=, __getf2@FUNCTION, $3, $4, $pop35, $pop34
	i32.const	$push33=, 0
	i32.ge_s	$push7=, $pop6, $pop33
	br_if   	0, $pop7        # 0: down to label2
# %bb.1:                                # %if.else
	i64.const	$push41=, 0
	i64.const	$push40=, 0
	i32.call	$push14=, __eqtf2@FUNCTION, $3, $4, $pop41, $pop40
	i32.eqz 	$push55=, $pop14
	br_if   	1, $pop55       # 1: down to label1
# %bb.2:                                # %if.else
	i64.const	$0=, 4611404543450677248
	i64.const	$push43=, 0
	i64.const	$push42=, 4611404543450677248
	i32.call	$push15=, __lttf2@FUNCTION, $3, $4, $pop43, $pop42
	i32.const	$push16=, -1
	i32.gt_s	$push17=, $pop15, $pop16
	br_if   	1, $pop17       # 1: down to label1
# %bb.3:                                # %while.body11.preheader
	i32.const	$push19=, 8
	i32.add 	$5=, $7, $pop19
	i32.const	$6=, 0
	i64.const	$1=, 0
.LBB0_4:                                # %while.body11
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push44=, 10
	i32.ge_u	$push18=, $6, $pop44
	br_if   	3, $pop18       # 3: down to label0
# %bb.5:                                # %if.end15
                                        #   in Loop: Header=BB0_4 Depth=1
	i64.const	$push48=, 0
	i64.const	$push47=, 4611123068473966592
	call    	__multf3@FUNCTION, $7, $1, $0, $pop48, $pop47
	i64.load	$0=, 0($5)
	i64.load	$1=, 0($7)
	i32.const	$push46=, 1
	i32.add 	$6=, $6, $pop46
	i32.call	$push20=, __lttf2@FUNCTION, $3, $4, $1, $0
	i32.const	$push45=, 0
	i32.lt_s	$push21=, $pop20, $pop45
	br_if   	0, $pop21       # 0: up to label3
	br      	2               # 2: down to label1
.LBB0_6:                                # %if.then2
	end_loop
	end_block                       # label2:
	i64.const	$push51=, 0
	i64.const	$push50=, 4611404543450677248
	i32.call	$push8=, __gttf2@FUNCTION, $3, $4, $pop51, $pop50
	i32.const	$push49=, 1
	i32.lt_s	$push9=, $pop8, $pop49
	br_if   	0, $pop9        # 0: down to label1
# %bb.7:                                # %while.body.preheader
	i64.const	$0=, 4611404543450677248
	i64.const	$1=, 0
	i32.const	$push11=, 24
	i32.add 	$5=, $7, $pop11
	i32.const	$6=, 0
.LBB0_8:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push52=, 10
	i32.ge_u	$push10=, $6, $pop52
	br_if   	2, $pop10       # 2: down to label0
# %bb.9:                                # %if.end6
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.const	$push31=, 16
	i32.add 	$push32=, $7, $pop31
	call    	__addtf3@FUNCTION, $pop32, $1, $0, $1, $0
	i64.load	$0=, 0($5)
	i64.load	$1=, 16($7)
	i32.const	$push54=, 1
	i32.add 	$6=, $6, $pop54
	i32.call	$push12=, __lttf2@FUNCTION, $1, $0, $3, $4
	i32.const	$push53=, 0
	i32.lt_s	$push13=, $pop12, $pop53
	br_if   	0, $pop13       # 0: up to label4
.LBB0_10:                               # %if.end18
	end_loop
	end_block                       # label1:
	i32.store	0($2), $6
	i32.const	$push28=, 0
	i32.const	$push26=, 48
	i32.add 	$push27=, $7, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	return
.LBB0_11:                               # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
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
	i32.const	$push8=, 16
	i32.sub 	$0=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $0
	i64.const	$push1=, 0
	i64.const	$push0=, 4611826755915743232
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	call    	test@FUNCTION, $pop1, $pop0, $pop11
	i64.const	$push20=, 0
	i64.const	$push2=, 4611897124659920896
	i32.const	$push12=, 12
	i32.add 	$push13=, $0, $pop12
	call    	test@FUNCTION, $pop20, $pop2, $pop13
	i64.const	$push19=, 0
	i64.const	$push3=, 4611967493404098560
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	call    	test@FUNCTION, $pop19, $pop3, $pop15
	i64.const	$push18=, 0
	i64.const	$push4=, 4612037862148276224
	i32.const	$push16=, 12
	i32.add 	$push17=, $0, $pop16
	call    	test@FUNCTION, $pop18, $pop4, $pop17
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
