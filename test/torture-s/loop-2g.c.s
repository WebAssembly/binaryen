	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2g.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 39
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push2=, $1, $0
	i32.const	$push3=, 254
	i32.store8	$discard=, 0($pop2), $pop3
	i32.const	$push4=, 1
	i32.add 	$0=, $0, $pop4
	i32.const	$push5=, 40
	i32.ne  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.const	$push0=, .L.str
	i32.call	$0=, open@FUNCTION, $pop0, $1
	i32.const	$push4=, 2147450880
	i32.const	$push3=, 65536
	i32.const	$push2=, 3
	i32.const	$push1=, 50
	i32.call	$0=, mmap@FUNCTION, $pop4, $pop3, $pop2, $pop1, $0, $1
	i32.const	$push5=, -1
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push7=, 254
	i32.store8	$push8=, 32766($0), $pop7
	i32.store8	$push9=, 32767($0), $pop8
	i32.store8	$push10=, 32768($0), $pop9
	i32.store8	$push11=, 32769($0), $pop10
	i32.store8	$push12=, 32770($0), $pop11
	i32.store8	$push13=, 32771($0), $pop12
	i32.store8	$push14=, 32772($0), $pop13
	i32.store8	$push15=, 32773($0), $pop14
	i32.store8	$push16=, 32774($0), $pop15
	i32.store8	$push17=, 32775($0), $pop16
	i32.store8	$push18=, 32776($0), $pop17
	i32.store8	$push19=, 32777($0), $pop18
	i32.store8	$push20=, 32778($0), $pop19
	i32.store8	$push21=, 32779($0), $pop20
	i32.store8	$push22=, 32780($0), $pop21
	i32.store8	$push23=, 32781($0), $pop22
	i32.store8	$push24=, 32782($0), $pop23
	i32.store8	$push25=, 32783($0), $pop24
	i32.store8	$push26=, 32784($0), $pop25
	i32.store8	$push27=, 32785($0), $pop26
	i32.store8	$push28=, 32786($0), $pop27
	i32.store8	$push29=, 32787($0), $pop28
	i32.store8	$push30=, 32788($0), $pop29
	i32.store8	$push31=, 32789($0), $pop30
	i32.store8	$push32=, 32790($0), $pop31
	i32.store8	$push33=, 32791($0), $pop32
	i32.store8	$push34=, 32792($0), $pop33
	i32.store8	$push35=, 32793($0), $pop34
	i32.store8	$push36=, 32794($0), $pop35
	i32.store8	$push37=, 32795($0), $pop36
	i32.store8	$push38=, 32796($0), $pop37
	i32.store8	$push39=, 32797($0), $pop38
	i32.store8	$push40=, 32798($0), $pop39
	i32.store8	$push41=, 32799($0), $pop40
	i32.store8	$push42=, 32800($0), $pop41
	i32.store8	$push43=, 32801($0), $pop42
	i32.store8	$push44=, 32802($0), $pop43
	i32.store8	$push45=, 32803($0), $pop44
	i32.store8	$discard=, 32804($0), $pop45
	i32.store8	$discard=, 32805($0), $1
.LBB1_2:                                # %if.end15
	end_block                       # label3:
	call    	exit@FUNCTION, $1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"/dev/zero"
	.size	.L.str, 10


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
