class Request < ActiveRecord::Base

	belongs_to :user	# foreign key: user_id

  validates_presence_of :title, :description, :expiration

  after_initialize :ensure_default_values

  protected

  def ensure_default_values
    if self.expiration.nil?
      self.expiration = DateTime.now + 15
    end
  end

end
