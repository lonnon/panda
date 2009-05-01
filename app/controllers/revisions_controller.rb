class RevisionsController < ApplicationController
    def index
        @repos = Repo.find(:all)
        # @revs = Revision.find(:all, :limit => 20, :order => "time desc")
        
        respond_to do |format|
            format.html
            format.xml { render :xml => @repos }
        end
    end
    
    def show
        @rev = Revision.find(params[:id])
        
        respond_to do |format|
            format.html
            format.xml { render :xml => @rev }
        end
    end
   
end
