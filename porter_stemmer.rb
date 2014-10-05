################################################################################
# Porter Stemmer
#
# Based on algorithm described in Porter 80.
#
# Author: Jason J
# Start: 4 October 2014
################################################################################

# Set to true to enable debugging.
DEBUG = false

# Set to true to enable test cases.
TEST = false

# Manually enter a word or run over the text files?
MANUAL = false

# Finds the measure of a word.
# [C](VC)^m[V], where m is the measure.
def measure(word)
  # TODO Kinda a magic number..
  measure = 10
  
  # There's really two ys.
  # One y is a consonant and the other is a vowel.
  # Vowel y is defined to be y when preceded by a consonant.
  # Make a copy of the word and replace any vowel y with a special symbols, ¥.
  # TODO For now, just replace the constant with "c".
  copy = word + ""
  copy.sub!(/[b-df-hj-np-tvxz]y/, "c¥")
  
  # Find the smallest i that matches.
  # TODO Guessing 10 is big enough?
  for i in 0..10
    # TODO Use \A and \Z or ^ and $?
   if /^[b-df-hj-np-tv-z]*([aeiou¥]+[b-df-hj-np-tv-z]+){#{i}}[aeiou¥]*$/.match(copy) != nil
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
  # See comment above for explanation of this.
  # TODO For now, just replace the constant with "c".
  copy = stem + ""
  copy.sub!(/[b-df-hj-np-tvxz]y/, "c¥")
  
  return result = (/^.*[aeiou¥].*$/.match(copy) != nil)
end

# Does the word end with a double consonant?
def ends_with_double?(word)
  # return result = (/.*([b-dfhj-np-tv-z])\1{2}$/.match(word) != nil)
  return result = (/.*(?<consonant>[b-df-hj-np-tv-z])\k<consonant>$/.match(word) != nil)
end

# Does the word end with cvc?
# Where is consonant vowel consonant
# And the second consonant is not w, x, or y.
def ends_with_cvc?(word)
  return result = (/.*[b-df-hj-np-tv-z][aeiouy][b-df-hj-np-tvz]$/.match(word) != nil)
end

# Step 1a of the algorithm.
def step_1a(word)
  if /sses$/.match(word) != nil
    word.sub!(/sses$/, "ss")
  elsif /ies$/.match(word) != nil
    word.sub!(/ies$/, "i")
  elsif /ss$/.match(word)
    word.sub!(/ss$/, "ss")
  elsif /s$/.match(word)
    word.sub!(/s$/, "")
  end
  
  return word
end

def step_1b_substep(word)
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
  
  return word
end

# Step 1b of the algorithm.
def step_1b(word)
  if /eed$/.match(word) != nil
    if measure(word.sub(/eed$/, "")) > 0
      word.sub!(/eed$/, "ee")
    end
  elsif /ed$/.match(word) != nil
    if contains_vowel?(word.sub(/ed$/, ""))
      word.sub!(/ed$/, "")
  
      puts "After Step 1b1 #{word}" if DEBUG
  
      word = step_1b_substep(word)
    end
  elsif /ing$/.match(word) != nil
    if contains_vowel?(word.sub(/ing$/, ""))
      word.sub!(/ing$/, "")
  
      puts "After Step 1b2 #{word}"  if DEBUG
    
      puts "#{ends_with_double?(word)} and #{not (ends_with?(word, "l") or ends_with?(word, "s") or ends_with?(word, "z"))}" if DEBUG
  
      word = step_1b_substep(word)
    end
  end
  
  return word
end

# Step 1c of the algorithm.
def step_1c(word)
  if contains_vowel?(word.sub(/y$/, "")) and ends_with?(word, "y")
    word.sub!(/y$/, "i")
  end
  
  return word
end

# Step 2 of the algorithm.
def step_2(word)
  if /ational$/.match(word) != nil
    if measure(word.sub(/ational$/, "")) > 0
      word.sub!(/ational$/, "ate")
    end
  elsif /tional$/.match(word) != nil
    if measure(word.sub(/tional$/, "")) > 0
      word.sub!(/tional$/, "tion")
    end
  elsif /enci$/.match(word) != nil
    if measure(word.sub(/enci$/, "")) > 0
      word.sub!(/enci$/, "ence")
    end
  elsif /anci$/.match(word) != nil
    if measure(word.sub(/anci$/, "")) > 0
      word.sub!(/anci$/, "ance")
    end
  elsif /izer$/.match(word) != nil
    if measure(word.sub(/izer$/, "")) > 0
      word.sub!(/izer$/, "ize")
    end
  elsif /abli$/.match(word) != nil
    if measure(word.sub(/abli$/, "")) > 0
      word.sub!(/abli$/, "able")
    end
  elsif /alli$/.match(word) != nil
    if measure(word.sub(/alli$/, "")) > 0
      word.sub!(/alli$/, "al")
    end
  elsif /entli$/.match(word) != nil
    if measure(word.sub(/entli$/, "")) > 0
      word.sub!(/entli$/, "ent")
    end
  elsif /eli$/.match(word) != nil
    if measure(word.sub(/eli$/, "")) > 0
      word.sub!(/eli$/, "e")
    end
  elsif /ousli$/.match(word) != nil
    if measure(word.sub(/ousli$/, "")) > 0
      word.sub!(/ousli$/, "ous")
    end
  elsif /ization$/.match(word) != nil
    if measure(word.sub(/ization$/, "")) > 0
      word.sub!(/ization$/, "ize")
    end
  elsif /ation$/.match(word) != nil
    if measure(word.sub(/ation$/, "")) > 0
      word.sub!(/ation$/, "ate")
    end
  elsif /ator$/.match(word) != nil
    if measure(word.sub(/ator$/, "")) > 0
      word.sub!(/ator$/, "ate")
    end
  elsif /alism$/.match(word) != nil
    if measure(word.sub(/alism$/, "")) > 0
      word.sub!(/alism$/, "al")
    end
  elsif /iveness$/.match(word) != nil
    if measure(word.sub(/iveness$/, "")) > 0
      word.sub!(/iveness$/, "ive")
    end
  elsif /fulness$/.match(word) != nil
    if measure(word.sub(/fulness$/, "")) > 0
      word.sub!(/fulness$/, "ful")
    end
  elsif /ousness$/.match(word) != nil
    if measure(word.sub(/ousness$/, "")) > 0
      word.sub!(/ousness$/, "ous")
    end
  elsif /aliti$/.match(word) != nil
    if measure(word.sub(/aliti$/, "")) > 0
      word.sub!(/aliti$/, "al")
    end
  elsif /iviti$/.match(word) != nil
    if measure(word.sub(/iviti$/, "")) > 0
      word.sub!(/iviti$/, "ive")
    end
  elsif /biliti$/.match(word) != nil
    if measure(word.sub(/biliti$/, "")) > 0
      word.sub!(/biliti$/, "ble")
    end
  end
  
  return word
end

# Step 3 of the algorithm.
def step_3(word)
  if /icate$/.match(word) != nil
    if measure(word.sub(/icate$/, "")) > 0
      word.sub!(/icate$/, "ic")
    end
  elsif /ative$/.match(word) != nil
    if measure(word.sub(/ative$/, "")) > 0
      word.sub!(/ative$/, "")
    end
  elsif /alize$/.match(word) != nil
    if measure(word.sub(/alize$/, "")) > 0
      word.sub!(/alize$/, "al")
    end
  elsif /iciti$/.match(word) != nil
    if measure(word.sub(/iciti$/, "")) > 0
      word.sub!(/iciti$/, "ic")
    end
  elsif /ical$/.match(word) != nil
    if measure(word.sub(/ical$/, "")) > 0
      word.sub!(/ical$/, "ic")
    end
  elsif /ful$/.match(word) != nil
    if measure(word.sub(/ful$/, "")) > 0
      word.sub!(/ful$/, "")
    end
  elsif /ness$/.match(word) != nil
    if measure(word.sub(/ness$/, "")) > 0
      word.sub!(/ness$/, "")
    end
  end
  
  return word
end

# Step 4 of the algorithm.
def step_4(word)
  if /al$/.match(word) != nil
    if measure(word.sub(/al$/, "")) > 1
      word.sub!(/al$/, "")
    end
  elsif /ance$/.match(word) != nil
    if measure(word.sub(/ance$/, "")) > 1
      word.sub!(/ance$/, "")
    end
  elsif /ence$/.match(word) != nil
    if measure(word.sub(/ence$/, "")) > 1
      word.sub!(/ence$/, "")
    end
  elsif /er$/.match(word) != nil
    if measure(word.sub(/er$/, "")) > 1
      word.sub!(/er$/, "")
    end
  elsif /ic$/.match(word) != nil
    if measure(word.sub(/ic$/, "")) > 1
      word.sub!(/ic$/, "")
    end
  elsif /able$/.match(word) != nil
    if measure(word.sub(/able$/, "")) > 1
      word.sub!(/able$/, "")
    end
  elsif /ible$/.match(word) != nil
    if measure(word.sub(/ible$/, "")) > 1
      word.sub!(/ible$/, "")
    end
  elsif /ant$/.match(word) != nil
    if measure(word.sub(/ant$/, "")) > 1
      word.sub!(/ant$/, "")
    end
  elsif /ement$/.match(word) != nil
    if measure(word.sub(/ement$/, "")) > 1
      word.sub!(/ement$/, "")
    end
  elsif /ment$/.match(word) != nil
    if measure(word.sub(/ment$/, "")) > 1
      word.sub!(/ment$/, "")
    end
  elsif /ent$/.match(word) != nil
    if measure(word.sub(/ent$/, "")) > 1
      word.sub!(/ent$/, "")
    end
  elsif /ion$/.match(word) != nil
    if measure(word.sub(/ion$/, "")) > 1 and (ends_with?(word.sub(/ion$/, ""), "s") or ends_with?(word.sub(/ion$/, ""), "t"))
      word.sub!(/ion$/, "")
    end
  elsif /ou$/.match(word) != nil
    if measure(word.sub(/ou$/, "")) > 1
      word.sub!(/ou$/, "")
    end
  elsif /ism$/.match(word) != nil
    if measure(word.sub(/ism$/, "")) > 1
      word.sub!(/ism$/, "")
    end
  elsif /ate$/.match(word) != nil
    if measure(word.sub(/ate$/, "")) > 1
      word.sub!(/ate$/, "")
    end
  elsif /iti$/.match(word) != nil
    if measure(word.sub(/iti$/, "")) > 1
      word.sub!(/iti$/, "")
    end
  elsif /ous$/.match(word) != nil
    if measure(word.sub(/ous$/, "")) > 1
      word.sub!(/ous$/, "")
    end
  elsif /ive$/.match(word) != nil
    if measure(word.sub(/ive$/, "")) > 1
      word.sub!(/ive$/, "")
    end
  elsif /ize$/.match(word) != nil
    if measure(word.sub(/ize$/, "")) > 1
      word.sub!(/ize$/, "")
    end
  end
  
  return word
end

# Step 5a of the algorithm.
def step_5a(word)
  puts "#{measure(word.sub(/e$/, "")) == 1} and #{(not ends_with_cvc?(word.sub(/e$/, "")))} and #{/e$/.match(word) != nil}" if DEBUG
  
  if /e$/.match(word) != nil
    if measure(word.sub(/e$/, "")) > 1
      word.sub!(/e$/, "")
    elsif measure(word.sub(/e$/, "")) == 1 and (not ends_with_cvc?(word.sub(/e$/, "")))
      word.sub!(/e$/, "")
    end
  end
  
  return word
end

# Step 5b of the algorithm.
def step_5b(word)
  if measure(word) > 1 and ends_with_double?(word) and ends_with?(word, "l")
    word = word[0..word.length - 2]
  end
  
  return word
end

# Porter stemmer algorithm.
def porter_stemmer(word)
  # Step 1a
  word = step_1a(word)
  puts "After Step 1a #{word}" if DEBUG

  # Step 1b
  word = step_1b(word)
  puts "After Step 1b #{word}" if DEBUG
  
  # Step 1c
  word = step_1c(word)
  puts "After Step 1c #{word}" if DEBUG
  
  # Step 2
  word = step_2(word)
  puts "After Step 2 #{word}" if DEBUG
  
  # Step 3
  word = step_3(word)
  puts "After Step 3 #{word}" if DEBUG

  # Step 4
  word = step_4(word)
  puts "After Step 4 #{word}" if DEBUG

  # Step 5a
  word = step_5a(word)
  puts "After Step 5a #{word}" if DEBUG

  # Step 5b
  word = step_5b(word)
  puts "After Step 5b #{word}" if DEBUG
  
  return word
end

if TEST
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
    :orrery => 2
  }

  step_1a_test_cases = {
    :caresses => :caress,
    :ponies => :poni,
    :ties => :ti,
    :caress => :caress,
    :cats => :cat
  }

  step_1b_test_cases = {
    :feed => :feed,
    :agreed => :agree,
    :plastered => :plaster,
    :bled => :bled,
    :motoring => :motor,
    :sing => :sing,
  
    :conflated => :conflate,
    :troubling => :trouble,
    :sized => :size,
    :hopping => :hop,
    :tanned => :tan,
    :falling => :fall,
    :hissing => :hiss,
    :fizzed => :fizz,
    :failing => :fail,
    :filing => :file
  }

  step_1c_test_cases = {
    :happy => :happi,
    :sky => :sky
  }

  step_2_test_cases = {
    :relational => :relate,
    :conditional => :condition,
    :rational => :rational,
    :valenci => :valence,
    :hesitanci => :hesitance,
    :digitizer => :digitize,
    :conformabli => :conformable,
    :radicalli => :radical,
    :differentli => :different,
    :vileli => :vile,
    :analogousli => :analogous,
    :vietnamization => :vietnamize,
    :predication => :predicate,
    :operator => :operate,
    :feudalism => :feudal,
    :decisiveness => :decisive,
    :hopefulness => :hopeful,
    :callousness => :callous,
    :formaliti => :formal,
    :sensitiviti => :sensitive,
    :sensibiliti => :sensible
  }

  step_3_test_cases = {
    :triplicate => :triplic,
    :formative => :form,
    :formalize => :formal,
    :electriciti => :electric,
    :electrical => :electric,
    :hopeful => :hope,
    :goodness => :good
  }

  step_4_test_cases = {
    :revival => :reviv,
    :allowance => :allow,
    :inference => :infer,
    :airliner => :airlin,
    :gyroscopic => :gyroscop,
    :adjustable => :adjust,
    :defensible => :defens,
    :irritant => :irrit,
    :replacement => :replac,
    :adjustment => :adjust,
    :dependent => :depend,
    :adoption => :adopt,
    :homologou => :homolog,
    :communism => :commun,
    :activate => :activ,
    :angulariti => :angular,
    :homologous => :homolog,
    :effective => :effect,
    :bowdlerize => :bowdler
  }

  step_5a_test_cases = {
    :probate => :probat,
    :rate => :rate,
    :cease => :ceas
  }

  step_5b_test_cases = {
    :controll => :control,
    :roll => :roll
  }

  # Print out if any of the test cases fail.
  measure_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if measure(key.to_s) != value
  end

  step_1a_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_1a(key.to_s) != value.to_s
  end

  step_1b_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_1b(key.to_s) != value.to_s
  end

  step_1c_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_1c(key.to_s) != value.to_s
  end

  step_2_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_2(key.to_s) != value.to_s
  end

  step_3_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_3(key.to_s) != value.to_s
  end

  step_4_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_4(key.to_s) != value.to_s
  end

  step_5a_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_5a(key.to_s) != value.to_s
  end

  step_5b_test_cases.each do |key, value|
    puts "#{key.to_s} FAILS" if step_5b(key.to_s) != value.to_s
  end
