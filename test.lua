local utf8 = require'utf8'

for pos, codepoint in utf8.codes("たたき") do

    print("Position", tostring(pos))
    print("char:", tostring(codepoint))
end
