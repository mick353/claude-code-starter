# Testing

Tests are the cheapest verification mechanism you have. Skipping them costs more than writing them, especially with AI-generated code where the model might confidently produce wrong-but-plausible logic.

## TDD as default

For any non-trivial behavior:

1. **Define the interface** — function signature, expected inputs, expected outputs.
2. **Write the failing test** — the test should fail because the implementation isn't there, not because the test is broken.
3. **Implement minimally** — just enough to pass.
4. **Refactor** — clean up while green.
5. **Repeat** for the next behavior.

You don't have to TDD every line. Prototypes, throwaway scripts, exploration — skip it. Production code paths, library functions, anything you'll regret if it breaks — TDD it.

## What "non-trivial" means here

- Has more than one branch
- Has any error handling
- Touches external systems (DB, API, filesystem)
- Will be called from multiple places

If a function is a 3-line transformation that is obviously correct from inspection, you don't need a test. If it has a single `if/else`, you do.

## Coverage targets

- **Touched files in a PR:** keep coverage flat or improve it.
- **Library / shared code:** ≥ 80% line coverage, with branch coverage on critical paths.
- **App / glue code:** lower bar, but every code path that handles errors should be exercised.

Coverage is a floor, not a goal. 100% coverage of trivial getters tells you nothing. 60% coverage that hits every error path is gold.

## What a good test looks like

- **One behavior per test.** A test named `validates email` should test exactly that.
- **Assertions describe the contract**, not the implementation. `expect(result.email).toBe(normalized)` over `expect(internalCallCount).toBe(3)`.
- **No shared mutable state** between tests. Each test sets up what it needs and tears down.
- **Fast.** Unit tests should be sub-millisecond. Integration tests sub-second. End-to-end tests sub-minute.
- **Deterministic.** No `Date.now()`, no random IDs, no network. Inject those.

## What a bad test looks like (and Claude often produces)

- A test that asserts only "doesn't throw."
- A test that re-implements the function under test, then asserts they match.
- A test that mocks so much that you're testing the mock, not the code.
- A test named `tests user logic` that has 40 assertions covering 8 cases.

If Claude generates one of these, push back: "split this into one assertion per behavior, with descriptive names."

## End-to-end vs unit

You want both, in different proportions:

- **Unit tests** — most of your tests. Cheap, fast, narrow.
- **Integration tests** — fewer. Test that two units work together correctly.
- **E2E tests** — fewest. Test critical user journeys end-to-end (signup → first action → key conversion).

Don't try to E2E-test everything. The maintenance cost is enormous and the signal-to-noise is poor. E2E covers the few flows where total system correctness matters more than any individual component.

## Tests as documentation

A reader of your test suite should be able to learn what the system does. If they can't, your tests are too low-level. Names matter:

```
✓ validates email format          // good
✓ test1                            // bad
✓ should return true when email   // bad — describes implementation
```

## When tests fail

- **First, read the assertion.** Many "test failures" are tests catching real bugs.
- **Don't relax the assertion to make it pass.** If the test is wrong, fix it intentionally with a comment explaining why.
- **Don't add a new test that passes** instead of fixing the failing one. The failing one is telling you something.
