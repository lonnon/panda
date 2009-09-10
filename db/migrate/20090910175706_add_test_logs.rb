class AddTestLogs < ActiveRecord::Migration
    def self.up
        create_table :test_logs do |t|
            t.integer  "test_run_id"
            t.text "stdout",         :limit => 16777215
            t.text "rawtest",     :limit => 16777215
        end
        
        TestRun.find(:all).each do |test_run|
            log = test_run.test_log
            if not log
                log = TestLog.new
            end
            
            log.stdout = test_run.log
            log.rawtest = test_run.rawtest
            log.save
            test_run.test_log = log
        end
        
        remove_column :test_runs, :log
        remove_column :test_runs, :rawtest
    end

    def self.down
    end
end
