class String
  def to_char_array
    a = []
    each_byte do |b|
      a << b.chr
    end
    a
  end

  def color(options = {})
    if options.is_a? Symbol
      options = {:fg => options}
    end

    color = ""
    if options[:fg]
      color << HighLine.const_get(options[:fg].to_s.upcase)
    end

    if options[:bg]
      color << HighLine.const_get("ON_#{options[:bg].to_s.upcase}")
    end

    "#{HighLine::BOLD}#{color}#{self}#{HighLine::RESET}"
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

