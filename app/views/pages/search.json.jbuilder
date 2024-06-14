json.markers @markers
json.searchcard_html render(partial: "searchcard", formats: :html, locals: { users: @near_users })
