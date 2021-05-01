# perl6-WebService-GitHub


*ALPHA STAGE, SUBJECT TO CHANGE*

## SYNOPSIS

    use WebService::GitHub;

    my $gh = WebService::GitHub.new(
        access-token => 'my-access-token'
    );

    my $res = $gh.request('/user');
    say $res.data.name;

## TODO

Patches welcome

 * Break down modules (Users, Repos, etc.)
 * Handle Errors
 * Auto Pagination
 * API Throttle

## Methods

### Args

 * `endpoint`

Useful for GitHub Enterprise. Default to https://api.github.com

 * `access-token`

Required for Authorized API Request.

 * `auth_login` & `auth_password`

Basic Authenticaation. useful to get `access-token`.

 * `per_page`

from [Doc](https://developer.github.com/v3/#pagination), default to 30, max to 100.

 * `jsonp_callback`

[JSONP Callback](https://developer.github.com/v3/#json-p-callbacks)

 * `time-zone`

UTC by default, [Doc](https://developer.github.com/v3/#timezones)

 * `with`

 Builds the object with a particular role

```perl6
my $gh = WebService::GitHub.new(
    with => ('Debug')
);
```

### Response

 * `raw`

HTTP::Response instance

 * `data`

JSON decoded data

 * `header(Str $field)`

Get header of HTTP Response

 * `first-page-url`, `prev-page-url`, `next-page-url`, `last-page-url`

Parsed from the Link header, [Doc](https://developer.github.com/v3/#pagination)

 * `x-ratelimit-limit`, `x-ratelimit-remaining`, `x-ratelimit-reset`

[Rate Limit](https://developer.github.com/v3/#rate-limiting)

## Examples

Some of them are, or will be, included in the `examples` directory.

### Public Access without access-token

#### get user info

```perl6
my $gh = WebService::GitHub.new;
my $user = $gh.request('/users/fayland').data;
say $user<name>;
```

#### search repositories

```perl6
use WebService::GitHub::Search;

my $search = WebService::GitHub::Search.new;
my $data = $search.repositories({
    :q<perl6>,
    :sort<stars>,
    :order<desc>
}).data;
```

### OAuth

#### get token from user/login

[examples/create_access_token.pl](examples/create_access_token.pl)

```perl6
use WebService::GitHub::OAuth;

my $gh = WebService::GitHub::OAuth.new(
    auth_login => 'username',
    auth_password => 'password'
);

my $auth = $gh.create_authorization({
    :scopes(['user', 'public_repo', 'repo', 'gist']), # just ['public_repo']
    :note<'test purpose'>
}).data;
say $auth<token>;
```

### Gist

#### create a gist

```perl6
use WebService::GitHub::Gist;

my $gist = WebService::GitHub::Gist.new(
    access-token => %*ENV<GITHUB_ACCESS_TOKEN>
);

my $data = $gist.create_gist({
    description => 'Test from perl6 WebService::GitHub::Gist',
    public => True,
    files => {
        'test.txt' => {
            content => "Created on " ~ now
        }
    }
}).data;
say $data<url>;
```

#### update gist

```perl6
$data = $gist.update_gist($id, {
    files => {
        "test_another.txt" => {
            content => "Updated on " ~ now
        }
    }
}).data;
```

#### delete gist

```perl6
$res = $gist.delete_gist($id);
say 'Deleted' if $res.is-success;
```
