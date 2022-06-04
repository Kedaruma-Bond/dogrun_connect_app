# 任意の場所でScreenshotを撮るために用意する
def take_screenshot
  page.save_screenshot "tmp/capybara/screenshot-#{DateTime.now}.png"
end

# ページをリロードするヘルパーメソッドを用意する

def reload_page
  visit current_path
end
