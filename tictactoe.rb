#Functions for determining computer plays. Also used to check status of the game.
module StrategyTools   

#Output is array containing representations of each column,row, and diagonal on the game board 
  def view_currentboard(some_array) 
	rows = some_array 

	cols = []
	cols[0] = ([rows[0][0],rows[1][0],rows[2][0]])
	cols[1] = ([rows[0][1],rows[1][1],rows[2][1]])
	cols[2]= ([rows[0][2],rows[1][2],rows[2][2]])

	diag1 = [rows[0][0], rows[1][1], rows[2][2]]
	diag2 = [rows[0][2], rows[1][1], rows[2][0]]
	
	currentboard_array =[rows,cols,diag1,diag2]
	
  end

  #Sums a one dimensional array 
  def sum_array(some_array) 
    sum = 0
	some_array.each do |x|
	  if x.is_a?Integer
	    sum = sum + x
	  end
	  
	 end
	 
	sum
  end

  #Sums a two dimensional array
  def sum_array_of_arrays(some_array) 
    big_sum = 0 
  
    some_array.each  do |x|
    big_sum = big_sum + sum_array(x)
    end
 
    big_sum
  
    end 

  #Chooses empty place on the board randomly for the computer to play
  def random_play(some_array) 
   test_for_change = sum_array_of_arrays(some_array)
  
   while sum_array_of_arrays(some_array) == test_for_change
     row = rand(3)
	 col = rand(3)
	
	 if some_array[row][col] == nil then some_array[row][col] = 10 end
	
   end 
   
   some_array
   
  end
  
  #Makes a play for the computer that wins the game or counters a potential user win. 
  def potential_wins(x,some_array)  
    currentboard_array = view_currentboard(some_array)
    rows = currentboard_array[0]
    cols = currentboard_array[1]
    diag1 = currentboard_array[2]
    diag2 = currentboard_array[3]
  
    if (sum_array(rows[0]) == x) && (rows[0].include?nil) 
      some_array[0][rows[0].index(nil)] = 10
    elsif (sum_array(rows[1]) == x) && (rows[1].include?nil)
      some_array[1][rows[1].index(nil)] = 10
    elsif (sum_array(rows[2])== x) && (rows[2].include?nil)
      some_array[2][rows[2].index(nil)] = 10
	
    elsif (sum_array(cols[0])== x) && (cols[0].include?nil) && (some_array[cols[0].index(nil)][0] == nil)
      some_array[cols[0].index(nil)][0] = 10
    elsif (sum_array(cols[1])== x) && (cols[1].include?nil) && (some_array[cols[1].index(nil)][1] == nil)
      some_array[cols[1].index(nil)][1] = 10
    elsif (sum_array(cols[2])== x) && (cols[2].include?nil) && (some_array[cols[2].index(nil)][2] == nil)
      some_array[cols[2].index(nil)][2] = 10
	
    elsif (sum_array(diag1) == x) && (diag1.include?nil) && (some_array[diag1.index(nil)][diag1.index(nil)] == nil)
      some_array[diag1.index(nil)][diag1.index(nil)] = 10
  
    elsif sum_array(diag2) == x
	  if diag2.index(nil) == 0
        some_array[0][2] = 10
	  elsif diag2.index(nil) == 1
	    some_array[1][1] = 10
	  elsif diag2.index(nil) == 2
	    some_array[2][0] = 10
	  end
    end 
	
    some_array
	
  end
  
  #Makes a move for the computer into one of the most strategic spaces on the board
  def good_move(some_array) 
    
	if (some_array[1][1] == nil) && (rand(3) == 0)
      some_array[1][1] = 10
    elsif (some_array[0][0] == nil) && (rand(3) == 0)
	  some_array[0][0] = 10
    elsif (some_array[0][2] == nil) && (rand(3) == 0)
	  some_array[0][2] = 10
    elsif (some_array[2][0] == nil) && (rand(3) == 0)
	  some_array[2][0] = 10
    elsif (some_array[2][2] == nil) && (rand(3) == 0)
	  some_array[2][2] = 10
    else
      random_play(some_array)
    end
	
    some_array
	
  end

  #Makes a move for the computer which minimizes the chance of a user win in the case of two intersecting user moves
  def look_for_intersect(some_array) 
  
    options = rand(2)
  
    if (some_array[0].include?1) && (some_array[1].include?1)
      case options
	  when 0
	    some_array[1][some_array[0].index(1)] ||= 10
	  when 1
	    some_array[0][some_array[1].index(1)] ||= 10
	  end
	
    elsif (some_array[0].include?1) && (some_array[2].include?1)
      case options
	  when 0
	    some_array[2][some_array[0].index(1)] ||= 10
	  when 1
	    some_array[0][some_array[2].index(1)] ||= 10
	  end
	
    elsif (some_array[1].include?1) && (some_array[2].include?1)
      case options
	  when 0
	    some_array[2][some_array[1].index(1)] ||= 10
	  when 1
	    some_array[1][some_array[2].index(1)] ||= 10
	  end
	
    end
  
    some_array
 
  end

  #Executes whichever computer play function is most appropriate for the current game board
  def smart_play(some_array) 
    include StrategyTools
 
    test_value = sum_array_of_arrays(some_array)
  
    #execute computer win
    if test_value == sum_array_of_arrays(some_array)
    some_array = potential_wins(20,some_array) 
    end
    

    #block user win
    if test_value == sum_array_of_arrays(some_array)
      some_array = potential_wins(2,some_array)
    end
   
    #build on one computer move
    if test_value == sum_array_of_arrays(some_array)
      some_array = potential_wins(10,some_array)
    end
    
    #block user at intersection
    if test_value == sum_array_of_arrays(some_array)
      some_array = look_for_intersect(some_array)
    end
    

    #move to a strategic place on the board
    if test_value == sum_array_of_arrays(some_array)
      some_array = good_move(some_array)
    end
    
    some_array

  end

  
