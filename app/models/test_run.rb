class TestRun < ActiveRecord::Base
    belongs_to :revision
    require "rexml/document"
    
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
