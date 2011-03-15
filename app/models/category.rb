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
    YAML::load( File.open(File.dirname(__FILE__) + "/category.yml" ) )
  end
  
  def self.root_old

root = Category.new('root') \
  .add_child( \
    Category.new('house') \
    .add_child( \
      Category.new('maintenance') \
        .add_child(Category.new('painting')) \
        .add_child(Category.new('masonrywork')) \
        .add_child(Category.new('electricity')) \
        .add_child(Category.new('alarms')) \
        .add_child(Category.new('network')) \
        .add_child(Category.new('automation')) \
        .add_child(Category.new('domotics')) \
        .add_child(Category.new('other')) \
    ) \
    .add_child(Category.new('design')) \
    .add_child( \
      Category.new('plants') \
        .add_child(Category.new('electrical')) \
        .add_child(Category.new('plumbing')) \
        .add_child(Category.new('heating')) \
        .add_child(Category.new('cooling')) \
        .add_child(Category.new('air_conditioning')) \
        .add_child(Category.new('other')) \
    ) \
    .add_child(Category.new('condo_management')) \
    .add_child(Category.new('other'))
   ) \
  .add_child( \
    Category.new('money') \
      .add_child(Category.new('administration')) \
      .add_child(Category.new('fiscal')) \
      .add_child(Category.new('finance')) \
  ) \
  .add_child( \
    Category.new('family') \
      .add_child(Category.new('baby_sitting')) \
      .add_child(Category.new('nursing')) \
      .add_child(Category.new('lawyer')) \
      .add_child(Category.new('other')) \
  )  \
  .add_child( \
    Category.new('wellness') \
      .add_child(Category.new('treatment')) \
      .add_child(Category.new('hair')) \
      .add_child(Category.new('body')) \
      .add_child(Category.new('massage')) \
      .add_child(Category.new('nails')) \
      .add_child(Category.new('other')) \
  ) \
  .add_child( \
    Category.new('special_event') \
      .add_child(Category.new('catering')) \
      .add_child(Category.new('party')) \
      .add_child(Category.new('wedding_planning')) \
      .add_child(Category.new('other')) \
  ) \
  .add_child( \
    Category.new('education') \
      .add_child(Category.new('tutoring')) \
      .add_child(Category.new('other')) \
  ) \
  .add_child( \
    Category.new('fashion') \
      .add_child(Category.new('persoanl_shopper')) \
      .add_child(Category.new('tailor')) \
      .add_child(Category.new('shoemaking')) \
      .add_child(Category.new('other')) \
  )  \
  .add_child( \
    Category.new('hobby') \
      .add_child(Category.new('musical_instruments')) \
      .add_child(Category.new('lutist')) \
      .add_child(Category.new('other')) \
  )  \
  .add_child( \
    Category.new('kids') \
      .add_child(Category.new('baby_sitting')) \
      .add_child(Category.new('tutoring')) \
      .add_child(Category.new('other')) \
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

  def initialize(include_root=false)
    @options = Array.new
    @include_root = include_root
  end

  def visit(category)
    if( !category.is_root || (category.is_root && @include_root) )
      @options.push Option.new(category.unique_key, ("-" * (category.depth-1)) + I18n.t("category." + category.unique_key + ".title"))
    end
    return self;
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


#root = Category.root
#print "#{root}\n"
#print "#{root.accept(Visitor1.new).desc}\n"
#print "#{root.accept(Visitor2.new).desc}\n"
#print "#{YAML.dump(root)}\n"