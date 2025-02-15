require "application_system_test_case"

class UserInventoriesTest < ApplicationSystemTestCase
  setup do
    @user_inventory = user_inventories(:one)
  end

  test "visiting the index" do
    visit user_inventories_url
    assert_selector "h1", text: "User inventories"
  end

  test "should create user inventory" do
    visit user_inventories_url
    click_on "New user inventory"

    fill_in "Inventory", with: @user_inventory.inventory_id
    fill_in "Owner email", with: @user_inventory.owner_email
    fill_in "User email", with: @user_inventory.user_email
    click_on "Create User inventory"

    assert_text "User inventory was successfully created"
    click_on "Back"
  end

  test "should update User inventory" do
    visit user_inventory_url(@user_inventory)
    click_on "Edit this user inventory", match: :first

    fill_in "Inventory", with: @user_inventory.inventory_id
    fill_in "Owner email", with: @user_inventory.owner_email
    fill_in "User email", with: @user_inventory.user_email
    click_on "Update User inventory"

    assert_text "User inventory was successfully updated"
    click_on "Back"
  end

  test "should destroy User inventory" do
    visit user_inventory_url(@user_inventory)
    click_on "Destroy this user inventory", match: :first

    assert_text "User inventory was successfully destroyed"
  end
end
