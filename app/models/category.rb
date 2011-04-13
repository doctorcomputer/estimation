require 'yaml'

class Category

  @@next = 0

  attr_accessor :key
  attr_accessor :parent

  def self.next_id
    @@next = @@next + 1
  end

  def initialize(key=nil)
    @id = Category.next_id
    @parent = nil
    @children = nil
    @key = key
    @enabled = true;
  end

  # Add a child category to this one and return self
  # so subsequent calls can be concatenated
  def add_child(category)
    category.parent = self
    @children = Array.new if @children.nil?
    @children.push category
    return self
  end

  def depth
    if parent.nil?
      0
    else
      parent.depth + 1
    end
  end

  def self.root
    YAML::load( File.open(File.dirname(__FILE__) + "/category.yml" ) )
  end
  
  def to_s
    return "#{@key.nil? ? 'root' : @key} #{@children.count} children"
  end

  def accept(visitor)
    visitor.visit(self)
    unless @children.nil?
      @children.each do |child|
        child.accept visitor
      end
    end
    return visitor
  end

  def is_root
    return @parent.nil?
  end

  # return the unique key of this category
  def unique_key
    if @parent.nil?
      #return key.nil? ? "" : key
      key
    else
      @parent.unique_key + "." + key
    end
  end

  # return the translated name of this category
  def t_name
    I18n.t("category." + category.unique_key + ".title")
  end

  # return the translated name of a category
  def self.t_name_by_key(key)
    I18n.t("category." + key + ".title")
  end
  
end

class Visitor1

  attr_accessor :desc

  def initialize
    @desc = ""
  end

  def visit(category)
    unless category.is_root
      @desc+= "|" + category.unique_key
    else
      @desc+= 'root'
    end
    return self;
  end
end

class Visitor2

  attr_accessor :desc

  def initialize
    @desc = ""
  end

  def visit(category)
    unless category.is_root
      @desc+= "\n" + (" " * category.depth) + category.key
    else
      @desc+= 'root'
    end
    return self;
  end
end

class Option
  attr_accessor :id
  attr_accessor :value
  def initialize(id, value)
    @id = id
    @value = value
  end

end

# This visitor collects all values in the category tree as options of a select tag.
# It collects values upto a given depth, to avoid building cumbersome trees.
class OptionsVisitor

  attr_accessor :options

  def initialize(include_root=false)
    @options = Array.new
    @include_root = include_root
    @excludeds = nil
  end

  def visit(category)
    if (!category.is_root || (category.is_root && @include_root) ) && ( category.depth <= 2 )
      @options.push Option.new(
        category.unique_key, \
        ( ("&nbsp;" * (category.depth-1)).html_safe ) + I18n.t("category." + category.unique_key + ".title"))
    end
    return self;
  end

  def is_excluded(category)
    unless @excludeds.nil?
      @excludeds.each do |excluded_key|
        if (category.length >= excluded_key.length) && (category.start_with? excluded_key)
          return true
        end
      end
    end
    return false
  end

  def exclude excludeds
    @excludeds = excludeds
  end
  
end

class CategoryCollectsAllVisitor

  def initialize()
    @values = Array.new
  end

  def visit(category)
    if( !category.is_root )
      @values.push category.unique_key
    end
    return self;
  end

  def values
    @values
  end
end

