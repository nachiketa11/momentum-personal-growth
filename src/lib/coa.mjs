export const WEEK_MASK = 0b1111111;

function assertWeek(value, label) {
  if (!Number.isInteger(value) || value < 0 || value > WEEK_MASK) {
    throw new RangeError(`${label} must be an integer from 0 through 127`);
  }
}

export function andDays(a, b) { assertWeek(a, "a"); assertWeek(b, "b"); return a & b; }
export function orDays(a, b) { assertWeek(a, "a"); assertWeek(b, "b"); return a | b; }
export function xorDays(a, b) { assertWeek(a, "a"); assertWeek(b, "b"); return a ^ b; }
export function notDays(a) { assertWeek(a, "a"); return (~a) & WEEK_MASK; }
export function shiftDays(a, positions) {
  assertWeek(a, "a");
  if (!Number.isInteger(positions) || positions < 0 || positions > 7) {
    throw new RangeError("positions must be an integer from 0 through 7");
  }
  return (a << positions) & WEEK_MASK;
}
export function toWeekBits(value) {
  assertWeek(value, "value");
  return Array.from({ length: 7 }, (_, day) => (value >> day) & 1);
}
