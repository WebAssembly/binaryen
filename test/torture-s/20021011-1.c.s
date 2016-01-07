	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021011-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, .str
	i32.const	$1=, buf
	i32.const	$2=, 9
	call    	memcpy, $1, $0, $2
	block   	.LBB0_19
	i32.call	$push0=, strcmp, $1, $0
	br_if   	$pop0, .LBB0_19
# BB#1:                                 # %for.body.preheader
	call    	memcpy, $1, $0, $2
	block   	.LBB0_18
	i32.call	$push1=, strcmp, $1, $0
	br_if   	$pop1, .LBB0_18
# BB#2:                                 # %for.cond
	i32.const	$1=, buf+1
	call    	memcpy, $1, $0, $2
	i32.call	$push2=, strcmp, $1, $0
	br_if   	$pop2, .LBB0_18
# BB#3:                                 # %for.cond.1
	i32.const	$1=, buf+2
	call    	memcpy, $1, $0, $2
	i32.call	$push3=, strcmp, $1, $0
	br_if   	$pop3, .LBB0_18
# BB#4:                                 # %for.cond.2
	i32.const	$1=, buf+3
	call    	memcpy, $1, $0, $2
	i32.call	$push4=, strcmp, $1, $0
	br_if   	$pop4, .LBB0_18
# BB#5:                                 # %for.cond.3
	i32.const	$1=, buf+4
	call    	memcpy, $1, $0, $2
	i32.call	$push5=, strcmp, $1, $0
	br_if   	$pop5, .LBB0_18
# BB#6:                                 # %for.cond.4
	i32.const	$1=, buf+5
	call    	memcpy, $1, $0, $2
	i32.call	$push6=, strcmp, $1, $0
	br_if   	$pop6, .LBB0_18
# BB#7:                                 # %for.cond.5
	i32.const	$1=, buf+6
	call    	memcpy, $1, $0, $2
	i32.call	$push7=, strcmp, $1, $0
	br_if   	$pop7, .LBB0_18
# BB#8:                                 # %for.cond.6
	i32.const	$1=, buf+7
	call    	memcpy, $1, $0, $2
	i32.call	$push8=, strcmp, $1, $0
	br_if   	$pop8, .LBB0_18
# BB#9:                                 # %for.cond.7
	i32.const	$1=, buf+8
	call    	memcpy, $1, $0, $2
	i32.call	$push9=, strcmp, $1, $0
	br_if   	$pop9, .LBB0_18
# BB#10:                                # %for.cond.8
	i32.const	$1=, buf+9
	call    	memcpy, $1, $0, $2
	i32.call	$push10=, strcmp, $1, $0
	br_if   	$pop10, .LBB0_18
# BB#11:                                # %for.cond.9
	i32.const	$1=, buf+10
	call    	memcpy, $1, $0, $2
	i32.call	$push11=, strcmp, $1, $0
	br_if   	$pop11, .LBB0_18
# BB#12:                                # %for.cond.10
	i32.const	$1=, buf+11
	call    	memcpy, $1, $0, $2
	i32.call	$push12=, strcmp, $1, $0
	br_if   	$pop12, .LBB0_18
# BB#13:                                # %for.cond.11
	i32.const	$1=, buf+12
	call    	memcpy, $1, $0, $2
	i32.call	$push13=, strcmp, $1, $0
	br_if   	$pop13, .LBB0_18
# BB#14:                                # %for.cond.12
	i32.const	$1=, buf+13
	call    	memcpy, $1, $0, $2
	i32.call	$push14=, strcmp, $1, $0
	br_if   	$pop14, .LBB0_18
# BB#15:                                # %for.cond.13
	i32.const	$1=, buf+14
	call    	memcpy, $1, $0, $2
	i32.call	$push15=, strcmp, $1, $0
	br_if   	$pop15, .LBB0_18
# BB#16:                                # %for.cond.14
	i32.const	$1=, buf+15
	call    	memcpy, $1, $0, $2
	i32.call	$push16=, strcmp, $1, $0
	br_if   	$pop16, .LBB0_18
# BB#17:                                # %for.cond.15
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_18:                                 # %if.then7
	call    	abort
	unreachable
.LBB0_19:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	buf,@object             # @buf
	.bss
	.globl	buf
	.align	4
buf:
	.zero	64
	.size	buf, 64

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"mystring"
	.size	.str, 9


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
