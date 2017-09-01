	.text
	.file	"20020413-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i64, i64, i32
	.local  	i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push22=, 0
	i32.load	$push21=, __stack_pointer($pop22)
	i32.const	$push23=, 48
	i32.sub 	$push46=, $pop21, $pop23
	tee_local	$push45=, $7=, $pop46
	i32.store	__stack_pointer($pop24), $pop45
	i32.const	$push28=, 32
	i32.add 	$push29=, $7, $pop28
	i64.const	$push44=, 0
	i64.const	$push0=, -9223372036854775808
	call    	__subtf3@FUNCTION, $pop29, $pop44, $pop0, $0, $1
	i64.const	$push43=, 0
	i64.const	$push42=, 0
	i32.call	$5=, __lttf2@FUNCTION, $0, $1, $pop43, $pop42
	i32.const	$6=, 0
	block   	
	block   	
	block   	
	i64.load	$push4=, 32($7)
	i32.const	$push41=, 0
	i32.lt_s	$push40=, $5, $pop41
	tee_local	$push39=, $5=, $pop40
	i64.select	$push38=, $pop4, $0, $pop39
	tee_local	$push37=, $3=, $pop38
	i32.const	$push1=, 40
	i32.add 	$push2=, $7, $pop1
	i64.load	$push3=, 0($pop2)
	i64.select	$push36=, $pop3, $1, $5
	tee_local	$push35=, $4=, $pop36
	i64.const	$push34=, 0
	i64.const	$push33=, 4611404543450677248
	i32.call	$push5=, __getf2@FUNCTION, $pop37, $pop35, $pop34, $pop33
	i32.const	$push32=, 0
	i32.ge_s	$push6=, $pop5, $pop32
	br_if   	0, $pop6        # 0: down to label2
# BB#1:                                 # %if.else
	i64.const	$push48=, 0
	i64.const	$push47=, 0
	i32.call	$push13=, __eqtf2@FUNCTION, $3, $4, $pop48, $pop47
	i32.eqz 	$push70=, $pop13
	br_if   	1, $pop70       # 1: down to label1
# BB#2:                                 # %if.else
	i64.const	$0=, 4611404543450677248
	i64.const	$push50=, 0
	i64.const	$push49=, 4611404543450677248
	i32.call	$push14=, __lttf2@FUNCTION, $3, $4, $pop50, $pop49
	i32.const	$push15=, -1
	i32.gt_s	$push16=, $pop14, $pop15
	br_if   	1, $pop16       # 1: down to label1
# BB#3:                                 # %while.body11.preheader
	i32.const	$push18=, 8
	i32.add 	$5=, $7, $pop18
	i32.const	$6=, 0
	i64.const	$1=, 0
.LBB0_4:                                # %while.body11
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push51=, 10
	i32.ge_u	$push17=, $6, $pop51
	br_if   	3, $pop17       # 3: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_4 Depth=1
	i64.const	$push59=, 0
	i64.const	$push58=, 4611123068473966592
	call    	__multf3@FUNCTION, $7, $1, $0, $pop59, $pop58
	i32.const	$push57=, 1
	i32.add 	$6=, $6, $pop57
	i64.load	$push56=, 0($7)
	tee_local	$push55=, $1=, $pop56
	i64.load	$push54=, 0($5)
	tee_local	$push53=, $0=, $pop54
	i32.call	$push19=, __lttf2@FUNCTION, $3, $4, $pop55, $pop53
	i32.const	$push52=, 0
	i32.lt_s	$push20=, $pop19, $pop52
	br_if   	0, $pop20       # 0: up to label3
	br      	2               # 2: down to label1
.LBB0_6:                                # %if.then2
	end_loop
	end_block                       # label2:
	i64.const	$push62=, 0
	i64.const	$push61=, 4611404543450677248
	i32.call	$push7=, __gttf2@FUNCTION, $3, $4, $pop62, $pop61
	i32.const	$push60=, 1
	i32.lt_s	$push8=, $pop7, $pop60
	br_if   	0, $pop8        # 0: down to label1
# BB#7:                                 # %while.body.preheader
	i64.const	$0=, 4611404543450677248
	i64.const	$1=, 0
	i32.const	$push10=, 24
	i32.add 	$5=, $7, $pop10
	i32.const	$6=, 0
.LBB0_8:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push63=, 10
	i32.ge_u	$push9=, $6, $pop63
	br_if   	2, $pop9        # 2: down to label0
# BB#9:                                 # %if.end6
                                        #   in Loop: Header=BB0_8 Depth=1
	i32.const	$push30=, 16
	i32.add 	$push31=, $7, $pop30
	call    	__addtf3@FUNCTION, $pop31, $1, $0, $1, $0
	i32.const	$push69=, 1
	i32.add 	$6=, $6, $pop69
	i64.load	$push68=, 16($7)
	tee_local	$push67=, $1=, $pop68
	i64.load	$push66=, 0($5)
	tee_local	$push65=, $0=, $pop66
	i32.call	$push11=, __lttf2@FUNCTION, $pop67, $pop65, $3, $4
	i32.const	$push64=, 0
	i32.lt_s	$push12=, $pop11, $pop64
	br_if   	0, $pop12       # 0: up to label4
.LBB0_10:                               # %if.end18
	end_loop
	end_block                       # label1:
	i32.store	0($2), $6
	i32.const	$push27=, 0
	i32.const	$push25=, 48
	i32.add 	$push26=, $7, $pop25
	i32.store	__stack_pointer($pop27), $pop26
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
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$push22=, $pop6, $pop8
	tee_local	$push21=, $0=, $pop22
	i32.store	__stack_pointer($pop9), $pop21
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

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
