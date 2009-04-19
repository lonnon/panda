class Revision < ActiveRecord::Base
    belongs_to :repo
    has_many :test_runs
end
