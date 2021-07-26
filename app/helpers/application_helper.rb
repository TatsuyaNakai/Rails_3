module ApplicationHelper
    def full_title(page_title= "")
        # full_titleメソッドでpage_titleの中身が空文字を選択
        base_title="Ruby on Rails Tutorial Sample App"
        if page_title.empty?
          base_title
        else
          page_title + " | " + base_title
        end
    end
end
