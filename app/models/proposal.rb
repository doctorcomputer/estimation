class Proposal < ActiveRecord::Base

	belongs_to :user  	# foreign key: user_id
  belongs_to :request  # foreign key: request_id

  validates_presence_of :description, :amount

  # Pagination
  cattr_reader :per_page
  @@per_page = 10

  # Find the proposals that have not be awarded.
  # These proposal are related to expired requests.
  def self.find_rejected(user)
    Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => user.id}) \
      .where(Proposal.table_name => {:is_best => false}) \
      .where(["#{Request.table_name}.status=:status", {:status => :active}]) \
      .where([":now>=#{Request.table_name}.expiration", {:now => DateTime.now}])
  end

  def self.count_rejected(user)
    self.find_rejected(user).count
  end

  # Find the proposals that have not be awarded.
  # These proposal are related to expired requests.
  def self.find_awarded(user)
    Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => user.id}) \
      .where(Proposal.table_name => {:is_best => true}) \
      .where(["#{Request.table_name}.status=:status", {:status => :active}]) \
      .where([":now>=#{Request.table_name}.expiration", {:now => DateTime.now}])
  end

  def self.count_awarded(user)
    self.find_awarded(user).count
  end

  # Find the proposals that are currently the best for an active request.
  def self.find_best(user)
    Proposal \
      .joins(:request) \
      .where(Proposal.table_name => {:user_id => user.id}) \
      .where(Proposal.table_name => {:is_best => true}) \
      .where("#{Request.table_name}.status=:status AND :now<#{Request.table_name}.expiration", :status => :active, :now => DateTime.now)
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
