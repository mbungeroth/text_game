class Room
  def initialize(player)
    @@player = player
  end

  def enter()
    puts "you shouldn't be here."
  end
end

class Bedroom < Room
  def initialize; end

  def enter
    loop do
      print ">>> "
      action = $stdin.gets.chomp
      if action =~ /off/i && action =~ /alarm/i
        puts "The alarm is off. You lie in bed, rubbing your eyes."
        break
      elsif action =~ /hit/i && action =~ /alarm/i
        puts "With great gusto you smack your alarm and it flies onto the"
        puts "floor, shattering. But it's off. You rub your eyes."
        break
      elsif action =~ /get/i && action =~ /up/i
        puts "You get out of bed. The alarm is still buzzing wildly."
        puts "You couldn't even start your day correctly. The buzzing"
        puts "is relentless. You tear your hair out. You run out into the"
        puts "street, naked, yelling, \"BZANG BZANG BZANG\" until you are"
        puts "ultimately arrested."
        @@player.lose("You spend the rest of your years in a mental hospital.")
      elsif action =~ /look/i && action =~ /around/i
        puts "You look around and see your nightstand, with an awfully"
        puts "loud alarm clock going off. There are some clothes and"
        puts "and a door, but this racket going on is making you unable"
        puts "to think properly."
      else
        puts "...what?"
        puts "BZANG BZANG BZANG BZANG"
      end
    end

    puts "You look around and see the work clothes you laid out last"
    puts "night and a door."

    door_open = false
    clothes_taken = false
    loop do
      print ">>> "
      action = $stdin.gets.chomp
      if action =~ /go/i && action =~ /door/i && action =~ /open/i
        puts "You open and walk through the door."
        return :living_room
      elsif action =~ /door/i && action =~ /open/i
        puts "You open the door and gaze into the living room."
        door_open = true
      elsif action =~ /into/i && action =~ /go/i  && door_open == true
        puts "You sleepily walk into the next room."
        return :living_room
      elsif action =~ /go/i && action =~ /door/i && door_open == false
        puts "You attempt to run, with all of your might, through the door."
        puts "..."
        puts "The door wins."
        @@player.lose("You knock yourself out, sleep through work, lose your job.")
      elsif action =~ /clothes/i && clothes_taken == false
        puts "You pick up your clothes. You feel like a winner. They are"
        puts "superbly clean and the polka dot underwear reminds you"
        puts "that you have impeccable fashion sense."
        @@player.add_item("clothes")
        clothes_taken = true
      elsif (action =~ /put/i && action =~ /clothes/i && @@player.clothes_on == true) ||
            (action =~ /dressed/i && @@player.clothes_on == true)
        puts "What.. you're already dressed."
      elsif (action =~ /put/i && action =~ /clothes/i && clothes_taken == true) ||
            (action =~ /dressed/i && clothes_taken == true)
            puts "You put on your clothes. Damn do you look sharp in them."
            @@player.clothes_on = true
      elsif (action =~ /put/i && action =~ /clothes/i && clothes_taken == false) ||
            (action =~ /dressed/i && clothes_taken == false)
        puts "You can't put on what you don't have."
      elsif action =~ /look/i && action =~ /around/i
        if clothes_taken == false
          puts "You look around and see the work clothes you laid out last"
          puts "night and a door."
        else
          puts "You see a door."
        end
      else
        puts "...what?"
      end
    end
  end
end

class LivingRoom < Room
  def initialize; end

  def enter
    puts "testing living room"
    :finished
  end
end

class Finished < Room
  def initialize; end

  def enter
    puts "You win."
    exit(0)
  end
end
