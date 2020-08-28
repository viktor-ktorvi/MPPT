% mapiranje vrednosti npr 5-10 u 0-1
function output = map(value, fromLow, fromHigh, toLow, toHigh)
narginchk(5,5)
nargoutchk(0,1)
output = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
end