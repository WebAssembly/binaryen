	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030715-1.c"
	.section	.text.ap_check_cmd_context,"ax",@progbits
	.hidden	ap_check_cmd_context
	.globl	ap_check_cmd_context
	.type	ap_check_cmd_context,@function
ap_check_cmd_context:                   # @ap_check_cmd_context
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	ap_check_cmd_context, .Lfunc_end0-ap_check_cmd_context

	.section	.text.server_type,"ax",@progbits
	.hidden	server_type
	.globl	server_type
	.type	server_type,@function
server_type:                            # @server_type
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	i32.call	$4=, strcmp@FUNCTION, $2, $pop0
	i32.const	$3=, 0
	copy_local	$5=, $3
	block
	block
	i32.const	$push2=, 0
	i32.eq  	$push3=, $4, $pop2
	br_if   	$pop3, 0        # 0: down to label1
# BB#1:                                 # %if.else
	i32.const	$push1=, .L.str.1
	i32.call	$4=, strcmp@FUNCTION, $2, $pop1
	i32.const	$2=, .L.str.2
	i32.const	$5=, 1
	br_if   	$4, 1           # 1: down to label0
.LBB1_2:                                # %if.end9
	end_block                       # label1:
	i32.store	$discard=, ap_standalone($3), $5
	copy_local	$2=, $3
.LBB1_3:                                # %cleanup
	end_block                       # label0:
	return  	$2
.Lfunc_end1:
	.size	server_type, .Lfunc_end1-server_type

	.section	.text.main,"ax",@progbits
	.hidden	main
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
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"inetd"
	.size	.L.str, 6

	.hidden	ap_standalone           # @ap_standalone
	.type	ap_standalone,@object
	.section	.bss.ap_standalone,"aw",@nobits
	.globl	ap_standalone
	.align	2
ap_standalone:
	.int32	0                       # 0x0
	.size	ap_standalone, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"standalone"
	.size	.L.str.1, 11

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"ServerType must be either 'inetd' or 'standalone'"
	.size	.L.str.2, 50


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
