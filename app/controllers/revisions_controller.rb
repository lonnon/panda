class RevisionsController < ApplicationController
    def index
        @revs = Revision.find(:all, :limit => 20, :order => "identifier desc")
        
        respond_to do |format|
            format.html
            format.xml { render :xml => @revs }
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
