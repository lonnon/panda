class GraphController < ApplicationController
    def index
        @graph = open_flash_chart_object(1000, 500, url_for(:controller => "graph", :action => "graph_code"), true, relative_url_root)
    end
    
    def graph_code
        title = Title.new("Build Times")
        bar = BarGlass.new
        tests = TestRun.find(:all, :limit => "40", :order => "id desc")
        
        values = []
        labels = []
        tests.each do |test|
            val = BarValue.new(test.runtime)
            if test.success
                val.set_colour("#00bb00") 
            else
                val.set_colour("#ff0000")
            end
            values << val
            labels << XAxisLabel.new(test.revision.identifier, '#0000ff', 20, 'diagonal')
        end
        
        x_labels = XAxisLabels.new
        x_labels.labels = labels
        x = XAxis.new
        x.set_labels(x_labels)

        bar.set_values(values)

        chart = OpenFlashChart.new
        chart.set_title(title)
        chart.x_axis = x 
        chart.add_element(bar)
        render :text => chart.to_s
    end
end
