# Orchestra

Key phrase analyzer for your timeline.

1. Twitter Streaming API
2. TupleSpace
3. Yahoo! Key phrase API
4. TupleSpace
5. Drip


## Installation

acoustic
:  Drip for tweets
staff
:  TupleSpace
score
:  Drip for key phrases
stream
:  Worker for Twitter Streaming API
phrase
:  Worker for Yahoo! key phrase API
compose
:  API for you


## Usage

I recommend use of daemontools.

First you have to set environments into `.env` (see `.env.sample`).  
Then,

```
$ bundle exec foreman run bin/acoustic
$ bundle exec foreman run bin/staff
$ bundle exec foreman run bin/score
$ bundle exec foreman run bin/stream
$ bundle exec foreman run bin/phrase
```

After few minutes later,

```
$ bundle exec foreman run bin/compose
```

You are composer ;)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
