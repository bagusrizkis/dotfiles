local status, number_toggle = pcall(require, 'numbertoggle')
if (not status) then return end

number_toggle.setup()
