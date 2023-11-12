require 'application_system_test_case'

class InstallTest < ApplicationSystemTestCase
  test 'installing a script' do
    script = Script.find(2)
    visit script_url(script, locale: :en)
    assert_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } => 1 do
      click_link 'Install this script'
      click_link 'I already have a user script manager, let me install it!'
      assert_current_path '/scripts/2.user.js'
    end

    visit script_url(script, locale: :en)
    assert_no_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } do
      click_link 'Install this script'
      assert_current_path '/scripts/2.user.js'
    end
  end

  test 'installing a script with antifeatures' do
    script = Script.find(22)
    visit script_url(script, locale: :en)
    click_link 'Install this script'
    click_link 'I already have a user script manager, let me install it!'
    assert_content 'This script contains antifeatures'

    assert_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } => 1 do
      click_button 'Install script'
      assert_current_path '/scripts/22.user.js'
    end
  end

  test 'installing a style as JS' do
    script = Script.find(23)
    visit script_url(script, locale: :en)
    assert_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } => 1 do
      click_link 'Install this script'
      click_link 'I already have a user script manager, let me install it!'
      assert_current_path '/scripts/23.user.js'
    end

    visit script_url(script, locale: :en)
    assert_no_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } do
      click_link 'Install this script'
      assert_current_path '/scripts/23.user.js'
    end
  end

  test 'installing a style with antifeatures as JS' do
    script = Script.find(24)
    visit script_url(script, locale: :en)
    click_link 'Install this script'
    click_link 'I already have a user script manager, let me install it!'
    assert_content 'This script contains antifeatures'

    assert_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } => 1 do
      click_button 'Install script'
      assert_current_path '/scripts/24.user.js'
    end
  end

  test 'installing a style as CSS' do
    script = Script.find(23)
    visit script_url(script, locale: :en)
    assert_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } => 1 do
      click_link 'Install as user style'
      click_link 'I already have a user style manager, let me install it!'
      assert_current_path '/scripts/23.user.css'
    end

    visit script_url(script, locale: :en)
    assert_no_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } do
      click_link 'Install as user style'
      assert_current_path '/scripts/23.user.css'
    end
  end

  test 'installing a style with antifeatures as CSS' do
    script = Script.find(24)
    visit script_url(script, locale: :en)
    click_link 'Install as user style'
    click_link 'I already have a user style manager, let me install it!'
    assert_content 'This script contains antifeatures'

    assert_difference -> { Script.connection.select_value('select count(*) from daily_install_counts') } => 1 do
      click_button 'Install script'
      assert_current_path '/scripts/24.user.css'
    end
  end
end
