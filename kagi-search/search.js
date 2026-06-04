#!/usr/bin/env node

const args = process.argv.slice(2);

// Parse options
let numResults = 10;
let outputJson = false;

const nIndex = args.indexOf("-n");
if (nIndex !== -1 && args[nIndex + 1]) {
	numResults = parseInt(args[nIndex + 1], 10);
	if (isNaN(numResults) || numResults < 1) numResults = 10;
	args.splice(nIndex, 2);
}

const jsonIndex = args.indexOf("--json");
if (jsonIndex !== -1) {
	outputJson = true;
	args.splice(jsonIndex, 1);
}

const query = args.join(" ").trim();

if (!query) {
	console.log("Usage: search.js <query> [-n <num>] [--json]");
	console.log("\nOptions:");
	console.log("  -n <num>       Number of results (default: 10, max: 50)");
	console.log("  --json         Output as JSON");
	console.log("\nEnvironment:");
	console.log("  KAGI_API_KEY   Required. Your Kagi API key.");
	console.log("\nExamples:");
	console.log('  search.js "rust programming"');
	console.log('  search.js "typescript decorators" -n 5');
	console.log('  search.js "weather tokyo" --json');
	process.exit(1);
}

const apiKey = process.env.KAGI_API_KEY;
if (!apiKey) {
	console.error("Error: KAGI_API_KEY environment variable is required.");
	console.error("Get your API key at: https://kagi.com/api/keys");
	process.exit(1);
}

async function searchKagi(query, limit) {
	const url = "https://kagi.com/api/v1/search";

	const response = await fetch(url, {
		method: "POST",
		headers: {
			"Authorization": `Bearer ${apiKey}`,
			"Content-Type": "application/json",
		},
		body: JSON.stringify({
			query,
			limit: Math.min(limit, 50),
		}),
	});

	if (!response.ok) {
		let errorText;
		try {
			const err = await response.json();
			errorText = err.error?.message || JSON.stringify(err);
		} catch {
			errorText = await response.text();
		}
		throw new Error(`HTTP ${response.status} ${response.statusText}\n${errorText}`);
	}

	const data = await response.json();

	// Extract results from the response
	const results = [];
	const searchResults = data?.data?.search || [];
	for (const result of searchResults.slice(0, limit)) {
		results.push({
			title: result.title || "",
			url: result.url || "",
			snippet: result.snippet || "",
		});
	}

	return results;
}

try {
	const results = await searchKagi(query, numResults);

	if (results.length === 0) {
		console.error("No results found.");
		process.exit(0);
	}

	if (outputJson) {
		console.log(JSON.stringify(results, null, 2));
	} else {
		for (let i = 0; i < results.length; i++) {
			const r = results[i];
			console.log(`--- Result ${i + 1} ---`);
			console.log(`Title: ${r.title}`);
			console.log(`URL: ${r.url}`);
			console.log(`Snippet: ${r.snippet}`);
			console.log("");
		}
	}
} catch (e) {
	console.error(`Error: ${e.message}`);
	process.exit(1);
}
