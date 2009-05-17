# Include hook code here
config.to_prepare do
  ApplicationController.helper(WildernessHelper)
end