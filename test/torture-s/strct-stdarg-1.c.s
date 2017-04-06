	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-stdarg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push27=, 0
	i32.load	$push26=, __stack_pointer($pop27)
	i32.const	$push28=, 16
	i32.sub 	$push35=, $pop26, $pop28
	tee_local	$push34=, $4=, $pop35
	i32.store	__stack_pointer($pop29), $pop34
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push33=, 1
	i32.lt_s	$push3=, $0, $pop33
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push39=, 8
	i32.add 	$push38=, $1, $pop39
	tee_local	$push37=, $3=, $pop38
	i32.store	12($4), $pop37
	i32.const	$push36=, 10
	i32.add 	$push4=, $2, $pop36
	i32.load8_s	$push5=, 0($1)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	3, $pop6        # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push41=, 20
	i32.add 	$push10=, $2, $pop41
	i32.const	$push40=, 1
	i32.add 	$push11=, $1, $pop40
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push13=, $pop10, $pop12
	br_if   	3, $pop13       # 3: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push43=, 30
	i32.add 	$push14=, $2, $pop43
	i32.const	$push42=, 2
	i32.add 	$push9=, $1, $pop42
	i32.load8_s	$push0=, 0($pop9)
	i32.ne  	$push15=, $pop14, $pop0
	br_if   	3, $pop15       # 3: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push45=, 40
	i32.add 	$push16=, $2, $pop45
	i32.const	$push44=, 3
	i32.add 	$push8=, $1, $pop44
	i32.load8_s	$push1=, 0($pop8)
	i32.ne  	$push17=, $pop16, $pop1
	br_if   	3, $pop17       # 3: down to label0
# BB#6:                                 # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push47=, 50
	i32.add 	$push18=, $2, $pop47
	i32.const	$push46=, 4
	i32.add 	$push7=, $1, $pop46
	i32.load8_s	$push2=, 0($pop7)
	i32.ne  	$push19=, $pop18, $pop2
	br_if   	3, $pop19       # 3: down to label0
# BB#7:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$1=, $3
	i32.const	$push50=, 1
	i32.add 	$push49=, $2, $pop50
	tee_local	$push48=, $2=, $pop49
	i32.lt_s	$push20=, $pop48, $0
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
# BB#10:                                # %if.end34
	i32.const	$push32=, 0
	i32.const	$push30=, 16
	i32.add 	$push31=, $4, $pop30
	i32.store	__stack_pointer($pop32), $pop31
	return  	$1
.LBB0_11:                               # %if.then
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
	i32.const	$push27=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 64
	i32.sub 	$push45=, $pop24, $pop26
	tee_local	$push44=, $1=, $pop45
	i32.store	__stack_pointer($pop27), $pop44
	i32.const	$push0=, 60
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 10784
	i32.store16	0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $1, $pop3
	i32.const	$push5=, 369898281
	i32.store	0($pop4), $pop5
	i64.const	$push6=, 2239708699736019978
	i64.store	48($1), $pop6
	i32.const	$push28=, 40
	i32.add 	$push29=, $1, $pop28
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop29, $pop7
	i32.load8_u	$push9=, 52($1)
	i32.store8	0($pop8), $pop9
	i32.const	$push10=, 62
	i32.add 	$push43=, $1, $pop10
	tee_local	$push42=, $0=, $pop43
	i32.const	$push11=, 52
	i32.store8	0($pop42), $pop11
	i32.const	$push30=, 32
	i32.add 	$push31=, $1, $pop30
	i32.const	$push41=, 4
	i32.add 	$push12=, $pop31, $pop41
	i32.const	$push13=, 57
	i32.add 	$push14=, $1, $pop13
	i32.load8_u	$push15=, 0($pop14)
	i32.store8	0($pop12), $pop15
	i32.const	$push32=, 24
	i32.add 	$push33=, $1, $pop32
	i32.const	$push40=, 4
	i32.add 	$push16=, $pop33, $pop40
	i32.load8_u	$push17=, 0($0)
	i32.store8	0($pop16), $pop17
	i32.load	$push18=, 48($1)
	i32.store	40($1), $pop18
	i32.load	$push19=, 53($1):p2align=0
	i32.store	32($1), $pop19
	i32.load	$push20=, 58($1):p2align=1
	i32.store	24($1), $pop20
	i32.const	$push21=, 123
	i32.store	12($1), $pop21
	i32.const	$push34=, 40
	i32.add 	$push35=, $1, $pop34
	i32.store	0($1), $pop35
	i32.const	$push36=, 24
	i32.add 	$push37=, $1, $pop36
	i32.store	8($1), $pop37
	i32.const	$push38=, 32
	i32.add 	$push39=, $1, $pop38
	i32.store	4($1), $pop39
	i32.const	$push22=, 3
	i32.call	$drop=, f@FUNCTION, $pop22, $1
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
