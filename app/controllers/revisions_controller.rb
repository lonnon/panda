class RevisionsController < ApplicationController
    def index
        @revs = Revision.find(:all, :limit => 20, :order => "identifier desc")
        
        
    end
    
    
   
end
