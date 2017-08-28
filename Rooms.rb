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
    snooze = 0
    loop do
      print ">>> "
      action = $stdin.gets.chomp
      if action =~ /off/i && action =~ /alarm/i
        puts "The alarm is off. You lie in bed, rubbing your eyes."
        break
      elsif action =~ /hit/i && action =~ /snooze/i
        if snooze < 2
          puts "You hit snooze and sleep ten more minutes. Stop delaying"
          puts "your future."
          puts "............"
          puts "BZANG BZANG BZANG BZANG"
          snooze += 1
        else
          puts "You can't spend your life pretending you can hit snooze"
          puts "to make bad things disappear. Get ahold of yourself."
          @@player.lose("Face life head on, you weakling.")
        end
      elsif action =~ /hit/i && action =~ /alarm/i
        puts "With great gusto you smack your alarm and it flies onto the"
        puts "floor, shattering. But it's off. You rub your eyes."
        break
      elsif (action =~ /get/i && action =~ /up/i) ||
            (action =~ /out/i && action =~ /bed/i)
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
      elsif (action =~ /into/i && action =~ /go/i  && door_open == true) ||
            (action =~ /through/i && action =~ /doorway/i && door_open == true) ||
            (action =~ /to/i && action =~ /room/i && door_open == true)
        puts "You sleepily walk into the next room."
        return :living_room
      elsif action =~ /go/i && action =~ /door/i && door_open == false
        puts "You attempt to run, with all of your might, through the door."
        puts "..."
        puts "The door wins."
        @@player.lose("You knock yourself out, sleep through work, lose your job.")
      elsif (action =~ /put/i && action =~ /clothes/i && clothes_taken == false) ||
            (action =~ /dressed/i && clothes_taken == false)
        puts "You can't put on what you don't have."
      elsif action =~ /clothes/i && clothes_taken == false
        puts "You pick up your clothes. You feel like a winner. They are"
        puts "superbly clean and the polka dot underwear reminds you"
        puts "that you have impeccable fashion sense."
        @@player.add_item("clothes")
        clothes_taken = true
      elsif (action =~ /put/i && action =~ /clothes/i && @@player.status[:clothes] == true) ||
            (action =~ /dressed/i && @@player.status[:clothes] == true)
        puts "What.. you're already dressed."
      elsif (action =~ /put/i && action =~ /clothes/i && clothes_taken == true) ||
            (action =~ /dressed/i && clothes_taken == true)
        puts "You put on your clothes. Damn do you look sharp in them."
        @@player.status[:clothes] = true
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
    puts "You enter the living room."
    puts "You have a luxuriously soft sofa and a nearby coffe table"
    puts "with some stuff on it. You have a television, across from"
    puts "the sofa (obviously). There is the door behind you, which"
    puts "leads back to the bedroom. You can also walk to the kitchen"
    puts "or into the bathroom."

    items_on_table = ["TV remote", "coffee table book", "keys",
                      "chinese take-out container"]

    loop do
      print ">>> "
      action = $stdin.gets.chomp

      if action == "end test"
        return :finished
      elsif action =~ /look/i && action =~ /table/i
        puts items_on_table.length
        range = items_on_table[0...items_on_table.length-1]
        puts "You look at the coffee table with a bit more interest."
        print "You see a "
        range.each { |item| print item + ", " }
        print "and a "
        puts items_on_table[items_on_table.length-1]+"."
      elsif action =~ /on/i && (action =~ /tv/i || action =~ /television/i)
        puts "You turn on the TV. The news shows the time and makes you"
        puts "realize you should be doing something else. You turn the"
        puts "TV off so you can focus on your task at hand."
      elsif action =~ /look/i && action =~ /book/i
        puts "It's a big book with pictures. Don't you have something"
        puts "else you should be doing?"
      elsif action =~ /chinese/i ||
            action =~ /take-out/i ||
            action =~ /container/i
        puts "You pick up the old container of food. You bring it"
        puts "towards your nose. You inhale..."
        puts "The nasty smell is overpowering."
        puts "You pass out."
        @@player.lose("You wake up a day later. You lost your job.")
      elsif action =~ /keys/i
        puts "You take your keys. Probably a good idea."
        @@player.add_item("keys")
        items_on_table.each do |item|
          if item == "keys"
            items_on_table.delete("keys")
          end
        end
      elsif action =~ /sit/i && (action =~ /couch/i || action =~ /sofa/i)
        puts "You sit on your amazingly soft couch. It's sweet caress"
        puts "gently lulls you to sleep. Welome to Dreamland, buddy."
        @@player.lose("You wake up a day later. You lost your job.")
      elsif action =~ /bedroom/i
        return :bedroom
      elsif action =~ /kitchen/i
        return :kitchen
      elsif action =~ /bathroom/i
        return :bathroom
      else
        puts "...what?"
      end
    end
  end
end

class Finished < Room
  def initialize; end

  def enter
    puts "You win."
    exit(0)
  end
end
