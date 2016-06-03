	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20466-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$5=, 0($0)
	i32.store	$drop=, 0($0), $2
	i32.load	$push0=, 0($4)
	i32.store	$drop=, 0($3), $pop0
	i32.load	$push1=, 0($1)
	i32.store	$drop=, 0($5), $pop1
	i32.load	$push2=, 0($0)
	i32.const	$push3=, 99
	i32.store	$drop=, 0($pop2), $pop3
	i32.const	$push4=, 3
                                        # fallthrough-return: $pop4
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
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 32
	i32.sub 	$push44=, $pop23, $pop24
	i32.store	$push46=, __stack_pointer($pop25), $pop44
	tee_local	$push45=, $1=, $pop46
	i32.const	$push4=, 42
	i32.store	$drop=, 28($pop45), $pop4
	i32.const	$push5=, 66
	i32.store	$0=, 24($1), $pop5
	i32.const	$push6=, 1
	i32.store	$drop=, 20($1), $pop6
	i32.const	$push7=, -1
	i32.store	$drop=, 16($1), $pop7
	i32.const	$push8=, 55
	i32.store	$drop=, 12($1), $pop8
	i32.const	$push26=, 28
	i32.add 	$push27=, $1, $pop26
	i32.store	$drop=, 8($1), $pop27
	i32.const	$push28=, 16
	i32.add 	$push29=, $1, $pop28
	i32.store	$drop=, 4($1), $pop29
	i32.const	$push30=, 12
	i32.add 	$push31=, $1, $pop30
	i32.store	$drop=, 0($1), $pop31
	i32.const	$push32=, 8
	i32.add 	$push33=, $1, $pop32
	i32.const	$push34=, 24
	i32.add 	$push35=, $1, $pop34
	i32.const	$push36=, 20
	i32.add 	$push37=, $1, $pop36
	i32.const	$push38=, 4
	i32.add 	$push39=, $1, $pop38
	i32.call	$drop=, f@FUNCTION, $pop33, $pop35, $pop37, $pop39, $1
	block
	i32.load	$push9=, 28($1)
	i32.ne  	$push10=, $0, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %entry
	i32.load	$push0=, 8($1)
	i32.const	$push40=, 20
	i32.add 	$push41=, $1, $pop40
	copy_local	$push1=, $pop41
	i32.ne  	$push11=, $pop0, $pop1
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %entry
	i32.load	$push2=, 20($1)
	i32.const	$push12=, 99
	i32.ne  	$push13=, $pop2, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#3:                                 # %entry
	i32.load	$push3=, 16($1)
	i32.const	$push14=, -1
	i32.ne  	$push15=, $pop3, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %lor.lhs.false6
	i32.load	$push17=, 4($1)
	i32.const	$push42=, 12
	i32.add 	$push43=, $1, $pop42
	i32.ne  	$push18=, $pop17, $pop43
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %lor.lhs.false6
	i32.load	$push16=, 12($1)
	i32.const	$push19=, 55
	i32.ne  	$push20=, $pop16, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#6:                                 # %if.end
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
