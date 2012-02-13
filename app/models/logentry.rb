class Logentry < ActiveRecord::Base
  belongs_to :logclass
  belongs_to :loggable, :polymorphic => true
end

