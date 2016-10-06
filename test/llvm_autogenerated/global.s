	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/global.ll"
	.globl	foo
	.type	foo,@function
foo:
	.result 	i32
	i32.const	$push0=, 0
	i32.load	$push1=, answer($pop0)
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	call_memcpy
	.type	call_memcpy,@function
call_memcpy:
	.param  	i32, i32, i32
	.result 	i32
	i32.call	$push0=, memcpy@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	call_memcpy, .Lfunc_end1-call_memcpy

	.type	.Lg,@object
	.data
	.p2align	2
.Lg:
	.int32	1337
	.size	.Lg, 4

	.type	ud,@object
	.p2align	2
ud:
	.skip	4
	.size	ud, 4

	.type	nil,@object
	.lcomm	nil,4,2
	.type	z,@object
	.lcomm	z,4,2
	.type	one,@object
	.p2align	2
one:
	.int32	1
	.size	one, 4

	.type	answer,@object
	.p2align	2
answer:
	.int32	42
	.size	answer, 4

	.type	u32max,@object
	.p2align	2
u32max:
	.int32	4294967295
	.size	u32max, 4

	.type	ud64,@object
	.p2align	3
ud64:
	.skip	8
	.size	ud64, 8

	.type	nil64,@object
	.lcomm	nil64,8,3
	.type	z64,@object
	.lcomm	z64,8,3
	.type	twoP32,@object
	.p2align	3
twoP32:
	.int64	4294967296
	.size	twoP32, 8

	.type	u64max,@object
	.p2align	3
u64max:
	.int64	-1
	.size	u64max, 8

	.type	f32ud,@object
	.p2align	2
f32ud:
	.skip	4
	.size	f32ud, 4

	.type	f32nil,@object
	.lcomm	f32nil,4,2
	.type	f32z,@object
	.lcomm	f32z,4,2
	.type	f32nz,@object
	.p2align	2
f32nz:
	.int32	2147483648
	.size	f32nz, 4

	.type	f32two,@object
	.p2align	2
f32two:
	.int32	1073741824
	.size	f32two, 4

	.type	f64ud,@object
	.p2align	3
f64ud:
	.skip	8
	.size	f64ud, 8

	.type	f64nil,@object
	.lcomm	f64nil,8,3
	.type	f64z,@object
	.lcomm	f64z,8,3
	.type	f64nz,@object
	.p2align	3
f64nz:
	.int64	-9223372036854775808
	.size	f64nz, 8

	.type	f64two,@object
	.p2align	3
f64two:
	.int64	4611686018427387904
	.size	f64two, 8

	.type	arr,@object
	.bss
	.globl	arr
	.p2align	4
arr:
	.skip	512
	.size	arr, 512

	.type	ptr,@object
	.data
	.globl	ptr
	.p2align	2
ptr:
	.int32	arr+80
	.size	ptr, 4

	.type	rom,@object
	.section	.rodata,"a",@progbits
	.globl	rom
	.p2align	4
rom:
	.skip	512
	.size	rom, 512

	.type	array,@object
array:
	.skip	8
	.size	array, 8

	.type	pointer_to_array,@object
	.section	.data.rel.ro,"aw",@progbits
	.globl	pointer_to_array
	.p2align	2
pointer_to_array:
	.int32	array+4
	.size	pointer_to_array, 4


