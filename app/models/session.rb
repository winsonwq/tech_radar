class Session

  private

  @@cache = {}

  public

  def self.set str_key, obj
    if get(str_key).nil?
      @@cache[str_key] = obj
      return true
    end
    false
  end

  def self.get str_key
    @@cache[str_key]
  end

  def self.safe_get str_key
    if get(str_key).nil?
      set str_key, {}
    end
    get str_key
  end

  def self.clear
    @@cache.clear
  end
end