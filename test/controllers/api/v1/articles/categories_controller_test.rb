require "controllers/api/v1/test"

class Api::V1::Articles::CategoriesControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @category = build(:articles_category, team: @team)
    @other_categories = create_list(:articles_category, 3)

    @another_category = create(:articles_category, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @category.save
    @another_category.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(category_data)
    # Fetch the category in question and prepare to compare it's attributes.
    category = Articles::Category.find(category_data["id"])

    assert_equal_or_nil category_data['name'], category.name
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal category_data["team_id"], category.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/articles/categories", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    category_ids_returned = response.parsed_body.map { |category| category["id"] }
    assert_includes(category_ids_returned, @category.id)

    # But not returning other people's resources.
    assert_not_includes(category_ids_returned, @other_categories[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/articles/categories/#{@category.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/articles/categories/#{@category.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    category_data = JSON.parse(build(:articles_category, team: nil).api_attributes.to_json)
    category_data.except!("id", "team_id", "created_at", "updated_at")
    params[:articles_category] = category_data

    post "/api/v1/teams/#{@team.id}/articles/categories", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/articles/categories",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/articles/categories/#{@category.id}", params: {
      access_token: access_token,
      articles_category: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @category.reload
    assert_equal @category.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/articles/categories/#{@category.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Articles::Category.count", -1) do
      delete "/api/v1/articles/categories/#{@category.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/articles/categories/#{@another_category.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
