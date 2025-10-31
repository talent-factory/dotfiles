# Best Practices

Best Practices für effektive Nutzung von `/develop:implement-linear-issue` und Linear-Integration.

## Issue-Management

### Issue-Beschreibungen

**Do's ✅**:

```markdown
## User Story
As a user, I want to authenticate via OAuth2 so that I can securely access my account.

## Problem Statement
Currently, users can only log in with username/password, which:
- Lacks modern security features (2FA, SSO)
- Creates password management overhead
- Limits integration with third-party services

## Acceptance Criteria
- [ ] User can log in with Google OAuth2
- [ ] User can log in with GitHub OAuth2
- [ ] Session persists for 30 days
- [ ] User can log out and session is invalidated
- [ ] Failed login shows clear error message

## Technical Notes
- Use Passport.js for OAuth2 integration
- Store sessions in Redis
- Implement CSRF protection

## Affected Files
- src/auth/oauth2.ts
- src/routes/auth.ts
- src/config/passport.ts
```

**Don'ts ❌**:

```markdown
Add OAuth

Fix login
```

**Best Practice**:

- **Klare User Story** - Wer, Was, Warum
- **Spezifische Akzeptanzkriterien** - Testbar und messbar
- **Technical Context** - Hilft bei Implementierung
- **Affected Files** - Beschleunigt Onboarding

### Labels richtig setzen

**Do's ✅**:

**Typ-Labels** (genau eins):

- `feature` - Neue Funktionalität
- `bug` - Fehlerbehebung
- `enhancement` - Verbesserung existierender Features
- `refactor` - Code-Umstrukturierung
- `docs` - Dokumentation

**Bereich-Labels** (mehrere möglich):

- `frontend` - UI/UX-Änderungen
- `backend` - Server/API-Änderungen
- `database` - Schema/Query-Änderungen
- `infrastructure` - DevOps/Deployment

**Priorität** (genau eins):

- `critical` - Blocker, sofort beheben
- `high-priority` - Wichtig, zeitnah
- `medium-priority` - Normal
- `low-priority` - Nice-to-have

**Beispiel**:

```text
Issue: "Add OAuth2 Authentication"
Labels: feature, backend, high-priority
```

**Don'ts ❌**:

```text
Labels: important, todo, asap, needs-work
# → Zu vage, nicht standardisiert
```

### Prioritäten setzen

**Linear Priority System**:

| Priority | Wann verwenden | SLA |
|----------|---------------|-----|
| **Urgent (0)** | Production down, Security-Issue | Sofort |
| **High (1)** | Wichtige Features, grössere Bugs | Diese Woche |
| **Medium (2)** | Standard-Features, kleinere Bugs | Nächste 2 Wochen |
| **Low (3)** | Nice-to-have, Optimierungen | Backlog |
| **No priority (4)** | Ideen, nicht eingeplant | Irgendwann |

**Best Practice**:

- **Realistisch priorisieren** - Nicht alles "Urgent"
- **Kontext geben** - Warum diese Priorität?
- **Regelmässig reviewen** - Priorities ändern sich

## Branch-Management

### Branch-Naming

**Schema**: `<type>/<issue-id>-<description>`

**Types**:

- `feature/` - Neue Features
- `fix/` - Bug-Fixes
- `refactor/` - Code-Refactoring
- `docs/` - Dokumentation
- `test/` - Test-Änderungen

**Beispiele** ✅:

```bash
feature/proj-123-oauth2-authentication
fix/proj-456-session-timeout-bug
refactor/proj-789-auth-service-cleanup
docs/proj-012-api-documentation
```

**Beispiele** ❌:

```bash
daniels-branch
fix-stuff
proj-123
oauth
```

**Best Practice**:

- **Lowercase** - Konsistenz, einfacher zu tippen
- **Kebab-case** - Bindestriche statt Leerzeichen
- **Max. 50 chars** - Übersichtlich
- **Beschreibend** - Sofort klar, worum es geht

### Branch-Lifecycle

**1. Erstellung**:

