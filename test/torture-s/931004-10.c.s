	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-10.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 16
	i32.sub 	$push24=, $pop14, $pop16
	tee_local	$push23=, $4=, $pop24
	i32.store	__stack_pointer($pop17), $pop23
	i32.store	12($4), $1
	i32.const	$push22=, 4
	i32.add 	$push1=, $1, $pop22
	i32.store	12($4), $pop1
	block   	
	block   	
	i32.const	$push21=, 1
	i32.lt_s	$push2=, $0, $pop21
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load8_s	$push3=, 0($1)
	i32.ne  	$push4=, $2, $pop3
	br_if   	2, $pop4        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push26=, 10
	i32.add 	$push5=, $2, $pop26
	i32.const	$push25=, 1
	i32.add 	$push6=, $1, $pop25
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	2, $pop8        # 2: down to label0
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 8
	i32.add 	$push9=, $1, $pop30
	i32.store	12($4), $pop9
	i32.const	$push29=, 4
	i32.add 	$1=, $1, $pop29
	i32.const	$push28=, -9
	i32.add 	$3=, $2, $pop28
	i32.const	$push27=, 1
	i32.add 	$push0=, $2, $pop27
	copy_local	$2=, $pop0
	i32.lt_s	$push10=, $3, $0
	br_if   	0, $pop10       # 0: up to label2
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 123
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#6:                                 # %if.end16
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return  	$1
.LBB0_7:                                # %if.then
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 32
	i32.sub 	$push20=, $pop9, $pop11
	tee_local	$push19=, $0=, $pop20
	i32.store	__stack_pointer($pop12), $pop19
	i32.const	$push0=, 12
	i32.store8	28($0), $pop0
	i32.const	$push1=, 353047562
	i32.store	24($0), $pop1
	i32.const	$push2=, 22
	i32.store8	29($0), $pop2
	i32.load16_u	$push3=, 24($0)
	i32.store16	22($0), $pop3
	i32.load16_u	$push4=, 26($0)
	i32.store16	20($0), $pop4
	i32.load16_u	$push5=, 28($0)
	i32.store16	18($0), $pop5
	i32.const	$push6=, 123
	i32.store	12($0), $pop6
	i32.const	$push13=, 18
	i32.add 	$push14=, $0, $pop13
	i32.store	8($0), $pop14
	i32.const	$push15=, 20
	i32.add 	$push16=, $0, $pop15
	i32.store	4($0), $pop16
	i32.const	$push17=, 22
	i32.add 	$push18=, $0, $pop17
	i32.store	0($0), $pop18
	i32.const	$push7=, 3
	i32.call	$drop=, f@FUNCTION, $pop7, $0
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
