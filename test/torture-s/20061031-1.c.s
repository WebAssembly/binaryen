	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20061031-1.c"
	.section	.text.ff,"ax",@progbits
	.hidden	ff
	.globl	ff
	.type	ff,@function
ff:                                     # @ff
	.param  	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ff, .Lfunc_end0-ff

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	call    	ff@FUNCTION, $0
	block   	
	i32.const	$push0=, 2
	i32.add 	$push6=, $0, $pop0
	tee_local	$push5=, $1=, $pop6
	i32.const	$push4=, 65535
	i32.and 	$push1=, $pop5, $pop4
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	#APP
	#NO_APP
.LBB1_2:                                # %for.inc
	end_block                       # label0:
	call    	ff@FUNCTION, $0
	block   	
	i32.add 	$push2=, $1, $0
	i32.const	$push7=, 65535
	i32.and 	$push3=, $pop2, $pop7
	br_if   	0, $pop3        # 0: down to label1
# BB#3:                                 # %if.then.1
	#APP
	#NO_APP
.LBB1_4:                                # %for.inc.1
	end_block                       # label1:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	nunmap                  # @nunmap
	.type	nunmap,@object
	.section	.rodata.nunmap,"a",@progbits
	.globl	nunmap
nunmap:
	.ascii	"\021\377\001"
	.size	nunmap, 3


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
