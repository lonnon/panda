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
    tests = TestRun.find(:all, :conditions => ["success is null and created_at < ?", 15.minutes.ago])
    
    tests.each do |test|
        pid = pidofmono
        begin
            Process.kill(2, pid)
            sleep 5
            Process.kill(9, pid)
        rescue => e
            # don't really care
        end
        test.success = false
        test.save
    end
end

main
