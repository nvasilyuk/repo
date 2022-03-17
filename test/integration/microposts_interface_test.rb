require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @dif_user = users(:two)
  end

  # test 'micropost interface Invalid submission' do
  #   log_in_as(@user)
  #   get root_path
  #   assert_select 'div.pagination'
  #   assert_no_difference 'Micropost.count' do
  #     post microposts_path, params: { micropost: { content: '' } }
  #   end
  #   assert_select 'div#error_explanation'
  #   assert_select 'a[href=?]', '/?page=2' # Correct pagination link
  # end

  test 'micropost interface Valid submission' do
    log_in_as(@user)
    get root_path
    # assert_select 'div.pagination'
    content = 'This micropost really ties the room together'
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test 'micropost interface Delete post' do
    log_in_as(@user)
    get root_path
    # assert_select 'div.pagination'
    assert_select 'a', text: 'sample app'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end

  test 'micropost interface visit different user (no delete links)' do
    log_in_as(@user)
    get root_path
    # assert_select 'div.pagination'
    get user_path(@dif_user)
    assert_select 'a', text: 'delete', count: 0
  end
end
