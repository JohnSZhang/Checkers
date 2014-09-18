class InvalidMoveError < StandardError

end

class JumpingAfterSlideError < InvalidMoveError
  def to_s
    "Jumping after sliding, everybody come! we have a cheater here!"
  end
end

class SlideAfterJumpError < InvalidMoveError
  def to_s
    "Sliding after jumping, and you thought you were soooooo clever..."
  end
end

class SlideAfterSlideError < InvalidMoveError
  def to_s
    "Sliding twice?? You aren't even very good at this whole cheating thing"
  end
end