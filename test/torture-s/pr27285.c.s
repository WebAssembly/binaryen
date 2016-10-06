	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27285.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load8_u	$push8=, 1($0)
	tee_local	$push7=, $3=, $pop8
	i32.eqz 	$push22=, $pop7
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push0=, 3
	i32.add 	$1=, $1, $pop0
	i32.const	$push9=, 3
	i32.add 	$0=, $0, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load8_u	$push4=, 0($0)
	i32.const	$push21=, 255
	i32.const	$push20=, 255
	i32.const	$push19=, 8
	i32.sub 	$push1=, $pop19, $3
	i32.shl 	$push2=, $pop20, $pop1
	i32.const	$push18=, 7
	i32.gt_s	$push17=, $3, $pop18
	tee_local	$push16=, $2=, $pop17
	i32.select	$push3=, $pop21, $pop2, $pop16
	i32.and 	$push5=, $pop4, $pop3
	i32.store8	0($1), $pop5
	i32.const	$push15=, 1
	i32.add 	$1=, $1, $pop15
	i32.const	$push14=, 1
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, -8
	i32.add 	$push6=, $3, $pop13
	i32.const	$push12=, 0
	i32.select	$push11=, $pop6, $pop12, $2
	tee_local	$push10=, $3=, $pop11
	br_if   	0, $pop10       # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push31=, 0
	i32.const	$push28=, 0
	i32.load	$push29=, __stack_pointer($pop28)
	i32.const	$push30=, 48
	i32.sub 	$push53=, $pop29, $pop30
	tee_local	$push52=, $0=, $pop53
	i32.store	__stack_pointer($pop31), $pop52
	i32.const	$push35=, 24
	i32.add 	$push36=, $0, $pop35
	i32.const	$push2=, 18
	i32.add 	$push3=, $pop36, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.x+18($pop0)
	i32.store8	0($pop3), $pop1
	i32.const	$push37=, 24
	i32.add 	$push38=, $0, $pop37
	i32.const	$push5=, 16
	i32.add 	$push6=, $pop38, $pop5
	i32.const	$push51=, 0
	i32.load16_u	$push4=, .Lmain.x+16($pop51):p2align=0
	i32.store16	0($pop6), $pop4
	i32.const	$push39=, 24
	i32.add 	$push40=, $0, $pop39
	i32.const	$push8=, 8
	i32.add 	$push9=, $pop40, $pop8
	i32.const	$push50=, 0
	i64.load	$push7=, .Lmain.x+8($pop50):p2align=0
	i64.store	0($pop9), $pop7
	i32.const	$push49=, 0
	i64.load	$push10=, .Lmain.x($pop49):p2align=0
	i64.store	24($0), $pop10
	i32.const	$push48=, 18
	i32.add 	$push11=, $0, $pop48
	i32.const	$push47=, 0
	i32.store8	0($pop11), $pop47
	i32.const	$push46=, 16
	i32.add 	$push12=, $0, $pop46
	i32.const	$push45=, 0
	i32.store16	0($pop12), $pop45
	i32.const	$push44=, 8
	i32.add 	$push13=, $0, $pop44
	i64.const	$push14=, 0
	i64.store	0($pop13), $pop14
	i64.const	$push43=, 0
	i64.store	0($0), $pop43
	i32.const	$push41=, 24
	i32.add 	$push42=, $0, $pop41
	call    	foo@FUNCTION, $pop42, $0
	block   	
	i32.load8_u	$push16=, 3($0)
	i32.const	$push15=, 170
	i32.ne  	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label2
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push19=, 4($0)
	i32.const	$push18=, 187
	i32.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label2
# BB#2:                                 # %lor.lhs.false13
	i32.load8_u	$push22=, 5($0)
	i32.const	$push21=, 204
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label2
# BB#3:                                 # %lor.lhs.false22
	i32.load8_u	$push25=, 6($0)
	i32.const	$push24=, 128
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push34=, 0
	i32.const	$push32=, 48
	i32.add 	$push33=, $0, $pop32
	i32.store	__stack_pointer($pop34), $pop33
	i32.const	$push27=, 0
	return  	$pop27
.LBB1_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.x,@object        # @main.x
	.section	.rodata..Lmain.x,"a",@progbits
.Lmain.x:
	.int8	0                       # 0x0
	.int8	25                      # 0x19
	.int8	0                       # 0x0
	.asciz	"\252\273\314\335\000\000\000\000\000\000\000\000\000\000\000"
	.size	.Lmain.x, 19


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
