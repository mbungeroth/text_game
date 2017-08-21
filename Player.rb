class Player
  attr_reader :items, :status #TODO see if this can be deleted
  attr_writer :room

  def initialize(room = "bed",
                 items = [],
                 status = { smell: "bad", skin: "dry", breath: "stinky",
                            hunger: true, coffee: false })
    @room = room
    @items = items
    @status = status
  end

  def add_item(item)
    @items << item
  end

  def change_status(status)
    @status << status
  end

  def lose(message)
    puts message
    exit(0)
  end

  def win(message)
    puts message
    exit(0)
  end
end

player = Player.new()
player.add_item("frog")
puts player.items
puts player.status[:smell]
player.status[:skin] = "wet"
puts player.status[:skin]
player.lose("You screwed up. Goodbye.")
