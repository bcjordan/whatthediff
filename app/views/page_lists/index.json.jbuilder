json.array!(@page_lists) do |page_list|
  json.extract! page_list, :id
  json.url page_list_url(page_list, format: :json)
end