end

#Some definitions used to align outputs
module FormatBoard 

  def center
    35.times{print " "}
  end
  
  def center2
    32.times{print " "}
  end

end  
  
  
  
#Delays some function invocations by a few seconds for user friendliness  
def delay(x=1)   
  current_time = Time.now.to_i
    while Time.now.to_i - current_time < x 
	end
end

#Puts string acknowledging a win or a tie.
 def win_?(one_two_ten) 
  
  case one_two_ten
  when 0
    return ""
	
  delay(3)
  
  when 10
    20.times{print " "};print "Unsurprisingly, I've won this round.\n\n"
  when 2
    18.times{print " "};print "A tie!? You won't be so lucky next time."
  when 1
	puts "Hmm... you won this round. You seem a bit bored. Tired of me going easy on you?\n\n"
  end
  
  end   

 #Returns 1 if user's won, 10 if computer's won, 2 if the board's full, else returns 0
def check_game_status (some_array) 
  include StrategyTools
  
  currentboard_array = view_currentboard(some_array)
  rows = currentboard_array[0]
  cols = currentboard_array[1]
  diag1 = currentboard_array[2]
  diag2 = currentboard_array[3]
	
	
  check = 0 
  
   #user win?
    if (sum_array(rows[0])) == 3 || (sum_array(rows[1])) == 3 || (sum_array(rows[2])) == 3 then check = 1 
	elsif (sum_array(cols[0])) == 3 || (sum_array(cols[1])) == 3 || (sum_array(cols[2])) == 3 then check = 1 
	elsif ((sum_array(diag1)) == 3) then check = 1 
	elsif ((sum_array(diag2)) == 3) then check = 1
 

   #computer win?
    elsif (sum_array(rows[0])) == 30 || (sum_array(rows[1])) == 30 || (sum_array(rows[2])) == 30 then check = 10 
    elsif (sum_array(cols[0])) == 30 || (sum_array(cols[1])) == 30 || (sum_array(cols[2])) == 30 then check = 10 
    elsif ((sum_array(diag1)) == 30) then check = 10 
    elsif ((sum_array(diag2)) == 30) then check = 10 
    
	
	#full board/no win
	elsif sum_array_of_arrays(some_array) >= 45 then check = 2
    end
  
  check   
  
  end

