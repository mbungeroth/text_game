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
      elsif (action =~ /dressed/i or action =~ /clothes/i) ||
            @@player.status[:smell] == "good"
        puts "Your put clothes on your freshly cleaned body."
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
    puts "or into the bathroom. Finally, there is your front door."

    items_on_table = ["TV remote", "coffee table book", "keys",
                      "chinese take-out container"]

    loop do
      print ">>> "
      action = $stdin.gets.chomp

      if action =~ /look/i && action =~ /table/i
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
      elsif action =~/front door/i
        return :finished
      else
        puts "...what?"
      end
    end
  end
end


class Kitchen < Room
  def initialize; end

  def enter
    puts "You rub your tired eyes as you enter the kitchen. There is"
    puts "a fridge that is gently humming along. Next to it is a"
    puts "counter with an electric coffee maker on top, next to a"
    puts "bunch of bananas. Next to that is your kitchen sink and a"
    puts "drying rack with an assortment of festive mugs."

  items_in_fridge = ["yogurt",
                     "slice of cake",
                     "a paper plate with nothing on it",
                     "an ice pack that you meant to put in the freezer"]
  mug = "no"

#TODO fix that you can't eat stuff you've already eaten

    loop do
      print ">>> "
      action = $stdin.gets.chomp

      if action == "end test"
        return :finished
      elsif (action =~ /on/i) ||
            (action =~ /make/i) &&
            action =~ /coffee/i &&
            mug == "no"
        puts "You turn on your coffee maker. It begins working. It starts"
        puts "dripping fresh, hot coffee... all over the counter and now"
        puts "the floor as well. You dingus. In a rush to clean it, you"
        puts "burn your hands on it."
        @@player.lose("What a mess. You give up on your life.")
      elsif action =~ /mug/i && action !=~ /make/i
        puts "You take a mug and place it on the coffee maker, ready"
        puts "to receive your delicious brew."
        mug = "yes"
      elsif ((action =~ /on/i) ||
            (action =~ /make/i) &&
            action =~ /coffee/i &&
            mug == "yes") ||
            (action =~ /mug/i &&
            (action =~ /make/i ||
            action =~ /on/i))
        puts "The aroma of your freshly made coffe is outsanding."
        puts "What a way to start the day. You slowly sip it, feeling"
        puts "your body slowly begin to come alive."
        @@player.status[:coffee] = true
        if @@player.status[:breath] = "good"
          @@player.status[:breath] = "stinky"
        end
      elsif (action =~ /look/i || action =~ /open/i) && action =~ /fridge/i
        range = items_in_fridge[0...items_in_fridge.length-1]
        puts "You open the refrigerator door."
        print "You see a "
        range.each { |item| print item + ", " }
        print "and a "
        puts items_in_fridge[items_in_fridge.length-1]+"."
      elsif (action =~ /eat/i && action =~ /banana/i && action =~ /cake/i) ||
            (action =~ /eat/i && action =~ /banana/i && action =~ /yogurt/i) ||
            (action =~ /eat/i && action =~ /yogurt/i && action =~ /cake/i)
        puts "Oh my goodness what a breakfast of champions!"
        @@player.status[:hunger] = false
        items_in_fridge.each do |item|
          if item == "cake"
            items_in_fridge.delete("cake")
          elsif item == "yogurt"
            items_in_fridge.delete("yogurt")
          end
        end
      elsif action =~ /eat/i && action =~ /banana/i
        puts "Mmm. My oh my what a delicious banana. You feel the"
        puts "potassium and sugars flow through you, energizing you."
        puts "You feel great."
        @@player.status[:hunger] = false
      elsif action =~ /eat/i && action =~/cake/i
        puts "You devil, you. Cake for breakfast? Hey, you only live once."
        @@player.status[:hunger] = false
        items_in_fridge.each do |item|
          if item == "slice of cake"
            items_in_fridge.delete("slice of cake")
          end
        end
      elsif action =~ /eat/i && action =~ /yogurt/i
        puts "You open the lid and toss the yogurt into your mouth"
        puts "like a champ. The nutrients liven your body up."
        @@player.status[:hunger] = false
        items_in_fridge.each do |item|
          if item == "yogurt"
            items_in_fridge.delete("yogurt")
      elsif action =~ /go/i && action =~ /living_room/i
        return :living_room
      elsif action =~ /go/i && action =~ /bathroom/i
        return :bathroom
      else
        puts "...what?"
          end
        end
      end
    end
  end
end

class Bathroom < Room
  def initialize; end

  def enter
    puts "You go into your bathroom. It has... well... bathroom things -"
    puts "a shower, a sink, a toilet, a mirror, a towel, your"
    puts "toothbrush, and some toothpaste."

    loop do
      print ">>> "
      action = $stdin.gets.chomp

      if action == "end test"
        return :finished
      elsif action =~ /shower/i and @@player.status[:clothes] == true
        puts "You turn on the shower and get in."
        puts "Seriously? You just showered with your clothes on?"
        @@player.lose("Good luck with life. You are a wet mess.")
      elsif action =~ /shower/i and @@player.status[:clothes] == false
        puts "You turn on the shower and get in. You wipe away"
        puts "the filth that was your weekend. You feel great."
        @@player.status[:smell] = "good"
        @@player.status[:skin] = "wet"
      elsif action =~ /dry/i || action =~ /towel/i
        puts "You rub the towel all over yourself. Every nook and cranny."
        @@player.status[:skin] = "dry"
      elsif action =~ /teeth/i || action =~ /brush/i
        puts "You put toothpaste on the brush and brush away the utter"
        puts "grossness that is your breath right now."
        @@player.status[:breath] = "good"
      elsif (action =~ /undress/i ||
            (action =~ /clothes/i && action =~ /off/i)) &&
            @@player.status[:clothes] == true
        puts "You take your clothes off. Nekkid time."
        @@player.status[:clothes] == false
      elsif action =~ /dressed/i ||
            (action =~ /clothes/i && action =~ /on/i)
        if @@player.status[:skin] == "wet" && @@player.items.include?("clothes")
          puts "Annnnd you just put clothes on a wet body. You have"
          puts "rendered them unwearable today, genius."
          @@player.lose("Good job!")
        elsif @@player.status[:skin] == "dry" && @@player.items.include?("clothes")
          puts "You put clothes on your nice clean body."
          @@player.status[:clothes] == true
        else
          puts "How do you put on clothing you don't have?"
        end
      elsif action =~ /mirror/i
        puts "You look in the mirror. Those gorgeous eyes stare right back."
      elsif action =~ /toilet/i || action =~ /pee/i || action =~/poo/i
        puts "You use the toilet and flush away two pounds."
      elsif action =~ /look around/i
        puts "You see a shower, a sink, a toilet, a mirror, a towel, your"
        puts "toothbrush, and some toothpaste. The room ain't changing."
      elsif action =~ /living room/i
        return :living_room
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
