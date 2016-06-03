	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980608-1.c"
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
	i32.const	$push33=, 0
	i32.const	$push30=, 0
	i32.load	$push31=, __stack_pointer($pop30)
	i32.const	$push32=, 16
	i32.sub 	$push37=, $pop31, $pop32
	i32.store	$push41=, __stack_pointer($pop33), $pop37
	tee_local	$push40=, $4=, $pop41
	i32.store	$push39=, 12($4), $1
	tee_local	$push38=, $1=, $pop39
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop38, $pop0
	i32.store	$2=, 12($pop40), $pop1
	block
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 101
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	$3=, 12($4), $pop6
	i32.load	$push7=, 0($2)
	i32.const	$push8=, 102
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push10=, 12
	i32.add 	$push11=, $1, $pop10
	i32.store	$2=, 12($4), $pop11
	i32.load	$push12=, 0($3)
	i32.const	$push13=, 103
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push15=, 16
	i32.add 	$push16=, $1, $pop15
	i32.store	$3=, 12($4), $pop16
	i32.load	$push17=, 0($2)
	i32.const	$push18=, 104
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push20=, 20
	i32.add 	$push21=, $1, $pop20
	i32.store	$2=, 12($4), $pop21
	i32.load	$push22=, 0($3)
	i32.const	$push23=, 105
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push25=, 24
	i32.add 	$push26=, $1, $pop25
	i32.store	$drop=, 12($4), $pop26
	i32.load	$push27=, 0($2)
	i32.const	$push28=, 106
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push36=, 0
	i32.const	$push34=, 16
	i32.add 	$push35=, $4, $pop34
	i32.store	$drop=, __stack_pointer($pop36), $pop35
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
	i32.sub 	$push10=, $pop7, $pop8
	i32.store	$push12=, __stack_pointer($pop9), $pop10
	tee_local	$push11=, $0=, $pop12
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop11, $pop0
	i64.const	$push2=, 455266533481
	i64.store	$drop=, 0($pop1), $pop2
	i64.const	$push3=, 446676598887
	i64.store	$drop=, 8($0), $pop3
	i64.const	$push4=, 438086664293
	i64.store	$drop=, 0($0), $pop4
	call    	debug@FUNCTION, $0, $0
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
