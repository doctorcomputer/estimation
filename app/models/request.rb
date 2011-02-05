class Request < ActiveRecord::Base

  after_initialize :ensure_default_values

  protected

  def ensure_default_values
    if self.expiration.nil?
      self.expiration = DateTime.now + 15
    end
  end

end
