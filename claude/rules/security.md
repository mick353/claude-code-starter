# Security

Mandatory checks. Apply on every code change without being asked.

## Secrets

- **Never** put a secret in source. No API keys, no passwords, no tokens, no private URLs with creds embedded.
- Use environment variables loaded at runtime. Never log them.
- `.env` files are git-ignored. Verify before committing.
- If you suspect a secret was committed, **rotate it** before doing anything else. The git history is permanent; assume it's already scraped.

Common patterns to watch for in source files:
- Strings of 32+ alphanumeric chars near the words "key", "token", "secret", "password"
- AWS-style `AKIA...` patterns
- GitHub-style `ghp_`, `gho_`, `ghs_`, `ghu_`, `ghr_` prefixes
- Anthropic-style `sk-ant-...`, OpenAI-style `sk-...`
- Connection strings with embedded passwords (`postgres://user:pass@host/db`)

If any of these appear in a diff, stop and confirm with the user before proceeding.

## Input validation

Every external input is hostile until proven otherwise.

- **HTTP request bodies, query params, headers** — validate against a schema (Zod, Pydantic, JSON Schema) before use.
- **File uploads** — verify content type and size; never trust the client-declared type.
- **URLs from users** — validate scheme; never fetch arbitrary URLs server-side without an allowlist (SSRF).
- **SQL** — parameterized queries always. Never string-concatenate into SQL.
- **Shell** — never pass user input directly to a shell. Use safe APIs that take args separately.
- **Filesystem paths** — reject `..`, absolute paths, symlinks; canonicalize before use.

## Authentication and authorization

- **Authentication** answers "who are you?" — verify identity (session, JWT, OAuth).
- **Authorization** answers "are you allowed?" — separate check, on every protected operation.

Never trust a "logged in" flag without checking what they're allowed to do for *this specific resource*. Common bug: a user can read their own data; the auth check is "logged in," and now any user can read any other user's data by changing the ID in the URL.

## Cryptography

- Don't roll your own crypto. Use vetted libraries (libsodium, the language standard library's modern primitives).
- Don't use MD5 or SHA1 for anything security-related. Use SHA-256+ for hashes, bcrypt/scrypt/argon2 for passwords.
- Don't use ECB mode. If the library makes you choose, you probably want GCM or CTR with a unique nonce.
- Don't compare secrets with `==`. Use a constant-time comparison.

## Common web vulns

- **XSS** — escape user content rendered in HTML. Use the framework's safe-by-default rendering.
- **CSRF** — use SameSite cookies and CSRF tokens for state-changing requests.
- **SSRF** — never let user input choose what URL the server fetches.
- **Open redirect** — validate redirect URLs against an allowlist.
- **IDOR** — every resource access checks the actor is authorized for *that resource*, not just authenticated.

## Dependencies

- Pin versions in lockfiles.
- Run dependency audit (`npm audit`, `pip-audit`, `cargo audit`) regularly.
- Don't add a new dependency for something the standard library does in 5 lines.

## Logging

- Log enough to debug and audit.
- Never log secrets, passwords, full tokens, full credit-card numbers, full SSNs.
- Log identifiers (user IDs, request IDs), not personal data, where possible.

## When in doubt

Two questions:

1. **What's the worst case if this input is malicious?** If the answer is "RCE / data leak / privilege escalation", the guard has to be paranoid.
2. **What does the framework / library handle for me already?** Many issues (XSS, parameterized SQL, secure cookie defaults) are solved if you use the framework's idiomatic API. Going around it is the most common security regression.
