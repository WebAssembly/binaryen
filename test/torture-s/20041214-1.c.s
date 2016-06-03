	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041214-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
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
# BB#1:                                 # %do_form_string.preheader
	i32.const	$push4=, 2
	i32.add 	$1=, $1, $pop4
.LBB0_2:                                # %do_form_string
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
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
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push10=, $pop4, $pop5
	i32.store	$push12=, __stack_pointer($pop6), $pop10
	tee_local	$push11=, $3=, $pop12
	i32.store	$drop=, 12($pop11), $2
	block
	i32.load8_u	$push1=, 0($1)
	i32.eqz 	$push16=, $pop1
	br_if   	0, $pop16       # 0: down to label3
# BB#1:                                 # %do_form_string.i.preheader
	i32.const	$push13=, 2
	i32.add 	$1=, $1, $pop13
	i32.load	$2=, 12($3)
.LBB1_2:                                # %do_form_string.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push2=, 0($2)
	i32.call	$drop=, strcpy@FUNCTION, $0, $pop2
	i32.const	$push15=, 4
	i32.add 	$2=, $2, $pop15
	i32.load8_u	$4=, 0($1)
	i32.const	$push14=, 2
	i32.add 	$push0=, $1, $pop14
	copy_local	$1=, $pop0
	br_if   	0, $4           # 0: up to label4
.LBB1_3:                                # %g.exit
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 32
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push17=, __stack_pointer($pop7), $pop15
	tee_local	$push16=, $2=, $pop17
	i32.const	$push0=, 0
	i32.store	$0=, 4($pop16), $pop0
	i32.const	$push1=, .L.str.1
	i32.store	$1=, 0($2), $pop1
	i32.const	$push11=, 22
	i32.add 	$push12=, $2, $pop11
	i32.const	$push2=, .L.str
	call    	f@FUNCTION, $pop12, $pop2, $2
	block
	i32.const	$push13=, 22
	i32.add 	$push14=, $2, $pop13
	i32.call	$push3=, strcmp@FUNCTION, $pop14, $1
	br_if   	0, $pop3        # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 32
	i32.add 	$push9=, $2, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	return  	$0
.LBB2_2:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%s"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"asdf"
	.size	.L.str.1, 5


	.ident	"clang version 3.9.0 "
	.functype	strcpy, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
