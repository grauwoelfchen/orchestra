# Orchestra

Key phrase analyzer for your timeline.

1. Twitter Streaming API
2. TupleSpace
3. Yahoo! Key phrase API
4. TupleSpace
5. Drip


## Installation

staff
:  TupleSpace
score
:  Drip
stream
:  Worker for Twitter Streaming API
phrase
:  Worker for Yahoo! key phrase API
conduct
:  Command for you


## Usage

I recommend to use daemontools :)

First you have to set environments into `.env` (see `.env.sample`).  
Then,

```
$ bundle exec foreman run bin/staff
$ bundle exec foreman run bin/score
$ bundle exec foreman run bin/stream
$ bundle exec foreman run bin/phrase
```


## Example

```
# shows newest 10 key phrases
$ bundle exec foreman run bin/conduct list --index 0 --number 10 --port 10060 (score port)

# creates google chart link
$ bundle exec foreman run bin/conduct chart -i 0 -n 5

# shows newest 5 tweets
$ bundle exec foreman run bin/conduct tweet -i 0 -n 5
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
