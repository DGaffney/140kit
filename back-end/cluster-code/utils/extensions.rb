class Array
  def sum
    self.compact.inject(0) { |s,v| s += v }
  end
  def to_i
    self.collect{|x| x.to_i}
  end
  def to_f
    self.collect{|x| x.to_i}
  end
end

class String

  require 'rubygems'
  require 'htmlentities'

  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").downcase.concat("s")
  end
  
  def to_bool
    if self == "1"
      return true
    elsif self == "0"
      return false
    else return nil
    end
  end
  
  def sanitize
    coder = HTMLEntities.new
    return coder.encode(self).gsub("#", "%23").gsub(" ", "%20").gsub("&quot\;", "%22").gsub("\"", "%22").gsub("\342\231\245", "&#9829\;")
  end
  
  def sanitize_for_streaming
    return self.split("").reject {|c| c.match(/[\w\'\-]/).nil?}.to_s
  end
  
  def classify
    if self.split(//).last == "s"
      camelize(self.sub(/.*\./, '').chop)
    else
      camelize(self.sub(/.*\./, ''))
    end
  end
  
  def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
  
  def constantize
    return Object.const_defined?(self) ? Object.const_get(self) : Object.const_missing(self)
  end
  
end

class Hash
  def flat_each(prefix=[], &blk)
    each do |k,v|
      if v.is_a?(Hash)
        v.flat_each(prefix+[k], &blk)
      else
        yield prefix+[k], v
      end
    end
  end
  
  def flatify
    hh = {}
    self.to_enum(:flat_each).collect { |k,v| [k.join("-"),v] }.collect {|attrib| hh[attrib[0]] = attrib[1]}
    return hh
  end
  
end

class Time
  def self.ntp
    return self.at(self.now.to_f + TIME_OFFSET)
  end
end

class Class
  def underscore
    return self.to_s.underscore
  end
  
  def sym
    return self.to_s.underscore.to_sym
  end
end