class TestRun < ActiveRecord::Base
    belongs_to :revision
    require "rexml/document"
    
    
    def job
        if not job_id
            return nil
        end
        
        begin
            return Bj.table.job.find(job_id)
        rescue => e
            begin 
                return Bj.table.job_archive(job_id)
            rescue => e
            end
            return nil
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
        if rawtest
            return REXML::Document.new "<xml>#{rawtest.gsub(/<\?xml.*?\?>/, '')}</xml>"
        else
            return REXML::Document.new "<xml></xml>"
        end
    end
end
