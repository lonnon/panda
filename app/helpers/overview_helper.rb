module OverviewHelper
    def job_running?(job)
        if job.is_a? Bj::Table::Job and job.state == "running"
            return true
        end
        return false
    end
end
