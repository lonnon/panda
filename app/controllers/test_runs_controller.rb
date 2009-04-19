class TestRunsController < ApplicationController
    def index
        @tests = TestRun.find(:all, :limit => 20, :conditions => ["success is not null"], :order => "id desc")
        @tests = @tests.select {|t| t.revision != nil}
        
        respond_to do |format|
            format.html
            format.xml {render :xml => @tests}
            format.rss
        end
    end
    
    def show
        @test = TestRun.find(params[:id])
        
        respond_to do |format|
            format.html
            format.xml {render :xml => @test}
        end
    end
    
end
