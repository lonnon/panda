xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
    xml.channel do
        xml.title "OpenSim Panda Build Results"
        xml.description "A list of recent builds"
        xml.link formatted_test_runs_url(:rss)
        
        for test in @tests
            success = "FAILED"
            if test.success
                success = "PASSED"
            end
            xml.item do
                xml.title "#{test.revision.repo.name} - #{test.revision.identifier} - #{success}"
                xml.description "Test Results (Passed / Skipped / Failed): #{test.passed} / #{test.skipped} / #{test.failed}"
                xml.pubDate test.updated_at.to_s(:rfc822)
                xml.link formatted_test_run_url(test, :rss)
                xml.guid formatted_test_run_url(test, :rss)
            end
        end
    end
end



