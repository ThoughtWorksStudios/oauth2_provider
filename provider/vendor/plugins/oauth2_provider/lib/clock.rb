class Clock
  
  def self.fake_now=(time_now)
    @fake_now = time_now
  end
  
  def self.now
    @fake_now || Time.now
  end
  
  def self.reset
    @fake_now = nil
  end
  
end