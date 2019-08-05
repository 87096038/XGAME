
RoomNode = Class("RoomNode")

function RoomNode:cotr(top, bottom, right, left)
    self.top = top
    self.btm = bottom
    self.right = right
    self.left = left


end

function RoomNode:GenerateEnvironment()

end

return RoomNode