end

if MANUAL
  # Manually enter a word.
  puts "Enter a word"
  word = gets.chomp
  s = word + ""

  puts "measure(#{word}) = #{measure(word)}"
  puts "porter_stemmer(#{word}) = #{porter_stemmer(s)}"
else
  # Run on specific files.
  # Open up the vocabulary file.
  file = File.open("voc.txt", "rb")
  vocabulary_string = file.read
  file.close

  # Store the vocabulary as an array.
  vocabulary = vocabulary_string.split("\n")

  # Open up the correct output file.
  file = File.open("output.txt", "rb")
  correct_output_string = file.read
  file.close

  # Store the correct output as an array.
  correct_output = correct_output_string.split("\n")

  # Keep track of how many don't match.
  wrong_count = 0

  # Go through each item in the vocabulary,
  # See if the stemmer's output matches the correct output.
  for i in 0...vocabulary.length
    copy = vocabulary[i] + ""
    copy = porter_stemmer(copy)
    #puts "word: #{vocabulary[i]}\tcorrect: #{correct_output[i]}\tstemmed: #{copy}" if copy != correct_output[i]
    printf("%15s\t%15s\t%15s\n", vocabulary[i], correct_output[i], copy) if copy != correct_output[i]
    wrong_count += 1 if copy != correct_output[i]
  end

  # Calculate the success rate.
  success_rate = 1.0 - wrong_count.to_f / vocabulary.length.to_f

  # Display the success rate.
  puts "Rate: #{wrong_count} / #{vocabulary.length} = #{success_rate}"
end
