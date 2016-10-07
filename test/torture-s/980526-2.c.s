	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980526-2.c"
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
	i32.const	$push17=, 13
	i32.mul 	$push18=, $0, $pop17
	i32.const	$push13=, 7
	i32.mul 	$push14=, $0, $pop13
	i32.const	$push9=, 3
	i32.add 	$push15=, $pop14, $pop9
	i32.const	$push43=, 3
	i32.shl 	$push10=, $0, $pop43
	i32.const	$push11=, 4
	i32.or  	$push12=, $pop10, $pop11
	i32.mul 	$push16=, $pop15, $pop12
	i32.add 	$push19=, $pop18, $pop16
	i32.const	$push4=, 5
	i32.mul 	$push5=, $0, $pop4
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push0=, 6
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.add 	$push3=, $pop1, $pop2
	i32.mul 	$push8=, $pop7, $pop3
	i32.add 	$push20=, $pop19, $pop8
	i32.const	$push24=, 9
	i32.mul 	$push25=, $0, $pop24
	i32.const	$push42=, 5
	i32.add 	$push26=, $pop25, $pop42
	i32.const	$push21=, 10
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push41=, 5
	i32.add 	$push23=, $pop22, $pop41
	i32.mul 	$push27=, $pop26, $pop23
	i32.add 	$push28=, $pop20, $pop27
	i32.const	$push32=, 11
	i32.mul 	$push33=, $0, $pop32
	i32.const	$push40=, 5
	i32.add 	$push34=, $pop33, $pop40
	i32.const	$push29=, 12
	i32.mul 	$push30=, $0, $pop29
	i32.const	$push39=, 5
	i32.add 	$push31=, $pop30, $pop39
	i32.mul 	$push35=, $pop34, $pop31
	i32.add 	$push36=, $pop28, $pop35
	i32.const	$push38=, 5
	i32.add 	$push37=, $pop36, $pop38
                                        # fallthrough-return: $pop37
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
	i32.const	$push2=, 14
	i32.shl 	$push3=, $2, $pop2
	i32.const	$push4=, -4194304
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push0=, 255
	i32.and 	$push1=, $2, $pop0
	i32.or  	$push6=, $pop5, $pop1
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
	i32.const	$push1=, .L.str
	i32.const	$push0=, 305419896
	i32.call	$drop=, sys_mknod@FUNCTION, $pop1, $0, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"test"
	.size	.L.str, 5


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
