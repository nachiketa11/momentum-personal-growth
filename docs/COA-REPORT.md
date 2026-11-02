# Binary Progress Engine — COA Report Draft

> Academic report draft for the Momentum personal growth application. Replace placeholders with verified implementation evidence before submission.

## Abstract

This project demonstrates how a seven-day progress week can be represented as a compact binary word and manipulated with fundamental bitwise operations. Each bit corresponds to one day of the week. The model is intended as an educational visualization and a deterministic way to combine weekly completion patterns.

## Representation

The least significant bit represents Monday and the most significant used bit represents Sunday. A set bit means at least one habit check-in was recorded for that date. The valid mask is `0b1111111` (`0x7F`), so values are restricted to seven bits. This daily indicator does not encode how many habits were completed.

## Operations to demonstrate

- **AND:** `A & B` identifies days set in both patterns.
- **OR:** `A | B` combines days set in either pattern.
- **XOR:** `A ^ B` identifies days where the patterns differ.
- **Masked NOT:** `(~A) & 0x7F` complements only the seven modeled day bits.
- **Left shift:** `(A << n) & 0x7F` moves progress toward later day positions while discarding bits beyond the week.

## JavaScript semantics

JavaScript `number` bitwise operators convert operands to signed 32-bit integers. `~` complements all 32 bits, and `<<` uses a shift count reduced modulo 32. Therefore this application must mask results with `0x7F` and validate the shift count and input range. The seven-bit mask is part of the model, not an automatic JavaScript behavior.

## Results

- Verified unit test result (Node.js v24.16.0, 1 November 2026): **6 passed, 0 failed** using `npm test`. Tests cover AND, OR, XOR, masked NOT, left-shift overflow, Monday-first bit extraction, and invalid input rejection.
- `npm run lint`: **passed** with Next.js ESLint flat config.
- `npm run typecheck`: **passed** with TypeScript 5.9.3.
- `npm run build`: **passed** with Next.js 16.4.3; `/` and `/_not-found` were prerendered.

## Evidence

- COA operation walkthrough screenshot: **[PLACEHOLDER — agent-browser is unavailable and local HTTP requests are blocked by the execution environment; insert a verified screenshot after manual/browser verification]**
- Test output screenshot or captured report: **[PLACEHOLDER — insert verified output if required by the course]**
- Deployment screenshot: **[PLACEHOLDER — insert only after deployment verification]**

## Limitations and future work

Progress bits record only whether a day has progress. They do not represent duration, habit quality, or causal effects. User data and analytics must be protected by authenticated access and database row-level security in the completed application.
