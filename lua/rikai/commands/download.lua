---@param requested_name string|nil
return function(requested_name)
	return require("rikai.download").run(requested_name)
end
