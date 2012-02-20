class AdminLevel < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_i
    if name.empty?
      0
    else
      1
    end
  end

end
