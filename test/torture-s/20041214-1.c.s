	.text
	.file	"20041214-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.load8_u	$push1=, 0($1)
	i32.eqz 	$push7=, $pop1
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %do_form_string.preheader
	i32.const	$push4=, 2
	i32.add 	$1=, $1, $pop4
.LBB0_2:                                # %do_form_string
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push2=, 0($2)
	i32.call	$drop=, strcpy@FUNCTION, $0, $pop2
	i32.const	$push6=, 4
	i32.add 	$2=, $2, $pop6
	i32.load8_u	$3=, 0($1)
	i32.const	$push5=, 2
	i32.add 	$push0=, $1, $pop5
	copy_local	$1=, $pop0
	br_if   	0, $3           # 0: up to label1
.LBB0_3:                                # %all_done
	end_loop
	end_block                       # label0:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$4=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $4
	i32.store	12($4), $2
	block   	
	i32.load8_u	$push1=, 0($1)
	i32.eqz 	$push13=, $pop1
	br_if   	0, $pop13       # 0: down to label2
# %bb.1:                                # %if.end.i
	i32.const	$push10=, 2
	i32.add 	$1=, $1, $pop10
	i32.load	$2=, 12($4)
.LBB1_2:                                # %do_form_string.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.load	$push2=, 0($2)
	i32.call	$drop=, strcpy@FUNCTION, $0, $pop2
	i32.const	$push12=, 4
	i32.add 	$2=, $2, $pop12
	i32.load8_u	$3=, 0($1)
	i32.const	$push11=, 2
	i32.add 	$push0=, $1, $pop11
	copy_local	$1=, $pop0
	br_if   	0, $3           # 0: up to label3
.LBB1_3:                                # %g.exit
	end_loop
	end_block                       # label2:
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $4, $pop7
	i32.store	__stack_pointer($pop9), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 32
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push15=, 0
	i32.store	4($0), $pop15
	i32.const	$push0=, .L.str.1
	i32.store	0($0), $pop0
	i32.const	$push10=, 22
	i32.add 	$push11=, $0, $pop10
	i32.const	$push1=, .L.str
	call    	f@FUNCTION, $pop11, $pop1, $0
	block   	
	i32.const	$push12=, 22
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, .L.str.1
	i32.call	$push2=, strcmp@FUNCTION, $pop13, $pop14
	br_if   	0, $pop2        # 0: down to label4
# %bb.1:                                # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 32
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push16=, 0
	return  	$pop16
.LBB2_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%s"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"asdf"
	.size	.L.str.1, 5


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
