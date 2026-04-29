import {getExceptionMessage} from "./pre.ts";



// # Globals # //
// Top-level functions available in the public API.



/**
 * Calls a function, wrapping it in error handling code so that if it hits a
 * fatal error, we throw a JS exception (which JS can handle) rather than
 * abort the entire process (which would not be a friendly behavior).
 * @param func the function to call
 * @return the return value of the given function
 */
function handleFatalError(func: () => number): number {
	try {
		return func();
	} catch (e) {
		// Fatal errors begin with a specific prefix. Strip it out, and the newline.
		if (typeof e === "number") {
			// Older version of emscripten can throw C++ exceptions as pointers (numbers) in release builds.
			const [_, message] = getExceptionMessage(e);
			if (message?.startsWith("Fatal: ")) {
				throw new Error(message.substr(7).trim());
			}
		} else {
			const err = e as Error;
			// Newer version of emscripten always throw CppException object but don’t
			// always populate the `.message` field.
			// TODO: Set EXCEPTION_STACK_TRACES instead?
			if (!err.message) {
				const [_, message] = getExceptionMessage(err);
				err.message = message;
			}
			err.message = err.message.replace("Fatal:", "");
			err.message = err.message.trim();
		}
		// Rethrow anything else.
		throw e;
	}
}



export function emitText() {};

export function readBinary() {};

export function readBinaryWithFeatures() {};

export function parseText() {};

export function exit() {};

export function getOptimizeLevel() {};

export function setOptimizeLevel() {};

export function getShrinkLevel() {};

export function setShrinkLevel() {};

export function getDebugInfo() {};

export function setDebugInfo() {};

export function getTrapsNeverHappen() {};

export function setTrapsNeverHappen() {};

export function getClosedWorld() {};

export function setClosedWorld() {};

export function getLowMemoryUnused() {};

export function setLowMemoryUnused() {};

export function getZeroFilledMemory() {};

export function setZeroFilledMemory() {};

export function getFastMath() {};

export function setFastMath() {};

export function getGenerateStackIR() {};

export function setGenerateStackIR() {};

export function getOptimizeStackIR() {};

export function setOptimizeStackIR() {};

export function getPassArgument() {};

export function setPassArgument() {};

export function clearPassArguments() {};

export function hasPassToSkip() {};

export function addPassToSkip() {};

export function clearPassesToSkip() {};

export function getAlwaysInlineMaxSize() {};

export function setAlwaysInlineMaxSize() {};

export function getFlexibleInlineMaxSize() {};

export function setFlexibleInlineMaxSize() {};

export function getOneCallerInlineMaxSize() {};

export function setOneCallerInlineMaxSize() {};

export function getAllowInliningFunctionsWithLoops() {};

export function setAllowInliningFunctionsWithLoops() {};
