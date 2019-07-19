require 'sinatra'

get '/pdf_for_testing.pdf' do
  headers['Content-Disposition'] = "attachment";
  send_file('pdf_for_testing.pdf')
end

get '/iframe' do
  <<-HTML
<html>
  <body>
    <h1>Outside Frame</h1>
    <iframe src="http://example.com/" name="example">
  </body>
</html>
  HTML
end

get '/nested_iframe' do
  <<-HTML
<html>
  <body>
    <h1>Top Frame</h1>
    <iframe src="/iframe" name="nested">
  </body>
</html>
  HTML
end

get '/' do
  erb :example
end

get '/example' do
  erb :example
end

get '/iana/domains/example' do
  erb :iana_domains_example
end

get '/gmail' do
  erb :gmail
end

get '/long_page' do
  erb :long_page
end
