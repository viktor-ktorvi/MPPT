function output = clamp(input, minimum, maximum)

    output = input;
    if output > maximum
        output = maximum;
    end
    
    if output < minimum
        output = minimum;
    end
    
end