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

    root = Category.new('root') \
      .add_child(Category.new('house') \
          .add_child(Category.new('design')) \
          .add_child(Category.new('renovations')) \
          .add_child(Category.new('maintenance')) \
       ) \
      .add_child(Category.new('plants') \
          .add_child(Category.new('electrical')) \
          .add_child(Category.new('plumbing')) \
      )



    return root
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

  def unique_key
    if @parent.nil?
      key
    else
      @parent.unique_key + "." + key
    end
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

class OptionsVisitor

  attr_accessor :options

  def initialize
    @options = Array.new
  end

  def visit(category)
    #value = ("-" * category.depth) + category.key
    @options.push Option.new(category.id, ("-" * category.depth) + I18n.t("category." + category.unique_key + ".title"))
    return self;
  end
end



#root = Category.root
#print "#{root}\n"
#print "#{root.accept(Visitor1.new).desc}\n"
#print "#{root.accept(Visitor2.new).desc}\n"
#print "#{YAML.dump(root)}\n"