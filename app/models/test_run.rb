class TestRun < ActiveRecord::Base
    belongs_to :revision
    belongs_to :test_set
    has_one :test_log
    require "rexml/document"

    # This should probably be in the test_log model, but it's here for now
    def before_create
        test_log = TestLog.new
        test_log.stdout = ""
        test_log.rawtest = ""
        test_log.save
    end
    
    def checkouttime
        if created_at and starttime
            return starttime - created_at
        else
            return 0
        end
    end
    
    def runtime
        if starttime and endtime
            return endtime - starttime
        else
            return 0
        end
    end

    def cleanuptime
        if endtime and success != nil
            return updated_at - endtime
        else 
            return 0
        end
    end
    
    def details
        doc = to_rexml
        results = Array.new
        doc.root.elements.each do |res|
            data = Hash.new
            res.attributes.each do |k, v|
                data[k] = v
            end
            if data["name"]
                data["name"].gsub!(/^.*\//, '')
                results << data
            end
        end
        return results
    end
    
    private 
    def to_rexml
        if test_log and test_log.rawtest
            return REXML::Document.new "<xml>#{test_log.rawtest.gsub(/<\?xml.*?\?>/, '')}</xml>"
        else
            return REXML::Document.new "<xml></xml>"
        end
    end
end