```bash
# Immer von main/develop
git checkout main
git pull origin main
git checkout -b feature/proj-123-oauth2

# NICHT von anderem Feature-Branch
```

**2. Arbeit**:

```bash
# Regelmässig committen
git add .
git commit -m "✨ feat: Add Google OAuth2 strategy"

# Regelmässig pushen
git push origin feature/proj-123-oauth2

# Main einmergen (bei langer Entwicklung)
git checkout main
git pull origin main
git checkout feature/proj-123-oauth2
git merge main
```

**3. Abschluss**:

```bash
# PR erstellt → Branch bleibt
# PR gemerged → Branch löschen
git checkout main
git pull origin main
git branch -d feature/proj-123-oauth2
git push origin --delete feature/proj-123-oauth2
```

### Branch-Protection

**Best Practices**:

- ✅ **Regelmässig mit main synchronisieren** - Merge-Konflikte vermeiden
- ✅ **Nur eine Feature** - Atomic branches
- ✅ **Tests grün** - Vor Push sicherstellen
- ❌ **Lange lebende Branches vermeiden** - >2 Wochen = Problem

## Commit-Management

### Commit-Messages

**Format**: `<emoji> <type>: <description> (<issue-id>)`

**Beispiele** ✅:

```bash
✨ feat: Add OAuth2 authentication (PROJ-123)
🐛 fix: Resolve session timeout issue (PROJ-456)
♻️ refactor: Extract auth service (PROJ-789)
📚 docs: Update API documentation (PROJ-012)
🧪 test: Add OAuth2 integration tests (PROJ-123)
```

**Beispiele** ❌:

```bash
Update code
Fixed stuff
WIP
asdfasdf
```

**Best Practice**:

- **Atomic Commits** - Eine logische Änderung pro Commit
- **Imperative Mood** - "Add" nicht "Added"
- **Issue-ID einbinden** - Nachvollziehbarkeit
- **Beschreibend** - Was und Warum

### Commit-Häufigkeit

**Do's ✅**:

```bash
# Kleine, häufige Commits
git commit -m "✨ feat: Add OAuth2 config"
git commit -m "✨ feat: Add Google strategy"
git commit -m "✨ feat: Add GitHub strategy"
git commit -m "🧪 test: Add OAuth2 tests"
```

**Don'ts ❌**:

```bash
# Ein riesiger Commit nach 3 Tagen
git commit -m "✨ feat: Complete OAuth2 implementation"
# → 50 Dateien, 2000+ Zeilen
```

**Best Practice**:

- **Commit nach jedem logischen Schritt**
- **Commits sollten einzeln reviewbar sein**
- **Tests sollten nach jedem Commit grün sein**

## Testing

### Test-Coverage

**Mindest-Coverage**:

- **Neue Features**: 80%+
- **Bug-Fixes**: 100% (Bug + Fix covered)
- **Refactoring**: Keine Reduktion
- **Critical Paths**: 100%

**Best Practice**:

```javascript
// Für jede neue Funktion
describe('OAuth2Strategy', () => {
  // Happy Path
  it('should authenticate valid Google token', () => {
    // Test
  })

  // Edge Cases
  it('should reject invalid token', () => {
    // Test
  })

  it('should handle network errors', () => {
    // Test
  })

  it('should handle expired token', () => {
    // Test
  })
})
```

### Test-Typen

**Pyramide**:

```text
         / \
       /     \
      /  E2E  \      <- Wenige, wichtigste Flows
     /---------\
    /Integration\  <- Mittelviel, API-Tests
   /-------------\
  /  Unit Tests   \ <- Viele, alle Funktionen
 /-----------------\
```

**Best Practice**:

- **70% Unit Tests** - Schnell, isoliert
- **20% Integration Tests** - API, Services
- **10% E2E Tests** - Critical User Flows

### Akzeptanzkriterien als Tests

**Issue-AC**:

```markdown
- [ ] User can log in with Google
- [ ] User can log in with GitHub
- [ ] Session persists for 30 days
- [ ] User can log out
```

