class TestRunsController < ApplicationController
    def index
        @tests = TestRun.find(:all)
        
        respond_to do |format|
            format.html
            format.xml {render :xml => @tests}
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
