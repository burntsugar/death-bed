# :skull: death-bed

## Why is this called death-bed?
Because I wrote this when I was in bed with the flu :cold_sweat:.

## What is it?

A URL parser - but mostly an exercise in string manipulation with [Ruby 2.5.1](https://ruby-doc.org/core-2.5.1/String.html) and testing with [RSpec 3.8+](https://rspec.info/documentation/)

## Tell me about it

* Will parse most commonly found URLs and store each part in a hash.
* Path segments are seperated into an array for convenience.
* Querystrings are seperated into a hash for convenience.
* Does not support IPv6 host names (maybe one day) - raises StandardError
* Raises StandardError for non-numeric port numbers.
* See lib/death-bed.rb for code. Heaps of comments - pretty ugly. I chose *against* abstracting code into too many methods. The logic to parse the URL is so tightly coupled that it made sense (against all other urges) to keep most it together.
* See spec/URLParserSpec for tests which contain a large range of [URL format](https://en.wikipedia.org/wiki/URL) combinations.

### Get RSpec...

````
$ gem install rspec
````

## Stars of the show: String methods...

### String :point_right: [include?(string)](https://ruby-doc.org/core-2.5.1/String.html#method-i-include-3F)

Need to know if a string contains a character or sequence of characters? In this example I was looking for the double slashes (*//*) which denote the beginning of the **Authority** component...

````
irb(main):002:0> str = "foo://example.com"
=> "foo://example.com"
irb(main):003:0> str.include? "//"
=> true
...
````

### String :point_right: working with the string index

In this example I remove the question mark (*?*) character which denotes the beginning of the querystring...

````
irb(main):004:0> str = "?fname=rach&currentstatus=sickasadog"
=> "?fname=rach&currentstatus=sickasadog"
irb(main):005:0> str[1..-1]
=> "fname=rach&currentstatus=sickasadog"
irb(main):006:0> 
````

### String :point_right: [split(string)](https://ruby-doc.org/core-2.5.1/String.html#method-i-split)

In this example I seperate each querystring - the ampersand character (*&*) seperates each pair. Split returns all of them in an array...

````
irb(main):013:0> str = "fname=rach&currentstatus=sickasadog"
=> "fname=rach&currentstatus=sickasadog"
irb(main):014:0> pairs = str.split("&")
=> ["fname=rach", "currentstatus=sickasadog"]
````

I can then split again, this time on each pair, on the equals character (*=*), in order to read the keys and values individually.

### String :point_right: [partition(string)](https://ruby-doc.org/core-2.5.1/String.html#method-i-partition)

(AKA my new best friend :heart_eyes:)

In this example I need to get the user info on the left of the *@* and the host name on the right. **partition** will locate the first occurance of a given character and then return an array containing the preceeding characters, the given character, and the characters which follow. Nice! 

````
irb(main):015:0> str = "user@example.com"
=> "user@example.com"
irb(main):016:0> str.partition("@")
=> ["user", "@", "example.com"]
````

There's also **rpartition**, which starts the search from the *end* of the string. Groovy!

### String :point_right: [slice!(regular expression)](https://ruby-doc.org/core-2.5.1/String.html#method-i-slice-21)

Need to remove a character sequence from your string? In this example I remove the double slashes (*//*) which denote the beginning of the **Authority** component...

````
irb(main):023:0> str = "foo://example.com"
=> "foo://example.com"
irb(main):024:0> str.slice!(/\/\//)
=> "//"
irb(main):025:0> str
=> "foo:example.com"
````

There's also a non-destructive version (omit the !).

### String :point_right: [count(string)](https://ruby-doc.org/core-2.5.1/String.html#method-i-count)

Need to count the occurance of a character or character sequence in your string? In this example I count the number of path segment seperators (slash) slash...

````
irb(main):028:0> str = "this/is/5/path/segments/"
=> "this/is/5/path/segments/"
irb(main):029:0> str.count("/")
=> 5
````

### ToDo...

* Add support for IPv6 host names.
* Can you think of others?

<br>

[contributor code of conduct](docs/CODE_OF_CONDUCT.md)
