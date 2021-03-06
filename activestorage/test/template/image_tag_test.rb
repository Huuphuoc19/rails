# frozen_string_literal: true

require "test_helper"
require "database/setup"

class ActiveStorage::ImageTagTest < ActionView::TestCase
  tests ActionView::Helpers::AssetTagHelper

  setup do
    @blob = create_image_blob filename: "racecar.jpg"
  end

  test "blob" do
    assert_dom_equal %(<img src="#{polymorphic_url @blob}" />), image_tag(@blob)
  end

  test "variant" do
    variant = @blob.variant(resize: "100x100")
    assert_dom_equal %(<img src="#{polymorphic_url variant}" />), image_tag(variant)
  end

  test "attachment" do
    attachment = ActiveStorage::Attachment.new(blob: @blob)
    assert_dom_equal %(<img src="#{polymorphic_url attachment}" />), image_tag(attachment)
  end

  test "error when attachment's empty" do
    @user = User.create!(name: "DHH")

    assert_not @user.avatar.attached?
    assert_raises(ArgumentError) { image_tag(@user.avatar) }
  end

  test "error when object can't be resolved into url" do
    unresolvable_object = ActionView::Helpers::AssetTagHelper
    assert_raises(ArgumentError) { image_tag(unresolvable_object) }
  end
end
