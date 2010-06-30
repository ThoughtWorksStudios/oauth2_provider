module SecureRandom
  
  def self.random_bytes(size=32)
    Base64.encode64(OpenSSL::Random.random_bytes(size)).gsub(/\W/, '')
  end
  
end