**Tests**:

```javascript
describe('OAuth2 Acceptance Criteria', () => {
  it('AC1: User can log in with Google', async () => {
    // Test implementation
  })

  it('AC2: User can log in with GitHub', async () => {
    // Test implementation
  })

  it('AC3: Session persists for 30 days', async () => {
    // Test implementation
  })

  it('AC4: User can log out', async () => {
    // Test implementation
  })
})
```

**Vorteil**:

- ✅ Alle ACs testbar
- ✅ 1:1 Mapping Issue → Tests
- ✅ Einfache Verifikation

## PR-Management

### PR-Grösse

**Ideal**: 150-400 Zeilen

**Zu gross** (>800 Zeilen):

```markdown
❌ Problem:
- Schwer zu reviewen
- Höhere Fehlerrate
- Längere Feedback-Loops

✅ Lösung:
- Feature in mehrere PRs aufteilen
- Separate PRs für Backend/Frontend
- Incremental Delivery
```

**Beispiel-Aufteilung**:

```markdown
Statt:
PR #1: Complete OAuth2 Implementation (2000 lines)

Besser:
PR #1: Add OAuth2 config and strategies (300 lines)
PR #2: Add OAuth2 routes and middleware (250 lines)
PR #3: Add OAuth2 tests (400 lines)
PR #4: Add OAuth2 documentation (150 lines)
```

### PR-Beschreibung

**Template** ✅:

```markdown
## Linear Issue
[PROJ-123: OAuth2 Authentication](https://linear.app/team/issue/PROJ-123)

## Summary
Implements OAuth2 authentication with Google and GitHub providers using Passport.js.

## Changes
- ✨ OAuth2 config and environment variables
- ✨ Google OAuth2 strategy
- ✨ GitHub OAuth2 strategy
- 🔒 Session handling with 30-day expiry
- 🧪 Integration and E2E tests (85% coverage)
- 📚 API documentation updated

## Test Plan
Based on Linear Issue acceptance criteria:

- [x] AC1: User can log in with Google
  - Manual: ✅ Tested in staging
  - Automated: ✅ oauth2.test.ts
- [x] AC2: User can log in with GitHub
  - Manual: ✅ Tested in staging
  - Automated: ✅ oauth2.test.ts
- [x] AC3: Session persists for 30 days
  - Automated: ✅ session.test.ts
- [x] AC4: User can log out
  - Manual: ✅ Tested in staging
  - Automated: ✅ oauth2.test.ts

## Screenshots
[Falls UI-Änderungen]

## Breaking Changes
None

## Migration Notes
Requires new environment variables:
- GOOGLE_CLIENT_ID
- GOOGLE_CLIENT_SECRET
- GITHUB_CLIENT_ID
- GITHUB_CLIENT_SECRET

## Reviewers
@alice - Backend review
@bob - Security review

## Linear Status
- Before: Backlog
- After: In Review
```

**Kurz** ❌:

```markdown
Add OAuth2

See Linear issue for details
```

### Review-Prozess

**Self-Review** (vor PR-Erstellung):

```bash
# 1. Code durchgehen
git diff main...HEAD

# 2. Checklist
- [ ] Alle Tests grün?
- [ ] Linting bestanden?
- [ ] Keine console.logs?
- [ ] Keine TODOs?
- [ ] Dokumentation aktualisiert?
- [ ] CHANGELOG aktualisiert?

# 3. Test Coverage prüfen
npm run test:coverage

# 4. Build erfolgreich?
npm run build
```

**Review anfordern**:

- **Experten taggen** - Backend, Frontend, Security
- **Context geben** - Was reviewen, worauf achten
- **Fragen stellen** - "Bessere Lösung für X?"

**Nach Review**:

- **Zeitnah Feedback umsetzen** - Innerhalb 24h
- **Diskussionen konstruktiv** - Begründungen geben
- **Re-Review anfragen** - Nach Änderungen

## Linear-Workflow

### Status-Transitions

**Typischer Flow**:

```markdown
Backlog → Todo → In Progress → In Review → Done
```

