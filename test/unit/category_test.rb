require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def setup
    @tree = Category.new('root') \
      .add_child( \
        Category.new('a') \
          .add_child(Category.new '1') \
          .add_child(Category.new '2') \
      ) \
      .add_child( \
        Category.new('b') \
          .add_child(Category.new '1') \
          .add_child(Category.new '2') \
      )
  end

  def test_build_category
    v=OptionsVisitor.new
    @tree.accept(v)
    assert_equal 6, v.options.size
  end

  def test_is_excluded
    v=OptionsVisitor.new
    v.exclude ['root.a']
    assert (!v.is_excluded('root')), 'root'
    assert (v.is_excluded 'root.a'), 'root.a'
    assert (v.is_excluded 'root.a.1'),'root.a.1'
    assert (v.is_excluded 'root.a.2'),'root.a.2'
    assert !(v.is_excluded 'root.b')
    assert !(v.is_excluded 'root.b.1')
    assert !(v.is_excluded 'root.b.2')
  end
  
end
