# Gistsume

Crib another user's entire Gist-stash for backup purposes or what-have-you.

* If the Gist already exists as a repo, it'll pull to get latest.
* Right now it only consumes your public gists due to limitations in GitHub's Gist API

## Usage

$ gitsume.rb [username]

    jp@populuxe:~$ gistsume.rb jpignata
    Pulling jpignata-gists/250480
    Pulling jpignata-gists/241231
    Pulling jpignata-gists/228912
    Pulling jpignata-gists/223279 (http://coderack.org/users/jpignata/entries/70-rackgeocities)
    Pulling jpignata-gists/223275
    Pulling jpignata-gists/223263
    Pulling jpignata-gists/220995
    ...
