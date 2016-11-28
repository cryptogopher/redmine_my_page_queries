desc <<-END_DESC
Clean configuration settings from old plugin versions

Example:
  rake redmine:clean_old_config RAILS_ENV="production"
END_DESC
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

namespace :redmine do
  task :clean_old_config => :environment do
    keys_to_update = Hash[ (1..5).map{ |n| ["custom_query#{n}", "issues_custom_query_#{n}"] } ]

    keys_to_remove = []
    keys_to_remove += (1..5).map{ |n| "custom_query#{n}" }
    keys_to_remove += (1..5).map{ |n| "custom_query_#{n}" }
    keys_to_remove += (1..5).map{ |n| "issues_custom_query_#{n}" }
    keys_to_remove += [ "issues_custom_query_" ]
    keys_to_remove += (1..5).map{ |n| "custom_query_desktop#{n}" }
    keys_to_remove += (1..5).map{ |n| "custom_query_mobile#{n}" }
    keys_to_remove += (1..5).map{ |n| "issues_custom_query_desktop#{n}" }
    keys_to_remove += (1..5).map{ |n| "issues_custom_query_mobile#{n}" }
    keys_to_remove += (1..5).map{ |n| ":issues_custom_query_#{n}desktop" }
    keys_to_remove += (1..5).map{ |n| ":issues_custom_query_#{n}mobile" }
    UserPreference.all.each do |user_prefs|
      custom_queries = user_prefs.others.select{ |k,v| k.in?(keys_to_update.keys) }
      custom_queries.each{ |k,v|
        user_prefs.others["#{keys_to_update[k]}desktop"] ||= user_prefs.others[k] ;
        user_prefs.others["#{keys_to_update[k]}mobile"] ||= user_prefs.others[k] }

      keys_to_remove.each{ |k| user_prefs.others.delete(k)}

      user_prefs.save
    end
  end
end

