#!/usr/bin/env python3
"""Assigns a reviewer to a GitHub pull request using exponentially decayed load.

For each eligible reviewer r on @WebAssembly/binaryen-reviewers (excluding the
PR author):

  Score(r) = ReviewLoad(r) / weight(r) - AUTHORED_LOAD_WEIGHT * AuthoredLoad(r)

Each non-draft PR is weighted by log10(additions + ADDITIONS_OFFSET) and decays
exponentially with a 7-day half-life. With ADDITIONS_OFFSET = 10.0, a 0-line PR
has weight 1.0, a 100-line PR has weight ~2, and a 1,000-line PR has weight ~3.
Open unapproved reviews are weighted by PENDING_REVIEW_MULTIPLIER (2.0x). The
reviewer with the lowest score is assigned.
"""

import json
import math
import os
import subprocess
import sys
import time
from datetime import datetime, timezone

TEAM_SLUG = 'binaryen-reviewers'
AUTHORED_LOAD_WEIGHT = 0.75
PENDING_REVIEW_MULTIPLIER = 2.0
HALF_LIFE_DAYS = 7.0
SECONDS_PER_DAY = 86400.0
DECAY_RATE = math.log(2.0) / (HALF_LIFE_DAYS * SECONDS_PER_DAY)
ADDITIONS_OFFSET = 10.0
RECENT_PR_PAGE_SIZE = 50
RECENT_PR_PAGES = 2
MAX_API_ATTEMPTS = 3
RETRYABLE_ERRORS = (
    'HTTP 500',
    'HTTP 502',
    'HTTP 503',
    'HTTP 504',
    'Something went wrong while executing your query',
)

# Current UTC timestamp used as the reference point for exponential time decay.
now = datetime.now(timezone.utc).timestamp()

# Accumulated exponentially decayed review load per reviewer.
review_load: dict[str, float] = {}

# Number of review-requested PRs per reviewer.
review_count: dict[str, int] = {}

# Accumulated exponentially decayed authored-PR load per reviewer.
authored_load: dict[str, float] = {}

# Number of authored PRs per reviewer.
authored_count: dict[str, int] = {}

# Most recent review-request timestamp per reviewer, used for tie-breaking.
last_assigned: dict[str, float] = {}

# Fetches the reviewer team roster and target PR metadata so closed, draft, or
# already-assigned PRs can exit early without querying PR history.
SETUP_QUERY = """
query($owner: String!, $name: String!, $pr: Int!, $team: String!) {
  organization(login: $owner) {
    team(slug: $team) {
      members(first: 100) {
        nodes {
          login
        }
      }
    }
  }
  repository(owner: $owner, name: $name) {
    targetPR: pullRequest(number: $pr) {
      state
      isDraft
      author { login }
      reviewRequests(first: 20) {
        nodes {
          requestedReviewer {
            ... on User { login }
          }
        }
      }
      latestReviews(first: 20) {
        nodes {
          author { login }
          state
        }
      }
    }
  }
}
"""

# Fetches a page of recently updated PRs with their review and timeline state
# to compute exponentially decayed reviewer and author loads.
RECENT_PRS_QUERY = """
query($owner: String!, $name: String!, $pageSize: Int!, $cursor: String) {
  repository(owner: $owner, name: $name) {
    recentPRs: pullRequests(
      first: $pageSize
      after: $cursor
      orderBy: {field: UPDATED_AT, direction: DESC}
    ) {
      pageInfo {
        hasNextPage
        endCursor
      }
      nodes {
        number
        state
        isDraft
        createdAt
        additions
        author { login }
        latestReviews(first: 20) {
          nodes {
            author { login }
            state
          }
        }
        reviewRequests(first: 20) {
          nodes {
            requestedReviewer {
              ... on User { login }
            }
          }
        }
        timelineItems(first: 100, itemTypes: [REVIEW_REQUESTED_EVENT, READY_FOR_REVIEW_EVENT]) {
          nodes {
            __typename
            ... on ReviewRequestedEvent {
              createdAt
              requestedReviewer {
                ... on User { login }
              }
            }
            ... on ReadyForReviewEvent {
              createdAt
            }
          }
        }
      }
    }
  }
}
"""


def parse_iso(ts: str) -> float:
    return datetime.fromisoformat(ts.replace('Z', '+00:00')).timestamp()


