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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	ap_check_cmd_context, .Lfunc_end0-ap_check_cmd_context

	.section	.text.server_type,"ax",@progbits
	.hidden	server_type
	.globl	server_type
	.type	server_type,@function
server_type:                            # @server_type
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block   	
	i32.const	$push0=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $2, $pop0
	i32.eqz 	$push7=, $pop1
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.else
	block   	
	i32.const	$push2=, .L.str.1
	i32.call	$push3=, strcmp@FUNCTION, $2, $pop2
	i32.eqz 	$push8=, $pop3
	br_if   	0, $pop8        # 0: down to label1
# BB#2:                                 # %cleanup
	i32.const	$push5=, .L.str.2
	return  	$pop5
.LBB1_3:
	end_block                       # label1:
	i32.const	$3=, 1
.LBB1_4:                                # %if.end9
	end_block                       # label0:
	i32.const	$push6=, 0
	i32.store	ap_standalone($pop6), $3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	server_type, .Lfunc_end1-server_type

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	ap_standalone($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
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
	.p2align	2
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	strcmp, i32, i32, i32
