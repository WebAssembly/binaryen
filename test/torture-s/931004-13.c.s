	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-13.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.load8_u	$push0=, 0($1)
	i32.const	$push1=, 10
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 1($1)
	i32.const	$push4=, 20
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 2($1)
	i32.const	$push7=, 30
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end11
	i32.load8_u	$push9=, 3($1)
	i32.const	$push10=, 40
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.load8_u	$push12=, 0($2)
	i32.const	$push13=, 11
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end22
	i32.load8_u	$push15=, 1($2)
	i32.const	$push16=, 21
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end28
	i32.load8_u	$push18=, 2($2)
	i32.const	$push19=, 31
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#7:                                 # %if.end34
	i32.load8_u	$push21=, 3($2)
	i32.const	$push22=, 41
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#8:                                 # %if.end40
	i32.load8_u	$push24=, 0($3)
	i32.const	$push25=, 12
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label0
# BB#9:                                 # %if.end46
	i32.load8_u	$push27=, 1($3)
	i32.const	$push28=, 22
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#10:                                # %if.end52
	i32.load8_u	$push30=, 2($3)
	i32.const	$push31=, 32
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# BB#11:                                # %if.end58
	i32.load8_u	$push33=, 3($3)
	i32.const	$push34=, 42
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#12:                                # %if.end64
	i32.const	$push36=, 123
	i32.ne  	$push37=, $4, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#13:                                # %if.end68
	return  	$1
.LBB0_14:                               # %if.then67
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
	i32.const	$push24=, 0
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 32
	i32.sub 	$push33=, $pop22, $pop23
	i32.store	$push35=, __stack_pointer($pop24), $pop33
	tee_local	$push34=, $1=, $pop35
	i32.const	$push0=, 25
	i32.add 	$push1=, $pop34, $pop0
	i32.const	$push2=, 22
	i32.store8	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 12
	i32.store8	$drop=, 24($1), $pop3
	i32.const	$push4=, 5130
	i32.store16	$drop=, 16($1), $pop4
	i32.const	$push5=, 21
	i32.store8	$drop=, 21($1), $pop5
	i32.const	$push6=, 30
	i32.store8	$drop=, 18($1), $pop6
	i32.const	$push7=, 11
	i32.store8	$0=, 20($1), $pop7
	i32.const	$push8=, 31
	i32.store8	$drop=, 22($1), $pop8
	i32.const	$push9=, 26
	i32.add 	$push10=, $1, $pop9
	i32.const	$push11=, 32
	i32.store8	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 40
	i32.store8	$drop=, 19($1), $pop12
	i32.const	$push13=, 41
	i32.store8	$drop=, 23($1), $pop13
	i32.const	$push25=, 16
	i32.add 	$push26=, $1, $pop25
	i32.add 	$push14=, $0, $pop26
	i32.const	$push15=, 42
	i32.store8	$drop=, 0($pop14), $pop15
	i32.load	$push16=, 16($1)
	i32.store	$drop=, 12($1), $pop16
	i32.load	$push17=, 20($1)
	i32.store	$drop=, 8($1), $pop17
	i32.load	$push18=, 24($1)
	i32.store	$drop=, 4($1), $pop18
	i32.const	$push27=, 12
	i32.add 	$push28=, $1, $pop27
	i32.const	$push29=, 8
	i32.add 	$push30=, $1, $pop29
	i32.const	$push31=, 4
	i32.add 	$push32=, $1, $pop31
	i32.const	$push19=, 123
	i32.call	$drop=, f@FUNCTION, $1, $pop28, $pop30, $pop32, $pop19
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
