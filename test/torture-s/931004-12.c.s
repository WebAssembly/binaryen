	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 16
	i32.sub 	$push28=, $pop18, $pop20
	tee_local	$push27=, $3=, $pop28
	i32.store	__stack_pointer($pop21), $pop27
	i32.store	12($3), $1
	i32.const	$push26=, 4
	i32.add 	$push1=, $1, $pop26
	i32.store	12($3), $pop1
	block   	
	block   	
	i32.const	$push25=, 1
	i32.lt_s	$push2=, $0, $pop25
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push29=, 10
	i32.add 	$push3=, $2, $pop29
	i32.load8_s	$push4=, 0($1)
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	2, $pop5        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push31=, 20
	i32.add 	$push7=, $2, $pop31
	i32.const	$push30=, 1
	i32.add 	$push8=, $1, $pop30
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop7, $pop9
	br_if   	2, $pop10       # 2: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push33=, 30
	i32.add 	$push11=, $2, $pop33
	i32.const	$push32=, 2
	i32.add 	$push6=, $1, $pop32
	i32.load8_s	$push0=, 0($pop6)
	i32.ne  	$push12=, $pop11, $pop0
	br_if   	2, $pop12       # 2: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push38=, 8
	i32.add 	$push13=, $1, $pop38
	i32.store	12($3), $pop13
	i32.const	$push37=, 4
	i32.add 	$1=, $1, $pop37
	i32.const	$push36=, 1
	i32.add 	$push35=, $2, $pop36
	tee_local	$push34=, $2=, $pop35
	i32.lt_s	$push14=, $pop34, $0
	br_if   	0, $pop14       # 0: up to label2
.LBB0_6:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push15=, 0($1)
	i32.const	$push16=, 123
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#7:                                 # %if.end22
	i32.const	$push24=, 0
	i32.const	$push22=, 16
	i32.add 	$push23=, $3, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	return  	$1
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push17=, 0
	i32.load	$push16=, __stack_pointer($pop17)
	i32.const	$push18=, 48
	i32.sub 	$push37=, $pop16, $pop18
	tee_local	$push36=, $1=, $pop37
	i32.store	__stack_pointer($pop19), $pop36
	i64.const	$push0=, 1588678943796237322
	i64.store	32($1), $pop0
	i32.const	$push20=, 28
	i32.add 	$push21=, $1, $pop20
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop21, $pop1
	i32.load8_u	$push3=, 34($1)
	i32.store8	0($pop2), $pop3
	i32.const	$push4=, 40
	i32.add 	$push35=, $1, $pop4
	tee_local	$push34=, $0=, $pop35
	i32.const	$push5=, 32
	i32.store8	0($pop34), $pop5
	i32.const	$push22=, 24
	i32.add 	$push23=, $1, $pop22
	i32.const	$push33=, 2
	i32.add 	$push6=, $pop23, $pop33
	i32.load8_u	$push7=, 37($1)
	i32.store8	0($pop6), $pop7
	i32.const	$push24=, 20
	i32.add 	$push25=, $1, $pop24
	i32.const	$push32=, 2
	i32.add 	$push8=, $pop25, $pop32
	i32.load8_u	$push9=, 0($0)
	i32.store8	0($pop8), $pop9
	i32.load16_u	$push10=, 32($1)
	i32.store16	28($1), $pop10
	i32.load16_u	$push11=, 35($1):p2align=0
	i32.store16	24($1), $pop11
	i32.load16_u	$push12=, 38($1)
	i32.store16	20($1), $pop12
	i32.const	$push13=, 123
	i32.store	12($1), $pop13
	i32.const	$push26=, 20
	i32.add 	$push27=, $1, $pop26
	i32.store	8($1), $pop27
	i32.const	$push28=, 24
	i32.add 	$push29=, $1, $pop28
	i32.store	4($1), $pop29
	i32.const	$push30=, 28
	i32.add 	$push31=, $1, $pop30
	i32.store	0($1), $pop31
	i32.const	$push14=, 3
	i32.call	$drop=, f@FUNCTION, $pop14, $1
	i32.const	$push15=, 0
	call    	exit@FUNCTION, $pop15
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
