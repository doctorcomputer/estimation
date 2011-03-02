class Proposal < ActiveRecord::Base

	belongs_to :user  	# foreign key: user_id
  belongs_to :request  # foreign key: request_id

  validates_presence_of :description, :amount

  # Pagination
  cattr_reader :per_page
  @@per_page = 10

  def self.find_best(user)
    Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => user.id}) \
      .where(Proposal.table_name => {:is_best => true}) \
      .where(["#{Request.table_name}.status=:status AND :now>=#{Request.table_name}.expiration", {:status => :active, :now => DateTime.now}])
  end

  def self.find_expired(user)
    Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => user.id}) \
      .where(["#{Request.table_name}.status=:status AND :now>=#{Request.table_name}.expiration", {:status => :active, :now => DateTime.now}])
  end

  def self.find_active(user)
    Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => user.id}) \
      .where(["#{Request.table_name}.status=:status AND :now<#{Request.table_name}.expiration", {:status => :active, :now => DateTime.now}])
  end

  def self.count_best(user)
    self.find_best(user).count
  end

  def self.count_active(user)
    self.find_active(user).count
  end

  def self.count_expired(user)
    self.find_expired(user).count
  end
  
end
