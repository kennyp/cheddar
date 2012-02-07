== Cheddar - Transform that hard-earned cheese into real integers or Fixnums.

Cheddar is a little library for converting human input strings into numbers.

== Installation

`gem install cheddar`

or add the following line to your `Gemfile`:

`gem 'cheddar'`

and run `bundle install` from your shell.

== Examples

The basics.

```ruby
require 'cheddar'

'15 hundred'.human_to_number
# => 1500

'$200 million'.human_to_number
# => 200000000

'15.72 vigintillion'.human_to_number
# => 1.5720000000000002e+64
```

Slightly more advanced.

```ruby
'25 bucks'.human_to_number
# => 25

'20 large'.human_to_number
# => 2000

'33 straight up large bills'.human_to_number
# => 3300
```