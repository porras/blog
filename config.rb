require "lib/custom_tag_helpers"
helpers CustomTagHelpers
preferred_syntax = :scss
require 'active_support/core_ext/string'
require 'app/helpers/html5_boilerplate_helper'
require 'icalendar'
require "zurb-foundation"
require 'newrelic_rpm' if ENV['RACK_ENV'] == 'production'

Haml::Filters.remove_filter('Markdown')
Haml::Filters.register_tilt_filter('Markdown', template_class: Tilt::RedcarpetTemplate::Redcarpet2)

set :markdown_engine, :redcarpet

###
# Blog settings
###

Middleman::Sitemap::Resource.class_eval do
  def url_without_extension
    ext.blank? ? url : url.sub(/#{ext}$/,'')
  end
end

# Time.zone = "UTC"

activate :blog do |blog|
  blog.layout  = 'article'
  blog.sources = 'blog/:year-:month-:day-:title.html'

  # blog.prefix = "blog"
  # blog.permalink = ":year/:month/:day/:title.html"
  # blog.taglink = "tags/:tag.html"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/:num"
end


Middleman::Blog::BlogData.class_eval do
  alias :all_articles :articles
  def articles
    published_articles
  end

  def published_articles
    all_articles.select &:published?
  end
end

Middleman::Blog::BlogArticle.class_eval do
  def published?
    data['published']
  end
end

page "/feed.xml", :layout => false
page "/schedule.ics", :layout => false

###
# Compass
###

# Susy grids in Compass
# First: gem install compass-susy-plugin
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates

helpers do
  include Html5BoilerplateHelper
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  activate :gzip

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end
