class Request < ActiveRecord::Base

	belongs_to :user	# foreign key: user_id
  has_many :proposals

  # Pagination
  cattr_reader :per_page
  @@per_page = 10

  validates_presence_of :title, :description, :expiration, :category_id
  validate :expiration_date_cannot_be_in_the_past

  after_initialize :ensure_default_values

  attr_accessor :eula

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

  def expiration_date_cannot_be_in_the_past
    errors.add(:expiration, I18n.t('activerecord.errors.models.request.attributes.expiration.in_the_past')) if !expiration.blank? and expiration< Date.today
  end

  protected

  def ensure_default_values
    self.expiration = DateTime.now + 15 if self.expiration.nil?
    self.status = :draft if self.status.blank?
  end

end
