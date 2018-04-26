	.text
	.file	"920501-9.c"
	.section	.text.proc1,"ax",@progbits
	.hidden	proc1                   # -- Begin function proc1
	.globl	proc1
	.type	proc1,@function
proc1:                                  # @proc1
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	proc1, .Lfunc_end0-proc1
                                        # -- End function
	.section	.text.proc2,"ax",@progbits
	.hidden	proc2                   # -- Begin function proc2
	.globl	proc2
	.type	proc2,@function
proc2:                                  # @proc2
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 305419896
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	proc2, .Lfunc_end1-proc2
                                        # -- End function
	.section	.text.proc3,"ax",@progbits
	.hidden	proc3                   # -- Begin function proc3
	.globl	proc3
	.type	proc3,@function
proc3:                                  # @proc3
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, -6144092016751651208
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	proc3, .Lfunc_end2-proc3
                                        # -- End function
	.section	.text.proc4,"ax",@progbits
	.hidden	proc4                   # -- Begin function proc4
	.globl	proc4
	.type	proc4,@function
proc4:                                  # @proc4
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, -1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	proc4, .Lfunc_end3-proc4
                                        # -- End function
	.section	.text.proc5,"ax",@progbits
	.hidden	proc5                   # -- Begin function proc5
	.globl	proc5
	.type	proc5,@function
proc5:                                  # @proc5
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 2864434397
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	proc5, .Lfunc_end4-proc5
                                        # -- End function
	.section	.text.print_longlong,"ax",@progbits
	.hidden	print_longlong          # -- Begin function print_longlong
	.globl	print_longlong
	.type	print_longlong,@function
print_longlong:                         # @print_longlong
	.param  	i64, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 32
	i32.sub 	$4=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $4
	i64.const	$push0=, 32
	i64.shr_u	$push1=, $0, $pop0
	i32.wrap/i64	$2=, $pop1
	i32.wrap/i64	$3=, $0
	block   	
	block   	
	i32.eqz 	$push13=, $2
	br_if   	0, $pop13       # 0: down to label1
# %bb.1:                                # %if.then
	i32.store	20($4), $3
	i32.store	16($4), $2
	i32.const	$push2=, .L.str
	i32.const	$push11=, 16
	i32.add 	$push12=, $4, $pop11
	i32.call	$drop=, sprintf@FUNCTION, $1, $pop2, $pop12
	br      	1               # 1: down to label0
.LBB5_2:                                # %if.else
	end_block                       # label1:
	i32.store	0($4), $3
	i32.const	$push3=, .L.str.1
	i32.call	$drop=, sprintf@FUNCTION, $1, $pop3, $4
.LBB5_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push10=, 0
	i32.const	$push8=, 32
	i32.add 	$push9=, $4, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	copy_local	$push14=, $4
                                        # fallthrough-return: $pop14
	.endfunc
.Lfunc_end5:
	.size	print_longlong, .Lfunc_end5-print_longlong
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 192
	i32.sub 	$0=, $pop17, $pop19
	i32.const	$push20=, 0
	i32.store	__stack_pointer($pop20), $0
	i32.const	$push0=, 1
	i32.store	64($0), $pop0
	i32.const	$push21=, 80
	i32.add 	$push22=, $0, $pop21
	i32.const	$push49=, .L.str.1
	i32.const	$push23=, 64
	i32.add 	$push24=, $0, $pop23
	i32.call	$drop=, sprintf@FUNCTION, $pop22, $pop49, $pop24
	block   	
	i32.const	$push1=, .L.str.2
	i32.const	$push25=, 80
	i32.add 	$push26=, $0, $pop25
	i32.call	$push2=, strcmp@FUNCTION, $pop1, $pop26
	br_if   	0, $pop2        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push3=, 305419896
	i32.store	48($0), $pop3
	i32.const	$push27=, 80
	i32.add 	$push28=, $0, $pop27
	i32.const	$push50=, .L.str.1
	i32.const	$push29=, 48
	i32.add 	$push30=, $0, $pop29
	i32.call	$drop=, sprintf@FUNCTION, $pop28, $pop50, $pop30
	i32.const	$push4=, .L.str.3
	i32.const	$push31=, 80
	i32.add 	$push32=, $0, $pop31
	i32.call	$push5=, strcmp@FUNCTION, $pop4, $pop32
	br_if   	0, $pop5        # 0: down to label2
# %bb.2:                                # %if.end11
	i64.const	$push6=, 1311768467732155613
	i64.store	32($0), $pop6
	i32.const	$push33=, 80
	i32.add 	$push34=, $0, $pop33
	i32.const	$push51=, .L.str
	i32.const	$push35=, 32
	i32.add 	$push36=, $0, $pop35
	i32.call	$drop=, sprintf@FUNCTION, $pop34, $pop51, $pop36
	i32.const	$push7=, .L.str.4
	i32.const	$push37=, 80
	i32.add 	$push38=, $0, $pop37
	i32.call	$push8=, strcmp@FUNCTION, $pop7, $pop38
	br_if   	0, $pop8        # 0: down to label2
# %bb.3:                                # %if.end19
	i64.const	$push9=, -1
	i64.store	16($0), $pop9
	i32.const	$push39=, 80
	i32.add 	$push40=, $0, $pop39
	i32.const	$push52=, .L.str
	i32.const	$push41=, 16
	i32.add 	$push42=, $0, $pop41
	i32.call	$drop=, sprintf@FUNCTION, $pop40, $pop52, $pop42
	i32.const	$push10=, .L.str.5
	i32.const	$push43=, 80
	i32.add 	$push44=, $0, $pop43
	i32.call	$push11=, strcmp@FUNCTION, $pop10, $pop44
	br_if   	0, $pop11       # 0: down to label2
# %bb.4:                                # %if.end27
	i32.const	$push12=, -1430532899
	i32.store	0($0), $pop12
	i32.const	$push45=, 80
	i32.add 	$push46=, $0, $pop45
	i32.const	$push13=, .L.str.1
	i32.call	$drop=, sprintf@FUNCTION, $pop46, $pop13, $0
	i32.const	$push14=, .L.str.6
	i32.const	$push47=, 80
	i32.add 	$push48=, $0, $pop47
	i32.call	$push15=, strcmp@FUNCTION, $pop14, $pop48
	br_if   	0, $pop15       # 0: down to label2
# %bb.5:                                # %if.end35
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
	unreachable
.LBB6_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%lx%08.lx"
	.size	.L.str, 10

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"%lx"
	.size	.L.str.1, 4

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"1"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"12345678"
	.size	.L.str.3, 9

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"aabbccdd12345678"
	.size	.L.str.4, 17

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"ffffffffffffffff"
	.size	.L.str.5, 17

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"aabbccdd"
	.size	.L.str.6, 9


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	sprintf, i32, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