**Best Practice**:

| Status | Wann setzen | Durch |
|--------|-------------|-------|
| **Backlog** | Issue erstellt | PM/User |
| **Todo** | Sprint-Planning, priorisiert | PM |
| **In Progress** | Arbeit beginnt (Branch erstellt) | `/develop:implement-linear-issue` |
| **In Review** | PR erstellt | `/develop:implement-linear-issue` |
| **Done** | PR gemerged | Automatisch (GitHub Action) |

**Vermeiden**:

- ❌ Manuelles Hin-und-Her zwischen Status
- ❌ Issues über Wochen in "In Progress"
- ❌ "Done" ohne PR/Tests

### Comments & Updates

**Wann kommentieren**:

**Do's ✅**:

```markdown
# Bei Blocker
🚫 Blocked: Waiting for API key from DevOps team

# Bei wichtigen Entscheidungen
💡 Decision: Using Passport.js instead of custom OAuth2 implementation
Reason: Better maintained, more secure, community support

# Bei Scope-Änderungen
📝 Scope Update: Adding GitHub OAuth2 in addition to Google
Reason: User feedback from staging

# Bei Verzögerungen
⏰ Status Update: Will take 2 more days due to integration complexity
```

**Don'ts ❌**:

```markdown
# Spam
Working on it
Still working
Almost done
Done!
```

**Best Practice**:

- **Substantielle Updates** - Nur bei wichtigen Änderungen
- **@mentions nutzen** - Stakeholder benachrichtigen
- **Links einbinden** - PR, Docs, Staging-URL

### Issue-Linking

**In Commits**:

```bash
git commit -m "✨ feat: Add OAuth2 (PROJ-123)"
# → Automatischer Link in Linear
```

**In PR**:

```markdown
## Linear Issue
[PROJ-123: OAuth2 Authentication](https://linear.app/team/issue/PROJ-123)

Fixes PROJ-123
# → Automatisches Close bei Merge
```

**In Code**:

```javascript
// TODO(PROJ-124): Refactor session handling
// See: https://linear.app/team/issue/PROJ-124
```

**In Documentation**:

```markdown
## OAuth2 Authentication

Implemented in [PROJ-123](https://linear.app/team/issue/PROJ-123)
```

## Team-Workflows

### Daily Workflow

**Morgen**:

```bash
# 1. Linear Issues checken
# "What's assigned to me?"

# 2. Prioritäten setzen
# High-Priority Issues zuerst

# 3. Issue auswählen
/develop:implement-linear-issue

# 4. Status-Update geben
# Comment in Linear: "Starting work on PROJ-123"
```

**Während der Arbeit**:

```bash
# Regelmässig committen
# Regelmässig pushen
# Bei Blocker: Linear-Comment

# Tests laufen lassen
npm test

# Code-Qualität prüfen
npm run lint
```

**Abend**:

```bash
# 1. WIP committen/pushen
git push

# 2. Linear aktualisieren
# Comment: Progress-Update

# 3. Morgen planen
# Welches Issue als nächstes?
```

### Sprint-Planning

**Issue-Vorbereitung**:

- ✅ **Klare Beschreibung** - User Story, Problem, AC
- ✅ **Geschätzt** - Story Points / Hours
- ✅ **Priorisiert** - High/Medium/Low
- ✅ **Zugewiesen** - Klare Ownership
- ✅ **Dependencies** - Geblockt von / Blockt

**Sprint-Commitment**:

```markdown
# Sprint 23 (2 Wochen)

High-Priority:
- PROJ-123: OAuth2 Authentication (5 SP)
- PROJ-124: Dark Mode Toggle (3 SP)

Medium-Priority:
- PROJ-125: API Rate Limiting (5 SP)

Stretch Goals:
- PROJ-126: Export Feature (3 SP)

Total: 13-16 SP (Velocity: 15 SP/Sprint)
```

### Retrospektiven

**Was tracken**:

