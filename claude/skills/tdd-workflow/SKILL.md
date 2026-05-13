---
name: tdd-workflow
description: Test-first implementation. Use when adding non-trivial behavior — anything with branches, error paths, or external interactions.
auto-load: false
---

# TDD Workflow

A disciplined red-green-refactor loop for adding new behavior.

## When to use

- Implementing a new function or method with non-trivial logic
- Fixing a bug (write the regression test first)
- Adding a new code path through existing code

## When *not* to use

- Throwaway scripts
- Pure refactors with no behavior change (existing tests should already cover this)
- Trivial changes (one-line fix, style edit, doc update)
- Exploratory prototyping where the interface isn't even decided yet

## The loop

### 1. Define the interface

Before any code: state the function's signature, inputs, outputs, and error cases. One paragraph or a typed declaration.

```typescript
// Validates an email per RFC 5322 (basic subset).
// Returns { valid: true, normalized } or { valid: false, reason }.
function validateEmail(input: string): ValidationResult
```

If the interface keeps changing as you write tests, slow down — that's a design signal, not a TDD problem.

### 2. Write the failing test

```typescript
test('rejects email without @', () => {
  expect(validateEmail('foo')).toEqual({ valid: false, reason: 'missing @' });
});
```

Run it. Confirm it fails — and that the failure is "function not implemented" or "wrong return," not "test syntax error."

### 3. Implement minimally

Just enough to pass. Don't anticipate the next test.

```typescript
function validateEmail(input: string) {
  if (!input.includes('@')) return { valid: false, reason: 'missing @' };
  return { valid: true, normalized: input };
}
```

Run the test. It passes.

### 4. Run all tests

Make sure you didn't break anything.

```bash
npm test
```

### 5. Refactor (if needed)

Clean up while green. Rename, extract, simplify. Run tests after each change. Don't add features and refactor in the same step.

### 6. Repeat

Next behavior, next failing test. One thing at a time.

## What "minimal" means

You can game minimality (`return cases[input]` for hardcoded test inputs). Don't. The point is **don't write code the tests don't justify** — but the implementation should be a reasonable, generalizable shape from the start.

If the test requires "validates email format," your implementation should look like an email validator, not a hardcoded lookup.

## When tests become hard to write

Read the resistance:

- **Lots of setup needed** → the function is too coupled. Inject dependencies.
- **Need to mock everything** → the function is doing too many things. Split.
- **Tests pass without the implementation** → your test isn't actually testing the behavior. Refine.
- **You can't decide what to test** → the interface isn't defined. Stop coding, define the interface.

## Output structure

When using this skill, structure responses by step:

```
Step 1 (interface): <signature and contract>
Step 2 (red): <test code, run output showing FAIL>
Step 3 (green): <implementation diff, run output showing PASS>
Step 4 (all tests): <full test run output>
Step 5 (refactor, if any): <diff>
```

This makes the loop visible, which is the whole point.

## Handoff

After the cycle, summarize:
- What behavior is now covered
- What's still un-covered
- What the next test would be (so the user can decide whether to continue)
