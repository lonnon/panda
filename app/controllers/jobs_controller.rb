class JobsController < ApplicationController
    def index
        @jobs = Bj.table.job.find(:all)  
    end
end
