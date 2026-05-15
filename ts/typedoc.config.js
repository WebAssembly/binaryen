export default {
	name: "Binaryen.TS",
	entryPoints: ["./src/binaryen.ts"],
	projectDocuments: ["./docs/API-Overview.md"],
	useFirstParagraphOfCommentAsSummary: true,
	out: "../docs/binaryen.ts/",
	githubPages: false, // when `false`, does not generate a `.nojekyll` file to prevent GitHub Pages from using Jekyll
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
