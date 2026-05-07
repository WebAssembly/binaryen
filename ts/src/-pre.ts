// # Preprocess # //
import Binaryen from "binaryen-raw";



/** The main object provided by Emscripten. This is what gets wrapped. It is not exposed to the consumer. */
export const BinaryenObj = await Binaryen();



export const {
	_free,
	_malloc,
	stackSave,
	stackRestore,
	stackAlloc,
	stringToUTF8OnStack,
	UTF8ToString,
	stringToAscii,
	getExceptionMessage,
	_BinaryenSizeofAllocateAndWriteResult,
} = BinaryenObj;
