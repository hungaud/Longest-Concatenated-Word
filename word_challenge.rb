# Hung Auduong
# 1/18/2018
# Longest Concatenated Word
#
# This program reads a file of ~ 173k list of words and finds the longest
# and second longest that is entirely made up of other words within the file.
# It also keeps track of how many of these concatenated words exist in the file

class WordChallenge

    # post: Initialize the program by setting it's variables
    def initialize(file = "wordsforproblem.txt")
        @total = 0
        @file = file
        @longest = ""
        @second_longest = ""
        @root = Node.new(nil)
        prompt_user
    end

    # post: Implementation of a trie tree. Takes each letter from each word and store it as a node
    #       in the trie tree. There is an indicator that indicates at the end of each word
    def create_tree
        File.open(@file).each do |word|
            temp_node = @root
            string = word.to_s.strip
            string.each_char do |char|
                char_symbol = char.to_s.intern
                unless temp_node.children.has_key?(char_symbol)
                    temp_node.add(char)
                end
                temp_node = temp_node.children[char_symbol]
            end
            temp_node.is_word = true
        end
    end

    # post: Iterate through each word to find if the word is a concatenation of other words
    #       within the file.
    #       if word >= longest word's length or word > second longest word's length
    #       then it updates the longest and second longest accordingly.
    def solve
        File.open(@file).each do |word|
            string = word.to_s.strip
            if search(string, @root, true)
                @total += 1
                if string.length >= @longest.length
                    @second_longest = @longest
                    @longest = string
                elsif string.length > @second_longest.length
                    @second_longest = string
                end

            end
        end
    end

    def result
        puts "The longest concatenated word was: #{@longest}. "
        puts "The second longest concatenated word was: #{@second_longest}."
        puts "The number of concatenated words in the file were: #{@total}."
    end

    private

    # post: Helper method. Recursively search each letter in the word and check if its a word.
    #       once it finds a word, the recursive call will act as a place holder and it continues
    #       to search the suffix. If the suffix can't find a path, then it goes back to the last
    #       placeholder and see if the last valid word can make a path.
    #       return true if finds a valid path. false if its on the original call and
    #       cant find a valid path.
    def search(string, node, first_call)
        n = 0
        while n < string.length
            char = string[n].to_s.intern
            node = node.children[char]
            if node.nil?
                return false
            elsif node.is_word
                if search(string[n+1..string.length], @root, false)
                    return true
                end
            end
            n+=1
        end
        node.is_word && !first_call
    end

    def prompt_user
        puts "Aspera Coding Challenge."
        puts "The Program will use the word file: wordsforproblem.txt \n\n"
    end
end


# post: Node class is represent each letter. It holds the following data:
#       the key its own hash, it's children nodes, and indicator if this node
#       is a valid word.

class Node

    attr_accessor :is_word, :children
    attr_reader :key

    def initialize(s, is_word = false)
        @key = s
        @is_word = is_word
        @children = Hash.new
    end

    def add(char)
        @children[char.intern] = Node.new(char)
    end
end

# post: driver.
start = Time.now
solve = WordChallenge.new
solve.create_tree
solve.solve
solve.result
stop = Time.now
puts "#{stop - start} second(s)."

