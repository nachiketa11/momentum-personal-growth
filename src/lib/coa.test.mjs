import test from "node:test";
import assert from "node:assert/strict";
import { andDays, orDays, xorDays, notDays, shiftDays, toWeekBits, WEEK_MASK } from "./coa.mjs";

test("AND keeps days shared by both weeks", () => assert.equal(andDays(0b0011011, 0b0010110), 0b0010010));
test("OR combines days and XOR keeps differences", () => {
  assert.equal(orDays(0b0011011, 0b0010110), 0b0011111);
  assert.equal(xorDays(0b0011011, 0b0010110), 0b0001101);
});
test("NOT is masked to seven bits", () => assert.equal(notDays(0b0000011), 0b1111100));
test("left shift drops progress beyond the week", () => assert.equal(shiftDays(0b1000001, 1), 0b0000010));
test("bits are returned Monday-first from least significant bit", () => assert.deepEqual(toWeekBits(0b1000001), [1, 0, 0, 0, 0, 0, 1]));
test("invalid words and shifts are rejected", () => {
  assert.throws(() => andDays(-1, 1), RangeError);
  assert.throws(() => shiftDays(1, 32), RangeError);
  assert.equal(WEEK_MASK, 127);
});
