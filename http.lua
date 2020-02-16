-- Resource: https://github.com/timotta/wrk-scripts/blob/master/multiplepaths.lua
-- initialize the pseudo random number generator
-- Resource: http://lua-users.org/wiki/MathLibraryTutorial
--math.randomseed(os.time())
math.randomseed(0)
math.random(); math.random(); math.random()

tid = 0
local g_counter = 1
setup = function(thread)
	thread:set("id", g_counter)
	g_counter = g_counter + 1
end

function init(args)
	requests  = 0
	responses = 0

	local msg = "thread %d created"
	tid = id
	print(msg:format(tid))
end

-- Shuffle array
-- Returns a randomly shuffled array
function shuffle(paths)
	local j, k
	local n = #paths

	for i = 1, n do
		j, k = math.random(n), math.random(n)
		paths[j], paths[k] = paths[k], paths[j]
	end

	return paths
end

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

	--return shuffle(lines)
	return lines
end

-- Load URL paths from file
--paths = load_url_paths_from_file("urls.txt")
MAX_PATHS=360000
THREADS=16

-- Check if at least one path was found in the file
--if #paths <= 0 then
--	print("multiplepaths: No paths found. You have to create a file paths.txt with one path per line")
--	os.exit()
--end

--print("multiplepaths: Found " .. #paths .. " paths")

-- Initialize the paths array iterator
counter = 0

request = function()
	-- Get the next paths array element
	--url_path = paths[counter]
	--url_path = string.format("http://10.1.4.100/file.%d.html", math.random(MAX_PATHS))
	url_path = string.format("http://10.1.4.100/file.%d.html", counter * THREADS + tid)
	--print("Requesting thread " .. tid )

	-- 
	counter = counter + 1


	-- If the counter is longer than the paths array length then reset it
	--if counter > #paths then
	if counter > (MAX_PATHS / THREADS - 1) then
		counter = 0
	end

	-- Return the request object with the current URL path
	return wrk.format(nil, url_path)
end
