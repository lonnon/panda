#!/usr/bin/env ./script/runner

def pidofmono
    IO.popen("ps auxw | grep -i mono | grep -i nant | grep test-xml | grep -v grep") do |line|
        line.each do |l|
            return l.split[1].to_i
        end
    end
    return nil
end


def main
    jobs = Bj.table.job.find(:all)
    
    jobs.each do |job|
        if (job.state == "running") and (job.started_at < 15.minutes.ago)
            # capture job so we can restart it
            cmd = job.command
            
            pid = pidofmono
            begin
                Process.kill(2, pid)
                sleep 5
                Process.kill(9, pid)
            rescue => e
                # don't really care
            end
            Bj.sumbit cmd
        end
    end
end

main
