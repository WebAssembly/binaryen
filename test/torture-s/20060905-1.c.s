	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060905-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, s-384
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	i32.const	$push6=, 128
	i32.lt_s	$push0=, $2, $pop6
	br_if   	0, $pop0        # 0: down to label1
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 0
	i32.load8_u	$push1=, 0($0)
	i32.store8	g($pop8), $pop1
	i32.const	$push7=, 1
	i32.add 	$1=, $1, $pop7
.LBB0_3:                                # %for.inc.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push13=, 3
	i32.add 	$0=, $0, $pop13
	i32.const	$push12=, 1
	i32.add 	$push11=, $2, $pop12
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 256
	i32.ne  	$push2=, $pop10, $pop9
	br_if   	0, $pop2        # 0: up to label0
# BB#4:                                 # %foo.exit
	end_loop
	block   	
	i32.const	$push3=, 128
	i32.ne  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#5:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
.LBB0_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	4
s:
	.skip	768
	.size	s, 768

	.hidden	g                       # @g
	.type	g,@object
	.section	.bss.g,"aw",@nobits
	.globl	g
g:
	.int8	0                       # 0x0
	.size	g, 1


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
