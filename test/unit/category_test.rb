require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def setup

    @category_a_2 = Category.new '2'

    @tree = Category.new('root') \
      .add_child( \
        Category.new('a') \
          .add_child(Category.new '1') \
          .add_child(@category_a_2) \
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

  def test_is_excluded_by_category_key
    v=OptionsVisitor.new
    v.exclude ['root.a']
    assert (!v.is_excluded('root')), 'root should not be there'
    assert (v.is_excluded 'root.a'), 'root.a should not be there'
    assert (v.is_excluded 'root.a.1'),'root.a.1 should not be there'
    assert (v.is_excluded 'root.a.2'),'root.a.2 should not be there'
    assert !(v.is_excluded 'root.b')
    assert !(v.is_excluded 'root.b.1')
    assert !(v.is_excluded 'root.b.2')
  end

  def test_find_root_by_unique_key_array
    tested_key = ['root']
    initial_length = tested_key.length
    assert_not_nil @tree.find_by_unique_key_array(tested_key)

    # This is to ensure that there are not side effects on the provided array
    assert_equal(initial_length, tested_key.length)

    assert_equal @tree, @tree.find_by_unique_key_array(tested_key)
  end

  def test_find_root_by_unique_key
    tested_key = 'root'
    assert_not_nil @tree.find_by_unique_key(tested_key)
    assert_equal @tree, @tree.find_by_unique_key(tested_key)
  end

  def test_find_by_unique_key_array
    tested_key = ['root','a','2']
    initial_length = tested_key.length
    assert_not_nil @category_a_2

    assert_not_nil @tree.find_by_unique_key_array(tested_key)

    # This is to ensure that there are not side effects on the provided array
    assert_equal(initial_length, tested_key.length)

    assert_equal @category_a_2, @tree.find_by_unique_key_array(tested_key)
  end

  def test_find_by_unique_key
    assert_not_nil @category_a_2
    assert_not_nil @tree.find_by_unique_key('root.a.2')
    assert_equal @category_a_2, @tree.find_by_unique_key('root.a.2')
  end
  
end
