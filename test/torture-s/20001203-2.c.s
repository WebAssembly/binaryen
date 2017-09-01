	.text
	.file	"20001203-2.c"
	.section	.text.create_array_type,"ax",@progbits
	.hidden	create_array_type       # -- Begin function create_array_type
	.globl	create_array_type
	.type	create_array_type,@function
create_array_type:                      # @create_array_type
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.eqz 	$push51=, $0
	br_if   	0, $pop51       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, 1
	i32.store16	8($0), $pop0
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 3
	i32.mul 	$push3=, $pop1, $pop2
	i32.store	0($0), $pop3
	block   	
	i32.load	$push28=, 4($0)
	tee_local	$push27=, $1=, $pop28
	i32.eqz 	$push52=, $pop27
	br_if   	0, $pop52       # 0: down to label2
# BB#2:                                 # %cond.true
	i32.const	$push4=, 20
	i32.add 	$push5=, $1, $pop4
	i32.load	$push35=, 0($pop5)
	tee_local	$push34=, $2=, $pop35
	i32.const	$push33=, 16
	i32.add 	$push32=, $1, $pop33
	tee_local	$push31=, $4=, $pop32
	i32.load	$push30=, 0($pop31)
	tee_local	$push29=, $3=, $pop30
	i32.sub 	$push6=, $pop34, $pop29
	i32.const	$push7=, 15
	i32.le_s	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label0
# BB#3:                                 # %if.end9
	i32.const	$push42=, 16
	i32.add 	$push41=, $3, $pop42
	tee_local	$push40=, $3=, $pop41
	i32.store	0($4), $pop40
	block   	
	i32.const	$push9=, 12
	i32.add 	$push39=, $1, $pop9
	tee_local	$push38=, $4=, $pop39
	i32.load	$push37=, 0($pop38)
	tee_local	$push36=, $6=, $pop37
	i32.ne  	$push10=, $3, $pop36
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.then14
	i32.const	$push11=, 28
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 1
	i32.store	0($pop12), $pop13
.LBB0_5:                                # %if.end15
	end_block                       # label3:
	i32.const	$push24=, 16
	i32.add 	$push25=, $1, $pop24
	i32.const	$push14=, 24
	i32.add 	$push15=, $1, $pop14
	i32.load	$push50=, 0($pop15)
	tee_local	$push49=, $5=, $pop50
	i32.add 	$push18=, $pop49, $3
	i32.const	$push16=, -1
	i32.xor 	$push17=, $5, $pop16
	i32.and 	$push48=, $pop18, $pop17
	tee_local	$push47=, $3=, $pop48
	i32.const	$push19=, 8
	i32.add 	$push20=, $1, $pop19
	i32.load	$push46=, 0($pop20)
	tee_local	$push45=, $1=, $pop46
	i32.sub 	$push21=, $3, $pop45
	i32.sub 	$push22=, $2, $1
	i32.gt_s	$push23=, $pop21, $pop22
	i32.select	$push44=, $2, $pop47, $pop23
	tee_local	$push43=, $1=, $pop44
	i32.store	0($pop25), $pop43
	i32.store	0($4), $1
	i32.store	12($0), $6
	return  	$0
.LBB0_6:
	end_block                       # label2:
	i32.const	$push26=, 0
	i32.store	12($0), $pop26
	return  	$0
.LBB0_7:                                # %if.then
	end_block                       # label1:
	i32.call	$drop=, alloc_type@FUNCTION
	unreachable
.LBB0_8:                                # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	create_array_type, .Lfunc_end0-create_array_type
                                        # -- End function
	.section	.text.alloc_type,"ax",@progbits
	.hidden	alloc_type              # -- Begin function alloc_type
	.globl	alloc_type
	.type	alloc_type,@function
alloc_type:                             # @alloc_type
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	alloc_type, .Lfunc_end1-alloc_type
                                        # -- End function
	.section	.text.get_discrete_bounds,"ax",@progbits
	.hidden	get_discrete_bounds     # -- Begin function get_discrete_bounds
	.globl	get_discrete_bounds
	.type	get_discrete_bounds,@function
get_discrete_bounds:                    # @get_discrete_bounds
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
	i64.const	$push1=, 2
	i64.store	0($1), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	get_discrete_bounds, .Lfunc_end2-get_discrete_bounds
                                        # -- End function
	.section	.text._obstack_newchunk,"ax",@progbits
	.hidden	_obstack_newchunk       # -- Begin function _obstack_newchunk
	.globl	_obstack_newchunk
	.type	_obstack_newchunk,@function
_obstack_newchunk:                      # @_obstack_newchunk
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	_obstack_newchunk, .Lfunc_end3-_obstack_newchunk
                                        # -- End function
	.section	.text.xmalloc,"ax",@progbits
	.hidden	xmalloc                 # -- Begin function xmalloc
	.globl	xmalloc
	.type	xmalloc,@function
xmalloc:                                # @xmalloc
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	xmalloc, .Lfunc_end4-xmalloc
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
