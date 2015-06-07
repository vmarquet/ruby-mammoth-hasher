mammoth-hasher [![Build Status](https://travis-ci.org/vmarquet/ruby-mammoth-hasher.svg?branch=master)](https://travis-ci.org/vmarquet/ruby-mammoth-hasher)
==============

Description
-----------
A Ruby gem for fingerprinting big files (several GB), quicker than usual algorithms such as MD5. I needed this for [a project of mine](https://github.com/vmarquet/pierrot/) where I need to identify big video files, whereas the code is run on a Raspberry Pi which has few computing power.

The algorithm (inspired by [this topic](http://www.perlmonks.org/?node_id=951861)) is the following:

* initialize a random number generator with the file size as the seed
* get 100 random numbers ranging between 0 and the file size (in bytes)
* use each random number as an offset in the file, and get the 4 bytes following this offset
* the final hash is the hash of the concatenation of all those chunks (400 bytes)

**WARNING**: in order to improve speed, I traded security. The algorithm doesn't read the whole content of the file, unlike MD5, so an attacker aware that this algorithm is used could create collisions.


Installation
------------
```
gem install mammoth-hasher -v 0.2.0
```

Nota bene: given that if the algorithm is modified for whatever reason, the resulting hash will be different, you should always specify the version of the gem you use in your project, and specify this version when you install it, in order to make sure you will always have the same results during all the lifetime of your project.


Usage
-----
```
require 'mammoth-hasher'

MammothHasher.hash 'test.mkv'
 => "98c14ac0d89bf2a8ad07980234082da6"
```


Speed
-----
Example with a 3 GB file, on a MacBook:
```
$ time md5 "test.mkv"  # => 7.35s
```
This is very long, whereas with `mammoth-hasher`:
```
# pass true as a second argument for timing info:
MammothHasher.hash "test.mkv", true
0.001828 seconds
 => "98c14ac0d89bf2a8ad07980234082da6"
```
It took only 0.001828 seconds !


TODO
----
* in the README, add a table with speed tests for popular devices such as Raspberry Pi


License
-------
[MIT](http://opensource.org/licenses/MIT)


