require_relative 'Player'
require_relative 'Rooms'
require_relative 'Map'

class GameRun
  def initialize(room, player)
    @room = room
    @player = player
  end

  def play()
    current_room = @room.opening_room
    last_room = @room.next_room('finished')

    while current_room != last_room
      next_room = current_room.enter
      current_room = @room.next_room(next_room)
    end

    current_room.enter
  end
end

player = Player.new()
Room.new(player)
the_map = Map.new(:bedroom)
the_game = GameRun.new(the_map, player)
intro = <<END
.......
BZANG BZANG BZANG BZANG...
.......
What's going on...
.......
BZANG BZANG BZANG BZANG...
.......
Ugh. The alarm. It's Monday morning. Oh god. You have work.
.......
BZANG BZANG BZANG BZANG...
.......
It's time to get up. You have to... make it to work. What do you do...
END

puts intro
the_game.play
