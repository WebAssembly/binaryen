	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980608-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push28=, 0
	i32.const	$push25=, 0
	i32.load	$push26=, __stack_pointer($pop25)
	i32.const	$push27=, 16
	i32.sub 	$push35=, $pop26, $pop27
	tee_local	$push34=, $4=, $pop35
	i32.store	__stack_pointer($pop28), $pop34
	i32.store	12($4), $1
	i32.const	$push0=, 4
	i32.add 	$push33=, $1, $pop0
	tee_local	$push32=, $2=, $pop33
	i32.store	12($4), $pop32
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 101
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 8
	i32.add 	$push37=, $1, $pop4
	tee_local	$push36=, $3=, $pop37
	i32.store	12($4), $pop36
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 102
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 12
	i32.add 	$push39=, $1, $pop8
	tee_local	$push38=, $2=, $pop39
	i32.store	12($4), $pop38
	i32.load	$push9=, 0($3)
	i32.const	$push10=, 103
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push12=, 16
	i32.add 	$push41=, $1, $pop12
	tee_local	$push40=, $3=, $pop41
	i32.store	12($4), $pop40
	i32.load	$push13=, 0($2)
	i32.const	$push14=, 104
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push16=, 20
	i32.add 	$push43=, $1, $pop16
	tee_local	$push42=, $2=, $pop43
	i32.store	12($4), $pop42
	i32.load	$push17=, 0($3)
	i32.const	$push18=, 105
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push20=, 24
	i32.add 	$push21=, $1, $pop20
	i32.store	12($4), $pop21
	i32.load	$push22=, 0($2)
	i32.const	$push23=, 106
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push31=, 0
	i32.const	$push29=, 16
	i32.add 	$push30=, $4, $pop29
	i32.store	__stack_pointer($pop31), $pop30
	return
.LBB1_7:                                # %if.then25
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	debug, .Lfunc_end1-debug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push11=, $pop7, $pop8
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop9), $pop10
	i32.const	$push0=, 16
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 455266533481
	i64.store	0($pop1), $pop2
	i64.const	$push3=, 446676598887
	i64.store	8($0), $pop3
	i64.const	$push4=, 438086664293
	i64.store	0($0), $pop4
	call    	debug@FUNCTION, $0, $0
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
