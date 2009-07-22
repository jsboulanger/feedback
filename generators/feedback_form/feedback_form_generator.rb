require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class FeedbackFormGenerator < Rails::Generator::Base
  
  attr_accessor :name, 
    :model_class_name,
    :controller_class_name,
    :helper_class_name,
    :mailer_class_name
  
  
  def initialize(runtime_args, runtime_options = {})
    super
    @name = (runtime_args[0] || "feedback").downcase
    @model_class_name = name.classify
    @mailer_class_name = "#{@model_class_name}Mailer"
    @controller_class_name = "#{@model_class_name.pluralize}Controller"
    @helper_class_name = "#{@model_class_name.pluralize}Helper"
    #@js_framework = (runtime_options[''])

  end
  
  def manifest
    record do |m|
      
      puts "hello"
      add_model(m)
      add_mailer(m)
      add_controller(m)
      add_helper(m)
      add_views(m)
      add_routes(m)
      add_unit_test(m)
      add_functional_test(m)
      add_stylesheet(m)
      add_javascript(m)
      add_images(m)
    end
  end
  
  
  def add_stylesheet(m)
    m.directory 'public/stylesheets'
    m.file 'feedback.css', 'public/stylesheets/feedback.css'
      
  end
  
  def add_javascript(m)
    m.directory 'public/javascripts'
    file_name = options[:jquery] ? 'jquery.feedback.js' : 'prototype.feedback.js'
    m.file file_name, "public/javascripts/#{file_name}"
  end
  
  def add_images(m)
    m.directory 'public/images/feedback'
    m.file "images/feedback_tab.png", "public/images/feedback/feedback_tab.png"
    m.file "images/feedback_tab_h.png", "public/images/feedback/feedback_tab_h.png"
    m.file "images/closelabel.gif", "public/images/feedback/closelabel.gif"
    m.file "images/loading.gif", "public/images/feedback/loading.gif"
  end

  def add_model(m)
    m.template 'feedback_model.rb.erb', "app/models/#{name}.rb"
  end
  
  def add_mailer(m)
    m.template 'feedback_mailer.rb.erb', "app/models/#{name}_mailer.rb"
    m.directory "app/views/#{name}_mailer"
    m.file 'views/feedback_mailer/feedback.html.erb', "app/views/#{name}_mailer/feedback.html.erb"
    
  end
  
  def add_controller(m)
    m.template 'feedbacks_controller.rb.erb', "app/controllers/#{name.pluralize}_controller.rb"
  end
  
  def add_helper(m)
    template_name = options[:jquery] ? 'feedbacks_helper.rb.jquery.erb' : 'feedbacks_helper.rb.prototype.erb'
    m.template template_name, "app/helpers/#{name.pluralize}_helper.rb"
  end
  
  def add_views(m)
    m.directory "app/views/#{name.pluralize}"
    m.file 'views/feedbacks/new.html.erb', "app/views/#{name.pluralize}/new.html.erb"
  end
  
  def add_routes(m)
    m.route_name "new_feedback", "feedbacks/new", {:controller => name.pluralize, :action => "new"}
    m.route_name "feedback", "feedbacks", {:controller => name.pluralize, :action => "create"}
  end
  
  def add_unit_test(m)
    m.template 'feedback_test.rb.erb', "test/unit/#{name}_test.rb"
    m.template 'feedback_mailer_test.rb.erb', "test/unit/#{name}_mailer_test.rb"
  end
  
  def add_functional_test(m)
    m.template 'feedbacks_controller_test.rb.erb', "test/functional/#{name.pluralize}_controller_test.rb"    
  end
  
  protected 
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--jquery",
      "Use jquery Javascript framework, default is Prototyp")           { |v| options[:jquery] = true }
  end
end