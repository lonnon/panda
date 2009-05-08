class Repo < ActiveRecord::Base
    require "rscm"
    has_many :revisions
    
    def rscm
        if rtype == "svn"
            return RSCM::Subversion.new(url)
        elsif rtype == "git"
            # for git we need a local cache to work off of
            rscm = RSCM::Git.new(url)
            rscm.depth = 100
            rscm.checkout_dir = "#{builddir}/panda-git-#{name}"
            rscm.checkout
            return rscm
        end
        return nil
    end
    
    def gather_revs(since = 1.day.ago)
        revs = rscm.revisions(since).sort!
        @latest = nil
        
        revs.each do |rev|
            if not revisions.find_by_identifier(rev.identifier)
                @latest = rev.identifier
                revision = revisions.build
                revision.identifier = rev.identifier
                revision.time = rev.time
                revision.message = rev.message
                revision.developer = rev.developer
                revisions << revision
            end
        end
        
        return @latest
    end
end
