# SaltStack Cron.Env Bug

* Author: [Jonathan M. Wilbur](https://jonathan.wilbur.space) <[jonathan@wilbur.space](mailto:jonathan@wilbur.space)>
* Copyright Year: 2018
* License: [MIT License](https://mit-license.org/)

## About

This repo is to prove the existence of
[this bug I reported in SaltStack](https://github.com/saltstack/salt/issues/50138).

This repo contains my testing to prove that this bug exists.

## The Bug

This bug comes from these two facts:

1. The SaltStack `cron.set_env` execution module _appends_ environment variables to `/etc/crontab`.
2. Environment variables set in `/etc/crontab` only apply to cron entries below them.

Which means that `cron.set_env` does not do anything.

## This Repo

This repo defines two virtual machines in `./Vagrantfile`. You must download
and install [Vagrant](https://www.vagrantup.com/) to perform these tests for
yourself.

One virtual machine is Fedora, and the other is Ubuntu, so that both a Debian
and RPM distro are tested.

## How the Tests Work

On each host, these lines are appended to `/etc/crontab` by the provisioning
script:

```cron
TEST1=foo
* * * * * root echo $TEST1 > /tmp/result1.txt
* * * * * root echo $TEST2 > /tmp/result2.txt
TEST2=bar
```

Because `TEST1` is defined before the crontab entry that uses it, its value
will `echo` successfully to `/tmp/result1.txt`.

According to my claim in the bug report, because `TEST2` is defined _after_
the crontab entry that uses it, it should _not_ `echo` successfully to
`/tmp/result2.txt`.

## Running the Tests

Clone this repo, like so:

```bash
git clone https://github.com/JonathanWilbur/saltstack-issues-50138.git
```

With [Vagrant](https://www.vagrantup.com/) installed, run `vagrant up`. Within
the root directory of this repo.

Inspect the contents of `/etc/crontab` to see that the lines described above
were added by running `cat /etc/crontab`.

Run `cat /tmp/result1.txt`. The output should be `foo`.

Run `cat /tmp/result2.txt`. **If my assertion is correct**, the output should
be `bar`.

## Results

The output of `cat /tmp/result1.txt` was `foo` on both hosts.
The output of `cat /tmp/result2.txt` was empty on both hosts.

These tests **prove** that I am right and that setting environment variables
using SaltStack's `cron.set_env`, which _appends_ environment variables to
`/etc/crontab`, does nothing. Please fix this.