class User < ActiveRecord::Base

  #== validates

  validates :nickname, presence: true, length:{ maximum:255 }
  validates :name, presence: true, length:{ maximum:255 }

  validates :image, {
    allow_blank: true,
    format: URI::regexp(%w(http https)),
    length:{ maximum:255 },
  }

  #== devise settings

  devise :omniauthable, :rememberable, :trackable

  def remember_me
    true
  end

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 10) }
  scope :order_default, -> { order("users.id DESC") }

  #== methods

  def image_bigger
    self.image.sub("_normal","_bigger") unless self.image.nil?
  end

  def image_mini
    self.image.sub("_normal","_mini") unless self.image.nil?
  end

  def admin?
    self.uid == "6259812" or self.uid == "4302721"
  end

end
