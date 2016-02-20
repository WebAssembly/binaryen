	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/frame-address.c"
	.section	.text.check_fa_work,"ax",@progbits
	.hidden	check_fa_work
	.globl	check_fa_work
	.type	check_fa_work,@function
check_fa_work:                          # @check_fa_work
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i32.const	$push0=, 0
	i32.store8	$discard=, 15($8), $pop0
	i32.const	$5=, 15
	i32.add 	$5=, $8, $5
	block
	block
	i32.le_u	$push1=, $5, $0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.else
	i32.le_u	$push4=, $0, $1
	i32.const	$6=, 15
	i32.add 	$6=, $8, $6
	i32.ge_u	$push5=, $6, $1
	i32.and 	$1=, $pop4, $pop5
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.then
	end_block                       # label1:
	i32.ge_u	$push2=, $0, $1
	i32.const	$7=, 15
	i32.add 	$7=, $8, $7
	i32.le_u	$push3=, $7, $1
	i32.and 	$1=, $pop2, $pop3
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	i32.const	$4=, 16
	i32.add 	$8=, $8, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	check_fa_work, .Lfunc_end0-check_fa_work

	.section	.text.check_fa_mid,"ax",@progbits
	.hidden	check_fa_mid
	.globl	check_fa_mid
	.type	check_fa_mid,@function
check_fa_mid:                           # @check_fa_mid
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$3=, 0($1)
	copy_local	$4=, $3
	i32.call	$push0=, check_fa_work@FUNCTION, $0, $4
	i32.const	$push1=, 0
	i32.ne  	$push2=, $pop0, $pop1
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $4
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	check_fa_mid, .Lfunc_end1-check_fa_mid

	.section	.text.check_fa,"ax",@progbits
	.hidden	check_fa
	.globl	check_fa
	.type	check_fa,@function
check_fa:                               # @check_fa
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$4=, 15
	i32.add 	$4=, $5, $4
	i32.call	$push0=, check_fa_mid@FUNCTION, $4
	i32.const	$push1=, 0
	i32.ne  	$push2=, $pop0, $pop1
	i32.const	$3=, 16
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return  	$pop2
	.endfunc
.Lfunc_end2:
	.size	check_fa, .Lfunc_end2-check_fa

	.section	.text.how_much,"ax",@progbits
	.hidden	how_much
	.globl	how_much
	.type	how_much,@function
how_much:                               # @how_much
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	how_much, .Lfunc_end3-how_much

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, check_fa@FUNCTION, $0
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push1=, 0
	return  	$pop1
.LBB4_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 3.9.0 "
