class TestSetsController < ApplicationController
    def latest_rawxml
        test_set = TestSet.find(params[:id])
        test_set.test_runs.find(:first, :order => "id desc")
        
        respond_to do |format|
            format.xml {render :xml => test_set.rawtest}
        end
    end
end
