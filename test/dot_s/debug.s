	.text
	.file	"fib.bc"
	.hidden	fib
	.globl	fib
	.type	fib,@function
fib:
.Lfunc_begin0:
	.file	1 "fib.c"
	.loc	1 1 0
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
.Ltmp0:
	i32.const	$3=, 0
.Ltmp1:
	i32.const	$2=, -1
	i32.const	$4=, 1
.LBB0_1:
        block
	loop
	i32.const	$push1=, 1
.Ltmp2:
	.loc	1 3 17 prologue_end discriminator 1
	i32.add 	$2=, $2, $pop1
	.loc	1 3 3 is_stmt 0 discriminator 1
	i32.ge_s	$push0=, $2, $0
	br_if   	1, $pop0
.Ltmp3:
	.loc	1 4 11 is_stmt 1
	i32.add 	$1=, $4, $3
.Ltmp4:
	copy_local	$3=, $4
	copy_local	$4=, $1
	br      	0
.Ltmp5:
.LBB0_3:
	end_loop
        end_block
.Ltmp6:
	.loc	1 6 3
	return  	$4
.Ltmp7:
	.endfunc
.Lfunc_end0:
	.size	fib, .Lfunc_end0-fib

	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 3.9.0 (trunk 266025)"
.Linfo_string1:
	.asciz	"fib.c"
.Linfo_string2:
	.asciz	"/Users/yury/llvmwasm"
.Linfo_string3:
	.asciz	"fib"
.Linfo_string4:
	.asciz	"int"
.Linfo_string5:
	.asciz	"n"
.Linfo_string6:
	.asciz	"a"
.Linfo_string7:
	.asciz	"b"
.Linfo_string8:
	.asciz	"i"
.Linfo_string9:
	.asciz	"t"
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.int32	.Lfunc_begin0-.Lfunc_begin0
	.int32	.Lfunc_end0-.Lfunc_begin0
	.int16	1
	.int8	150
	.int32	0
	.int32	0
.Ldebug_loc1:
	.int32	.Ltmp0-.Lfunc_begin0
	.int32	.Ltmp6-.Lfunc_begin0
	.int16	3
	.int8	17
	.int8	0
	.int8	159
	.int32	.Ltmp6-.Lfunc_begin0
	.int32	.Lfunc_end0-.Lfunc_begin0
	.int16	1
	.int8	150
	.int32	0
	.int32	0
.Ldebug_loc2:
	.int32	.Ltmp0-.Lfunc_begin0
	.int32	.Ltmp4-.Lfunc_begin0
	.int16	3
	.int8	17
	.int8	1
	.int8	159
	.int32	.Ltmp4-.Lfunc_begin0
	.int32	.Lfunc_end0-.Lfunc_begin0
	.int16	1
	.int8	150
	.int32	0
	.int32	0
.Ldebug_loc3:
	.int32	.Ltmp4-.Lfunc_begin0
	.int32	.Lfunc_end0-.Lfunc_begin0
	.int16	1
	.int8	150
	.int32	0
	.int32	0
	.section	.debug_abbrev,"",@progbits
.Lsection_abbrev:
	.int8	1
	.int8	17
	.int8	1
	.int8	37
	.int8	14
	.int8	19
	.int8	5
	.int8	3
	.int8	14
	.int8	16
	.int8	23
	.int8	27
	.int8	14
	.ascii	"\341\177"
	.int8	25
	.int8	17
	.int8	1
	.int8	18
	.int8	6
	.int8	0
	.int8	0
	.int8	2
	.int8	46
	.int8	1
	.int8	17
	.int8	1
	.int8	18
	.int8	6
	.ascii	"\347\177"
	.int8	25
	.int8	64
	.int8	24
	.int8	3
	.int8	14
	.int8	58
	.int8	11
	.int8	59
	.int8	11
	.int8	39
	.int8	25
	.int8	73
	.int8	19
	.int8	63
	.int8	25
	.ascii	"\341\177"
	.int8	25
	.int8	0
	.int8	0
	.int8	3
	.int8	5
	.int8	0
	.int8	2
	.int8	23
	.int8	3
	.int8	14
	.int8	58
	.int8	11
	.int8	59
	.int8	11
	.int8	73
	.int8	19
	.int8	0
	.int8	0
	.int8	4
	.int8	52
	.int8	0
	.int8	2
	.int8	23
	.int8	3
	.int8	14
	.int8	58
	.int8	11
	.int8	59
	.int8	11
	.int8	73
	.int8	19
	.int8	0
	.int8	0
	.int8	5
	.int8	52
	.int8	0
	.int8	28
	.int8	13
	.int8	3
	.int8	14
	.int8	58
	.int8	11
	.int8	59
	.int8	11
	.int8	73
	.int8	19
	.int8	0
	.int8	0
	.int8	6
	.int8	36
	.int8	0
	.int8	3
	.int8	14
	.int8	62
	.int8	11
	.int8	11
	.int8	11
	.int8	0
	.int8	0
	.int8	0
	.section	.debug_info,"",@progbits
.Lsection_info:
.Lcu_begin0:
	.int32	135
	.int16	4
	.int32	.Lsection_abbrev
	.int8	4
	.int8	1
	.int32	.Linfo_string0
	.int16	12
	.int32	.Linfo_string1
	.int32	.Lline_table_start0
	.int32	.Linfo_string2

	.int32	.Lfunc_begin0
	.int32	.Lfunc_end0-.Lfunc_begin0
	.int8	2
	.int32	.Lfunc_begin0
	.int32	.Lfunc_end0-.Lfunc_begin0

	.int8	0
	.int32	.Linfo_string3
	.int8	1
	.int8	1

	.int32	131


	.int8	3
	.int32	.Ldebug_loc0
	.int32	.Linfo_string5
	.int8	1
	.int8	1
	.int32	131
	.int8	4
	.int32	.Ldebug_loc1
	.int32	.Linfo_string6
	.int8	1
	.int8	2
	.int32	131
	.int8	4
	.int32	.Ldebug_loc2
	.int32	.Linfo_string7
	.int8	1
	.int8	2
	.int32	131
	.int8	5
	.int8	0
	.int32	.Linfo_string8
	.int8	1
	.int8	2
	.int32	131
	.int8	4
	.int32	.Ldebug_loc3
	.int32	.Linfo_string9
	.int8	1
	.int8	2
	.int32	131
	.int8	0
	.int8	6
	.int32	.Linfo_string4
	.int8	5
	.int8	4
	.int8	0
	.section	.debug_ranges,"",@progbits
.Ldebug_range:
	.section	.debug_macinfo,"",@progbits
.Ldebug_macinfo:
.Lcu_macro_begin0:
	.int8	0
	.section	.debug_pubnames,"",@progbits
	.int32	.LpubNames_end0-.LpubNames_begin0
.LpubNames_begin0:
	.int16	2
	.int32	.Lcu_begin0
	.int32	139
	.int32	38
	.asciz	"fib"
	.int32	0
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.int32	.LpubTypes_end0-.LpubTypes_begin0
.LpubTypes_begin0:
	.int16	2
	.int32	.Lcu_begin0
	.int32	139
	.int32	131
	.asciz	"int"
	.int32	0
.LpubTypes_end0:

	.ident	"clang version 3.9.0 (trunk 266025)"
	.section	.debug_line,"",@progbits
.Lline_table_start0:
