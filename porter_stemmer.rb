# Porter Stemmer
# Based on algorithm described in Porter 80.
# Jason J
# 4 October 2014

# Finds the measure of a word.
# [C](VC)^m[V], where m is the measure.
# TODO Does this apply to the entire string?
# TODO OR just the part not including the suffix?
# TODO not working for "goodness"
def measure(word)
  measure = 10
  
  # Find the smallest i that matches.
  # TODO Guessing 5 is big enough?
  for i in 0..10
    # TODO y is in both consonants and vowels
    # TODO maybe use other symbol for one case?
    # TODO Use \A and \Z or ^ and $?
   if /^[b-dfhj-np-tv-z]*([aeiouy]*[b-dfhj-np-tv-z]*){#{i}}[aeiouy]*$/.match(word) != nil
     # Found an i that matches, it's the measure.
     measure = i
     break
   end
  end
 
 return measure
end

# Does a word end in a specific letter?
# for rules like *S
def ends_with?(word, letter)
  return result = (/.*#{letter}$/.match(word) != nil)
end

# Does the stem contain a vowel?
def contains_vowel?(stem)
  return result = (/^.*[aeiouy].*$/.match(stem) != nil)
end

# Does the word end with a double consonant?
def ends_with_double?(word)
  return result = (/.*([b-dfhj-np-tv-z]){2}$/.match(word) != nil)
end

# Does the word end with cvc?
# Where is consonant vowel consonant
# And the second consonant is not w, x, or y.
def ends_with_cvc?(word)
  return result = (/.*[b-dfhj-np-tv-z][aeiouy][b-dfhj-np-tvz]$/.match(word) != nil)
end

def porter_stemmer(word)
  # Step 1a
  if /sses$/.match(word) != nil
    word.sub!(/sses$/, "ss")
  elsif /ies$/.match(word) != nil
    word.sub!(/ies$/, "i")
  elsif /ss$/.match(word)
    word.sub!(/ss$/, "ss")
  elsif /s$/.match(word)
    word.sub!(/s$/, "")
  end

  puts "After Step 1a #{word}"

  # Step 1b
  # TODO Logic error: via rules "feed" matches if, but via if matches elsif..... this is causing "feed" to get stemmed to "fe"
  if measure(word.sub("eed", "")) > 0 and /eed$/.match(word) != nil
    word.sub!(/eed$/, "ee")
  elsif contains_vowel?(word.sub("ed", "")) and /ed$/.match(word) != nil
    word.sub!(/ed$/, "")
  
    puts "After Step 1b1 #{word}"
  
    # TODO refactor
    if /at$/.match(word) != nil
      word.sub!(/at$/, "ate")
    elsif /bl$/.match(word) != nil
      word.sub!(/bl$/, "ble")
    elsif /iz$/.match(word) != nil
      word.sub!(/iz$/, "ize")
    elsif ends_with_double?(word) and not (ends_with?(word, "l") or ends_with?(word, "s") or ends_with?(word, "z"))
      # Get rid of last character.
      word = word[0..word.length - 2]
    elsif measure(word) == 1 and ends_with_cvc?(word)
      word = word + "e"
    end
  
  elsif contains_vowel?(word.sub("ing", "")) and /ing$/.match(word) != nil
    word.sub!(/ing$/, "")
  
    puts "After Step 1b2 #{word}"
  
    # TODO refactor
    if /at$/.match(word) != nil
      word.sub!(/at$/, "ate")
    elsif /bl$/.match(word) != nil
      word.sub!(/bl$/, "ble")
    elsif /iz$/.match(word) != nil
      word.sub!(/iz$/, "ize")
    elsif ends_with_double?(word) and not (ends_with?(word, "l") or ends_with?(word, "s") or ends_with?(word, "z"))
      # Get rid of last character.
      word = word[0..word.length - 2]
    elsif measure(word) == 1 and ends_with_cvc?(word)
      word = word + "e"
    end
  end
  
  # Step 1c
  if contains_vowel?(word.sub("y", "")) and ends_with?(word, "y")
    word.sub!(/y$/, "i")
  end
  
  puts "After Step 1c #{word}"
  
  # Step 2
  if measure(word.sub("ational", "")) > 0 and /ational$/.match(word) != nil
    word.sub!(/ational$/, "ate")
  elsif measure(word.sub("tional", "")) > 0 and /tional$/.match(word) != nil
    word.sub!(/tional$/, "tion")
  elsif measure(word.sub("enci", "")) > 0 and /enci$/.match(word) != nil
    word.sub!(/enci$/, "ence")
  elsif measure(word.sub("anci", "")) > 0 and /anci$/.match(word) != nil
    word.sub!(/anci$/, "ance")
  elsif measure(word.sub("izer", "")) > 0 and /izer$/.match(word) != nil
    word.sub!(/izer$/, "ize")
  elsif measure(word.sub("abli", "")) > 0 and /abli$/.match(word) != nil
    word.sub!(/abli$/, "able")
  elsif measure(word.sub("alli", "")) > 0 and /alli$/.match(word) != nil
    word.sub!(/alli$/, "al")
  elsif measure(word.sub("entli", "")) > 0 and /entli$/.match(word) != nil
    word.sub!(/entli$/, "ent")
  elsif measure(word.sub("eli", "")) > 0 and /eli$/.match(word) != nil
    word.sub!(/eli$/, "e")
  elsif measure(word.sub("ousli", "")) > 0 and /ousli$/.match(word) != nil
    word.sub!(/ousli$/, "ous")
  elsif measure(word.sub("ization", "")) > 0 and /ization$/.match(word) != nil
    word.sub!(/ization$/, "ize")
  elsif measure(word.sub("ation", "")) > 0 and /ation$/.match(word) != nil
    word.sub!(/ation$/, "ate")
  elsif measure(word.sub("ator", "")) > 0 and /ator$/.match(word) != nil
    word.sub!(/ator$/, "ate")
  elsif measure(word.sub("alism", "")) > 0 and /alism$/.match(word) != nil
    word.sub!(/alism$/, "al")
  elsif measure(word.sub("iveness", "")) > 0 and /iveness$/.match(word) != nil
    word.sub!(/iveness$/, "ive")
  elsif measure(word.sub("fulness", "")) > 0 and /fulness$/.match(word) != nil
    word.sub!(/fulness$/, "ful")
  elsif measure(word.sub("ousness", "")) > 0 and /ousness$/.match(word) != nil
    word.sub!(/ousness$/, "ous")
  elsif measure(word.sub("aliti", "")) > 0 and /aliti$/.match(word) != nil
    word.sub!(/aliti$/, "al")
  elsif measure(word.sub("iviti", "")) > 0 and /iviti$/.match(word) != nil
    word.sub!(/iviti$/, "ive")
  elsif measure(word.sub("biliti", "")) > 0 and /biliti$/.match(word) != nil
    word.sub!(/biliti$/, "ble")
  end
  
  puts "After Step 2 #{word}"
  
  # Step 3
  if measure(word.sub("icate", "")) > 0 and /icate$/.match(word) != nil
    word.sub!(/icate$/, "ic")
  elsif measure(word.sub("ative", "")) > 0 and /ative$/.match(word) != nil
    word.sub!(/ative$/, "")
  elsif measure(word.sub("alize", "")) > 0 and /alize$/.match(word) != nil
    word.sub!(/alize$/, "al")
  elsif measure(word.sub("iciti", "")) > 0 and /iciti$/.match(word) != nil
    word.sub!(/iciti$/, "ic")
  elsif measure(word.sub("ical", "")) > 0 and /ical$/.match(word) != nil
    word.sub!(/ical$/, "ic")
  elsif measure(word.sub("ful", "")) > 0 and /ful$/.match(word) != nil
    word.sub!(/ful$/, "")
  elsif measure(word.sub("ness", "")) > 0 and /ness$/.match(word) != nil
    word.sub!(/ness$/, "")
  end
  
  puts "After Step 3 #{word}"

  # Step 4
  if measure(word.sub("al", "")) > 1 and /al$/.match(word) != nil
    word.sub!(/al$/, "")
  elsif measure(word.sub("ance", "")) > 1 and /ance$/.match(word) != nil
    word.sub!(/ance$/, "")
  elsif measure(word.sub("ence", "")) > 1 and /ence$/.match(word) != nil
    word.sub!(/ence$/, "")
  elsif measure(word.sub("er", "")) > 1 and /er$/.match(word) != nil
    word.sub!(/er$/, "")
  elsif measure(word.sub("ic", "")) > 1 and /ic$/.match(word) != nil
    word.sub!(/ic$/, "")
  elsif measure(word.sub("able", "")) > 1 and /able$/.match(word) != nil
    word.sub!(/able$/, "")
  elsif measure(word.sub("ible", "")) > 1 and /ible$/.match(word) != nil
    word.sub!(/ible$/, "")
  elsif measure(word.sub("ant", "")) > 1 and /ant$/.match(word) != nil
    word.sub!(/ant$/, "")
  elsif measure(word.sub("ement", "")) > 1 and /ement$/.match(word) != nil
    word.sub!(/ement$/, "")
  elsif measure(word.sub("ment", "")) > 1 and /ment$/.match(word) != nil
    word.sub!(/ment$/, "")
  elsif measure(word.sub("ent", "")) > 1 and /ent$/.match(word) != nil
    word.sub!(/ent$/, "")
  elsif measure(word.sub("ion", "")) > 1 and (ends_with?(word.sub("ion", ""), "s") or ends_with?(word.sub("ion", ""), "t")) and /ion$/.match(word) != nil
    word.sub!(/ion$/, "")
  elsif measure(word.sub("ou", "")) > 1 and /ou$/.match(word) != nil
    word.sub!(/ou$/, "")
  elsif measure(word.sub("ism", "")) > 1 and /ism$/.match(word) != nil
    word.sub!(/ism$/, "")
  elsif measure(word.sub("ate", "")) > 1 and /ate$/.match(word) != nil
    word.sub!(/ate$/, "")
  elsif measure(word.sub("iti", "")) > 1 and /iti$/.match(word) != nil
    word.sub!(/iti$/, "")
  elsif measure(word.sub("ous", "")) > 1 and /ous$/.match(word) != nil
    word.sub!(/ous$/, "")
  elsif measure(word.sub("ive", "")) > 1 and /ive$/.match(word) != nil
    word.sub!(/ive$/, "")
  elsif measure(word.sub("ize", "")) > 1 and /ize$/.match(word) != nil
    word.sub!(/ize$/, "")
  end
  
  puts "After Step 4 #{word}"

  # Step 5a
  if measure(word.sub("e", "")) > 1 and /e$/.match(word) != nil
    word.sub!(/e$/, "")
  elsif measure(word.sub("e", "")) == 1 and not ends_with_cvc?(word.sub("e", "")) and /e$/.match(word) != nil
    word.sub!(/e$/, "")
  end
  
  puts "After Step 5a #{word}"

  # Step 5b
  if measure(word) > 1 and ends_with_double?(word) and ends_with?(word, "l")
    word = word[0..word.length - 2]
  end
  
  puts "After Step 5b #{word}"
  
  return word
end

# Add some hashes with test cases.
measure_test_cases = {
  :tr => 0,
  :ee => 0,
  :tree => 0,
  :y => 0,
  :by => 0,
  
  :trouble => 1,
  :oats => 1,
  :trees => 1,
  :ivy => 1,
  
  :troubles => 2,
  :private => 2,
  :oaten => 2,
  :orrery => 2,
}

# Print out if any of the test cases fail.
measure_test_cases.each do |key, value|
  puts "#{key.to_s} FAILS" if measure(key.to_s) != value
end

puts "Enter a word"
word = gets.chomp
s = word + ""

puts "measure(#{word}) = #{measure(word)}"

puts "porter_stemmer(#{word}) = #{porter_stemmer(s)}"
