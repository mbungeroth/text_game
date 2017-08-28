class Map
  @@rooms = {bedroom: Bedroom.new(),
             living_room: LivingRoom.new(),
             kitchen: Kitchen.new(),
             bathroom: Bathroom.new(),
             finished: Finished.new()}

  def initialize(start_room)
    @start_room = start_room
  end

  def next_room(room_name)
    the_room = @@rooms[room_name]
    the_room
  end

  def opening_room()
    next_room(@start_room)
  end
end
