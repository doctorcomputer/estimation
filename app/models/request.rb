class Request < ActiveRecord::Base

	belongs_to :user	# foreign key: user_id

  validates_presence_of :title, :description, :expiration

  after_initialize :ensure_default_values

  def self.find_drafts(user)
    Request.where('user_id = :user_id AND status = :status', :user_id => user.id, :status => :draft)
  end

  def self.find_active(user)
    Request.where('user_id = :user_id AND status=:status AND :now<expiration', :user_id => user.id, :status => :active, :now => DateTime.now)
  end

  def self.find_expired(user)
    Request.where('user_id = :user_id AND status=:status AND :now>=expiration', :user_id => user.id, :status => :active, :now => DateTime.now)
  end

  protected

  def ensure_default_values
    if self.expiration.nil?
      self.expiration = DateTime.now + 15
    end
  end

end
