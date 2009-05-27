class TestSet < ActiveRecord::Base
    belongs_to :repo
    belongs_to :procedure
    belongs_to :environment
end
