class GraphController < ApplicationController
    require "sys/uname"
    include Sys
    
    def index
        @graphs = []
        repos = Repo.find(:all)
        repos.each do |repo|
            repo.test_sets.each do |set|
                @graphs << open_flash_chart_object(1000, 500, url_for(:controller => "graph", :action => "graph_code", :id => set.id), true, "#{relative_url_root}/")
            end
        end
    end
    
    def graph_code
        set = TestSet.find(params[:id])
        
        title = Title.new("#{set.repo.name} : #{set.name} - #{set.environment.name}")
        bar = BarGlass.new
        tests = set.test_runs.find(:all, :limit => "40", :order => "id desc")
        
        values = []
        labels = []
        tests.reverse.each do |test|
            val = BarValue.new(test.runtime)
            if test.success
                val.set_colour("#00bb00") 
            else
                val.set_colour("#ff0000")
            end
            values << val
            labels << XAxisLabel.new("#{test.revision.identifier}", '#0000ff', 12, 1)
        end
        
        x_labels = XAxisLabels.new
        x_labels.set_vertical()
        x_labels.set_steps(2)
        x_labels.labels = labels
        
        x = XAxis.new
        # x.set_steps(2)
        x.set_labels(x_labels)
      
        y = YAxis.new
        y.set_range(0,600,60)

        
        bar.set_values(values)

        chart = OpenFlashChart.new
        chart.set_title(title)
        chart.x_axis = x 
        chart.y_axis = y
      
        x_legend = XLegend.new("Release Number")
        x_legend.set_style('{font-size: 12px; color: #778877}')

        y_legend = XLegend.new("Build Time (seconds)")
        y_legend.set_style('{font-size: 12px; color: #778877}')

        chart.set_x_legend(x_legend)
        chart.set_y_legend(y_legend)

        chart.add_element(bar)
        render :text => chart.to_s
    end
end
