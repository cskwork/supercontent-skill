#!/usr/bin/env node
// readlevel-gate - deterministic read-level check for Korean educational text by grade band.
// Korean has no single canonical readability formula, so this uses transparent, auditable proxies:
//   1. sentence length in 어절 (space tokens) - average + hard cap per band
//   2. over-range vocabulary - words listed in reference/vocab-tiers/<band>-overrange.txt
// It flags text that reads too hard for the declared band. It is a FLOOR, not a substitute for the
// edu-critic's judgment of naturalness. NEVER edit thresholds to pass - simplify the writing.
//
// Per-line escape hatch: "edu-ok" on a line suppresses its over-range vocab hits (e.g. a term the
// lesson is explicitly teaching and defines in place). Sentence-length caps are not suppressible.
//
// Usage: node readlevel-gate.mjs --band <초저|초고|중|고> <file.md|.txt|.html> [<file> ...]
// Exit 0 = within band. Exit 1 = over range. Exit 2 = usage/read error.

import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));

function usage(msg) {
  if (msg) console.error(`readlevel-gate: ${msg}`);
  console.error("usage: node readlevel-gate.mjs --band <초저|초고|중|고> <file> [<file> ...]");
  process.exit(2);
}

// avg = target average 어절/sentence; cap = hard max for any single sentence.
const BANDS = {
  "초저": { avg: 7, cap: 12 },
  "초고": { avg: 10, cap: 18 },
  "중": { avg: 14, cap: 26 },
  "고": { avg: 20, cap: 40 },
};

const argv = process.argv.slice(2);
let band = null;
const files = [];
for (let i = 0; i < argv.length; i++) {
  if (argv[i] === "--band") { band = argv[++i]; continue; }
  files.push(argv[i]);
}
if (!band || !BANDS[band]) usage(`--band must be one of: ${Object.keys(BANDS).join(", ")}`);
if (files.length === 0) usage("missing <file>");

let overrange = [];
try {
  overrange = readFileSync(resolve(HERE, `../reference/vocab-tiers/${band}-overrange.txt`), "utf8")
    .split(/\r?\n/).map((s) => s.trim()).filter((s) => s && !s.startsWith("#"));
} catch { /* no list for this band -> vocab check skipped */ }

// Strip markdown/html/code so we measure prose, not markup.
function toProse(text) {
  return text
    .replace(/```[\s\S]*?```/g, " ")     // fenced code
    .replace(/`[^`]*`/g, " ")             // inline code
    .replace(/<[^>]+>/g, " ")             // html tags
    .replace(/!?\[([^\]]*)\]\([^)]*\)/g, "$1") // md links/images -> text
    .replace(/[#>*_~|-]/g, " ");
}

const { avg, cap } = BANDS[band];
const findings = [];
let totalEojeol = 0;
let totalSentences = 0;
let read = 0;

for (const file of files) {
  let raw;
  try { raw = readFileSync(file, "utf8"); }
  catch (e) { console.error(`readlevel-gate: cannot read ${file}: ${e.message}`); continue; }
  read++;
  const prose = toProse(raw);
  const sentences = prose.split(/[.!?。…\n]+/).map((s) => s.trim()).filter((s) => s.length > 1);
  for (const s of sentences) {
    const eojeol = s.split(/\s+/).filter(Boolean).length;
    if (eojeol < 1) continue;
    totalSentences++;
    totalEojeol += eojeol;
    if (eojeol > cap) findings.push(`${file}: sentence over hard cap (${eojeol} > ${cap} 어절): "${s.slice(0, 50)}…"`);
  }
  // over-range vocab (line-based so edu-ok can suppress a taught term)
  raw.split(/\r?\n/).forEach((line, i) => {
    if (/edu-ok/i.test(line)) return;
    for (const w of overrange) if (line.includes(w)) findings.push(`${file}:${i + 1}: over-range word for ${band}: "${w}"`);
  });
}

if (read === 0) usage("no readable files");

const meanEojeol = totalSentences ? (totalEojeol / totalSentences) : 0;
if (totalSentences > 0 && meanEojeol > avg) {
  findings.unshift(`average sentence length ${meanEojeol.toFixed(1)} 어절 exceeds band target ${avg} for ${band}`);
}

if (findings.length > 0) {
  console.log("== READLEVEL GATE: FAIL ==");
  for (const f of findings) console.log(`  ${f}`);
  console.log(`\n${findings.length} issue(s); mean ${meanEojeol.toFixed(1)} 어절 over ${totalSentences} sentence(s) in ${read} file(s).`);
  console.log("Simplify the writing, not this gate.");
  process.exit(1);
}

console.log(`== READLEVEL GATE: PASS == (band ${band}, mean ${meanEojeol.toFixed(1)} 어절, ${totalSentences} sentence(s), ${read} file(s))`);
process.exit(0);
