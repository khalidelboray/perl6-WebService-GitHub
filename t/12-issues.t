use Test;
# -*- mode: perl6 -*-
use WebService::GitHub;
use WebService::GitHub::Issues;

ok(1);
my $gh = WebService::GitHub.new;

if ((%*ENV<TRAVIS> && $gh.rate-limit-remaining()) || %*ENV<GH_TOKEN>) {
    diag "running on travis or with token";
    my $gh = WebService::GitHub::Issues.new;
    my $issues = $gh.show(repo => 'fayland/perl6-WebService-GitHub').data;
    cmp-ok $issues.elems, ">", 0, "Non-null number of issues";
    my $first-issue = $gh.single-issue(repo => 'fayland/perl6-WebService-GitHub', issue => 1).data;
    is $first-issue<created_at>, "2015-10-26T19:45:45Z", "First issue OK";
    my @all-issues = $gh.all-issues('JJ/perl6em');
    cmp-ok @all-issues.elems, ">", 0, "Non-null number of issues";
    is @all-issues[0]<state>, "closed", "State of first issue is closed";
    cmp-ok +@all-issues.grep(*<state> eq 'closed'), ">=", 2, "More than 2 issues closed";
}

done-testing();
