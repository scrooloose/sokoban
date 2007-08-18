class String
  def to_char_array
    a = []
    each_byte do |b|
      a << b.chr
    end
    a
  end
end

class Array
  def include_all?(*objs)
    objs.each do |obj|
      return false unless include?(obj)
    end
    true
  end

  def include_any?(*objs)
    objs.each do |obj|
      return true if include?(obj)
    end
    false
  end
end

class Hash
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end

  def reverse_merge!(other_hash)
    replace(reverse_merge(other_hash))
  end
end