def pr_weight(additions: int) -> float:
    return math.log10(additions + ADDITIONS_OFFSET)


def gh_api(args: list[str]) -> str:
    for attempt in range(1, MAX_API_ATTEMPTS + 1):
        res = subprocess.run(
            ['gh', 'api', *args],
            capture_output=True,
            text=True,
            check=False,
        )
        if res.returncode == 0:
            return res.stdout
        stderr = res.stderr.strip() if res.stderr else ''
        if attempt == MAX_API_ATTEMPTS or not any(
            err in stderr for err in RETRYABLE_ERRORS
        ):
            break
        delay = 2**attempt
        print(
            f'Transient GitHub API error ({stderr}); retrying in {delay}s...',
            file=sys.stderr,
        )
        time.sleep(delay)
    if stderr:
        print(stderr, file=sys.stderr)
    raise subprocess.CalledProcessError(
        res.returncode,
        res.args,
        output=res.stdout,
        stderr=res.stderr,
    )


def fetch_recent_prs(owner: str, name: str) -> list[dict]:
    prs: list[dict] = []
    seen: set[int] = set()
    cursor: str | None = None
    for _ in range(RECENT_PR_PAGES):
        args = [
            'graphql',
            '-f',
            f'query={RECENT_PRS_QUERY}',
            '-f',
            f'owner={owner}',
            '-f',
            f'name={name}',
            '-F',
            f'pageSize={RECENT_PR_PAGE_SIZE}',
        ]
        if cursor is not None:
            args.extend(['-f', f'cursor={cursor}'])
        page = json.loads(gh_api(args))['data']['repository']['recentPRs']
        for pr in page['nodes']:
            if pr['number'] not in seen:
                seen.add(pr['number'])
                prs.append(pr)
        if not page['pageInfo']['hasNextPage']:
            break
        cursor = page['pageInfo']['endCursor']
    return prs


def accumulate_pr_activity(pr: dict, reviewer_set: set[str]) -> None:
    author = pr['author']['login'] if pr['author'] else ''
    created_at = parse_iso(pr['createdAt'])
    timeline = pr['timelineItems']['nodes']

    # Use the last ReadyForReviewEvent if the PR was ever a draft.
    active_at = next(
        (
            parse_iso(e['createdAt'])
            for e in reversed(timeline)
            if e['__typename'] == 'ReadyForReviewEvent'
        ),
        created_at,
    )
    w_pr = pr_weight(pr['additions'])

    if author in reviewer_set:
        age = max(0.0, now - active_at)
        authored_load[author] += w_pr * math.exp(-DECAY_RATE * age)
        authored_count[author] += 1

    # Track which reviewers have reviewed or approved so we can ignore removed
    # unreviewed requests and drop PENDING_REVIEW_MULTIPLIER on approved PRs.
    reviewed_by: set[str] = set()
    approved_by: set[str] = set()
    for rev in pr['latestReviews']['nodes']:
        if rev['author'] and rev['state'] != 'PENDING':
            r_login = rev['author']['login']
            reviewed_by.add(r_login)
            if rev['state'] == 'APPROVED':
                approved_by.add(r_login)

    currently_requested = {
        n['requestedReviewer'].get('login')
        for n in pr['reviewRequests']['nodes']
        if n['requestedReviewer']
    } - {None}

    # Track the earliest ReviewRequestedEvent per reviewer for decay timestamps.
    first_requested_at: dict[str, float] = {}
    for e in timeline:
        if e['__typename'] == 'ReviewRequestedEvent' and e['requestedReviewer']:
            r_login = e['requestedReviewer'].get('login')
            if r_login in reviewer_set and r_login != author:
                first_requested_at.setdefault(r_login, parse_iso(e['createdAt']))

    for r, assign_ts in first_requested_at.items():
        if r not in currently_requested and r not in reviewed_by:
            continue
        last_assigned[r] = max(last_assigned[r], assign_ts)
        # Open unapproved reviews count extra toward review load.
        is_pending = (
            pr['state'] == 'OPEN'
            and r in currently_requested
            and r not in approved_by
        )
        mult = PENDING_REVIEW_MULTIPLIER if is_pending else 1.0
        age = max(0.0, now - assign_ts)
        review_load[r] += mult * w_pr * math.exp(-DECAY_RATE * age)
        review_count[r] += 1


