	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041214-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.load8_u	$3=, 0($1)
	i32.store	$discard=, 12($7), $2
	block
	i32.const	$push12=, 0
	i32.eq  	$push13=, $3, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#1:                                 # %do_form_string.preheader
	i32.const	$push6=, 2
	i32.add 	$1=, $1, $pop6
.LBB0_2:                                # %do_form_string
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push0=, 12($7)
	i32.const	$push11=, 3
	i32.add 	$push1=, $pop0, $pop11
	i32.const	$push10=, -4
	i32.and 	$push2=, $pop1, $pop10
	tee_local	$push9=, $2=, $pop2
	i32.const	$push8=, 4
	i32.add 	$push3=, $pop9, $pop8
	i32.store	$discard=, 12($7), $pop3
	i32.load	$push4=, 0($2)
	i32.call	$discard=, strcpy@FUNCTION, $0, $pop4
	i32.load8_u	$2=, 0($1)
	i32.const	$push7=, 2
	i32.add 	$1=, $1, $pop7
	br_if   	0, $2           # 0: up to label1
.LBB0_3:                                # %all_done
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push5=, 0
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$pop5
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $6
	i32.call	$discard=, g@FUNCTION, $0, $1, $pop0
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 32
	i32.sub 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 8
	i32.sub 	$11=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$11=, 0($3), $11
	i32.const	$push0=, .L.str.1
	i32.store	$0=, 0($11), $pop0
	i32.const	$push1=, 4
	i32.add 	$1=, $11, $pop1
	i32.const	$push2=, 0
	i32.store	$1=, 0($1), $pop2
	i32.const	$push3=, .L.str
	i32.const	$9=, 22
	i32.add 	$9=, $11, $9
	call    	f@FUNCTION, $9, $pop3
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 8
	i32.add 	$11=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$11=, 0($5), $11
	i32.const	$10=, 22
	i32.add 	$10=, $11, $10
	i32.call	$0=, strcmp@FUNCTION, $10, $0
	block
	br_if   	0, $0           # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$8=, 32
	i32.add 	$11=, $11, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
	return  	$1
.LBB2_2:                                # %if.then
	end_block                       # label3:
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
