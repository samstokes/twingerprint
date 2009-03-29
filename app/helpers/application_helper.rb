# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title(text)
    content_for(:title) { text }
    content_tag(:h1, text)
  end
end
