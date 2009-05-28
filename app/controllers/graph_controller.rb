class GraphController < ApplicationController
    require "sys/uname"
    include Sys
    
    def index
        @graphs = []
        repos = Repo.find(:all)
        repos.each do |repo|
            @graphs << open_flash_chart_object(1000, 500, url_for(:controller => "graph", :action => "compare_graph", :id => repo.id), true, "#{relative_url_root}/")
            repo.test_sets.each do |set|
                @graphs << open_flash_chart_object(1000, 500, url_for(:controller => "graph", :action => "graph_code", :id => set.id), true, "#{relative_url_root}/")
            end
        end
    end

    def compare_graph
        repo = Repo.find(params[:id])
        sets = repo.test_sets
        revisions = repo.revisions.find(:all, :limit => "40", :order => "time desc")
        
        # make the bars
        barvals = {}
        sets.each do set
            barvals[set.id] = []
        end

        
        title = Title.new("#{set.repo.name} : #{Uname.machine} - comparison graph")
        
        values = []

        revisions.reverse.each do |rev|
            labels << XAxisLabel.new("#{test.revision.identifier}", '#0000ff', 12, 1)

            sets.each do set
                test = set.find(:first, :conditions => ["revision_id = ?", rev.id])
                val = BarValue.new(0)
                if test
                    val = BarValue.new(test.runtime)
                    color = (set.id * 2) % 6
                    if test.success
                        val.set_colour("#00bb#{color}0") 
                    else
                        val.set_colour("#ff#{color}000")
                    end
                end
                barvals[set.id] << val
            end
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

        sets.each do set
            bar = BarGlass.new
            bar.set_values(barvals[set.id])
            chart.add_element(bar)
        end

        render :text => chart.to_s
    end
    
    def graph_code
        set = TestSet.find(params[:id])
        
        title = Title.new("#{set.repo.name} : #{set.name} - #{Uname.machine}")
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
