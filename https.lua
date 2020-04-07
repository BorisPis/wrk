-- #!/bin/lua
-- -- https://www.digitalocean.com/community/tutorials/how-to-benchmark-http-latency-with-wrk-on-ubuntu-14-04#
-- Load URL paths from the file
function load_url_paths_from_file(file)
  lines = {}

  -- Check if the file exists
  -- Resource: http://stackoverflow.com/a/4991602/325852
  local f=io.open(file,"r")
  if f~=nil then
    io.close(f)
  else
    -- Return the empty array
    return lines
  end

  -- If the file exists loop through all its lines
  -- and add them into the lines array
  for line in io.lines(file) do
    if not (line == '') then
      lines[#lines + 1] = line
    end
  end

  return lines
end

-- Load URL paths from file
paths = load_url_paths_from_file("/scrap/borisp/ssl/wrk/urls52")

print("multiplepaths: Found " .. #paths .. " paths from /scrap/borisp/ssl/wrk/urls52")
print(paths[1])

-- Initialize the paths array iterator
counter = 0

request = function()
  -- Get the next paths array element
  url_path = paths[counter]

  counter = counter + 1

  -- If the counter is longer than the paths array length then reset it
  if counter > #paths then
    counter = 0
  end

  -- Return the request object with the current URL path
  return wrk.format(nil, url_path)
end
