	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030715-1.c"
	.globl	ap_check_cmd_context
	.type	ap_check_cmd_context,@function
ap_check_cmd_context:                   # @ap_check_cmd_context
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end0:
	.size	ap_check_cmd_context, func_end0-ap_check_cmd_context

	.globl	server_type
	.type	server_type,@function
server_type:                            # @server_type
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, .str
	i32.call	$4=, strcmp, $2, $pop0
	i32.const	$3=, 0
	copy_local	$5=, $3
	block   	BB1_3
	block   	BB1_2
	i32.const	$push2=, 0
	i32.eq  	$push3=, $4, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.else
	i32.const	$push1=, .str.1
	i32.call	$4=, strcmp, $2, $pop1
	i32.const	$2=, .str.2
	i32.const	$5=, 1
	br_if   	$4, BB1_3
BB1_2:                                  # %if.end9
	i32.store	$discard=, ap_standalone($3), $5
	copy_local	$2=, $3
BB1_3:                                  # %cleanup
	return  	$2
func_end1:
	.size	server_type, func_end1-server_type

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, ap_standalone($0), $pop0
	return  	$0
func_end2:
	.size	main, func_end2-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"inetd"
	.size	.str, 6

	.type	ap_standalone,@object   # @ap_standalone
	.bss
	.globl	ap_standalone
	.align	2
ap_standalone:
	.int32	0                       # 0x0
	.size	ap_standalone, 4

	.type	.str.1,@object          # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.1:
	.asciz	"standalone"
	.size	.str.1, 11

	.type	.str.2,@object          # @.str.2
.str.2:
	.asciz	"ServerType must be either 'inetd' or 'standalone'"
	.size	.str.2, 50


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
