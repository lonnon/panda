module OverviewHelper
    def job_running?(job)
        if job.is_a? Bj::Table::Job and job.state == "running"
            return true
        end
        return false
    end
    
    # this sucks, but not sure how it make it much cleaner
    def state_column(test)
        result = ""
        if test.success == false
            result = "<tr class=\"test_result\">
                 <td class=\"spacer\"></td>
     <td>#{image_tag 'reddot-small.png'} Build Failed</td>"
            
       elsif test.success == true
            result = "<tr class=\"test_result\">
     <td class=\"spacer\"></td>
     <td>#{image_tag 'greendot-small.png'} Build Succeeded</td>"
        else
            result = "<tr class=\"test_run\">
     <td class=\"spacer\"></td>
     <td>Build in Progress</td>"
        end
        return result
    end
    
    def build_time(test)
        if test.starttime and test.endtime
            return test.endtime - test.starttime
        else
            return "unknown"
        end
    end
end
