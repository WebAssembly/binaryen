export default {
	name: "Binaryen.TS",
	entryPoints: ["./src/binaryen.ts"],
	projectDocuments: ["./docs/API-Overview.md"],
	useFirstParagraphOfCommentAsSummary: true,
	out: "./docs/out/",
	customCss: "./docs/styles.css",

	intentionallyNotExported: [
		"Tag",
		"Global",
		"Memory",
		"Table",
		"BinaryenFunction",
		"DataSegment",
		"ElementSegment",
		"Import",
		"Export",
	],
};
