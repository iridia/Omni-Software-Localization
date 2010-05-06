Given /^"([^\"]*)" exists as a project$/ do |arg1|
  # do nothing
end

When /^I select "([^\"]*)" from the menu$/ do |arg1|
  app.gui.select_menu arg1
end

When /^I fill in the broadcast message form with subject "([^\"]*)" and body "([^\"]*)"$/ do |arg1, arg2|
  app.gui.fill_in arg1, "//CPTextField[tag='subject']"
  app.gui.fill_in arg2, "//CPTextField[tag='message_body']"
end

When /^I submit the broadcast message$/ do
  app.gui.press "//CPButton[title='Send Message']"
end

Then /^the subscribers of "([^\"]*)" should receive a new message$/ do |arg1|
  # do nothing
end

When /^I select "([^\"]*)" in the sidebar$/ do |arg1|
  app.gui.select_from arg1, "//CPOutlineView[tag='sidebar']"
  sleep 2
end

When /^I search for "([^\"]*)"$/ do |arg1|
  app.gui.fill_in arg1, "//CPSearchField[tag='search']"
  sleep 2
end

When /^I double\-click "([^\"]*)" in the search results$/ do |arg1|
  app.gui.double_click arg1, "//CPTableView[tag='search_results']"
end

When /^I download the selected project$/ do
  # do nothing
end

Then /^"([^\"]*)" exists in the search results$/ do |arg1|
  assert_true app.gui.find_in(arg1, "//CPTableView[tag='search_results']")
end

When /^I double\-click "([^\"]*)"  in the search results$/ do |arg1|
  app.gui.double_click arg1, "//CPTableView[tag='search']"
end

Then /^the downloaded project is a zip file$/ do
  # do nothing
end

Given /^"([^\"]*)" has the resources:$/ do |arg1, table|
  # do nothing
end

Given /^"([^\"]*)" of "([^\"]*)" has the line items:$/ do |arg1, arg2, table|
  # do nothing
end

When /^I select "([^\"]*)" from the selected project$/ do |arg1|
  app.gui.select_from arg1, "//CPTableView[tag='resources']"
end

When /^I select "([^\"]*)" from the selected resource$/ do |arg1|
  app.gui.select_from arg1, "//CPTableView[tag='line_items']"
end

When /^I edit the line item "([^\"]*$)" to be "([^\"]*)"$/ do |arg1, arg2|
  app.gui.double_click arg1, "//CPTableView[tag='line_items']"
  app.gui.fill_in arg2, "//CPTextField[tag='line_item_edit']"
end

Then /^"([^\"]*)" should have the line items:$/ do |arg1, table|
  app.gui.select_from arg1, "//CPTableView[tag='resources']"
  table.hashes.each do |hash|
    assert_true app.gui.find_in hash.name, "//CPTableView[tag='line_items']"
  end
end

Given /^the application is loaded$/ do
  # do nothing
end

Given /^the welcome window is closed$/ do
  app.gui.press "//CPButton[tag='close_welcome']"
end

Given /^the upload window is opened$/ do
  app.gui.select_menu "Upload"
end

When /^I upload "([^\"]*)"$/ do |arg1|
  # do nothing
end

Then /^the sidebar should contain "([^\"]*)"$/ do |arg1|
  assert_true app.gui.find_in arg1, "//CPOutliveView[tag='sidebar']"
end

Given /^"([^\"]*)" exists as a glossary$/ do |arg1|
  assert_true app.gui.find_in arg1, "//CPOutlineView[tag='sidebar']"
end

Then /^the glossary "([^\"]*)" should display$/ do |arg1|
  assert_true app.gui.find "//CPTableView[tag='glossary']"
end

When /^I create a new message$/ do
  app.gui.press "//CPToolbarItem[tag='new_message']"
end

When /^I fill in the message form with subject "([^\"]*)" and body "([^\"]*)" to "([^\"]*)"$/ do |arg1, arg2, arg3|
  app.gui.fill_in arg1, "//CPTextField[tag='subject']"
  app.gui.fill_in arg2, "//CPTextField[tag='message_body']"
  app.gui.fill_in arg3, "//CPTextField[tag='to']"
end

When /^I submit the message$/ do
  app.gui.press "//CPButton[title='Send Message']"
end

Then /^"([^\"]*)" should receive a new message$/ do |arg1|
  # do nothing
end

When /^I upload a new "([^\"]*)" with the resources:$/ do |arg1, table|
  # do nothing
end

Then /^"([^\"]*)" should have the resources:$/ do |arg1, table|
  app.gui.select_from arg1, "//CPOutlineView[tag='sidebar']"
  table.hashes.each do |hash|
    assert_true app.gui.find_in hash.name, "//CPTableView[tag='resources']"
  end
end

When /^I upload a replacement "([^\"]*)" of "([^\"]*)" with items:$/ do |arg1, arg2, table|
  # do nothing
end

Then /^"([^\"]*)" of "([^\"]*)" should have line items:$/ do |arg1, arg2, table|
  app.gui.select_from arg2, "//CPOutlineView[tag='sidebar']"
  app.gui.select_from arg1, "//CPTableView[tag='resources']"
  table.hashes.each do |hash|
    assert_true app.gui.find_in hash.name, "//CPTableView[tag='line_items']"
  end
end

Then /^the project "([^\"]*)" should display$/ do |arg1|
  assert_true app.gui.find_in arg1, "//CPOutlineView[tag='line_items']"
end

Then /^the project "([^\"]*)" should display resources:$/ do |arg1, table|
  app.gui.select_from arg1, "//CPOutlineView[tag='sidebar']"
  table.hashes.each do |hash|
    assert_true app.gui.find_in hash.name, "//CPTableView[tag='resources']"
  end
end

When /^I upvote the selected resource$/ do
  app.gui.press "//CPButton[tag='upvote']"
end

Then /^"([^\"]*)" should have a vote total of 1$/ do |arg1|
  assert_equal 1, app.gui.text_for("//CPTextField[tag='vote_total']")
end

Then /^the search results should be:$/ do |table|
  table.hashes.each do |hash|
    throw "Search results not found" unless app.gui.find_in hash[:name], "//CPTableView[tag='search_results']"
  end
end

Given /^the application has loaded$/ do
  # we just wanna wait for stuff to load here. Only use when necessary (is slow!)
  app.gui.login
  sleep 5
end