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
# BB#0:                                 # %entry
	block   	
	i32.load8_u	$push1=, 0($1)
	i32.eqz 	$push7=, $pop1
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %do.body.preheader
	i32.const	$push4=, 2
	i32.add 	$1=, $1, $pop4
.LBB0_2:                                # %do.body
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
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$push11=, $pop3, $pop5
	tee_local	$push10=, $4=, $pop11
	i32.store	__stack_pointer($pop6), $pop10
	i32.store	12($4), $2
	block   	
	i32.load8_u	$push1=, 0($1)
	i32.eqz 	$push15=, $pop1
	br_if   	0, $pop15       # 0: down to label2
# BB#1:                                 # %if.end.i
	i32.const	$push12=, 2
	i32.add 	$1=, $1, $pop12
	i32.load	$2=, 12($4)
.LBB1_2:                                # %do.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.load	$push2=, 0($2)
	i32.call	$drop=, strcpy@FUNCTION, $0, $pop2
	i32.const	$push14=, 4
	i32.add 	$2=, $2, $pop14
	i32.load8_u	$3=, 0($1)
	i32.const	$push13=, 2
	i32.add 	$push0=, $1, $pop13
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
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 32
	i32.sub 	$push17=, $pop3, $pop5
	tee_local	$push16=, $0=, $pop17
	i32.store	__stack_pointer($pop6), $pop16
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
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 32
	i32.add 	$push8=, $0, $pop7
	i32.store	__stack_pointer($pop9), $pop8
	i32.const	$push18=, 0
	return  	$pop18
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
