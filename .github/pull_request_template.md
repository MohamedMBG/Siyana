## Summary

<!-- What changes and why, in one to three sentences. -->

## CDC traceability

- Requirement IDs: <!-- e.g. INT-05, R03 -->
- CDC version: <!-- validated tag -->
- Deviation from the CDC: none <!-- or link to the approved cdc-change ticket -->

## Changes

<!-- Behaviour changes, grouped by module. Link the ticket. -->

## Verification

<!-- Commands run and their real results. Screenshots or a recording for UI. -->

## Impact

- Data and migrations:
- Sync protocol and local mobile data:
- Permissions and security:
- Documentation and ADR updated:

## Author checklist

- [ ] I reviewed every line of this diff and can explain each one.
- [ ] Every acceptance criterion has an automated test and quality gates are green.
- [ ] No debt markers, commented-out code, skipped tests or unjustified suppressions.
- [ ] No secrets, no real personal data, no confidential documents.
- [ ] Nothing in code, comments, names, commits or this description refers to authoring tools.
- [ ] The traceability matrix and affected docs are updated.

## Reviewer checklist

- [ ] CDC conformity: criteria met, nothing extra.
- [ ] Tests are meaningful and cover failure, concurrency and offline cases where relevant.
- [ ] Authorization, validation and data safety checked.
- [ ] Migrations, sync and local data impact checked.
- [ ] Readability, naming and module boundaries are acceptable.
- [ ] Ran the change locally if it touches sync, stock, permissions or KPI.
