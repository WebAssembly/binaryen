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
	i32.load8_u	$push0=, 0($1)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %do_form_string.preheader
	i32.const	$push3=, 2
	i32.add 	$1=, $1, $pop3
.LBB0_2:                                # %do_form_string
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push1=, 0($2)
	i32.call	$discard=, strcpy@FUNCTION, $0, $pop1
	i32.load8_u	$3=, 0($1)
	i32.const	$push5=, 4
	i32.add 	$2=, $2, $pop5
	i32.const	$push4=, 2
	i32.add 	$1=, $1, $pop4
	br_if   	0, $3           # 0: up to label1
.LBB0_3:                                # %all_done
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push2=, 0
	return  	$pop2
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
	i32.const	$push4=, __stack_pointer
	i32.const	$push1=, __stack_pointer
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push8=, $pop2, $pop3
	i32.store	$3=, 0($pop4), $pop8
	i32.load8_u	$4=, 0($1)
	i32.store	$discard=, 12($3), $2
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $4, $pop12
	br_if   	0, $pop13       # 0: down to label3
# BB#1:                                 # %do_form_string.i.preheader
	i32.load	$2=, 12($3)
	i32.const	$push9=, 2
	i32.add 	$1=, $1, $pop9
.LBB1_2:                                # %do_form_string.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load	$push0=, 0($2)
	i32.call	$discard=, strcpy@FUNCTION, $0, $pop0
	i32.load8_u	$4=, 0($1)
	i32.const	$push11=, 4
	i32.add 	$2=, $2, $pop11
	i32.const	$push10=, 2
	i32.add 	$1=, $1, $pop10
	br_if   	0, $4           # 0: up to label4
.LBB1_3:                                # %g.exit
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push7=, __stack_pointer
	i32.const	$push5=, 16
	i32.add 	$push6=, $3, $pop5
	i32.store	$discard=, 0($pop7), $pop6
	return
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
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 32
	i32.sub 	$push15=, $pop5, $pop6
	i32.store	$push17=, 0($pop7), $pop15
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
	i32.const	$push10=, __stack_pointer
	i32.const	$push8=, 32
	i32.add 	$push9=, $2, $pop8
	i32.store	$discard=, 0($pop10), $pop9
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