#Prints a representation of the current board 
def display_board(some_array,some_letter) 
  include FormatBoard
  
  if some_letter == "X" 
    other_letter = "O"
  else
    other_letter = "X"
  end

#converts the game array to a usable string
  def make_sentence(array)  
	sentence = ""
	array.each do |mini_arrays|
      mini_arrays.each do |element|
        sentence << "a#{element}a "
      end
    end 
    
	sentence
  end

  some_array_string = make_sentence(some_array)
  sep_strings = some_array_string.split(' ')

  board_hash = {"a1a" => "#{some_letter}", "a10a" => "#{other_letter}", "aa" => "?"}

  print "\n\n"
  center2
  puts "CURRENT BOARD"
  center2
  puts "_____________"
  print "\n\n"
  center; 3.times{print "_  "} 
  print "\n\n"
  center; print board_hash[sep_strings[0]] + "  " +  board_hash[sep_strings[1]] + "  " +  board_hash[sep_strings[2]];puts
  center; print board_hash[sep_strings[3]] + "  " +  board_hash[sep_strings[4]] + "  " +  board_hash[sep_strings[5]];puts
  center; print board_hash[sep_strings[6]] + "  " +  board_hash[sep_strings[7]] + "  " +  board_hash[sep_strings[8]];puts
  center; 3.times{print "_  "}; puts; puts
  
  some_array
  
 end

 # Picks random or smart computer plays according to game level
def comp_move(some_array,which_level) 
  include StrategyTools
  include FormatBoard
  
  3.times{print "\n"}
  center
  print "MY MOVE\n"
  center
  4.times{print "_ "}
  
  case which_level 
  when "1"
	random_play(some_array)  
  
  when "2"
	if rand(2).odd?
	  smart_play(some_array) 			
	else
	  random_play(some_array) 
	end
	
  when "3"
    if rand(4) < 3
	  smart_play(some_array) 
	else
	  random_play(some_array) 
	end

  when "4"
	if rand(100) < 98
	  smart_play(some_array) 		
	else
	  random_play(some_array) 
	end
	
  end
  
  some_array
end

# Puts a user move into the game array 
def user_move(one,two,some_array) 
  include FormatBoard
  
  if some_array[one][two] == nil
     some_array[one][two] = 1
	 puts;puts;puts;center2;print "  ";print "YOUR MOVE"
     puts;center2;print "  ";5.times{print "_ "}
	 
  else
    puts "That space is already taken. Pick somewhere else."
	new_input_array = prompt_for_move
	new_row = new_input_array[0].to_i - 1
	new_col = new_input_array[1].to_i - 1
	user_move(new_row,new_col,some_array)
  end
  
  some_array
end

#Returns array containing row and column of user move. Is stored in variable 'input_array'.
def prompt_for_move 
  puts "\n\n\nMake your move. Or press ENTER/RETURN to end this round and declare a tie.\n\n"
 
  goes_to_input_array = []
    
  until ((goes_to_input_array[0] =~ /[123]/) && (goes_to_input_array[1]) =~ /[123]/) != nil 
    puts "Please enter two integers between 1 and 3.\n\n" 
	print "> "
	goes_to_input_array = STDIN.gets.chomp.split(/[[:punct:]]* */)
	if goes_to_input_array == [] then return [nil] end 
  end
  
  goes_to_input_array = [goes_to_input_array[0].to_i, goes_to_input_array[1].to_i]
  
  goes_to_input_array 

end

