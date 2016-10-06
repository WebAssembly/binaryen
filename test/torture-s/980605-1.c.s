	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980605-1.c"
	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	f64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, x($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push1=, 10
	i32.add 	$push2=, $pop9, $pop1
	i32.store	x($pop0), $pop2
	i32.trunc_u/f64	$push4=, $0
	i32.const	$push8=, 10
	i32.mul 	$push3=, $1, $pop8
	i32.add 	$push5=, $pop4, $pop3
	i32.const	$push6=, 45
	i32.add 	$push7=, $pop5, $pop6
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	f2, .Lfunc_end0-f2

	.section	.text.getval,"ax",@progbits
	.hidden	getval
	.globl	getval
	.type	getval,@function
getval:                                 # @getval
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, x($pop5)
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop3, $pop1
	i32.store	x($pop0), $pop2
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	getval, .Lfunc_end1-getval

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push23=, $pop10, $pop11
	tee_local	$push22=, $1=, $pop23
	i32.store	__stack_pointer($pop12), $pop22
	i32.const	$push0=, 0
	i32.const	$push21=, 0
	i32.load	$push20=, x($pop21)
	tee_local	$push19=, $0=, $pop20
	i32.const	$push1=, 20
	i32.add 	$push2=, $pop19, $pop1
	i32.store	x($pop0), $pop2
	i32.const	$push18=, 20
	i32.mul 	$push3=, $0, $pop18
	i32.const	$push4=, 207
	i32.add 	$push17=, $pop3, $pop4
	tee_local	$push16=, $0=, $pop17
	i32.store	0($1), $pop16
	i32.const	$push6=, buf
	i32.const	$push5=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $pop6, $pop5, $1
	block   	
	i32.const	$push7=, 227
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $1, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	return
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int32	1                       # 0x1
	.size	x, 4

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
buf:
	.skip	10
	.size	buf, 10

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	sprintf, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
