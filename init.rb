require 'redmine'

Redmine::Plugin.register :redmine_my_page_queries do
  name 'MyPage custom queries'
  author 'David Robinson'
  description 'Adds custom queries onto My Page screen\nbased on plugin by Milan Stastny of ALVILA SYSTEMS'
  version '0.0.2'

  Rails.configuration.to_prepare do
    MyController.send :include, MyControllerPatch
  end
end

