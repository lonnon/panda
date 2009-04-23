class JobsController < ApplicationController
    def index
        @jobs = Bj.table.job.find(:all)
    end
    
    def show
        @jobs = Bj.table.job.find(params[:id])
    end
end
