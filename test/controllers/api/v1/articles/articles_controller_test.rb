require "controllers/api/v1/test"

class Api::V1::Articles::ArticlesControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @category = create(:articles_category, team: @team)
    @article = build(:articles_article, category: @category)
    @other_articles = create_list(:articles_article, 3)

    @another_article = create(:articles_article, category: @category)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @article.save
    @another_article.save

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
  def assert_proper_object_serialization(article_data)
    # Fetch the article in question and prepare to compare it's attributes.
    article = Articles::Article.find(article_data["id"])

    assert_equal_or_nil article_data['title'], article.title
    assert_equal_or_nil article_data['published'], article.published
    assert_equal_or_nil article_data['cover_image'], article.cover_image
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal article_data["category_id"], article.category_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/articles/categories/#{@category.id}/articles", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    article_ids_returned = response.parsed_body.map { |article| article["id"] }
    assert_includes(article_ids_returned, @article.id)

    # But not returning other people's resources.
    assert_not_includes(article_ids_returned, @other_articles[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/articles/articles/#{@article.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/articles/articles/#{@article.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    article_data = JSON.parse(build(:articles_article, category: nil).api_attributes.to_json)
    article_data.except!("id", "category_id", "created_at", "updated_at")
    params[:articles_article] = article_data

    post "/api/v1/articles/categories/#{@category.id}/articles", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/articles/categories/#{@category.id}/articles",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/articles/articles/#{@article.id}", params: {
      access_token: access_token,
      articles_article: {
        title: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @article.reload
    assert_equal @article.title, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/articles/articles/#{@article.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Articles::Article.count", -1) do
      delete "/api/v1/articles/articles/#{@article.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/articles/articles/#{@another_article.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
