#these scripts will add steak to any ruby on rails project with some javascript/selenium support

TEST_NAME=widget_list

echo 'group :test, :development do' >> Gemfile
echo "  gem 'steak'" >> Gemfile
echo "  gem 'launchy'" >> Gemfile
echo "  gem 'selenium-webdriver'" >> Gemfile
echo "  gem 'spork'" >> Gemfile
echo 'end' >> Gemfile

bundle install
rails g steak:install
rails g steak:spec $TEST_NAME

bundle exec spork --bootstrap
echo '--drb' >> .rspec

echo 'RSpec.configure do |config|'                                       >> spec/acceptance/acceptance_helper.rb
echo '  config.before(:each) do'                                         >> spec/acceptance/acceptance_helper.rb 
echo '    Capybara.default_wait_time = 10'                               >> spec/acceptance/acceptance_helper.rb
echo '    Capybara.current_driver = :selenium if example.metadata[:js]'  >> spec/acceptance/acceptance_helper.rb
echo '  end'                                                             >> spec/acceptance/acceptance_helper.rb
echo ''                                                                  >> spec/acceptance/acceptance_helper.rb
echo '  config.after(:each) do'                                          >> spec/acceptance/acceptance_helper.rb
echo '    Capybara.use_default_driver if example.metadata[:js]'          >> spec/acceptance/acceptance_helper.rb
echo '  end'                                                             >> spec/acceptance/acceptance_helper.rb
echo 'end'                                                               >> spec/acceptance/acceptance_helper.rb

echo "feature '""$GEMNAME"" javascript example (just pass :js => true for selenium JS test)', '' do " >> 'spec/acceptance/'$TEST_NAME'_spec.rb'
echo "  scenario 'JAVASCRIPT SELENIUM TEST', :js => true do "   >> 'spec/acceptance/'$TEST_NAME'_spec.rb'
echo "  visit '/' "                                      >> 'spec/acceptance/'$TEST_NAME'_spec.rb'
echo "end"                                               >> 'spec/acceptance/'$TEST_NAME'_spec.rb'

bundle exec rspec 'spec/acceptance/'$TEST_NAME'_spec.rb'

#bundle exec spork (ensure you run this )