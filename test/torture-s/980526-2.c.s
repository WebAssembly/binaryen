	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980526-2.c"
	.section	.text.do_mknod,"ax",@progbits
	.hidden	do_mknod
	.globl	do_mknod
	.type	do_mknod,@function
do_mknod:                               # @do_mknod
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 360710264
	i32.ne  	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	do_mknod, .Lfunc_end0-do_mknod

	.section	.text.getname,"ax",@progbits
	.hidden	getname
	.globl	getname
	.type	getname,@function
getname:                                # @getname
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 13
	i32.mul 	$push28=, $0, $pop27
	i32.const	$push8=, 7
	i32.mul 	$push9=, $0, $pop8
	i32.const	$push10=, 3
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push43=, 3
	i32.shl 	$push12=, $0, $pop43
	i32.const	$push13=, 4
	i32.or  	$push14=, $pop12, $pop13
	i32.mul 	$push30=, $pop11, $pop14
	i32.add 	$push33=, $pop28, $pop30
	i32.const	$push0=, 5
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 6
	i32.mul 	$push5=, $0, $pop4
	i32.const	$push6=, 2
	i32.add 	$push7=, $pop5, $pop6
	i32.mul 	$push29=, $pop3, $pop7
	i32.add 	$push34=, $pop33, $pop29
	i32.const	$push15=, 9
	i32.mul 	$push16=, $0, $pop15
	i32.const	$push42=, 5
	i32.add 	$push17=, $pop16, $pop42
	i32.const	$push18=, 10
	i32.mul 	$push19=, $0, $pop18
	i32.const	$push41=, 5
	i32.add 	$push20=, $pop19, $pop41
	i32.mul 	$push31=, $pop17, $pop20
	i32.add 	$push35=, $pop34, $pop31
	i32.const	$push21=, 11
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push40=, 5
	i32.add 	$push23=, $pop22, $pop40
	i32.const	$push24=, 12
	i32.mul 	$push25=, $0, $pop24
	i32.const	$push39=, 5
	i32.add 	$push26=, $pop25, $pop39
	i32.mul 	$push32=, $pop23, $pop26
	i32.add 	$push36=, $pop35, $pop32
	i32.const	$push38=, 5
	i32.add 	$push37=, $pop36, $pop38
	return  	$pop37
	.endfunc
.Lfunc_end1:
	.size	getname, .Lfunc_end1-getname

	.section	.text.sys_mknod,"ax",@progbits
	.hidden	sys_mknod
	.globl	sys_mknod
	.type	sys_mknod,@function
sys_mknod:                              # @sys_mknod
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 14
	i32.shl 	$push1=, $2, $pop0
	i32.const	$push2=, -4194304
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 255
	i32.and 	$push5=, $2, $pop4
	i32.or  	$push6=, $pop3, $pop5
	call    	do_mknod@FUNCTION, $2, $2, $pop6
	unreachable
	.endfunc
.Lfunc_end2:
	.size	sys_mknod, .Lfunc_end2-sys_mknod

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	i32.const	$push1=, 305419896
	i32.call	$discard=, sys_mknod@FUNCTION, $pop0, $0, $pop1
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"test"
	.size	.L.str, 5


	.ident	"clang version 3.9.0 "
