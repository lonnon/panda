class TestSetsController < ApplicationController
    def latest
        test_set = TestSet.find(params[:id])
        run = test_set.test_runs.find(:first, :order => "id desc")
        
        data = run.test_log.rawtest.gsub(/\<\?xml version="1.0" encoding="utf-8" standalone="no"\?\>/, '')
        data = "<xml>#{data}</xml>"
        
        respond_to do |format|
            format.xml {render :xml => data}
        end
    end
end
