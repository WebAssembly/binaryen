	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020227-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
# BB#0:                                 # %f2.exit
	return
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 8
	i32.const	$2=, 16
	block
	i32.const	$push1=, 4
	i32.add 	$push2=, $0, $pop1
	i32.load8_u	$push3=, 0($pop2)
	i32.shl 	$push4=, $pop3, $1
	i32.const	$push5=, 3
	i32.add 	$push6=, $0, $pop5
	i32.load8_u	$push7=, 0($pop6)
	i32.or  	$push8=, $pop4, $pop7
	i32.shl 	$push9=, $pop8, $2
	i32.const	$push10=, 2
	i32.add 	$push11=, $0, $pop10
	i32.load8_u	$push12=, 0($pop11)
	i32.shl 	$push13=, $pop12, $1
	i32.load8_u	$push14=, 1($0)
	i32.or  	$push15=, $pop13, $pop14
	i32.or  	$push16=, $pop9, $pop15
	f32.reinterpret/i32	$push17=, $pop16
	f32.const	$push35=, 0x1p0
	f32.ne  	$push36=, $pop17, $pop35
	br_if   	$pop36, 0       # 0: down to label0
# BB#1:                                 # %entry
	i32.add 	$push26=, $0, $1
	i32.load8_u	$push27=, 0($pop26)
	i32.shl 	$push28=, $pop27, $1
	i32.const	$push29=, 7
	i32.add 	$push30=, $0, $pop29
	i32.load8_u	$push31=, 0($pop30)
	i32.or  	$push32=, $pop28, $pop31
	i32.shl 	$push33=, $pop32, $2
	i32.const	$push20=, 6
	i32.add 	$push21=, $0, $pop20
	i32.load8_u	$push22=, 0($pop21)
	i32.shl 	$push23=, $pop22, $1
	i32.const	$push18=, 5
	i32.add 	$push19=, $0, $pop18
	i32.load8_u	$push24=, 0($pop19)
	i32.or  	$push25=, $pop23, $pop24
	i32.or  	$push34=, $pop33, $pop25
	f32.reinterpret/i32	$push0=, $pop34
	f32.const	$push37=, 0x0p0
	f32.ne  	$push38=, $pop0, $pop37
	br_if   	$pop38, 0       # 0: down to label0
# BB#2:                                 # %lor.lhs.false
	i32.load8_u	$push39=, 0($0)
	i32.const	$push40=, 42
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	$pop41, 0       # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB2_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2


	.ident	"clang version 3.9.0 "
