class TestRun < ActiveRecord::Base
    belongs_to :revision
    require "rexml/document"
    
    
    def job
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
            data["name"].gsub!(/^.*\//, '')
            results << data
        end
        return results
    end
    
    private 
    def to_rexml
        REXML::Document.new "<xml>#{rawtest.gsub(/<\?xml.*?\?>/, '')}</xml>"
    end
end
