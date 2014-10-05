Porter Stemmer
==============

A stemmer removes suffixes from a word, leaving only the stem of the word. The
Porter stemmer is a popular stemmer for the English language. This is my attempt at implementing a Porter stemmer in Ruby for the English language.

I'm still learning Ruby. So, yeah, it's why some of my code might not be done in a very Ruby way.

Currently, the stemmer correctly stems the sample English vocabulary from voc.txt, with the results matching the stemmed output file, output.txt, found below:

http://snowball.tartarus.org/algorithms/porter/stemmer.html

To-Do List:
--------------

* Add command line options for
  * Passing in a file to stem
  * Passing in a corresponding correct output file
  * Passing an individual word to stem
  * Enabling testing
  * Enabling ebugging
  * Maybe some others that I'm not thinking of at the moment
* Consider possible ways to make it more efficient