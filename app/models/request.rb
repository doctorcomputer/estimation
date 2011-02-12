class Request < ActiveRecord::Base

	belongs_to :user	# foreign key: user_id
  has_many :proposals

  validates_presence_of :title, :description, :expiration

  after_initialize :ensure_default_values

  def is_draft
    self.status == :draft.to_s
  end

  def is_active
    (self.status == :active.to_s) && (DateTime.now < self.expiration)
  end

  def is_expired
    (self.status == :active.to_s) && (DateTime.now >= self.expiration)
  end

  def self.find_drafts(user=nil)
    if user.nil?
      Request.where('status = :status', :status => :draft)
    else
      Request.where('user_id = :user_id AND status = :status', :user_id => user.id, :status => :draft)
    end
  end

  def self.find_active(user=nil)
    if user.nil?
      Request.where('status=:status AND :now<expiration', :status => :active, :now => DateTime.now)
    else
      Request.where('user_id = :user_id AND status=:status AND :now<expiration', :user_id => user.id, :status => :active, :now => DateTime.now)
    end
  end

  def self.find_expired(user=nil)
    if user.nil?
      Request.where('status=:status AND :now>=expiration', :user_id => user.id, :status => :active, :now => DateTime.now)
    else
      Request.where('user_id = :user_id AND status=:status AND :now>=expiration', :user_id => user.id, :status => :active, :now => DateTime.now)
    end
  end

  def best_proposal
    proposals = Proposal.where('request_id = :request_id AND is_best = :is_best', {:request_id => self.id, :is_best => true})
    if proposals.nil? || proposals.count == 0
      return nil
    else
      return proposals[0]
    end
  end

  def unloved_proposals
    Proposal.where('request_id = :request_id AND is_best = :is_best', {:request_id => self.id, :is_best => false})
  end

  protected

  def ensure_default_values
    if self.expiration.nil?
      self.expiration = DateTime.now + 15
    end
  end

end
