function x = get_binary_bits(solution_space)
   x=0 
   for i = 1:50
        if(2^i>solution_space)
            x=i;
            break;
        end
    end
end