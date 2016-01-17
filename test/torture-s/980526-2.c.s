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
	br_if   	$pop1, 0        # 0: down to label0
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 5
	i32.const	$2=, 3
	i32.const	$push25=, 13
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push7=, 7
	i32.mul 	$push8=, $0, $pop7
	i32.add 	$push9=, $pop8, $2
	i32.shl 	$push10=, $0, $2
	i32.const	$push11=, 4
	i32.or  	$push12=, $pop10, $pop11
	i32.mul 	$push28=, $pop9, $pop12
	i32.add 	$push31=, $pop26, $pop28
	i32.mul 	$push0=, $0, $1
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, 6
	i32.mul 	$push4=, $0, $pop3
	i32.const	$push5=, 2
	i32.add 	$push6=, $pop4, $pop5
	i32.mul 	$push27=, $pop2, $pop6
	i32.add 	$push32=, $pop31, $pop27
	i32.const	$push13=, 9
	i32.mul 	$push14=, $0, $pop13
	i32.add 	$push15=, $pop14, $1
	i32.const	$push16=, 10
	i32.mul 	$push17=, $0, $pop16
	i32.add 	$push18=, $pop17, $1
	i32.mul 	$push29=, $pop15, $pop18
	i32.add 	$push33=, $pop32, $pop29
	i32.const	$push19=, 11
	i32.mul 	$push20=, $0, $pop19
	i32.add 	$push21=, $pop20, $1
	i32.const	$push22=, 12
	i32.mul 	$push23=, $0, $pop22
	i32.add 	$push24=, $pop23, $1
	i32.mul 	$push30=, $pop21, $pop24
	i32.add 	$push34=, $pop33, $pop30
	i32.add 	$push35=, $pop34, $1
	return  	$pop35
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
	block
	i32.const	$push0=, 14
	i32.shl 	$push1=, $2, $pop0
	i32.const	$push2=, -4194304
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 255
	i32.and 	$push5=, $2, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.const	$push7=, 360710264
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB2_2:                                # %if.else.i
	end_block                       # label1:
	call    	abort@FUNCTION
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