- ✅ **Velocity** - Story Points pro Sprint
- ✅ **Lead Time** - Todo → Done Dauer
- ✅ **Cycle Time** - In Progress → Done Dauer
- ✅ **PR Size** - Durchschnittliche Lines
- ✅ **Test Coverage** - Trend über Zeit

**Verbesserungen**:

```markdown
# Retro: Sprint 23

What went well:
✅ All PRs had good test coverage (85%+)
✅ Fast review times (<24h)
✅ Clear issue descriptions

What to improve:
❌ Some PRs too large (>800 lines)
❌ Delayed status updates in Linear
❌ Missing documentation in some PRs

Action Items:
- Split large features into multiple PRs
- Daily Linear updates (EOD)
- Documentation checklist in PR template
```

## Security Best Practices

### API Keys

**Do's ✅**:

```bash
# Environment Variables
export LINEAR_API_KEY="lin_api_xxx"

# .env File (in .gitignore!)
LINEAR_API_KEY=lin_api_xxx

# Secret Manager (Production)
aws secretsmanager get-secret-value \
  --secret-id prod/linear-api-key
```

**Don'ts ❌**:

```javascript
// Hardcoded
const API_KEY = "lin_api_xxx"  // ❌

// In Repository
git commit -m "Add API key"    // ❌

// In Logs
console.log(process.env.LINEAR_API_KEY)  // ❌
```

### Code Security

**Best Practice**:

- ✅ **Input Validation** - Alle User-Inputs
- ✅ **Output Encoding** - XSS-Prevention
- ✅ **CSRF Protection** - Für alle State-Changing Operations
- ✅ **Rate Limiting** - API-Endpoints schützen
- ✅ **Security Headers** - CSP, HSTS, etc.

### Dependency Security

```bash
# Regelmässig prüfen
npm audit

# Auto-Fix
npm audit fix

# Dependencies aktualisieren
npm update

# Outdated checken
npm outdated
```

## Performance Best Practices

### API-Calls

**Do's ✅**:

```javascript
// Batching
const issues = await getIssues({ ids: [1, 2, 3] })

// Caching
const cached = cache.get('my-issues')
if (cached) return cached

// Rate Limiting respektieren
await sleep(rateLimitDelay)
```

**Don'ts ❌**:

```javascript
// Einzelne Calls in Loop
for (const id of ids) {
  await getIssue(id)  // ❌ N+1 Problem
}

// Kein Caching
await getIssue(123)  // Jedes Mal neuer Call

// Rate Limit ignorieren
while (true) { await apiCall() }  // ❌
```

### Git Operations

**Do's ✅**:

```bash
# Shallow Clone (für CI)
git clone --depth 1

# Sparse Checkout (grosse Repos)
git sparse-checkout set src/

# Fetch statt Pull (wenn kein Merge nötig)
git fetch origin
```

**Don'ts ❌**:

```bash
# Komplette Historie clonen (10GB+)
git clone https://...  # ❌ bei grossen Repos

# Ungefiltered Commands
git log  # ❌ bei 100k+ commits
```

## Zusammenfassung

**Top 10 Best Practices**:

1. ✅ **Klare Issue-Beschreibungen** - User Story, Problem, AC
2. ✅ **Aussagekräftige Branch-Names** - `feature/proj-123-description`
3. ✅ **Atomic Commits** - Eine Änderung pro Commit
4. ✅ **Tests schreiben** - Mindestens 80% Coverage
5. ✅ **Kleine PRs** - 150-400 Zeilen ideal
6. ✅ **Linear synchron halten** - Status, Comments
7. ✅ **API Keys schützen** - Environment Variables
8. ✅ **Regelmässig committen/pushen** - Mindestens täglich
9. ✅ **Code-Quality prüfen** - Linting, Tests, Build
10. ✅ **Dokumentieren** - Code, PRs, Linear

**Siehe auch**:

- **[workflow.md](./workflow.md)** - Detaillierter Workflow
- **[linear-integration.md](./linear-integration.md)** - Linear Setup
- **[troubleshooting.md](./troubleshooting.md)** - Problem-Lösungen
