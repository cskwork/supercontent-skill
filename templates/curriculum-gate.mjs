#!/usr/bin/env node
// curriculum-gate - deterministic detector for 성취기준 (achievement-standard) alignment.
// The Builder declares what standard a piece teaches in curriculum-claims.json; THIS script
// verifies the declaration against the shipped reference/curriculum-index.json (the current-year
// 2022 개정 lookup) and the official code format. The Builder cannot claim "맞는 학년" by eyeball.
// NEVER edit this script (or the index) to make a mismatched claim pass - fix the content/claim.
//
// Usage: node curriculum-gate.mjs <curriculum-claims.json> [<curriculum-index.json>]
//   index defaults to ../reference/curriculum-index.json relative to this script.
// Exit 0 = aligned. Exit 1 = violation. Exit 2 = usage/read error.

import { readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));

function usage(msg) {
  if (msg) console.error(`curriculum-gate: ${msg}`);
  console.error("usage: node curriculum-gate.mjs <curriculum-claims.json> [<curriculum-index.json>]");
  process.exit(2);
}

// Official 2022 개정 성취기준 code shapes:
//   초/중: [2국01-01], [6과05-01], [9사03-02]   (과목 + 영역2자리 - 순번2자리)
//   고 공통: [10공국1-01-01]                     (공통과목번호 - 영역2자리 - 순번2자리)
const CODE_RE = /^\[\d{1,2}[가-힣]{1,3}\d{1,2}-\d{2}(-\d{2})?\]$/;

// Leading number of a code = the top grade of its 학년군. Map to a band.
function bandFromCodeNumber(n) {
  if (n === 2) return "초저";       // 초1-2
  if (n === 4 || n === 6) return "초고"; // 초3-6
  if (n === 9) return "중";          // 중1-3
  if (n >= 10) return "고";          // 고등
  return null;
}

// Normalize a declared grade ("초5", "초등 5학년", "초고", "중2", "고1") to a band.
function bandFromGrade(grade) {
  const g = String(grade).replace(/\s|학년|등/g, "");
  if (g.includes("초저")) return "초저";
  if (g.includes("초고")) return "초고";
  if (/^고|^고$|고[1-3]/.test(g) || g.startsWith("고")) return "고";
  if (g.startsWith("중")) return "중";
  const m = g.match(/초?([1-6])/);
  if (m) return Number(m[1]) <= 2 ? "초저" : "초고";
  return null;
}

const claimsPath = process.argv[2];
if (!claimsPath) usage("missing <curriculum-claims.json>");
const indexPath = process.argv[3] || resolve(HERE, "../reference/curriculum-index.json");

let claims, index;
try { claims = JSON.parse(readFileSync(claimsPath, "utf8")); }
catch (e) { usage(`cannot read claims: ${e.message}`); }
try { index = JSON.parse(readFileSync(indexPath, "utf8")); }
catch (e) { usage(`cannot read index: ${e.message}`); }

const codes = (index && index.codes) || {};
const entries = Array.isArray(claims) ? claims : [claims];

const findings = [];
entries.forEach((c, i) => {
  const at = `claim[${i}]`;
  if (!c || typeof c !== "object") { findings.push(`${at}: not an object`); return; }
  const { grade, subject, standard_code, objective } = c;

  if (!standard_code) { findings.push(`${at}: missing standard_code (declare the 성취기준, or flag closest for teacher)`); return; }
  if (!CODE_RE.test(standard_code)) { findings.push(`${at}: standard_code "${standard_code}" is not a valid 성취기준 code shape [NN과NN-NN]`); }

  const entry = codes[standard_code];
  if (!entry) {
    findings.push(`${at}: standard_code "${standard_code}" not found in curriculum-index.json (${index.version || "?"}). If it is real, add it to the index; do not invent codes.`);
    return; // can't cross-check grade/subject without the entry
  }

  const leadNum = Number(String(standard_code).match(/\d{1,2}/)[0]);
  const codeBand = bandFromCodeNumber(leadNum);
  const declBand = bandFromGrade(grade);
  if (declBand && codeBand && declBand !== codeBand) {
    findings.push(`${at}: declared grade "${grade}" (band ${declBand}) does not match code band ${codeBand} for ${standard_code}`);
  }
  if (entry.gradeBand && declBand && entry.gradeBand !== declBand) {
    findings.push(`${at}: declared grade "${grade}" (band ${declBand}) does not match index gradeBand ${entry.gradeBand} for ${standard_code}`);
  }
  if (subject && entry.subject && subject !== entry.subject) {
    findings.push(`${at}: declared subject "${subject}" does not match index subject "${entry.subject}" for ${standard_code}`);
  }
  if (!objective || String(objective).trim().length < 8) {
    findings.push(`${at}: objective missing or too thin (state what the learner will be able to do, tied to ${standard_code})`);
  }
});

if (findings.length > 0) {
  console.log("== CURRICULUM GATE: FAIL ==");
  for (const f of findings) console.log(`  ${f}`);
  console.log(`\n${findings.length} violation(s) across ${entries.length} claim(s).`);
  console.log("Fix the content/claim, not this gate.");
  process.exit(1);
}

console.log(`== CURRICULUM GATE: PASS == (${entries.length} claim(s), index ${index.version || "?"} ${index.year || ""})`);
process.exit(0);
