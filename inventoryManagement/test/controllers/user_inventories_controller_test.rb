require "test_helper"

class UserInventoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_inventory = user_inventories(:one)
  end

  test "should get index" do
    get user_inventories_url
    assert_response :success
  end

  test "should get new" do
    get new_user_inventory_url
    assert_response :success
  end

  test "should create user_inventory" do
    assert_difference("UserInventory.count") do
      post user_inventories_url, params: { user_inventory: { inventory_id: @user_inventory.inventory_id, owner_email: @user_inventory.owner_email, user_email: @user_inventory.user_email } }
    end

    assert_redirected_to user_inventory_url(UserInventory.last)
  end

  test "should show user_inventory" do
    get user_inventory_url(@user_inventory)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_inventory_url(@user_inventory)
    assert_response :success
  end

  test "should update user_inventory" do
    patch user_inventory_url(@user_inventory), params: { user_inventory: { inventory_id: @user_inventory.inventory_id, owner_email: @user_inventory.owner_email, user_email: @user_inventory.user_email } }
    assert_redirected_to user_inventory_url(@user_inventory)
  end

  test "should destroy user_inventory" do
    assert_difference("UserInventory.count", -1) do
      delete user_inventory_url(@user_inventory)
    end

    assert_redirected_to user_inventories_url
  end
end
