class FeedbackFormGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :name, :type => :string, :default => "feedback"
  class_option :jquery, :type => :boolean, :default => true, :desc => "Use jQuery Javascript framework"

  attr_accessor :model_class_name,
    :controller_class_name,
    :helper_class_name,
    :mailer_class_name

  def initialize(*runtime_args, &runtime_options)
    super
    @name ||= "feedback"
    @model_class_name = name.classify
    @mailer_class_name = "#{@model_class_name}Mailer"
    @controller_class_name = "#{@model_class_name.pluralize}Controller"
    @helper_class_name = "#{@model_class_name.pluralize}Helper"
  end

  def add_stylesheet
    copy_file 'feedback.css.scss', 'app/assets/stylesheets/feedback.css.scss'
  end

  def add_javascript
    file_name = options[:jquery] ? 'jquery.feedback.js' : 'prototype.feedback.js'
    copy_file file_name, "app/assets/javascripts/#{file_name}"
  end

  def add_images
    copy_file "images/feedback_tab.png", "app/assets/images/feedback/feedback_tab.png"
    copy_file "images/feedback_tab_h.png", "app/assets/images/feedback/feedback_tab_h.png"
    copy_file "images/closelabel.gif", "app/assets/images/feedback/closelabel.gif"
    copy_file "images/loading.gif", "app/assets/images/feedback/loading.gif"
  end

  def add_model
    template 'feedback_model.rb.erb', "app/models/#{name}.rb"
  end

  def add_mailer
    template 'feedback_mailer.rb.erb', "app/mailers/#{name}_mailer.rb"
    copy_file 'views/feedback_mailer/feedback.html.erb', "app/views/#{name}_mailer/feedback.html.erb"
  end

  def add_controller
    template 'feedbacks_controller.rb.erb', "app/controllers/#{name.pluralize}_controller.rb"
  end

  def add_helper
    template_name = options[:jquery] ? 'feedbacks_helper.rb.jquery.erb' : 'feedbacks_helper.rb.prototype.erb'
    template template_name, "app/helpers/#{name.pluralize}_helper.rb"
  end

  def add_views
    copy_file 'views/feedbacks/new.html.erb', "app/views/#{name.pluralize}/new.html.erb"
  end

  def add_routes
    route "match 'feedbacks/new' => '#{name.pluralize}#new', :as => :new_feedback"
    route "match 'feedbacks' => '#{name.pluralize}#create', :as => :feedback"
  end

  def add_unit_test
    template 'feedback_test.rb.erb', "test/unit/#{name}_test.rb"
    template 'feedback_mailer_test.rb.erb', "test/unit/#{name}_mailer_test.rb"
  end

  def add_functional_test
    template 'feedbacks_controller_test.rb.erb', "test/functional/#{name.pluralize}_controller_test.rb"
  end
end
