class Player
  attr_accessor :room, :items, :status

  def initialize(room = "bedroom",
                 items = [],
                 status = { smell: "bad", skin: "dry", breath: "stinky",
                            hunger: true, coffee: false, clothes: false,
                            bathroom: false, kitchen: false })
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
    puts "You lose."
    exit(0)
  end
end
