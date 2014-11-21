class MingleAPI
  class Macro
    def text(node, css)
      if ret = node.at_css(css)
        ret.text
      end
    end

    def apply(node, attr)
      case attr
      when String
        [attr, text(node, attr)]
      when Symbol
        apply(node, attr.to_s)
      when Array
        attr.map do |a|
          apply(node, a)
        end.flatten
      when Hash
        attr.map do |key, value|
          case value
          when Symbol
            [value, text(node, key)]
          when Proc
            node.css(key).map do |child|
              self.instance_exec(child, &value)
            end
          end
        end
      end
    end
  end
end