require 'yaml'

# A category in a category tree.
class Category

  @@next = 0

  attr_accessor :key
  attr_accessor :parent

  def find_by_unique_key_array the_ids
    ids = Array.new(the_ids)
    result = nil;
    if(!ids.nil? && !ids.empty? && ids[0]==@key)
      ids.delete_at(0)
      if ids.empty?
        result = self
      else
        i = 0
        while result == nil && i<@children.length
          result = @children[i].find_by_unique_key_array ids
          i = i + 1
        end
      end
    end
    return result
  end

  # Find the descendant that is described by the provided key.
  def find_by_unique_key unique_key
    return find_by_unique_key_array unique_key.split('.')
  end

  def self.next_id
    @@next = @@next + 1
  end

  def initialize(key=nil)
    raise "Illegal category key [#{key}]" if !key.nil? && key.include?('.')
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

  # return the path to the category
  def breadcrumb_keys options=nil
    whole = self.unique_key
    result = Array.new
    first = 0
    last = 0
    while !last.nil? && last < whole.length
      last = whole.index '.', last
      last = whole.length if last.nil?
      result<<whole[first, last-first]
      last = last + 1 #to jump the dot
    end

    if !options.nil? && options[:exclude_root] == true
      result.delete_at 0
    end

    return result
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
      cat_key = category.unique_key
      unless is_excluded(cat_key)
        @options.push Option.new(
          cat_key, \
          ( ("&nbsp;" * (category.depth-1)).html_safe ) + I18n.t("category." + category.unique_key + ".title"))
      end
    end
    return self;
  end

  # Return true if the a category with the given category key
  # should not be visited
  def is_excluded(category_key)
    unless @excludeds.nil?
      @excludeds.each do |excluded_key|
        if (category_key.length >= excluded_key.length) && (category_key.start_with? excluded_key)
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

# This one returs all categories
# Usage is:
# @categories = CategoryCollectsAllVisitor.new.visit(Category.root)
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

