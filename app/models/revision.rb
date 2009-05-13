class Revision < ActiveRecord::Base
    belongs_to :repo
    has_many :test_runs
    
    def builddir
        return "#{repo.builddir}/#{repo.name}-#{identifier}"
    end
end