#Chooses who makes the first move randomly. Makes first computer move if rand(2) is odd
def coin_flip(some_array,which_level,some_letter) 
  display_board(some_array,some_letter)
  
  print "\n\nFlipping coin...\n\n"
  
  delay
  
  if rand(2).odd?
	puts;puts "TAILS. I go first.\n\n"
	delay
	some_array = comp_move(some_array,which_level)
	display_board(some_array,some_letter)
	
  else
    print " HEADS\n\n"
    puts "Heads. You're up.\n"
  end
  
  some_array
  
end

# Prompts user to choose level. Outputs the appropriate string. 
def choose_level 
  puts "\n\nChoose level 1, 2, 3, or 4.\n\n"
  print "> "
  test = STDIN.gets.chomp
  
  if (test == "1") || (test == "2") || (test == "3") || (test == "4") 
    level = test
	puts "\n\nProceeding to level #{level}!\n"
	40.times{print "_ "}
	level
  else
	choose_level	
  end 
  
end

#Prompts user to pick their letter
def choose_letter 
  puts "\nPick your letter (X/O)."
  print "> "
  letter = STDIN.gets.chomp.upcase


  if (letter != "X") && (letter != "O")
    puts "\nWrong character.\nPlease press the \"X\" or \"O\" key\non your keyboard.\n\n\n"
    letter = choose_letter
  end
  letter
end

#Makes the game array 
def generate_tic_tac_array 
  game_array = Array.new
  3.times{game_array.push([nil,nil,nil])}
  game_array
end




#Printing an introduction to the console
80.times{print "-"};puts
35.times{print " "};puts "Tic Tac Toe"
80.times{print "-"};puts

delay
puts <<HOWTO
			 Here's how the game works:
		
		1) We'll flip a coin to see who goes first. 
		
		2) When it's your turn, you'll tell me the 
		   row and column of your move. 

		For example: 
		Entering '23' will put your next move in the
		2nd row of the 3rd column, as shown here. 

				-	-	-
				?	?	?
				?	?	X
				?	?	?
				-	-	-	

		2) I'll display the game board after each play.

				 Let's begin! 
		-------------------------------------------------
HOWTO


#Setting scoreboard variables
games = 0
your_wins = 0
my_wins = 0
ties = 0 


#Starting the play loop
while true
  tic_tac_array = generate_tic_tac_array
  
  letter = choose_letter
  
  level = choose_level
  delay
  tic_tac_array = coin_flip(tic_tac_array,level,letter)
  

  while true
    input_array = prompt_for_move
	if input_array == [nil]
	  ties +=1
	  break
	end 
	
    tic_tac_array = user_move(input_array[0]-1,input_array[1]-1,tic_tac_array)
	
    display_board(tic_tac_array,letter)
	
	checkpoint = check_game_status(tic_tac_array)
	if checkpoint == 1 then your_wins +=1 end
	if checkpoint == 2 then ties +=1 end
	win_?(checkpoint)
	delay(2)
	break if checkpoint > 0 
	
	
	print "\n\n\n"
	center;print "My turn...\n\n"
	
	
	delay
    tic_tac_array = comp_move(tic_tac_array,level)
	
    display_board(tic_tac_array,letter)
	
    checkpoint = check_game_status(tic_tac_array)
	if checkpoint == 10 then my_wins +=1 end
	if checkpoint == 2 then ties +=1 end
	win_?(checkpoint)
	delay(2)
	break if checkpoint > 0 
		
  end
  
  
   
  games +=1
  
  delay
  30.times{print "\n"}
  puts "SCOREBOARD"
  10.times{print "_"}
  puts "\n\nTotal matches: #{games}"
  puts "Your wins: #{your_wins}"
  puts "My wins: #{my_wins}"
  puts "Ties: #{ties}"
  
  puts "\n\nGame over! Type 's' to start over. Press ENTER/RETURN to exit the game.\n\n" 
  print "> "
  response = STDIN.gets.chomp.downcase
  break if response != "s" 
   
  30.times{print"\n"} 
  print "You haven't had enough yet? Let's play again then!"
  puts
end
