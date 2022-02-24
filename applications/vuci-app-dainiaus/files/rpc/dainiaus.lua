local M = {}

function M.get_time(params)
	local time = os.date("%H:%M:%S").."test"
	params.time = time
	return params
end

return M