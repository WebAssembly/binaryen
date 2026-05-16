// # Library # //
// Project-agnostic library artifacts for TypeScript development.



import {
	BinaryenObj,
} from "./-pre.ts";



/**
 * Mark a method as deprecated by logging a warning in the console.
 * @example
 * class Module {
 * 	\@replacedBy("`this.global.addExport`")
 * 	addGlobalExport(...args) {
 * 		return this.global.addExport(...args);
 * 	}
 * }
 *
 * @param replacement the name or signature of the new method replacing the deprecated one
 * @returns a method decorator
 */
export function replacedBy<This, Params extends unknown[], Return>(replacement: string = ""): (
	method: (this: This, ...args: Params) => Return,
	context: ClassMethodDecoratorContext<This, typeof method>,
) => (typeof method) | void {
	return (method, context) => function (...args) {
		const message = `WARNING: ${ context.static ? "Static" : "Instance" } method \`${ String(context.name) }\` is deprecated${ replacement && `; use ${ replacement } instead` }.`;
		BinaryenObj.printWarn(message);
		return method.call(this, ...args);
	};
}
