module Colorable
  [:red, :green, :yellow, :blue, :magenta, :cyan, :white].each do |color|
    define_method(color) do |text|
      c = HighLine.const_get(color.to_s.upcase)
      "#{HighLine::BOLD}#{c}#{text}#{HighLine::RESET}"
    end
  end

  def color_text(color, text)
    "#{color}#{text}#{HighLine::RESET}"
  end
end
