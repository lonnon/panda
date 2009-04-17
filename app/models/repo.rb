class Repo < ActiveRecord::Base
    require "rscm"
    has_many :revisions
    
    def rscm
        if rtype == "svn"
            return RSCM::Subversion.new(url)
        end
        return nil
    end
    
    def gather_revs
        revs = rscm.revisions(1.day.ago)
        latest = nil
        
        if revs.length > 0 and not revisions.find_by_identifier(revs[-1].identifier)
            latest = revs[-1].identifier
        end
        
        revs.each do |rev|
            if not revisions.find_by_identifier(rev.identifier)
                revision = revisions.build
                revision.identifier = rev.identifier
                revision.time = rev.time
                revision.message = rev.message
                revision.developer = rev.developer
                revisions << revision
            end
        end
        
        return latest
    end
end