# Load per-reviewer weight overrides from REVIEWER_WEIGHTS (JSON object mapping
# GitHub login -> float, defaulting to 1.0). Because review_load is divided by
# weight, a weight of 0.5 halves a reviewer's review rate, 2.0 doubles it, and
# <= 0 excludes them from assignment.
def load_weights(reviewers: list[str]) -> dict[str, float]:
    raw_weights = os.environ.get('REVIEWER_WEIGHTS', '').strip()
    if not raw_weights:
        return dict.fromkeys(reviewers, 1.0)
    try:
        overrides = json.loads(raw_weights)
        if not isinstance(overrides, dict):
            raise TypeError
        return {r: float(overrides.get(r, 1.0)) for r in reviewers}
    except (json.JSONDecodeError, ValueError, TypeError):
        # Avoid printing raw_weights in tracebacks so secrets are never leaked.
        sys.exit('Invalid REVIEWER_WEIGHTS secret format.')


def main() -> None:
    owner, name = os.environ['GITHUB_REPOSITORY'].split('/', 1)
    pr_number = int(os.environ['PR_NUMBER'])

    data = json.loads(
        gh_api([
            'graphql',
            '-f',
            f'query={SETUP_QUERY}',
            '-f',
            f'owner={owner}',
            '-f',
            f'name={name}',
            '-F',
            f'pr={pr_number}',
            '-f',
            f'team={TEAM_SLUG}',
        ]),
    )['data']

    org = data['organization']
    team = org['team'] if org else None
    if not team:
        sys.exit(
            f'Could not fetch team {owner}/{TEAM_SLUG}; check GH_TOKEN permissions.',
        )
    reviewers = [m['login'] for m in team['members']['nodes']]
    reviewer_set = set(reviewers)
    weights = load_weights(reviewers)

    repo_data = data['repository']
    target = repo_data['targetPR']
    if not target or target['state'] != 'OPEN' or target['isDraft']:
        print(f'PR #{pr_number} is not an open non-draft PR; skipping.')
        return

    pr_author = target['author']['login'] if target['author'] else ''

    # Skip if another team member is already requested or has already reviewed.
    existing_users = {
        n['requestedReviewer'].get('login')
        for n in target['reviewRequests']['nodes']
        if n['requestedReviewer']
    } - {None}
    reviewed_users = {
        n['author']['login']
        for n in target['latestReviews']['nodes']
        if n['author'] and n['state'] != 'PENDING'
    }
    if ((existing_users | reviewed_users) - {pr_author}) & reviewer_set:
        print(f'PR #{pr_number} already has a team reviewer assigned; skipping.')
        return

    # Exclude the PR author and any reviewer with a non-positive weight.
    eligible = [r for r in reviewers if r != pr_author and weights[r] > 0]
    if not eligible:
        print(f'No eligible reviewers for PR #{pr_number} (author={pr_author}).')
        return

    recent_prs = fetch_recent_prs(owner, name)

    review_load.update(dict.fromkeys(reviewers, 0.0))
    review_count.update(dict.fromkeys(reviewers, 0))
    authored_load.update(dict.fromkeys(reviewers, 0.0))
    authored_count.update(dict.fromkeys(reviewers, 0))
    last_assigned.update(dict.fromkeys(reviewers, 0.0))
    for pr in recent_prs:
        if not pr['isDraft'] and pr['number'] != pr_number:
            accumulate_pr_activity(pr, reviewer_set)

    scores = {
        r: review_load[r] / weights[r] - AUTHORED_LOAD_WEIGHT * authored_load[r]
        for r in eligible
    }
    # Break ties by least-recently-assigned reviewer, then team member order.
    ranked = sorted(
        eligible,
        key=lambda r: (
            round(scores[r], 6),
            last_assigned[r],
            reviewers.index(r),
        ),
    )
    print('Candidate reviewers:')
    for r in ranked:
        print(
            f'  {r}: score={scores[r]:.2f} '
            f'(review_requests={review_count[r]}, review_load={review_load[r]:.2f}, '
            f'authored={authored_count[r]}, authored_load={authored_load[r]:.2f})',
        )
    chosen = ranked[0]
    print(f'Selected reviewer for PR #{pr_number}: {chosen}')

    gh_api([
        '--method',
        'POST',
        f'repos/{owner}/{name}/pulls/{pr_number}/requested_reviewers',
        '-f',
        f'reviewers[]={chosen}',
    ])


if __name__ == '__main__':
    main()
