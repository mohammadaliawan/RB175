require "socket"

def parse_request(request_line)
  http_method, path_and_params, http_version = request_line.split
  path, params = path_and_params.split("?")

  params = params.split("&").each_with_object({}) do |pair, hsh|
  key, value = pair.split("=")
  hsh[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept
  
  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls!</h1>"
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  rolls.times do |_|
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end

  client.puts "</html>"
  client.puts "</body>"

  client.close
end