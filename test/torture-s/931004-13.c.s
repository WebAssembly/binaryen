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
	i32.const	$push22=, __stack_pointer
	i32.load	$push23=, 0($pop22)
	i32.const	$push24=, 32
	i32.sub 	$1=, $pop23, $pop24
	i32.const	$push25=, __stack_pointer
	i32.store	$discard=, 0($pop25), $1
	i32.const	$push26=, 16
	i32.add 	$push27=, $1, $pop26
	i32.const	$push5=, 9
	i32.add 	$push6=, $pop27, $pop5
	i32.const	$push7=, 22
	i32.store8	$discard=, 0($pop6), $pop7
	i32.const	$push28=, 16
	i32.add 	$push29=, $1, $pop28
	i32.const	$push10=, 10
	i32.add 	$push11=, $pop29, $pop10
	i32.const	$push12=, 32
	i32.store8	$discard=, 0($pop11):p2align=1, $pop12
	i32.const	$push30=, 16
	i32.add 	$push31=, $1, $pop30
	i32.const	$push1=, 11
	i32.store8	$push2=, 20($1):p2align=2, $pop1
	i32.add 	$push15=, $pop31, $pop2
	i32.const	$push16=, 42
	i32.store8	$discard=, 0($pop15), $pop16
	i32.const	$push0=, 5130
	i32.store16	$discard=, 16($1):p2align=3, $pop0
	i32.const	$push3=, 12
	i32.store8	$discard=, 24($1):p2align=3, $pop3
	i32.const	$push4=, 21
	i32.store8	$discard=, 21($1), $pop4
	i32.const	$push8=, 30
	i32.store8	$discard=, 18($1):p2align=1, $pop8
	i32.const	$push9=, 31
	i32.store8	$discard=, 22($1):p2align=1, $pop9
	i32.const	$push13=, 40
	i32.store8	$discard=, 19($1), $pop13
	i32.const	$push14=, 41
	i32.store8	$discard=, 23($1), $pop14
	i32.load	$push17=, 16($1):p2align=3
	i32.store	$discard=, 12($1), $pop17
	i32.load	$push18=, 20($1)
	i32.store	$discard=, 8($1), $pop18
	i32.load	$push19=, 24($1):p2align=3
	i32.store	$discard=, 4($1), $pop19
	i32.const	$push32=, 12
	i32.add 	$push33=, $1, $pop32
	i32.const	$push34=, 8
	i32.add 	$push35=, $1, $pop34
	i32.const	$push36=, 4
	i32.add 	$push37=, $1, $pop36
	i32.const	$push20=, 123
	i32.call	$discard=, f@FUNCTION, $0, $pop33, $pop35, $pop37, $pop20
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
