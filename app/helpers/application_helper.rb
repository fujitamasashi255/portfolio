# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  # アクティブなメニューを判定
  def active_if(*paths)
    active_link?(*paths) ? "active" : nil
  end

  def active_link?(*paths)
    paths.any? { |path| current_page?(path) }
  end

  # 並び替えリンクがアクティブかどうかを判定
  def active_sort_link_if(search_form_object, sort_type)
    search_form_object.sort_type == sort_type ? "active" : nil
  end

  # コントローラの名前空間に Admin が含まれるかどうかを判定
  def admin_controller?(controller)
    class_name = controller.class.name
    class_name.gsub("::#{class_name.demodulize}", "").include?("Admin")
  end

  # twitter共有のためのURLを生成
  def twitter_share_url(text = nil, url = nil)
    twitter_share_url = URI.parse("https://twitter.com/intent/tweet")
    query_array = []
    query_array << ["text", text]
    query_array << ["url", url]
    query_array << ["hashtags", t("common.site_name")]
    twitter_share_url.query = URI.encode_www_form(query_array)
    twitter_share_url.to_s
  end
end
