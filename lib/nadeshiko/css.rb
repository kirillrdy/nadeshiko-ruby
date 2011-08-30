module Nadeshiko
  class Css

    def initialize
      @styles = {}
    end

    def add selector, style
      @styles[selector] ||= []
      @styles[selector] << style
    end

    def to_css
      string = ""
      for selector in @styles.keys
        string += "#{selector} {\n"
        for entry_item in @styles[selector]
          entry_item.keys.each do |key|
            string += "#{key}: #{entry_item[key]};\n"
          end
        end
        string += "}"
      end
      return string
    end

  end

end

require './lib/nadeshiko'
css = Nadeshiko::Css.new
css.add('body',{:height => '100px'})
css.to_css

